report 70241757 MoveWorkSheetLines59FDW
{
    Caption = 'Move Worksheet Lines';
    ProcessingOnly = true;
    Extensible = false;
    UsageCategory = None;
    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = filter(1));
            trigger OnPreDataItem()
            begin
                CheckToCallPlanWorksheetName();
            end;

            trigger OnAfterGetRecord()
            begin
                MoveLines();
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoOfSelectedLinesPage; NoOfSelectedLinesPage)
                    {
                        Caption = 'No. of Selected Lines';
                        ApplicationArea = CallPlanAppArea59FDW;
                        Editable = false;
                        ToolTip = 'Specifies the number of lines selected in the call plan worksheet to be moved to another call plan worksheet.';
                    }
                    field(FromCallPlanWorksheetNamePage; FromCallPlanWorksheetNamePage)
                    {
                        Caption = 'From Call Plan Worksheet Name';
                        ApplicationArea = CallPlanAppArea59FDW;
                        Editable = false;
                        ToolTip = 'Specifies the name of the call plan worksheet from which the lines should be moved.';
                    }
                    field(ToCallPlanWorksheetNamePage; ToCallPlanWorksheetNamePage)
                    {
                        Caption = 'To Call Plan Worksheet Name';
                        ApplicationArea = CallPlanAppArea59FDW;
                        TableRelation = CAPWorkSheetName59FDW;
                        ToolTip = 'Specifies the name of the call plan worksheet to which the lines should be moved.';
                        ShowMandatory = true;
                        trigger OnValidate()
                        var
                            SameFromAndToWorksheetErr: Label 'The ''To Call Plan Worksheet Name'' cannot be the same as the ''From Call Plan Worksheet Name''.';
                        begin
                            GetToCallPlanWorksheetNameReport(ToCallPlanWorksheetNamePage);
                            if ToCallPlanWorksheetNamePage = FromCallPlanWorksheetNamePage then
                                Error(SameFromAndToWorksheetErr);
                        end;
                    }
                }
            }
        }

        var
            NoOfSelectedLinesPage: Integer;
            FromCallPlanWorksheetNamePage: Code[10];
            ToCallPlanWorksheetNamePage: Code[10];

        trigger OnOpenPage()
        begin
            GetRequestPageDetails(NoOfSelectedLinesPage, FromCallPlanWorksheetNamePage);
        end;
    }
    var
        FromCAPWorkSheetEntry: Record CAPWorkSheetEntry59FDW;
        NoOfSelectedLinesReport: Integer;
        FromCallPlanWorksheetNameReport: Code[10];
        ToCallPlanWorksheetNameReport: Code[10];

    internal procedure GetParameters(var CAPWorkSheetEntry: Record CAPWorkSheetEntry59FDW)
    begin
        FromCAPWorkSheetEntry.Copy(CAPWorkSheetEntry);
        if FromCAPWorkSheetEntry.FindSet() then begin
            NoOfSelectedLinesReport := FromCAPWorkSheetEntry.Count();
            FromCallPlanWorksheetNameReport := FromCAPWorkSheetEntry."Worksheet Name";
        end;
    end;

    local procedure GetToCallPlanWorksheetNameReport(ToCAPWorksheetNameReport: Code[10])
    begin
        ToCallPlanWorksheetNameReport := ToCAPWorksheetNameReport;
    end;

    local procedure GetRequestPageDetails(var CAPNoOfSelectedLinesReport: Integer; var FromCAPWorksheetNameReport: Code[10])
    begin
        CAPNoOfSelectedLinesReport := NoOfSelectedLinesReport;
        FromCAPWorksheetNameReport := FromCallPlanWorksheetNameReport;
    end;

    local procedure CheckToCallPlanWorksheetName()
    var
        ToWorkSheetErrorMsg: Label 'To Call Plan Worksheet Name cannot be blank.';
    begin
        if ToCallPlanWorksheetNameReport = '' then
            Error(ToWorkSheetErrorMsg);
    end;

    local procedure MoveLines()
    var
        ToCAPWorkSheetEntry: Record CAPWorkSheetEntry59FDW;
        DeleteCAPWorkSheetEntry: Record CAPWorkSheetEntry59FDW;
        LastLineNo: Integer;
    begin
        ToCAPWorkSheetEntry.SetRange("Worksheet Name", ToCallPlanWorksheetNameReport);
        if ToCAPWorkSheetEntry.FindLast() then
            LastLineNo := ToCAPWorkSheetEntry."Line No.";

        repeat
            ToCAPWorkSheetEntry.TransferFields(FromCAPWorkSheetEntry, true);
            ToCAPWorkSheetEntry."Worksheet Name" := ToCallPlanWorksheetNameReport;
            LastLineNo := LastLineNo + 10000;
            ToCAPWorkSheetEntry."Line No." := LastLineNo;
            if ToCAPWorkSheetEntry.Insert() then
                if DeleteCAPWorkSheetEntry.Get(FromCAPWorkSheetEntry."Worksheet Name", FromCAPWorkSheetEntry."Line No.") then
                    DeleteCAPWorkSheetEntry.Delete();
        until FromCAPWorkSheetEntry.Next() = 0;
    end;
}