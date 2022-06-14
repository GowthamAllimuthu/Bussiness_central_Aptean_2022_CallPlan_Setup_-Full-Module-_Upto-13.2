codeunit 70241762 AccessCallplan59FDW
{
    Access = Internal;
    internal procedure OpenCallPlanCustomer(Customer: Record Customer)
    begin
        OpenCallPlanCustomer(Customer, '');
    end;

    internal procedure OpenCallPlanShipToAddress(ShipToAddress: Record "Ship-to Address")
    var
        Customer: Record Customer;
    begin
        Customer.Get(ShipToAddress."Customer No.");
        OpenCallPlanCustomer(Customer, ShipToAddress.Code);
    end;

    internal procedure OpenCallPlanCustomer(Customer: Record Customer; ShipToCode: Code[10])
    var
        ShipToAddressCapSetup59FDW: Record ShipToAddressCapSetup59FDW;
        CAPSetupCustShipToAddr59FDW: Page CAPSetupCustShipToAddr59FDW;
    begin
        if not ShipToAddressCapSetup59FDW.Get(Customer."No.", ShipToCode) then begin
            ShipToAddressCapSetup59FDW.Init();
            ShipToAddressCapSetup59FDW."Customer No." := Customer."No.";
            ShipToAddressCapSetup59FDW."Ship-to Code" := ShipToCode;
            ShipToAddressCapSetup59FDW.Insert(true);
        end;
        ShipToAddressCapSetup59FDW.SetRange("Customer No.", Customer."No.");
        ShipToAddressCapSetup59FDW.SetRange("Ship-to Code", ShipToCode);
        CAPSetupCustShipToAddr59FDW.SetTableView(ShipToAddressCapSetup59FDW);
        CAPSetupCustShipToAddr59FDW.SetCutOffVisible(ShipToCode = '');
        CAPSetupCustShipToAddr59FDW.Run();
    end;

    internal procedure OpenCallPlanResponsibilityCenter(var ResponsibilityCenter: Record "Responsibility Center")
    var
        ResponsibilityCenterCAPS59FDW: Record ResponsibilityCenterCAPS59FDW;
        ResponsibilityCenterCAPS59FDWPage: Page ResponsibilityCenterCAPS59FDW;
    begin
        ResponsibilityCenterCAPS59FDW.SetRange("Responsibility Center Code", ResponsibilityCenter.Code);
        if not ResponsibilityCenterCAPS59FDW.FindFirst() then begin
            ResponsibilityCenterCAPS59FDW.Init();
            ResponsibilityCenterCAPS59FDW."Responsibility Center Code" := ResponsibilityCenter.Code;
            ResponsibilityCenterCAPS59FDW.Insert();
        end;
        ResponsibilityCenterCAPS59FDWPage.SetTableView(ResponsibilityCenterCAPS59FDW);
        ResponsibilityCenterCAPS59FDWPage.Run();
    end;
}