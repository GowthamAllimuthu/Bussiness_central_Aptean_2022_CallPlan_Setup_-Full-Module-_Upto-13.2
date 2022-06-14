page 70241757 CAPWorkSheetNames59FDW
{
    Caption = 'Call Plan Worksheet Names';
    PageType = List;
    SourceTable = CAPWorkSheetName59FDW;
    Extensible = false;
    UsageCategory = None;
    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                Caption = 'Control1';
                field(Name; Rec.Name)
                {
                    ApplicationArea = CallPlanAppArea59FDW;
                    Editable = true;
                    ToolTip = 'Specifies the name of the call plan worksheet.';
                    ShowMandatory = true;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = CallPlanAppArea59FDW;
                    Editable = true;
                    ToolTip = 'Specifies a description for the call plan worksheet.';
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(EditWorksheet)
            {
                ApplicationArea = CallPlanAppArea59FDW;
                Caption = 'Edit Worksheet';
                Image = OpenWorksheet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ShortcutKey = 'Return';
                ToolTip = 'Make the worksheet lines editable.';

                trigger OnAction()
                begin
                    CallplanWorksheetMgt59FDW.WorkSheetSelection(Rec);
                end;
            }
        }
    }
    var
        CallplanWorksheetMgt59FDW: Codeunit CallplanWorksheetMgt59FDW;
}