pageextension 70241762 PostedSalesInvoice59FDW extends "Posted Sales Invoice"
{
    layout
    {
        addafter("Salesperson Code")
        {
            field(InsideSalespersonCode59FDW; Rec.InsideSalespersonCode59FDW)
            {
                ApplicationArea = CallPlanAppArea59FDW;
                Importance = Additional;
                Editable = false;
                ToolTip = 'Specifies the user responsible for calling the customer and accepting and entering their sales orders';
            }
        }
    }
}