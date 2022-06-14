pageextension 70241757 CustomerCard59FDW extends "Customer Card"
{
    layout
    {
        addafter("Salesperson Code")
        {
            field("Inside Salesperson Code59FDW"; Rec.InsideSalespersonCode59FDW)
            {
                ApplicationArea = CallPlanAppArea59FDW;
                Caption = 'Inside Salesperson Code';
                ToolTip = 'Specifies the user responsible for calling the customer and accepting and entering their sales orders.';
            }
        }
    }
    actions
    {
        addlast("&Customer")
        {
            action(CAPS59FDW)
            {
                Caption = 'Call Plan Setup';
                Image = SetupLines;
                ApplicationArea = CallPlanAppArea59FDW;
                ToolTip = 'Set up customer specific call plan settings, i.e. whether the customer should be included in call plans and if so on which days the customer should be called by the sales department.';
                trigger OnAction()
                var
                    AccessCallplanCustomer59FDW: Codeunit AccessCallplan59FDW;
                begin
                    AccessCallplanCustomer59FDW.OpenCallPlanCustomer(Rec);
                end;
            }
        }
    }
}