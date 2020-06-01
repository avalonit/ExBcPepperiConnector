codeunit 70659926 "ALV AzFile Service API" implements "ALV CloudManagementInterface"
{
    procedure Download(folderName: Text; fileName: Text; var output: InStream): Boolean
    var
        config: Record "ALV AzConnector Configuration";
        AppInsights: Codeunit "ALV Application Insights Mgt.";
        AppTelemetry: Codeunit "ALV Application Telemetry";
        client: HttpClient;
        response: HttpResponseMessage;
        headers: HttpHeaders;
        endpoint: Text;
        folder: Text;
        xmsdate: Text;
        skLite: Text;
        canonicalizedStr: Text;
        method: Text;
        xmsversion: Text;
        canPath: Text;
        encMgt: codeunit "Cryptography Management";
        newLine: Text;
        charCr: Char;
        telemetryID: Text;
    begin
        if not config.FindFirst() then exit(false);
        AppInsights.TraceInformation('ALV AzFile Service API Download Start');
        telemetryID := 'ALV AzFile Service API::Download::' + fileName;
        AppTelemetry.Start(telemetryID);

        folder := StrSubstNo('%1/%2', folderName, fileName);
        endpoint := StrSubstNo('%1/%2', config.AzureFileUri, folder);

        xmsdate := GetUTCDate(CurrentDateTime());
        method := 'GET';
        xmsversion := GetXmsVersion();
        canPath := StrSubstNo('/%1/%2/%3/%4', config.AzureFileUsername, config.CloudWorkingPath, folderName, fileName);

        charCr := 10;
        newLine := FORMAT(charCr);
        canonicalizedStr := StrSubstNo('%1%6%6%2%6%6x-ms-date:%3%6x-ms-version:%4%6%5', method, '', xmsdate, xmsversion, canPath, newLine);
        skLite := encMgt.GenerateBase64KeyedHashAsBase64String(canonicalizedStr, config.AzureBlobToken, 2);
        skLite := StrSubstNo('SharedKeyLite %1:%2', config.AzureFileUsername, skLite);

        client.DefaultRequestHeaders().Clear();
        client.DefaultRequestHeaders().Add('Authorization', skLite);
        client.DefaultRequestHeaders().Add('x-ms-date', xmsdate);
        client.DefaultRequestHeaders().Add('x-ms-version', xmsversion);

        if client.Get(endpoint, response) then begin
            AppInsights.TraceInformation('ALV AzFile Service API Download Completed');
            AppTelemetry.Log(telemetryID);
            exit(response.Content().ReadAs(output))
        end
        else begin
            AppInsights.TraceError('ALV AzFile Service API Download Failed');
        end;
    end;

    procedure Download(folderName: Text; fileName: Text; var output: Text): Boolean
    var
        config: Record "ALV AzConnector Configuration";
        AppInsights: Codeunit "ALV Application Insights Mgt.";
        AppTelemetry: Codeunit "ALV Application Telemetry";
        client: HttpClient;
        response: HttpResponseMessage;
        headers: HttpHeaders;
        endpoint: Text;
        folder: Text;
        xmsdate: Text;
        skLite: Text;
        canonicalizedStr: Text;
        method: Text;
        xmsversion: Text;
        canPath: Text;
        encMgt: codeunit "Cryptography Management";
        newLine: Text;
        charCr: Char;
        telemetryID: Text;
    begin
        if not config.FindFirst() then exit(false);
        AppInsights.TraceInformation('ALV AzFile Service API Download Start');
        telemetryID := 'ALV AzFile Service API::Download::' + fileName;
        AppTelemetry.Start(telemetryID);

        folder := StrSubstNo('%1/%2', folderName, fileName);
        endpoint := StrSubstNo('%1/%2', config.AzureFileUri, folder);

        xmsdate := GetUTCDate(CurrentDateTime());
        method := 'GET';
        xmsversion := GetXmsVersion();
        canPath := StrSubstNo('/%1/%2/%3/%4', config.AzureFileUsername, config.CloudWorkingPath, folderName, fileName);

        charCr := 10;
        newLine := FORMAT(charCr);
        canonicalizedStr := StrSubstNo('%1%6%6%2%6%6x-ms-date:%3%6x-ms-version:%4%6%5', method, '', xmsdate, xmsversion, canPath, newLine);
        skLite := encMgt.GenerateBase64KeyedHashAsBase64String(canonicalizedStr, config.AzureBlobToken, 2);
        skLite := StrSubstNo('SharedKeyLite %1:%2', config.AzureFileUsername, skLite);

        client.DefaultRequestHeaders().Clear();
        client.DefaultRequestHeaders().Add('Authorization', skLite);
        client.DefaultRequestHeaders().Add('x-ms-date', xmsdate);
        client.DefaultRequestHeaders().Add('x-ms-version', xmsversion);

        if client.Get(endpoint, response) then begin
            AppInsights.TraceInformation('ALV AzFile Service API Download Completed');
            AppTelemetry.Log(telemetryID);
            exit(response.Content().ReadAs(output))
        end
        else begin
            AppInsights.TraceError('ALV AzFile Service API Download Failed');
        end;
    end;


    procedure GetUTCDate(currentDateTime: DateTime): Text
    var
        requestDateString: Text;
    begin
        requestDateString := Format(currentDateTime, 0, '<Weekday Text,3>, <Day> <Month Text> <Year4> <Hours24,2>:<Minutes,2>:<Seconds,2> GMT');
        exit(requestDateString);
    end;

    procedure GetXmsVersion(): Text
    var
        xmsVersion: Text;
    begin
        xmsVersion := '2017-11-09';
        exit(xmsVersion);
    end;
}