pageextension 70241766 ResponsibilityCenterList59FDW extends "Responsibility Center List"
{
    actions
    {
        addlast(navigation)
        {
            action(CAPS59FDW)
            {
                Caption = 'Call Plan Setup';
                Image = SetupLines;
                Enabled = EnableCAPSetup;
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
    var
        [InDataSet]
        EnableCAPSetup: Boolean;

    trigger OnAfterGetCurrRecord()
    begin
        EnableCAPSetup := Rec.Code <> '';
    end;
}