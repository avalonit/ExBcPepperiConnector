codeunit 70659928 "ALV Application Insights Mgt."
{
    trigger OnRun()
    begin

    end;

    var
        AppInsightsSDK: Codeunit "ALV Application Insights SDK";
        Properties: Dictionary of [Text, Text];
        Metrics: Dictionary of [Text, Decimal];

    [NonDebuggable]
    //AppInsightKeyTxt: Label '5be7a45c-81b6-4505-affe-479b464da3e4', Locked = true;

    procedure AddProperty(PropertyName: Text; PropertyValue: Text)
    begin
        if Properties.ContainsKey(PropertyName) then
            Properties.Set(PropertyName, PropertyValue)
        else
            Properties.Add(PropertyName, PropertyValue);
    end;

    procedure AddMetric(MetricName: Text; MetricValue: Decimal)
    begin
        if Metrics.ContainsKey(MetricName) then
            Metrics.Set(MetricName, MetricValue)
        else
            Metrics.Add(MetricName, MetricValue);
    end;

    procedure CustomEvent(EventName: Text)
    begin
        SetKey();
        AppInsightsSDK.TrackCustomEvent(EventName, Properties, Metrics);
    end;

    procedure ExceptionError(Id: Text; ExceptionMsg: Text)
    var
        SeverityLevel: Enum "ALV Trace Severity";
    begin
        SetKey();
        AppInsightsSDK.TrackException(Id, ExceptionMsg, SeverityLevel::Error, Properties, Metrics);
    end;

    procedure ExceptionCritical(Id: Text; ExceptionMsg: Text)
    var
        SeverityLevel: Enum "ALV Trace Severity";
    begin
        SetKey();
        AppInsightsSDK.TrackException(Id, ExceptionMsg, SeverityLevel::Critical, Properties, Metrics);
    end;

    procedure ExceptionWarning(Id: Text; ExceptionMsg: Text)
    var
        SeverityLevel: Enum "ALV Trace Severity";
    begin
        SetKey();
        AppInsightsSDK.TrackException(Id, ExceptionMsg, SeverityLevel::Warning, Properties, Metrics);
    end;

    procedure TraceInformation(TraceText: Text)
    var
        SeverityLevel: Enum "ALV Trace Severity";
    begin
        SetKey();
        AppInsightsSDK.TrackTrace(TraceText, SeverityLevel::Information, Properties);
    end;

    procedure TraceWarning(TraceText: Text)
    var
        SeverityLevel: Enum "ALV Trace Severity";
    begin
        SetKey();
        AppInsightsSDK.TrackTrace(TraceText, SeverityLevel::Warning, Properties);
    end;

    procedure TraceError(TraceText: Text)
    var
        SeverityLevel: Enum "ALV Trace Severity";
    begin
        SetKey();
        AppInsightsSDK.TrackTrace(TraceText, SeverityLevel::Error, Properties);
    end;

    procedure TraceCritical(TraceText: Text)
    var
        SeverityLevel: Enum "ALV Trace Severity";
    begin
        SetKey();
        AppInsightsSDK.TrackTrace(TraceText, SeverityLevel::Critical, Properties);
    end;

    procedure TrackPageOpen(ObjectName: Text)
    var
        UsageObjectType: Enum "ALV Usage Object Type";
    begin
        SetKey();
        AppInsightsSDK.TrackObjectUsage(UsageObjectType::Page, ObjectName);
    end;

    procedure TrackReportOpen(ObjectName: Text)
    var
        UsageObjectType: Enum "ALV Usage Object Type";
    begin
        SetKey();
        AppInsightsSDK.TrackObjectUsage(UsageObjectType::Report, ObjectName);
    end;

    procedure TrackRunAction(ObjectName: Text; ActionName: Text)
    var
        UsageObjectType: Enum "ALV Usage Object Type";
    begin
        SetKey();
        AppInsightsSDK.TrackObjectUsage(UsageObjectType::Action, StrSubstNo('%1.%2', ObjectName, ActionName));
    end;

    local procedure SetKey()
    var
        configuration: Record "ALV AzConnector Configuration";

    begin
        //AppInsightsSDK.Init(AppInsightKeyTxt);
        if configuration.FindFirst() then begin
            AppInsightsSDK.Init(configuration.AppInsightKey);
        end;
    end;

}