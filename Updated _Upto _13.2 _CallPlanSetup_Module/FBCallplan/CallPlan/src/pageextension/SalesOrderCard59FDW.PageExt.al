pageextension 70241760 SalesOrderCard59FDW extends "Sales Order"
{
    layout
    {
        addafter("Salesperson Code")
        {
            field("InsideSalespersonCode59FDW"; Rec.InsideSalespersonCode59FDW)
            {
                ApplicationArea = CallPlanAppArea59FDW;
                ToolTip = 'Specifies the user responsible for calling the customer and accepting and entering their sales orders';
                Importance = Additional;
                QuickEntry = false;
            }
            field("IncludeforCutoffTime59FDW"; Rec.IncludeforCutoffTime59FDW)
            {
                ApplicationArea = CallPlanAppArea59FDW;
                ToolTip = 'Specifies if the sales order is included in the cut-off time restrictions. If so, sales lines for this order will no longer be editable after a certain cut-off time (set up at the Call Plan Setup page), related to the order^s shipment date';
                Importance = Additional;
                QuickEntry = false;
            }
        }
        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                CreateSalesOrder: Codeunit CreateSalesOrder59FDW;
            begin
                CreateSalesOrder.SendInsideSalespersonNotification(Rec.InsideSalespersonCode59FDW);
            end;
        }
    }
}