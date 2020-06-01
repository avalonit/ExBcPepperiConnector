interface "ALV CloudManagementInterface"
{
    /* Dir(), Upload(), Rename(), MoveFile(), CopyFile() */
    procedure Download(folderName: Text; fileName: Text; var output: InStream): Boolean
    procedure Download(folderName: Text; fileName: Text; var output: Text): Boolean
}

