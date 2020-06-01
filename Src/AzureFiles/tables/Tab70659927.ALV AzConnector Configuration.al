table 70659927 "ALV AzConnector Configuration"
{
    fields
    {
        field(1; "CloudContainerNo"; Integer)
        {
        }
        field(2; "CloudContainerCode"; Code[20])
        {
            NotBlank = true;
        }

        field(3; "CloudWorkingPath"; Text[250])
        {
        }

        field(4; "AzureBlobUri"; Text[250])
        {
        }
        field(5; "AzureBlobToken"; Text[250])
        {
        }

        field(6; "AzureFileUri"; Text[250])
        {
        }

        field(7; "AzureFileUsername"; Text[250])
        {
        }
        field(8; "AppInsightKey"; Text[250])
        {
        }


    }

    keys
    {
        key(Key1; "CloudContainerNo")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

