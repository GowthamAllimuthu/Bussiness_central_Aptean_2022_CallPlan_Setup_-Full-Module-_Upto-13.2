page 70241763 CAPSShipToAddressSubform59FDW
{
    PageType = ListPart;
    SourceTable = CAPStructure59FDW;
    Caption = 'Call Plan Structure Customer Subform';
    RefreshOnActivate = true;
    DelayedInsert = true;
    Extensible = false;
    UsageCategory = None;
    layout
    {
        area(Content)
        {
            repeater(control1)
            {
                Caption = 'control1';
                field("Shipment Day"; Rec."Shipment Day")
                {
                    ToolTip = 'Specifies the shipment day for which to set up a call day.';
                    ApplicationArea = CallPlanAppArea59FDW;
                    BlankZero = true;
                    ShowMandatory = true;
                }
                field("Call Day"; Rec."Call Day")
                {
                    ToolTip = 'Specifies the day on which the customer should be contacted regarding sales orders with a shipment day as specified on the line.';
                    ApplicationArea = CallPlanAppArea59FDW;
                    BlankZero = true;
                    ShowMandatory = true;
                }
                field("Call Window Starting Time"; Rec."Call Window Starting Time")
                {
                    ToolTip = 'Specifies the time from which the customer can be contacted on this call day.';
                    ApplicationArea = CallPlanAppArea59FDW;
                }
                field("Call Window Ending Time"; Rec."Call Window Ending Time")
                {
                    ToolTip = 'Specifies the time until which the customer can be contacted on this call day.';
                    ApplicationArea = CallPlanAppArea59FDW;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ToolTip = 'Specifies the day from which this call plan structure line is active.';
                    ApplicationArea = CallPlanAppArea59FDW;
                    ShowMandatory = true;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ToolTip = 'Specifies the day until which this call plan structure line is active.';
                    ApplicationArea = CallPlanAppArea59FDW;
                }
                field(Note; Rec.Note)
                {
                    ToolTip = 'Specifies any additional information related to the call plan structure line, which will be shown in the call plan worksheet.';
                    ApplicationArea = CallPlanAppArea59FDW;
                    QuickEntry = false;
                }
                field(Frequency; Rec.Frequency)
                {
                    ToolTip = 'Specifies how often the customer should be included in the call plan worksheet: weekly or bi-weekly.';
                    ApplicationArea = CallPlanAppArea59FDW;
                    QuickEntry = false;
                }
                field("Last Creation Date"; Rec."Last Creation Date")
                {
                    ToolTip = 'Specifies the date on which the previous call plan record was created .';
                    ApplicationArea = CallPlanAppArea59FDW;
                    Visible = false;
                }
            }
        }
    }
}