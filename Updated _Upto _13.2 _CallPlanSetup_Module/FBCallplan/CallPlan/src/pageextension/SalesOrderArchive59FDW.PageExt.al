pageextension 70241763 SalesOrderArchive59FDW extends "Sales Order Archive"
{
    layout
    {
        addafter("Salesperson Code")
        {
            field("InsideSalespersonCode59FDW"; Rec.InsideSalespersonCode59FDW)
            {
                ApplicationArea = CallPlanAppArea59FDW;
                ToolTip = 'Specifies the user responsible for calling the customer and archiving sales orders';
                Editable = false;
            }
        }
    }
}