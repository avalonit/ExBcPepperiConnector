codeunit 70659924 "ALV AzBlob Service API" implements "ALV CloudManagementInterface"
{
    procedure Download(containerName: Text; blobName: Text; var text: Text): Boolean
    var
        configuration: Record "ALV AzConnector Configuration";
        AppInsights: Codeunit "ALV Application Insights Mgt.";
        AppTelemetry: Codeunit "ALV Application Telemetry";
        client: HttpClient;
        response: HttpResponseMessage;
        result: Boolean;
        telemetryID: Text;
    begin
        if not configuration.FindFirst() then exit(false);

        AppInsights.TraceInformation('ALV AzBlob Service API Download Start');
        telemetryID := 'ALV AzBlob Service API::Download::' + blobName;
        AppTelemetry.Start(telemetryID);

        //GET https://<accountname>.blob.core.windows.net/<container>/<blob>?<sastoken>
        if not client.Get(StrSubstNo('%1/%2/%3?%4', configuration.AzureBlobUri, containerName, blobName, configuration.AzureBlobToken), response) then exit(false);
        result := response.Content().ReadAs(text);

        if (result) then begin
            AppInsights.TraceInformation('ALV AzBlob Service API Download Completed');
            AppTelemetry.Log(telemetryID);
        end
        else begin
            AppInsights.TraceError('ALV AzBlob Service API Download Failed');
        end;
        exit(result);
    end;

    procedure Download(containerName: Text; blobName: Text; var stream: InStream): Boolean
    var
        configuration: Record "ALV AzConnector Configuration";
        AppInsights: Codeunit "ALV Application Insights Mgt.";
        AppTelemetry: Codeunit "ALV Application Telemetry";
        client: HttpClient;
        response: HttpResponseMessage;
        result: Boolean;
        telemetryID: Text;
    begin
        if not configuration.FindFirst() then exit(false);

        AppInsights.TraceInformation('ALV AzBlob Service API Download Start');
        telemetryID := 'ALV AzBlob Service API::Download::' + blobName;
        AppTelemetry.Start(telemetryID);

        //GET https://<accountname>.blob.core.windows.net/<container>/<blob>?<sastoken>
        if not client.Get(StrSubstNo('%1/%2/%3?%4', configuration.AzureBlobUri, containerName, blobName, configuration.AzureBlobToken), response) then exit(false);
        result := response.Content().ReadAs(stream);
        if (result) then begin
            AppInsights.TraceInformation('ALV AzBlob Service API Download Completed');
            AppTelemetry.Log(telemetryID);
        end
        else begin
            AppInsights.TraceError('ALV AzBlob Service API Download Failed');
        end;
        exit(result)
    end;


}

