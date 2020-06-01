codeunit 70659929 "ALV Application Telemetry"
{

    var
        AppInsightsMgt: Codeunit "ALV Application Insights Mgt.";
        AppStart: Dictionary of [text, DateTime];
        AppStop: Dictionary of [text, DateTime];

    procedure Log(functionId: Text)
    begin
        Stop(functionId);
        AppInsightsMgt.AddMetric('duration', GetTimeSpan(functionId));
        AppInsightsMgt.CustomEvent(functionId);

    end;

    procedure Start(appKey: text)
    begin
        if AppStart.ContainsKey(appKey) then
            AppStart.Set(appKey, CurrentDateTime)
        else
            AppStart.Add(appKey, CurrentDateTime);
    end;

    procedure Stop(appKey: Text)
    begin
        if AppStop.ContainsKey(appKey) then
            AppStop.Set(appKey, CurrentDateTime)
        else
            AppStop.Add(appKey, CurrentDateTime);
    end;

    procedure GetTimeSpan(functionId: Text): Integer
    var
        start: DateTime;
        stop: DateTime;
    begin
        start := AppStart.Get(functionId);
        stop := AppStop.Get(functionId);
        exit(stop - start);
    end;


}