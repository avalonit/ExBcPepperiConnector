codeunit 70659927 "ALV Application Insights SDK"
{
    var
        AppInsightKey: Text;
        Debugging: Boolean;
        UrlTxt: label 'https://dc.services.visualstudio.com/v2/track', Locked = true;

    [NonDebuggable]
    procedure Init(apiKey: Text)
    begin
        AppInsightKey := apiKey;
        Debugging := false;
    end;

    /// <summary>
    /// Allows to track custom events in Application Insights
    /// </summary>
    /// <param name="EventName">Name of the event which is tracked</param>
    /// <param name="Properties">Dictionary of the event custom properties seen on the event view in Application Insight</param>
    /// <param name="Metrics">Dictionary of the event metrics seen on the event view in Application Insight as decimal values</param>
    /// <see cref="https://docs.microsoft.com/en-us/azure/azure-monitor/app/data-model-event-telemetry"/>
    procedure TrackCustomEvent(EventName: Text; Properties: Dictionary of [Text, Text]; Metrics: Dictionary of [Text, Decimal]): Text
    var
        JSONEventData: JsonObject;
        Result: Text;
    begin
        JSONEventData.Add('name', EventName);
        Result := Track('EventData', JSONEventData, Properties, Metrics);
        exit(Result);
    end;

    /// <summary>
    /// Allows to trace custom messages with proper severity level in Application Insights
    /// </summary>
    /// <param name="Message">Message which is trace</param>
    /// <param name="SeverityLevel">Severity of the message Information, Verbose, Warning, Error, Critical</param>
    /// <param name="Properties">Dictionary of the trace custom properties seen on the trace view in Application Insight</param>
    /// <see cref="https://docs.microsoft.com/en-us/azure/azure-monitor/app/data-model-trace-telemetry"/>
    procedure TrackTrace(Message: Text; SeverityLevel: Enum "ALV Trace Severity"; Properties: Dictionary of [Text, Text]): Text
    var
        JSONEventData: JsonObject;
        EmptyDictionary: Dictionary of [Text, Decimal];
        Result: Text;
    begin
        JSONEventData.Add('message', Message);
        JSONEventData.Add('severityLevel', Format(SeverityLevel));
        Result := Track('MessageData', JSONEventData, Properties, EmptyDictionary);
        exit(Result);
    end;

    /// <summary>
    /// Allows to trace if the object such as page, report or action was used by the user
    /// </summary>
    /// <param name="UsageObjectType">Type of object which was used such as Page, Report, Action value is imported to operation_Name field</param>
    /// <param name="ObjectName">Type of object which was used</param>
    procedure TrackObjectUsage(UsageObjectType: Enum "ALV Usage Object Type"; ObjectName: Text): Text
    var
        JSONEventData: JsonObject;
        EmptyMetrics: Dictionary of [Text, Decimal];
        EmptyProperties: Dictionary of [Text, Text];
        Result: Text;
    begin
        JSONEventData.Add('operation_Name', Format(UsageObjectType));
        JSONEventData.Add('name', ObjectName);
        JSONEventData.Add('duration', '00:00:00');
        Result := Track('PageViewData', JSONEventData, EmptyProperties, EmptyMetrics);
        exit(Result);
    end;

    /// <summary>
    /// Allows to track exceptions in Application Insights
    /// </summary>
    /// <param name="ProblemId"Identifier of where the exception was thrown in code. Used for exceptions grouping. 
    /// Typically a function from the call stack. The Type of Extension is automatically added to ProblemId
    ///</param>
    /// <param name="Message">Message of the exception</param>
    /// <param name="SeverityLevel">Severity of the message Information, Verbose, Warning, Error, Critical</param>
    /// <param name="Properties">Dictionary of the exception properties seen in Application Insight</param>
    /// <param name="Metrics">Dictionary of the exception metrics seen on in Application Insight as decimal values</param>
    /// <see cref="https://docs.microsoft.com/en-us/azure/azure-monitor/app/data-model-exception-telemetry"/>
    procedure TrackException(ProblemId: Text; Message: Text; SeverityLevel: Enum "ALV Trace Severity"; Properties: Dictionary of [Text, Text]; Metrics: Dictionary of [Text, Decimal]): Text
    var
        JSONEventData: JsonObject;
        JSONException: JsonObject;
        JSONExceptions: JsonArray;
        Result: Text;
    begin
        JSONException.Add('typeName', 'AL.Exception');
        JSONException.Add('problemId', StrSubstNo('AL.Exception.%1', ProblemId));
        JSONException.Add('message', Message);
        JSONEventData.Add('severityLevel', Format(SeverityLevel));
        JSONExceptions.Add(JSONException);
        JSONEventData.Add('exceptions', JSONExceptions);
        Result := Track('ExceptionData', JSONEventData, Properties, Metrics);
        Exit(Result);
    end;


    local procedure Track(BaseEventType: Text; JSONEventData: JsonObject; Properties: Dictionary of [Text, Text]; Metrics: Dictionary of [Text, Decimal]): Text
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        Headers: HttpHeaders;
        Content: HttpContent;
        JArray: JsonArray;
        JSON: JsonObject;
        JSONData: JsonObject;
        JSONProperties: JsonObject;
        JSONMeasurements: JsonObject;
        MetricValue: Decimal;
        JSONText: Text;
        TimeStamp: Text;
        ValueName: Text;
        PropValue: Text;
        Result: Text;
    begin
        // Build the JSON data
        JSON.Add('name', 'ALExtension.Event');
        TimeStamp := Format(CurrentDateTime(), 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2><Second dec.>');
        JSON.Add('time', TimeStamp);
        JSON.Add('iKey', AppInsightKey);

        JSONData.Add('baseType', BaseEventType);
        JSONEventData.Add('ver', 2);

        if (Properties.Count() > 0) then begin
            foreach ValueName in Properties.Keys() do begin
                Properties.Get(ValueName, PropValue);
                JSONProperties.Add(ValueName, PropValue)
            end;
            JSONEventData.Add('properties', JSONProperties);
        end;

        if (Metrics.Count() > 0) then begin
            foreach ValueName in Metrics.Keys() do begin
                Metrics.Get(ValueName, MetricValue);
                JSONMeasurements.Add(ValueName, MetricValue)
            end;
            JSONEventData.Add('measurements', JSONMeasurements);
        end;

        JSONData.Add('baseData', JSONEventData);
        JSON.Add('data', JSONData);

        // For debugging
        if Debugging then begin
            JSON.WriteTo(JSONText);
            Message('JSON: %1', JSONText);
        end;

        // Add the JSON data to the request content
        JArray.Add(JSON);
        Content.Clear();
        Content.WriteFrom(Format(JSON));

        // Add the Content-Type to the Content headers, but first remove
        // the existing Content-Type.
        Content.GetHeaders(Headers);
        Headers.Remove('Content-Type');
        Headers.Add('Content-Type', 'application/json');

        Client.Post(UrlTxt, Content, Response);
        Response.Content().ReadAs(Result);

        // For debugging
        if Debugging then
            Message('Result: %1', Result);

        exit(Result);
    end;

}