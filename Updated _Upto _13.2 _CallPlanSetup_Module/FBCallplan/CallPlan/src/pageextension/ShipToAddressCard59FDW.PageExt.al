pageextension 70241759 ShipToAddressCard59FDW extends "Ship-to Address"
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
}