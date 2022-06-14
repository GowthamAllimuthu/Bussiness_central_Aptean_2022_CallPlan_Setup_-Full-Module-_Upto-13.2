table 70241757 CAPWorkSheetName59FDW
{
    Caption = 'Call Plan Work Sheet Name';
    DataCaptionFields = Name, Description;
    LookupPageId = CAPWorkSheetNames59FDW;
    DrillDownPageId = CAPWorkSheetNames59FDW;
    Access = Internal;
    Extensible = false;
    fields
    {
        field(1; Name; Code[10])
        {
            NotBlank = true;
            DataClassification = CustomerContent;
            Caption = 'Name';
        }
        field(2; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
    }

    keys
    {
        key(PK; Name)
        {
            Clustered = true;
        }

    }

    trigger OnDelete()
    var
        CAPWorkSheetEntry: Record CAPWorkSheetEntry59FDW;
        CAPWorkSheetEntryExistErr: Label 'Not possible to delete worksheet name because one or more entries exist in the call plan worksheet that is linked to this name.';
    begin
        CAPWorkSheetEntry.SetRange("Worksheet Name", Rec.Name);
        if not CAPWorkSheetEntry.IsEmpty then
            Error(CAPWorkSheetEntryExistErr);
    end;

}