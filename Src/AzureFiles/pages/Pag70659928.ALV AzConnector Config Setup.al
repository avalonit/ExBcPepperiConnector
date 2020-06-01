page 70659928 "ALV AzConnector Config Setup"
{
    Caption = 'ALV AzConnector Config Setup';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ALV AzConnector Configuration";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("CloudContainerNo"; "CloudContainerNo")
                {
                    ApplicationArea = All;
                    Caption = 'No';
                }

                field("CloudContainerCode"; "CloudContainerCode")
                {
                    ApplicationArea = All;
                    Caption = 'Code';
                }
                field("AzureBlobUri"; "AzureBlobUri")
                {
                    ApplicationArea = All;
                    Caption = 'Azure Blob Uri';
                }

                field("AzureBlobToken"; "AzureBlobToken")
                {
                    ApplicationArea = All;
                    Caption = 'Azure Blob Token';
                }
                field("AzureFileUri"; "AzureFileUri")
                {
                    ApplicationArea = All;
                    Caption = 'Azure File Uri';
                }

                field("AzureFileUsername"; "AzureFileUsername")
                {
                    ApplicationArea = All;
                    Caption = 'Azure File Username';
                }

                field("CloudWorkingPath"; CloudWorkingPath)
                {
                    ApplicationArea = All;
                    Caption = 'Working Path';
                }

                field("AppInsightKey"; AppInsightKey)
                {
                    ApplicationArea = All;
                    Caption = 'App Insight Key';
                }


            }
        }
    }



}

