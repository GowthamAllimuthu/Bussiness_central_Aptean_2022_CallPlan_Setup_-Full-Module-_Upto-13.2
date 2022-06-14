pageextension 70241765 ResponsibilityCenterCard59FDW extends "Responsibility Center Card"
{
    actions
    {
        addlast(navigation)
        {
            action(CAPS59FDW)
            {
                Caption = 'Call Plan Setup';
                Image = SetupLines;
                ApplicationArea = CallPlanAppArea59FDW;
                ToolTip = 'Set up customer specific call plan settings for the selected customer i.e. whether the customer should be included in call plans and if so on which days the customer should be called by the sales department.';

                trigger OnAction()
                var
                    AccessCallplanCustomer59FDW: Codeunit AccessCallplan59FDW;
                begin
                    AccessCallplanCustomer59FDW.OpenCallPlanResponsibilityCenter(Rec);
                end;
            }
        }
    }
}


