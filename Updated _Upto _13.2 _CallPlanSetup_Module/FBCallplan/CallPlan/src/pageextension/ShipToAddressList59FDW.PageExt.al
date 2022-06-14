pageextension 70241758 ShipToAddressList59FDW extends "Ship-to Address List"
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
                ToolTip = 'Set up address specific call plan settings for the selected ship-to address i.e. whether the ship-to address should be included in call plans and if so on which days the customer should be called by the sales department.';
                trigger OnAction()
                var
                    AccessShipToAddress59FDW: Codeunit AccessCallplan59FDW;
                begin
                    AccessShipToAddress59FDW.OpenCallPlanShipToAddress(Rec);
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