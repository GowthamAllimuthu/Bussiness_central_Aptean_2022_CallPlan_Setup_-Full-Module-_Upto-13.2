codeunit 70241760 CreateSalesOrder59FDW
{
    internal procedure CreateNewSalesOrder(var CAPWorkSheetEntry59FDW: Record CAPWorkSheetEntry59FDW)
    var
        SalesHeader: Record "Sales Header";
        SalesOrder: Page "Sales Order";
    begin
        CAPWorkSheetEntry59FDW.TestField("Customer No.");
        SalesHeader.Init();
        SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
        SalesHeader.InsideSalespersonCode59FDW := GetInsideSalesPersonCode(CAPWorkSheetEntry59FDW);
        SalesHeader."Requested Delivery Date" := CAPWorkSheetEntry59FDW."Delivery Date";
        SalesHeader.Insert(true);
        SalesHeader.Validate("Sell-to Customer No.", CAPWorkSheetEntry59FDW."Customer No.");
        if CAPWorkSheetEntry59FDW."Ship-To Code" <> '' then
            SalesHeader.Validate("Ship-to Code", CAPWorkSheetEntry59FDW."Ship-To Code");
        if CAPWorkSheetEntry59FDW."Shipment Date" <> 0D then
            SalesHeader.Validate("Shipment Date", CAPWorkSheetEntry59FDW."Shipment Date");
        if CAPWorkSheetEntry59FDW."Delivery Date" <> 0D then
            SalesHeader.Validate("Requested Delivery Date", CAPWorkSheetEntry59FDW."Delivery Date");
        SalesHeader.Modify(true);
        CompletingCallPlanStatus(CAPWorkSheetEntry59FDW);
        SalesOrder.SetRecord(SalesHeader);
        SalesOrder.Run();
    end;

    local procedure GetInsideSalesPersonCode(var CAPWorkSheetEntry59FDW: Record CAPWorkSheetEntry59FDW): Code[20]
    var
        CallPlanSetup59FDW: Record CallPlanSetup59FDW;
        UserSetup: Record "User Setup";
    begin
        CallPlanSetup59FDW.Get();
        if CallPlanSetup59FDW."InsideSalesperson Code" = CallPlanSetup59FDW."InsideSalesperson Code"::"Call plan" then
            exit(CAPWorkSheetEntry59FDW."Inside Salesperson Code")
        else
            if UserSetup.Get(UserId) then
                exit(UserSetup."Salespers./Purch. Code");
        exit(CAPWorkSheetEntry59FDW."Inside Salesperson Code");
    end;

    local procedure CompletingCallPlanStatus(var CAPWorkSheetEntry59FDW: Record CAPWorkSheetEntry59FDW)
    begin
        CAPWorkSheetEntry59FDW."Call Plan Status" := CAPWorkSheetEntry59FDW."Call Plan Status"::Completed;
    end;

    internal procedure SendInsideSalespersonNotification(InsideSalespersonCode: Code[20])
    var
        CallplanSetup: Record CallPlanSetup59FDW;
        UserSetup: Record "User Setup";
        InsideSalesPersonMsg: Label '''Inside Salesperson Code'' could not be automatically specified, because no salesperson is set up on the User Setup page for user [%1]. Please select a value manually.', Comment = '%1=User ID';
    begin
        CallplanSetup.Get();
        if CallplanSetup."InsideSalesperson Code" = CallplanSetup."InsideSalesperson Code"::"User setup" then
            if not UserSetup.Get(UserId) then
                if InsideSalespersonCode = '' then
                    Message(StrSubstNo(InsideSalesPersonMsg, UserId));
    end;

    internal procedure UpdateInsideSalesPersoncode(var SalesHeader: Record "Sales Header"; Customer: Record Customer)
    var
        CallPlanSetup59FDW: Record CallPlanSetup59FDW;
        ShipToAddressCapSetup59FDW: Record ShipToAddressCapSetup59FDW;
        UserSetup: Record "User Setup";
    begin
        if SalesHeader."Document Type" <> SalesHeader."Document Type"::Order then
            exit;
        CallPlanSetup59FDW.Get();
        SalesHeader.InsideSalespersonCode59FDW := '';
        case CallPlanSetup59FDW."InsideSalesperson Code" of
            CallPlanSetup59FDW."InsideSalesperson Code"::"Call plan":
                if ShipToAddressCapSetup59FDW.Get(SalesHeader."Sell-to Customer No.", '') then
                    if ShipToAddressCapSetup59FDW."Include in Call Plan" then begin
                        Customer.Get(SalesHeader."Sell-to Customer No.");
                        if Customer.InsideSalespersonCode59FDW <> '' then
                            SalesHeader.InsideSalespersonCode59FDW := Customer.InsideSalespersonCode59FDW;
                    end;
            CallPlanSetup59FDW."InsideSalesperson Code"::"User setup":
                if UserSetup.Get(UserId) then begin
                    if UserSetup."Salespers./Purch. Code" <> '' then
                        SalesHeader.InsideSalespersonCode59FDW := UserSetup."Salespers./Purch. Code";
                end else
                    if ShipToAddressCapSetup59FDW.Get(SalesHeader."Sell-to Customer No.", '') then
                        if ShipToAddressCapSetup59FDW."Include in Call Plan" then begin
                            Customer.Get(SalesHeader."Sell-to Customer No.");
                            if Customer.InsideSalespersonCode59FDW <> '' then
                                SalesHeader.InsideSalespersonCode59FDW := Customer.InsideSalespersonCode59FDW;
                        end;
        end;
    end;

    internal procedure UpdateIncludeforCutoffTime(var SalesHeader: Record "Sales Header")
    var
        ShipToAddressCapSetup59FDW: Record ShipToAddressCapSetup59FDW;
    begin
        if ShipToAddressCapSetup59FDW.Get(SalesHeader."Sell-to Customer No.", '') then
            SalesHeader.IncludeforCutoffTime59FDW := ShipToAddressCapSetup59FDW."Inc.forCutoffTimeRestriction"
        else
            SalesHeader.IncludeforCutoffTime59FDW := false;
    end;
}