page 70241764 CallPlanOrders59FDW
{
    PageType = List;
    SourceTable = CAPWorkSheetEntry59FDW;
    UsageCategory = None;
    Extensible = false;
    Caption = 'Call Plan Orders';
    DataCaptionExpression = DataCaption();
    layout
    {
        area(Content)
        {
            repeater(Control)
            {
                field("Call Plan Worksheet Name"; Rec."Worksheet Name")
                {
                    ApplicationArea = CallPlanAppArea59FDW;
                    Caption = 'Call Plan Worksheet Name';
                    ToolTip = 'Specifies the name of the call plan worksheet in which this call plan line exists.';
                }
                field("Call Plan Status"; Rec."Call Plan Status")
                {
                    ApplicationArea = CallPlanAppArea59FDW;
                    Caption = 'Call Plan Status';
                    ToolTip = 'Specifies the status of the call plan worksheet line: new - indicates the customer has not yet been called, retry - indicates that the customer has to be contacted (again) later for some reasons, completed - indicates that the customer has been called and any necessary sales order(s) has/have been created. ';
                }
                field("Call Date"; Rec."Call Date")
                {
                    ApplicationArea = CallPlanAppArea59FDW;
                    Caption = 'Call Date';
                    ToolTip = 'Specifies the date on which the customer should be contacted regarding sales orders with a shipment date as specified on the line.';
                }
                field("Inside Salesperson Code"; Rec."Inside Salesperson Code")
                {
                    ApplicationArea = CallPlanAppArea59FDW;
                    Caption = 'Inside Salesperson Code';
                    ToolTip = 'Specifies the user responsible for calling the customer and accepting and entering their sales orders.';
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = CallPlanAppArea59FDW;
                    Caption = 'Shipment Date';
                    ToolTip = 'Specifies the shipment date of the sales orders regarding which the customer should be contacted.';
                }
                field("Shipment Day"; Rec."Shipment Day")
                {
                    ApplicationArea = CallPlanAppArea59FDW;
                    Caption = 'Shipment Day';
                    ToolTip = 'Specifies the shipment day of the sales orders regarding which the customer should be contacted.';
                }
                field(Note; Rec.Note)
                {
                    ApplicationArea = CallPlanAppArea59FDW;
                    Caption = 'Note';
                    ToolTip = 'Specifies any additional information related to the call plan worksheet.';
                }
            }
        }
    }
    local procedure DataCaption(): Text[250]
    begin
        exit(Rec."Customer No." + '  ' + Rec."Ship-To Code" + ' - ' + 'Call Plan Orders')
    end;
}