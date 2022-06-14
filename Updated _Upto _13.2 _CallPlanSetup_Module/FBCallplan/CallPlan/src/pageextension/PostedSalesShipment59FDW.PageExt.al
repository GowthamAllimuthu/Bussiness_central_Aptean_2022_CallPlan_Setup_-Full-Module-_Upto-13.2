pageextension 70241761 PostedSalesShipment59FDW extends "Posted Sales Shipment"
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
                Editable = false;
            }
        }
    }
}