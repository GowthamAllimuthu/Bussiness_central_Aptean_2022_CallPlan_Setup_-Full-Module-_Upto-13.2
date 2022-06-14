codeunit 70241782 "LibraryCallPlanMgmt59FDW"
{
    var
        CallPlanSetupTable59FDW: Record CallPlanSetup59FDW;
        LibrarySales: Codeunit "Library - Sales";
        CustomerCard: TestPage "Customer Card";
        ShipToAddressCard: TestPage "Ship-to Address";
        CallPlanSetup59FDW: TestPage CallPlanSetup59FDW;

    internal procedure AccessCallPlanWorksheetPage(var CAPWorkSheetNames59FDW: TestPage CAPWorkSheetNames59FDW)
    begin
        CallPlanSetup59FDW.OpenEdit();
        CallPlanSetupTable59FDW.Get();
        CallPlanSetup59FDW.GoToRecord(CallPlanSetupTable59FDW);
        CAPWorkSheetNames59FDW.Trap();
        CallPlanSetup59FDW.CallPlanWorksheet59FDW.Invoke();
    end;

    internal procedure CreateCallPlanSetup(var CallPlanSetup59FDW: Record CallPlanSetup59FDW; InsideSalesPersonCode: Option "Call plan","User setup")
    var
        CallDays59FDW: Enum WeekDay59FDW;
    begin
        if not CallPlanSetup59FDW.Get() then
            CallPlanSetup59FDW.Insert();
        CallPlanSetup59FDW.Validate("Enable Cut-off Restrictions", true);
        CallPlanSetup59FDW.Validate("Cut-off Warning Minutes", 30);
        CallPlanSetup59FDW.Validate("Call Day for Monday Shipment", CallDays59FDW::Friday);
        CallPlanSetup59FDW.Validate("Call Day for Tuesday Shipment", CallDays59FDW::Monday);
        CallPlanSetup59FDW.Validate("Call Day for Wednesday Shipment", CallDays59FDW::Tuesday);
        CallPlanSetup59FDW.Validate("Call Day for Thursday Shipment", CallDays59FDW::Wednesday);
        CallPlanSetup59FDW.Validate("Call Day for Friday Shipment", CallDays59FDW::Thursday);
        CallPlanSetup59FDW.Validate("Call Day for Saturday Shipment", CallDays59FDW::Friday);
        CallPlanSetup59FDW.Validate("Call Day for Sunday Shipment", CallDays59FDW::Saturday);
        CallPlanSetup59FDW.Validate("Monday Cut-off Time", 110000T);
        CallPlanSetup59FDW.Validate("Tuesday Cut-off Time", 120000T);
        CallPlanSetup59FDW.Validate("Wednesday Cut-off Time", 130000T);
        CallPlanSetup59FDW.Validate("Thursday Cut-off Time", 140000T);
        CallPlanSetup59FDW.Validate("Friday Cut-off Time", 150000T);
        CallPlanSetup59FDW.Validate("Saturday Cut-off Time", 160000T);
        CallPlanSetup59FDW.Validate("Sunday Cut-off Time", 170000T);
        CallPlanSetup59FDW.Validate("InsideSalesperson Code", InsideSalesPersonCode);
        CallPlanSetup59FDW.Modify();
    end;

    internal procedure CreateNewCAPWorksheetName(var CAPWorkSheetName59FDW: Record CAPWorkSheetName59FDW; WorksheetName: Code[10]; Description: Text[100])
    begin
        CAPWorkSheetName59FDW.Init();
        CAPWorkSheetName59FDW.Name := WorksheetName;
        CAPWorkSheetName59FDW.Description := Description;
        CAPWorkSheetName59FDW.Insert(true);
    end;

    procedure CreateCustomer(var Customer: Record Customer)
    begin
        LibrarySales.CreateCustomer(Customer);
    end;

    procedure CreateSalesPerson(var SalesPersonPurchaser: Record "Salesperson/Purchaser")
    begin
        LibrarySales.CreateSalesperson(SalesPersonPurchaser);
    end;

    procedure CreateCustomerCallplan(var ShipToAddressCapSetup59FDW: Record ShipToAddressCapSetup59FDW; Customer: Record Customer; CallPlanInclusion: Boolean; IncCutoffTime: Boolean)
    begin
        ShipToAddressCapSetup59FDW.Init();
        ShipToAddressCapSetup59FDW."Customer No." := Customer."No.";
        ShipToAddressCapSetup59FDW."Ship-to Code" := '';
        ShipToAddressCapSetup59FDW."Customer Name" := Customer.Name;
        ShipToAddressCapSetup59FDW."Include in Call Plan" := CallPlanInclusion;
        ShipToAddressCapSetup59FDW."Inc.forCutoffTimeRestriction" := IncCutoffTime;
        ShipToAddressCapSetup59FDW.Insert(true);
    end;

    procedure CreateShipToCode(var Customer: Record Customer; var ShipToAddress: Record "Ship-to Address")
    begin
        LibrarySales.CreateShipToAddress(ShipToAddress, Customer."No.");
    end;

    procedure OpenCustomerCard(var Customer: Record Customer; var SalespersonPurchaser: Record "Salesperson/Purchaser"; var PageCAPSetupCustShipToAddr59FDW: TestPage CAPSetupCustShipToAddr59FDW)
    begin
        CustomerCard.OpenEdit();
        CustomerCard.GoToRecord(Customer);
        CustomerCard."Inside Salesperson Code59FDW".SetValue(SalespersonPurchaser.Code);
        PageCAPSetupCustShipToAddr59FDW.Trap();
        CustomerCard.CAPS59FDW.Invoke();
    end;

    procedure OpenShipToCallPlan(var Customer: Record Customer; ShipToAddress: Record "Ship-to Address"; CAPSetupCustShipToAddr59FDWPage: TestPage CAPSetupCustShipToAddr59FDW)
    begin
        CustomerCard.ShipToAddresses.Invoke();
        ShipToAddressCard.OpenEdit();
        ShipToAddressCard.GoToRecord(ShipToAddress);
        CAPSetupCustShipToAddr59FDWPage.Trap();
        ShipToAddressCard.CAPS59FDW.Invoke();
        ShipToAddressCard.Close();
        CustomerCard.Close();
    end;

    procedure CreateCustomerShipToCallPlan(var ShipToAddressCapSetup59FDW: Record ShipToAddressCapSetup59FDW; Customer: Record Customer; ShipToAddress: Record "Ship-to Address"; CallplanInclusionShipTo: Boolean)
    begin
        ShipToAddressCapSetup59FDW.Init();
        ShipToAddressCapSetup59FDW."Customer No." := ShipToAddress."Customer No.";
        ShipToAddressCapSetup59FDW."Ship-to Code" := ShipToAddress.Code;
        ShipToAddressCapSetup59FDW."Customer Name" := ShipToAddress.Name;
        ShipToAddressCapSetup59FDW."Ship-to Name" := ShipToAddress.Name;
        ShipToAddressCapSetup59FDW."Include in Call Plan" := CallplanInclusionShipTo;
        ShipToAddressCapSetup59FDW.Insert(true);
    end;

    procedure SetIncludeinCallPlanForCustomer(var Customer: Record Customer; SalespersonPurchaser: Record "Salesperson/Purchaser"; ShipToAddress: Record "Ship-to Address")
    var
        PageCAPSetupCustShipToAddr59FDW: TestPage CAPSetupCustShipToAddr59FDW;
    begin
        CustomerCard.OpenEdit();
        CustomerCard.GoToRecord(Customer);
        CustomerCard."Inside Salesperson Code59FDW".SetValue(SalespersonPurchaser.Code);
        PageCAPSetupCustShipToAddr59FDW.Trap();
        CustomerCard.CAPS59FDW.Invoke();
        PageCAPSetupCustShipToAddr59FDW."Include in Call Plan".SetValue(true);
        PageCAPSetupCustShipToAddr59FDW.Close();
        CustomerCard.Close();
    end;

    procedure SetIncludeinCallPlanForShipTo(var Customer: Record Customer; ShipToAddress: Record "Ship-to Address")
    var
        CAPSetupCustShipToAddr59FDWPage: TestPage CAPSetupCustShipToAddr59FDW;
    begin
        ShipToAddressCard.OpenEdit();
        ShipToAddressCard.GoToRecord(ShipToAddress);
        CAPSetupCustShipToAddr59FDWPage.Trap();
        ShipToAddressCard.CAPS59FDW.Invoke();
        CAPSetupCustShipToAddr59FDWPage."Include in Call Plan".SetValue(true);
        CAPSetupCustShipToAddr59FDWPage.Close();
        ShipToAddressCard.Close();
    end;

    internal procedure SetCallday(var CAPStructure59FDW: Record CAPStructure59FDW; ShipmentDay: Enum WeekDay59FDW)
    begin
        CAPStructure59FDW.Init();
        CAPStructure59FDW.Validate("Shipment Day", ShipmentDay);
        CAPStructure59FDW.Validate("Call Day", UpdateCallDayFromSetup(CAPStructure59FDW));
        CAPStructure59FDW.Insert(true);
    end;

    local procedure UpdateCallDayFromSetup(var CAPStructure59FDW: Record CAPStructure59FDW): Enum WeekDay59FDW
    begin
        case CAPStructure59FDW."Shipment Day" of
            CAPStructure59FDW."Shipment Day"::Monday:
                exit(CallPlanSetupTable59FDW."Call Day for Monday Shipment");
            CAPStructure59FDW."Shipment Day"::Tuesday:
                exit(CallPlanSetupTable59FDW."Call Day for Tuesday Shipment");
            CAPStructure59FDW."Shipment Day"::Wednesday:
                exit(CallPlanSetupTable59FDW."Call Day for Wednesday Shipment");
            CAPStructure59FDW."Shipment Day"::Thursday:
                exit(CallPlanSetupTable59FDW."Call Day for Thursday Shipment");
            CAPStructure59FDW."Shipment Day"::Friday:
                exit(CallPlanSetupTable59FDW."Call Day for Friday Shipment");
            CAPStructure59FDW."Shipment Day"::Saturday:
                exit(CallPlanSetupTable59FDW."Call Day for Saturday Shipment");
        end
    end;

    internal procedure CreateCAPWorksheetName(var CAPWorkSheetNames59FDW: Record CAPWorkSheetName59FDW; WorkSheetName: Code[10])
    begin
        CAPWorkSheetNames59FDW.Init();
        CAPWorkSheetNames59FDW.Name := WorkSheetName;
        CAPWorkSheetNames59FDW.Insert(true);
    end;

    internal procedure DeleteCAPWorksheetName(var CAPWorksheetName59FDW: Record CAPWorkSheetName59FDW; WorkSheetName: Code[10])
    begin
        CAPWorksheetName59FDW.Get(WorkSheetName);
        CAPWorksheetName59FDW.Delete(true);
    end;

    internal procedure CreateWorksheetEntry(var CAPWorkSheetEntry59FDW: Record CAPWorkSheetEntry59FDW; CurrentWorkSheetName: Code[10]; CurrentLineNo: Integer; Customer: Record Customer; NewCallDate: Date; SalesPersonCode: Code[20]; ShipmentDate: Date; DeliveryDate: Date; CallStatus: Option; OrderEntryCutofEntryTime: Time)
    begin
        CAPWorkSheetEntry59FDW.Init();
        CAPWorkSheetEntry59FDW."Customer No." := Customer."No.";
        CAPWorkSheetEntry59FDW."Worksheet Name" := CurrentWorkSheetName;
        CAPWorkSheetEntry59FDW."Line No." := CurrentLineNo;
        CAPWorkSheetEntry59FDW."Call Date" := NewCallDate;
        CAPWorkSheetEntry59FDW."Inside Salesperson Code" := SalesPersonCode;
        CAPWorkSheetEntry59FDW."Order Entry Cut-off Time" := OrderEntryCutofEntryTime;
        CAPWorkSheetEntry59FDW."Shipment Date" := ShipmentDate;
        CAPWorkSheetEntry59FDW."Delivery Date" := DeliveryDate;
        CAPWorkSheetEntry59FDW."Call Plan Status" := CallStatus;
        CAPWorkSheetEntry59FDW.Insert(true);
    end;

    internal procedure CreateShipToAddressList(var ShipToAddress: Record "Ship-to Address"; Customer: Record Customer)
    begin
        LibrarySales.CreateShipToAddress(ShipToAddress, Customer."No.");
    end;

    internal procedure EditCAPWorkSheetName(var CAPWorkSheetEntry59FDW: Record CAPWorkSheetEntry59FDW; CurrentWorkSheetName: Code[10]; CurrentLineNo: Integer; Customer: Record Customer; EditCallDate: Date; EditSalespersonCode: Code[20]; EditShipmentDate: Date; EditDeliveryDate: Date; CallStatus: Option)
    begin
        CAPWorkSheetEntry59FDW.Rename(CurrentWorkSheetName, CurrentLineNo);
        CAPWorkSheetEntry59FDW.Validate("Customer No.", Customer."No.");
        CAPWorkSheetEntry59FDW.Validate("Call Date", EditCallDate);
        CAPWorkSheetEntry59FDW.Validate("Inside Salesperson Code", EditSalespersonCode);
        CAPWorkSheetEntry59FDW.Validate("Shipment Date", EditShipmentDate);
        CAPWorkSheetEntry59FDW.Validate("Delivery Date", EditDeliveryDate);
        CAPWorkSheetEntry59FDW.Validate("Call Plan Status", CallStatus);
        CAPWorkSheetEntry59FDW.Modify(true);
    end;

    internal procedure OrderEntryCutofftimeWarningShow(CAPWorkSheetEntry59FDW: Record CAPWorkSheetEntry59FDW; CallPlanSetup59FDW: Record CallPlanSetup59FDW; CurrentTime: Time): Text
    var
        WarningMinutes: Duration;
        OrderEntryCutOffStyle: Text;
    begin
        OrderEntryCutOffStyle := 'Standard';
        if (CAPWorkSheetEntry59FDW."Order Entry Cut-off Time" = 0T) or (CurrentTime = 0T) then
            exit;
        WarningMinutes := 1000 * CallPlanSetup59FDW."Cut-off Warning Minutes" * 60;
        case CallPlanSetup59FDW."Enable Cut-off Restrictions" of
            (CallPlanSetup59FDW."Cut-off Warning Minutes" <> 0) and (CurrentTime >= (CAPWorkSheetEntry59FDW."Order Entry Cut-off Time" - WarningMinutes)) and (CurrentTime < CAPWorkSheetEntry59FDW."Order Entry Cut-off Time"):
                OrderEntryCutOffStyle := 'Ambiguous';
            (CurrentTime >= CAPWorkSheetEntry59FDW."Order Entry Cut-off Time"):
                OrderEntryCutOffStyle := 'Unfavorable';
        end;
        exit(OrderEntryCutOffStyle);
    end;

    internal procedure CreateCallplanheader(var ShipToAddressCapSetup59FDW: Record ShipToAddressCapSetup59FDW; var Customer59FDW: Record Customer)
    begin
        ShipToAddressCapSetup59FDW.Init();
        ShipToAddressCapSetup59FDW.Validate("Customer No.", Customer59FDW."No.");
        ShipToAddressCapSetup59FDW.Validate("Include in Call Plan", true);
        ShipToAddressCapSetup59FDW.Insert();
    end;

    internal procedure CreateCallplanStructure(var CAPStructure59FDW: Record CAPStructure59FDW; CustomerNo: Code[20]; StartDate: Date; EndingDate: Date; ShipmentDay: Enum WeekDay59FDW; CallDay: Enum WeekDay59FDW; CallWindowStartingTime: Time; CallWindowEndingTime: Time; ShipToAdress: Code[10]; Note: Text[100])
    begin
        if StartDate <> 0D then
            CAPStructure59FDW.Init();
        CAPStructure59FDW.Validate("Customer No.", CustomerNo);
        CAPStructure59FDW.Validate("Ship-To Code", ShipToAdress);
        CAPStructure59FDW.Validate("Starting Date", StartDate);
        CAPStructure59FDW.Validate("Ending Date", EndingDate);
        CAPStructure59FDW.Validate("Shipment Day", ShipmentDay);
        CAPStructure59FDW.Validate("Call Day", CallDay);
        CAPStructure59FDW.Validate("Call Window Starting Time", CallWindowStartingTime);
        CAPStructure59FDW.Validate("Call Window Ending Time", CallWindowEndingTime);
        CAPStructure59FDW.Validate(Note, Note);
        CAPStructure59FDW.Insert();
    end;

    internal procedure DeletingCAPStructureRecords(var CAPStructure59FDW: Record CAPStructure59FDW; StartingDate: Date)
    begin
        CAPStructure59FDW.Delete(true);
    end;

    internal procedure CreateWorksheetEntry(var CAPWorkSheetEntry59FDW: Record CAPWorkSheetEntry59FDW; var SalesPersonPurchaser: Record "Salesperson/Purchaser"; var Customer: Record Customer; var WeekDays: Enum WeekDay59FDW; var ShipToAddress: Record "Ship-to Address"; var CallPlanStatus: Option "New","Completed","Retry"; var CAPWorkSheetName59FDW: Record CAPWorkSheetName59FDW; LineNo: Integer)
    begin
        CAPWorkSheetEntry59FDW.Init();
        CAPWorkSheetEntry59FDW.Validate("Worksheet Name", CAPWorkSheetName59FDW.Name);
        CAPWorkSheetEntry59FDW.Validate("Line No.", LineNo);
        CAPWorkSheetEntry59FDW.Validate("Call Plan Status", CallPlanStatus::New);
        CAPWorkSheetEntry59FDW.Validate("Customer No.", Customer."No.");
        CAPWorkSheetEntry59FDW.Validate("Customer Name", Customer.Name);
        CAPWorkSheetEntry59FDW.Validate("Call Date", 20220426D);
        CAPWorkSheetEntry59FDW.Validate("Shipment Date", 20220428D);
        CAPWorkSheetEntry59FDW.Validate("Shipment Day", WeekDays::Monday);
        CAPWorkSheetEntry59FDW.Validate("Delivery Date", 20220430D);
        CAPWorkSheetEntry59FDW.Validate("Delivery Day", WeekDays::Thursday);
        CAPWorkSheetEntry59FDW.Validate("Inside Salesperson Code", SalesPersonPurchaser.Code);
        CAPWorkSheetEntry59FDW.Validate("Ship-To Code", ShipToAddress.Code);
        CAPWorkSheetEntry59FDW.Validate("Ship-To Name", ShipToAddress.Name);
        CAPWorkSheetEntry59FDW.Validate("Order Entry Cut-off Time", 120000T);
        CAPWorkSheetEntry59FDW.Insert();
    end;

    internal procedure CreateSalesHeader(var SalesHeader: Record "Sales Header"; CustomerNo: Code[20])
    begin
        LibrarySales.CreateSalesHeader(SalesHeader, SalesHeader."Document Type"::Order, CustomerNo);
    end;

    internal procedure UpdateCallPlanOrders(var CAPWorkSheetEntry59FDW: Record CAPWorkSheetEntry59FDW)
    var
    begin
        CAPWorkSheetEntry59FDW.CalcFields("Call Plan Orders")
    end;

    internal procedure CreateSalesOrder(var SalesHeader: Record "Sales Header"; var CAPWorkSheetEntry59FDW: Record CAPWorkSheetEntry59FDW; Status: Enum "Sales Document Status"; DocumentType: Enum "Sales Document Type"; var Customer: Record Customer)
    begin
        LibrarySales.CreateSalesHeader(SalesHeader, DocumentType::Order, Customer."No.");
        SalesHeader.Validate("Ship-to Code", CAPWorkSheetEntry59FDW."Ship-To Code");
        SalesHeader.Validate("Shipment Date", CAPWorkSheetEntry59FDW."Shipment Date");
        SalesHeader.Validate(Status, Status::Open);
        SalesHeader.Modify(true);
    end;

    internal procedure UpdateExistingOrders(var CAPWorkSheetEntry59FDW: Record CAPWorkSheetEntry59FDW)
    var
    begin
        CAPWorkSheetEntry59FDW.CalcFields("Existing Orders");
    end;

    internal procedure SetReportData(var GenerateCallPlanLines59FDW: TestRequestPage GenerateCallPlanLines59FDW; CallDate: Date; CallDay: Enum WeekDay59FDW; ClearLines: Boolean)
    begin
        GenerateCallPlanLines59FDW.CallDatePage.SetValue(CallDate);
        GenerateCallPlanLines59FDW.ClearExistingLinesPage.SetValue(ClearLines);
        GenerateCallPlanLines59FDW.DayoftheWeekPage.SetValue(CallDay);
    end;

    internal procedure SetCallDayShipmentDay(var Customer: Record Customer; SalesPersonPurchaser: Record "Salesperson/Purchaser")
    var
        WeeKDays59FDW: Enum WeekDay59FDW;
        PageCAPSetupCustShipToAddr59FDW: TestPage CAPSetupCustShipToAddr59FDW;
    begin
        CustomerCard.OpenEdit();
        CustomerCard.GoToRecord(Customer);
        CustomerCard."Inside Salesperson Code59FDW".SetValue(SalesPersonPurchaser.Code);
        PageCAPSetupCustShipToAddr59FDW.Trap();
        CustomerCard.CAPS59FDW.Invoke();
        PageCAPSetupCustShipToAddr59FDW."Include in Call Plan".SetValue(true);
        PageCAPSetupCustShipToAddr59FDW.CallPlanStructure."Call Day".SetValue(WeeKDays59FDW::Tuesday);
        PageCAPSetupCustShipToAddr59FDW.CallPlanStructure."Shipment Day".SetValue(WeeKDays59FDW::Wednesday);
        PageCAPSetupCustShipToAddr59FDW.Close();
        CustomerCard.Close();
    end;

    internal procedure GetWeekDay(CurrentDate: Date): Enum WeekDay59FDW
    var
        RecordDate: Record Date;
    begin
        RecordDate.Get(RecordDate."Period Type"::Date, CurrentDate);
        exit(Enum::WeekDay59FDW.FromInteger(RecordDate."Period No."));
    end;

    internal procedure CheckDataInWorksheetEntry(var CAPWorkSheetEntry59FDW: Record CAPWorkSheetEntry59FDW)
    begin
        CAPWorkSheetEntry59FDW.TestField("Customer No.");
        CAPWorkSheetEntry59FDW.TestField("Call Date");
        CAPWorkSheetEntry59FDW.TestField("Shipment Date");
        CAPWorkSheetEntry59FDW.TestField("Shipment Day");
        CAPWorkSheetEntry59FDW.TestField("Delivery Date");
        CAPWorkSheetEntry59FDW.TestField("Delivery Day");
        CAPWorkSheetEntry59FDW.TestField(Note);
    end;

    internal procedure SetFiltersForRequestPage(var Customer: Record Customer; var GenerateCallPlanLines59FDW: TestRequestPage GenerateCallPlanLines59FDW; SalespersonPurchaser: Record "Salesperson/Purchaser"; ShiptoAddress: Record "Ship-to Address")
    begin
        GenerateCallPlanLines59FDW.Customer.SetFilter("No.", Customer."No.");
        GenerateCallPlanLines59FDW.Customer.SetFilter("InsideSalespersonCode59FDW", SalespersonPurchaser.Code);
        GenerateCallPlanLines59FDW.Customer.SetFilter("Ship-to Code", ShiptoAddress.Code);
    end;

    internal procedure GetAllRecords(var CAPWorkSheetEntry59FDW: Record CAPWorkSheetEntry59FDW)
    begin
        CAPWorkSheetEntry59FDW.FindSet();
        repeat
            CheckDataInWorksheetEntry(CAPWorkSheetEntry59FDW);
        until CAPWorkSheetEntry59FDW.Next() = 0;
    end;

    internal procedure CreateUserSetup(var UserSetup: Record "User Setup")
    begin
        if not UserSetup.Get(UserId) then begin
            UserSetup.Init();
            UserSetup."User ID" := UserId();
            UserSetup.Insert();
        end;
    end;

    internal procedure InsertSalesPersonCodeInUserSetUp(var UserSetup: Record "User Setup")
    var
        Salespersonpurchaser: Record "Salesperson/Purchaser";
    begin
        LibrarySales.CreateSalesperson(Salespersonpurchaser);
        CreateUserSetup(UserSetup);
        UserSetup."Salespers./Purch. Code" := Salespersonpurchaser.Code;
        UserSetup.Modify();
    end;

    internal procedure SetBlankValueForSalesPerson(var UserSetup: Record "User Setup")
    begin
        CreateUserSetup(UserSetup);
        UserSetup."Salespers./Purch. Code" := '';
        UserSetup.Modify();
    end;

    internal procedure UpdateCutoffTimeFromSetup(var OrderDay: Enum WeekDay59FDW; var CallPlanSetupTable59FDW: Record CallPlanSetup59FDW): Time
    begin
        case OrderDay of
            OrderDay::Monday:
                exit(CallPlanSetupTable59FDW."Monday Cut-off Time");
            OrderDay::Tuesday:
                exit(CallPlanSetupTable59FDW."Tuesday Cut-off Time");
            OrderDay::Wednesday:
                exit(CallPlanSetupTable59FDW."Wednesday Cut-off Time");
            OrderDay::Thursday:
                exit(CallPlanSetupTable59FDW."Thursday Cut-off Time");
            OrderDay::Friday:
                exit(CallPlanSetupTable59FDW."Friday Cut-off Time");
            OrderDay::Saturday:
                exit(CallPlanSetupTable59FDW."Saturday Cut-off Time");
            OrderDay::Sunday:
                exit(CallPlanSetupTable59FDW."Sunday Cut-off Time");
        end
    end;

    internal procedure IsSalesLineValidForInsert(var SalesHeader: Record "Sales Header"; OrderDayCutOffTime: Time; Today: Date; SystemTime: Time)
    var
        InsertModifyErr: Label 'It is not possible to edit the sales lines anymore, because based on the call day linked to the shipment day of the order, the cut-off time for this order was set up to be [#1########,#2######], which has passed. ', Comment = '%1=WeekDay, %2=CurrentDayCutOffTime';
    begin
        if SalesHeader."Order Date" = Today then
            if (OrderDayCutOffTime <> 0T) and (OrderDayCutOffTime <= SystemTime) then
                Error(InsertModifyErr);
    end;

    internal procedure IsSalesLineValidForModify(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; OrderDayCutOffTime: Time; Today: Date; SystemTime: Time; Quantity: Integer)
    var
        InsertModifyErr: Label 'It is not possible to edit the sales lines anymore, because based on the call day linked to the shipment day of the order, the cut-off time for this order was set up to be [#1########,#2######], which has passed. ', Comment = '%1=WeekDay, %2=CurrentDayCutOffTime';
    begin
        if SalesHeader."Order Date" = Today then
            if SalesLine.Quantity <> Quantity then
                if (OrderDayCutOffTime <> 0T) and (OrderDayCutOffTime <= SystemTime) then
                    Error(InsertModifyErr);
    end;

    internal procedure IsSalesLineValidForDelete(var SalesHeader: Record "Sales Header"; OrderDayCutOffTime: Time; Today: Date; SystemTime: Time)
    var
        DeleteErr: Label 'It is not possible to delete the sales lines anymore, because based on the call day linked to the shipment day of the order, the cut-off time for this order was set up to be [#1########,#2######], which has passed. ', Comment = '%1=WeekDay, %2=CurrentDayCutOffTime';
    begin
        if SalesHeader."Order Date" = Today then
            if (OrderDayCutOffTime <> 0T) and (OrderDayCutOffTime <= SystemTime) then
                Error(DeleteErr);
    end;

    internal procedure ArchiveSalesDocument(var SalesHeader: Record "Sales Header")
    var
        ArchiveManagement: Codeunit ArchiveManagement;
    begin
        ArchiveManagement.ArchiveSalesDocument(SalesHeader);
    end;

    internal procedure RestoreSalesDocument(var SalesHeaderArchive: Record "Sales Header Archive")
    var
        ArchiveManagement: Codeunit ArchiveManagement;
    begin
        ArchiveManagement.RestoreSalesDocument(SalesHeaderArchive);
    end;

    internal procedure CreateWorksheetEntryWithShipToAddress(var CAPWorkSheetEntry59FDW: Record CAPWorkSheetEntry59FDW; CurrentWorkSheetName: Code[10]; CurrentLineNo: Integer; Customer: Record Customer; ShipToAddress: Record "Ship-to Address"; NewCallDate: Date; SalesPersonCode: Code[20]; ShipmentDate: Date; DeliveryDate: Date; CallStatus: Option; OrderEntryCutofEntryTime: Time)
    begin
        CAPWorkSheetEntry59FDW.Init();
        CAPWorkSheetEntry59FDW."Customer No." := Customer."No.";
        CAPWorkSheetEntry59FDW."Ship-To Code" := ShipToAddress.Code;
        CAPWorkSheetEntry59FDW."Worksheet Name" := CurrentWorkSheetName;
        CAPWorkSheetEntry59FDW."Line No." := CurrentLineNo;
        CAPWorkSheetEntry59FDW."Call Date" := NewCallDate;
        CAPWorkSheetEntry59FDW."Inside Salesperson Code" := SalesPersonCode;
        CAPWorkSheetEntry59FDW."Order Entry Cut-off Time" := OrderEntryCutofEntryTime;
        CAPWorkSheetEntry59FDW."Shipment Date" := ShipmentDate;
        CAPWorkSheetEntry59FDW."Delivery Date" := DeliveryDate;
        CAPWorkSheetEntry59FDW."Call Plan Status" := CallStatus;
        CAPWorkSheetEntry59FDW.Insert(true);
    end;

    internal procedure CreateServiceAgentCodeForShipToAddress(CAPStructure59FDW: Record CAPStructure59FDW; var ShipToAddress: Record "Ship-to Address"; ShippingAgentServices: Record "Shipping Agent Services"; ShippingAgent: Record "Shipping Agent")
    var
        LibraryInventory: Codeunit "Library - Inventory";
        ShipmentDuration: DateFormula;
    begin
        ShipToAddress.Get(CAPStructure59FDW."Customer No.", CAPStructure59FDW."Ship-To Code");
        LibraryInventory.CreateShippingAgent(ShippingAgent);
        if Format(ShipmentDuration) = '' then
            Evaluate(ShipmentDuration, '<2D>');
        LibraryInventory.CreateShippingAgentService(ShippingAgentServices, ShippingAgent.Code, ShipmentDuration);
        ShipToAddress.Validate("Shipping Agent Code", ShippingAgent.Code);
        ShipToAddress.Validate("Shipping Agent Service Code", ShippingAgentServices.Code);
        ShipToAddress.Modify(true);
    end;

    internal procedure CreateServiceAgentForCustomer(CAPStructure59FDW: Record CAPStructure59FDW; var Customer: Record Customer; var ShipToAddress: Record "Ship-to Address"; ShippingAgentServices: Record "Shipping Agent Services"; ShippingAgent: Record "Shipping Agent")
    var
        LibraryInventory: Codeunit "Library - Inventory";
        ShipmentDuration: DateFormula;
    begin
        ShipToAddress.Get(CAPStructure59FDW."Customer No.", CAPStructure59FDW."Ship-To Code");
        ShipToAddress.Validate("Shipping Agent Service Code", '');
        ShipToAddress.Modify(true);
        LibraryInventory.CreateShippingAgent(ShippingAgent);
        if Format(ShipmentDuration) = '' then
            Evaluate(ShipmentDuration, '<1D>');
        LibraryInventory.CreateShippingAgentService(ShippingAgentServices, ShippingAgent.Code, ShipmentDuration);
        Customer.Get(CAPStructure59FDW."Customer No.");
        Customer.Validate("Shipping Agent Code", ShippingAgent.Code);
        Customer.Validate("Shipping Agent Service Code", ShippingAgentServices.Code);
        Customer.Modify(true);
    end;

    internal procedure CreateShippingTimeInCustomer(CAPStructure59FDW: Record CAPStructure59FDW; var Customer: Record Customer)
    var
        ShipmentDuration: DateFormula;
    begin
        Customer.Get(CAPStructure59FDW."Customer No.");
        Customer.Validate("Shipping Agent Code", '');
        Customer.Validate("Shipping Agent Service Code", '');
        Customer.Modify(true);
        if Format(ShipmentDuration) = '' then
            Evaluate(ShipmentDuration, '<3D>');
        Customer.Validate("Shipping Time", ShipmentDuration);
        Customer.Modify(true);
    end;

    internal procedure CreateResponsibilityCenterCode(var ResponsibilityCenter: Record "Responsibility Center"; NewResponsibilityCenterCode: Code[10])
    begin
        ResponsibilityCenter.Init();
        ResponsibilityCenter.Code := NewResponsibilityCenterCode;
        ResponsibilityCenter.Insert(true);
    end;
}