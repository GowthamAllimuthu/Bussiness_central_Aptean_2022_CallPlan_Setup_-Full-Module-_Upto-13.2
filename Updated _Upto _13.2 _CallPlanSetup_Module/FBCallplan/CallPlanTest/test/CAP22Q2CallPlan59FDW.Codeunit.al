codeunit 70241783 "CAP22Q2CallPlan59FDW"
{
    Subtype = test;

    trigger OnRun()
    begin
        //[FEATURE] Call Plan Setup
    end;

    var
        CallPlanSetupTable59FDW: Record CallPlanSetup59FDW;
        CAPWorkSheetName59FDW: Record CAPWorkSheetName59FDW;
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesHeader: Record "Sales Header";
        Customer: Record Customer;
        SalesLine: Record "Sales Line";
        Item: Record Item;
        ShiptoAddress: Record "Ship-to Address";
        UserSetup: Record "User Setup";
        SalesPersonPurchaser: Record "Salesperson/Purchaser";
        ShippingAgentServices: Record "Shipping Agent Services";
        ShippingAgent: Record "Shipping Agent";
        ShipToAddressCapSetup59FDW: Record ShipToAddressCapSetup59FDW;
        CAPStructure59FDW: Record CAPStructure59FDW;
        CAPWorkSheetEntry59FDWTable: Record CAPWorkSheetEntry59FDW;
        ResponsibilityCenter: Record "Responsibility Center";
        MoveWorkSheetLines59FDW: Report MoveWorkSheetLines59FDW;
        LibraryAssert: Codeunit "Library Assert";
        LibraryUtility: Codeunit "Library - Utility";
        LibrarySales: Codeunit "Library - Sales";
        LibraryInventory: Codeunit "Library - Inventory";
        LibraryCallPlanMgmt59FDW: Codeunit LibraryCallPlanMgmt59FDW;
        CallplanWorksheetMgt59FDW: Codeunit CallplanWorksheetMgt59FDW;
        IsInitialized: Boolean;
        InsideSalespersonCode: Option "Call plan","User Setup";
        CallPlanStatus: Option "New","Completed","Retry";
        WeekDay59FDW: Enum WeekDay59FDW;
        DocumentType: Enum "Sales Document Type";
        Status: Enum "Sales Document Status";
        CustomerList: TestPage "Customer List";
        CustomerCard: TestPage "Customer Card";
        CallPlanSetup59FDW: TestPage CallPlanSetup59FDW;
        CAPSetupCustShipToAddr59FDW: TestPage CAPSetupCustShipToAddr59FDW;
        CAPWorkSheetEntry59FDW: TestPage CAPWorkSheetEntry59FDW;
        CAPWorkSheetNames59FDW: TestPage CAPWorkSheetNames59FDW;
        SalesOrder: TestPage "Sales Order";
        SalesList: TestPage "Sales List";
        SalesOrderCard: TestPage "Sales Order";
        PageCAPSetupCustShipToAddr59FDW: TestPage CAPSetupCustShipToAddr59FDW;
        CAPSetupCustShipToAddr59FDWPage: TestPage CAPSetupCustShipToAddr59FDW;
        ShiptoAddressList: TestPage "Ship-to Address List";
        CallPlanOrders59FDW: TestPage CallPlanOrders59FDW;
        SalesOrderList: TestPage "Sales Order List";
        ResponsibilityCenterCAPS59FDW: TestPage ResponsibilityCenterCAPS59FDW;
        ResponsibilityCenterCard: TestPage "Responsibility Center Card";
        ToWorkSheetName: Code[10];
        FirstWorkSheetName: Code[10];
        SecondWorkSheetName: Code[10];
        NoOfSelectedLines: Integer;
        InsideSalesPersonCodeErrorMessage: Text;

    local procedure Initialize();
    begin
        LibraryCallPlanMgmt59FDW.CreateCallPlanSetup(CallPlanSetupTable59FDW, InsideSalespersonCode::"Call plan");
        Clear(ShiptoAddress);
        if IsInitialized then
            exit;
        IsInitialized := true;
    end;

    [Test]
    procedure T10_SourceforInsideSalespersonwithdefaultvalueCallPlan()
    // [USER STORY] 1.3 Call Plan Setup : Source for Inside Salesperson
    begin
        // [SCENARIO #10] Source for Inside Salesperson with default value "Call Plan"
        Initialize();
        // [GIVEN] Call Plan Setup page exists
        // [GIVEN] Source for Inside Salesperson dropdown exists
        // [GIVEN] Execute the call plan setup page using Tell me function
        // [WHEN] Verifying default value in the Source for Inside Salesperson dropdown
        // [THEN] Call Plan as a default value in the Source for Inside Salesperson dropdown is verified
        LibraryAssert.AreEqual(CallPlanSetupTable59FDW."InsideSalesperson Code"::"Call plan", CallPlanSetupTable59FDW."InsideSalesperson Code", 'Default value of insideSalesPerson Code is not callplan');
    end;

    [Test]
    procedure T11_SourceforInsideSalespersonwithvalueUserSetup()
    // [USER STORY] 1.3 Call Plan Setup : Source for Inside Salesperson
    var
        CallPlanSetup59FDWTestPage: TestPage CallPlanSetup59FDW;
    begin
        // [SCENARIO #11] Source for Inside Salesperson with value User Setup
        Initialize();
        // [GIVEN] Call Plan Setup page exists
        // [GIVEN] Source for Inside Salesperson dropdown exists
        // [GIVEN] Execute the call plan setup page using Tell me function
        CallPlanSetup59FDWTestPage.OpenEdit();
        CallPlanSetupTable59FDW.Get();
        CallPlanSetup59FDWTestPage.GoToRecord(CallPlanSetupTable59FDW);
        // [WHEN] Selecting User setup from Source for Inside Salesperson dropdown
        CallPlanSetup59FDWTestPage."Source for Inside Salesperson Code".SetValue(InsideSalespersonCode::"User Setup");
        // [THEN] User setup from Source for Inside Salesperson dropdown is selected
        CallPlanSetup59FDWTestPage.Close();
        CallPlanSetupTable59FDW.Get();
        CallPlanSetupTable59FDW.TestField("InsideSalesperson Code", CallPlanSetupTable59FDW."InsideSalesperson Code"::"User setup");
    end;

    [Test]
    procedure T19_ToaccessCallPlanWorkSheetPage()
    // [USER STORY] 1.5 Ability to access Call Plan WorkSheet Page
    begin
        // [SCENARIO #19] To access Call Plan WorkSheet PageFDW;
        Initialize();
        // [GIVEN] Call Plan Setup page exists
        // [GIVEN] Executes call plan WorkSheet Names Page 
        // [WHEN] User Clicks on Call Plan WorkSheet Button in Call Plan Setup
        // [THEN] Call Plan WorkSheet Name Page Executed
        LibraryCallPlanMgmt59FDW.AccessCallPlanWorksheetPage(CAPWorkSheetNames59FDW);
        CAPWorkSheetNames59FDW.Close();
    end;

    [Test]
    [HandlerFunctions('WorksheetNameModalPageHandler')]
    procedure T20_ConfigureCallPlanWorksheetNames()
    // [USER STORY] 2.1 Configure Call Plan Worksheet Names
    begin
        // [SCENARIO #20] Configure Call Plan Worksheet Names
        // [GIVEN] Call Plan Setup page exists
        // [GIVEN] Name field exists in Call Plan Worksheet Entry with type text
        // [GIVEN] Call Plan Worksheet Names Executes from Call Plan Worksheet Entry through lookup of name field in Call Plan worksheet Entry
        // [GIVEN] Call Plan Worksheet Name page Executes with field name with type text
        CAPWorkSheetEntry59FDW.OpenEdit();
        // [WHEN] Click on the assist button to Execute the request page for worksheet names
        // [THEN] Call Plan Worksheet Name page gets configured
        CAPWorkSheetNames59FDW.Trap();
        CAPWorkSheetEntry59FDW.CurrentWorkSheetName.Lookup();
        CAPWorkSheetEntry59FDW.Close();
    end;

    [ModalPageHandler]
    procedure WorksheetNameModalPageHandler(var CAPWorkSheetNames59FDW: TestPage CAPWorkSheetNames59FDW)
    begin
    end;

    [Test]
    procedure T21_TocreatenewrecordsinCallPlanWorksheetNamespage()
    // [USER STORY] 2.1 Configure Call Plan Worksheet Names
    var
        NewWorksheetName: Code[10];
    begin
        // [SCENARIO #21] To create new records in Call Plan Worksheet Names page
        // [GIVEN] Call Plan Setup page exists
        // [GIVEN] Call Plan Worksheet Names page exists
        // [WHEN] Click the new button to create a new entry in call plan worksheet names
        // [THEN] New record created in Call Plan Worksheet Names Page
        NewWorksheetName := LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW);
        LibraryCallPlanMgmt59FDW.CreateNewCAPWorksheetName(CAPWorkSheetName59FDW, NewWorksheetName, 'New sales worksheet added');
    end;

    [Test]
    procedure T23_ToeditrecordsinCallPlanWorksheetNamespage()
    // [USER STORY] 2.1 Configure Call Plan Worksheet Names
    var
        EditedWorksheetName: Code[10];
    begin
        // [SCENARIO #23] To edit records in Call Plan Worksheet Names page
        // [GIVEN] Call Plan Setup page exists
        // [GIVEN] Call Plan worksheet exists
        LibraryCallPlanMgmt59FDW.CreateNewCAPWorksheetName(CAPWorkSheetName59FDW, LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW), 'New worksheet created');
        // [GIVEN] Call plan Worksheet Names exists
        // [GIVEN] Particular record in Call Plan Worksheet Names page exists
        // [WHEN] Click the edit list button in Call Plan Worksheet Names page
        // [THEN] Selected record is edited
        EditedWorksheetName := LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW);
        CAPWorkSheetName59FDW.Rename(EditedWorksheetName);
        //  CAPWorkSheetName59FDW.Get(EditedWorksheetName);
        CAPWorkSheetName59FDW.TestField(Name, EditedWorksheetName);
    end;

    [Test]
    procedure T28_IncludeShiptoaddressincallplanforcustomerhavingnocallplan()
    // [USER STORY] 3.2 To include Ship- to address in the Call Plan Worksheet
    var
        ShipToPageValidationErr: Label 'Not possible to include this ship-to address in the call plan, since the customer itself is not set up to be included in the call plan (on the page ''Call Plan Setup'' for the customer).';
    begin
        // [SCENARIO #28] Include Ship to address in call plan for customer having no call plan
        // [GIVEN] Call Plan Setup page exists
        // [GIVEN] Customer C0011 exists
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        // [GIVEN] Customer C0011 is not included in Call Plan
        // [GIVEN] Ship To Code “Test Route” exists
        // [GIVEN] Salesperson= “Jan” exists
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        // [GIVEN] Execute customer card using the tell me function
        // [GIVEN] Select the customer C0011
        // [GIVEN] Clicks on “Ship-to Addresses” in the ribbon on the Customer card
        // [GIVEN] Select ship- to code as “Test Route”
        // [GIVEN] Execute the page “Call Plan Setup” on Ship- To record ribbon
        LibraryCallPlanMgmt59FDW.CreateShipToCode(Customer, ShiptoAddress);
        LibraryCallPlanMgmt59FDW.OpenCustomerCard(Customer, SalesPersonPurchaser, PageCAPSetupCustShipToAddr59FDW);
        LibraryCallPlanMgmt59FDW.OpenShipToCallPlan(Customer, ShiptoAddress, CAPSetupCustShipToAddr59FDWPage);
        // [GIVEN] Include in call plan is checked
        // [WHEN] Try to include ship to address in the call plan
        ShipToAddressCapSetup59FDW.Get(Customer."No.", ShiptoAddress.Code);
        PageCAPSetupCustShipToAddr59FDW."Include in Call Plan".SetValue(false);
        asserterror CAPSetupCustShipToAddr59FDWPage."Include in Call Plan".SetValue(true);
        // [THEN] Unable to include Ship To Address in the call plan and throws validation error
        LibraryAssert.ExpectedError(ShipToPageValidationErr);
        PageCAPSetupCustShipToAddr59FDW.Close();
        CAPSetupCustShipToAddr59FDWPage.Close();
    end;

    [Test]
    [HandlerFunctions('ConfirmHandler')]
    procedure T29_IncludeShiptoaddressincallplanforcustomerhavingcallplan()
    // [USER STORY] 3.2 To include Ship- to address in the Call Plan Worksheet
    begin
        // [SCENARIO #29] Include Ship to address in call plan for customer having call plan
        // [GIVEN] Call Plan Setup page exists
        // [GIVEN] Customer C0012 exists
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        LibraryCallPlanMgmt59FDW.CreateCustomerCallplan(ShipToAddressCapSetup59FDW, Customer, false, false);
        // [GIVEN] Customer C0012 is included in Call Plan exists
        // [GIVEN] Salesperson Jan exists
        // [GIVEN] Execute customer using the tell me function
        // [GIVEN] clicked on the related button
        // [GIVEN] Customer dropdown exists
        // [GIVEN] Ship-to Addresses in the ribbon exists
        // [GIVEN] Ship- to code as Test Route exists
        LibraryCallPlanMgmt59FDW.CreateShipToCode(Customer, ShiptoAddress);
        // [GIVEN] Execute the Call Plan Setup in the record ribbon
        // [GIVEN] Assigned Insides Salesperson as Jan
        // [GIVEN] Include the customer for cut-off time restriction with boolean values
        // [GIVEN] Contact code 01 is added from the related contacts
        // [GIVEN] Try to include ship to address in the call plan by enabling the include call plan
        // [GIVEN] Contact Name field will be filled with the name associated to the Contact code
        // [GIVEN] Contact Phone No. will be filled with the Phone no. from the Call Plan Contact Record
        // [GIVEN] Contact E-Mail will be filled with the e-mail from the Call Plan Contact Record
        // [GIVEN] Include in call plan is enabled exists
        LibraryCallPlanMgmt59FDW.CreateCustomerShipToCallPlan(ShipToAddressCapSetup59FDW, Customer, ShiptoAddress, false);
        //[WHEN] Try to include ship to address in call plan by enabling the include call plan
        LibraryCallPlanMgmt59FDW.SetIncludeinCallPlanForCustomer(Customer, SalesPersonPurchaser, ShiptoAddress);
        //[THEN] Ship to address is included in the call plan
        LibraryCallPlanMgmt59FDW.SetIncludeinCallPlanForShipTo(Customer, ShiptoAddress);
    end;

    [Test]
    [HandlerFunctions('ConfirmHandler')]
    procedure T30_ToaccesstheCallplanstructurewithcustomerincludedincallplan()
    // [USER STORY] 4.1 Call Plan Structure: Customer Page/List
    begin
        // [SCENARIO #30] To access the Call plan structure with customer included in call plan
        // [GIVEN] Call plan setup page exists
        // [GIVEN] Customer C0011 exists and included in the call plan
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        LibraryCallPlanMgmt59FDW.CreateCustomerCallplan(ShipToAddressCapSetup59FDW, Customer, true, false);
        // [GIVEN] Execute customer page through tell me function
        CustomerList.OpenEdit();
        CustomerList.GoToRecord(Customer);
        // [GIVEN] clicked on the related button
        // [GIVEN] Call plan Setup button exists
        // [GIVEN] Execute for Customer C0011
        // [GIVEN] Call Plan Structure is exists in the Call Plan setup page
        // [WHEN] Open the call plan structure page
        // [THEN] Call plan structure page is executed
        PageCAPSetupCustShipToAddr59FDW.Trap();
        CustomerList.CAPS59FDW.Invoke();
        PageCAPSetupCustShipToAddr59FDW.Close();
        CustomerList.Close();
    end;

    [ConfirmHandler]
    procedure ConfirmHandler(Question: Text[1024]; var Confirmation: Boolean)
    begin
        Confirmation := true;
    end;

    [Test]
    procedure T28_Tocontrolwhetherthecustomergenerallyistobeincludedinthecallplanworksheet()
    // [USER STORY] 3.1 To include customers in the Call Plan Worksheet
    begin
        // [SCENARIO #28] To control whether the customer generally is to be included in the call plan worksheet.
        // [GIVEN] Call Plan Setup page exists
        // [GIVEN] Customer C0011 exists
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        // [GIVEN] Salesperson "Jan" for Customer C0011 exists
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        // [GIVEN] Execute Customers by using Tell me function
        // [GIVEN] Executes customer card for customer C0011
        CustomerList.OpenEdit();
        CustomerList.GoToRecord(Customer);
        CustomerCard.OpenEdit();
        // [GIVEN] Related button in the ribbon exists
        PageCAPSetupCustShipToAddr59FDW.Trap();
        CustomerCard.CAPS59FDW.Invoke();
        // [GIVEN] Customer dropdown exists
        // [GIVEN] Call plan Setup tab exists
        // [GIVEN] Include in Call Plan button exists
        // [GIVEN] Salesperson dropdown with Jan code exists
        // [GIVEN] Contact No exists
        // [GIVEN] Contact Name exists
        // [GIVEN] Contact Phone No exists
        // [GIVEN] Contact Email exists
        // [GIVEN] Enable cut off restriction button exists
        // [WHEN] To include customer to the call plan
        LibraryCallPlanMgmt59FDW.CreateCustomerCallplan(ShipToAddressCapSetup59FDW, Customer, true, false);
        // [THEN] Customer is included in the call plan
        LibraryAssert.AreEqual(ShipToAddressCapSetup59FDW."Include in Call Plan", true, 'Customer is not included in the call plan');
        PageCAPSetupCustShipToAddr59FDW.Close();
        CustomerList.Close();
        CustomerCard.Close();
    end;

    [Test]
    procedure T38_TosettheShipmentdayintheCallPlanstructure()
    // [USER STORY] 4.4 Call Plan Structure: Call days in relation to shipment days
    begin
        // [SCENARIO #38] To set the Shipment day in the Call Plan structure
        Initialize();
        // [GIVEN] Customer C0011 exists
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        // [GIVEN] Customer C0011 is included in Call Plan
        // [GIVEN] Execute customers by using Tell me function
        CustomerList.OpenEdit();
        CustomerList.GoToRecord(Customer);
        CustomerCard.OpenEdit();
        // [GIVEN] clicked on the related button
        // [GIVEN] Customer dropdown exists
        // [GIVEN] Call Plan Setup button exists
        PageCAPSetupCustShipToAddr59FDW.Trap();
        CustomerCard.CAPS59FDW.Invoke();
        // [GIVEN] Default call day for friday shipment exists
        // [GIVEN] Call Plan Structure exists in the call plan setup page
        // [GIVEN] Shipment day dropdown exists with each day of the week
        // [WHEN] Select the Shipment day as Friday
        // [THEN] Shipment day selected
        LibraryCallPlanMgmt59FDW.SetCallday(CAPStructure59FDW, WeekDay59FDW::Monday);
        // [THEN] Call day gets generated
        LibraryAssert.AreEqual(CAPStructure59FDW."Call Day", CallPlanSetupTable59FDW."Call Day for Monday Shipment", 'Call from call plan setup not set');
        PageCAPSetupCustShipToAddr59FDW.Close();
        CustomerList.Close();
        CustomerCard.Close();
    end;

    [Test]
    procedure T25_DeleteCallPlanWorksheetNamewithRecords()
    // [USER STORY] 2.2 Delete “Call Plan Worksheet” Name with records
    var
        CreateNewWorksheetName: Code[10];
        CAPWorkSheetEntryExistErr: Label 'Not possible to delete worksheet name because one or more entries exist in the call plan worksheet that is linked to this name.';
    begin
        // [SCENARIO #25] Deleting Call Plan Worksheet name with records
        // [GIVEN] Call Plan Worksheet page exists
        // [GIVEN] Customer C14229 exists
        // [GIVEN] Execute Call Plan Worksheet page through tell me function
        // [GIVEN] Call Plan Worksheet name exists
        CreateNewWorksheetName := LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW);
        LibraryCallPlanMgmt59FDW.CreateCAPWorksheetName(CAPWorkSheetName59FDW, CreateNewWorksheetName);
        // [GIVEN] Execute call plan lines for the customer C14229 in the worksheet
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        LibraryCallPlanMgmt59FDW.CreateWorksheetEntry(CAPWorkSheetEntry59FDWTable, CreateNewWorksheetName, 1, Customer, 20220422D, SalesPersonPurchaser.Code, 20220423D, 20220423D, CAPWorkSheetEntry59FDWTable."Call Plan Status"::Completed, 120000T);
        // [GIVEN] Call Plan Status as New exists
        // [GIVEN] Assist button on the call plan worksheet name field exists
        // [GIVEN] Customer C14229 with records exists
        // [WHEN] Delete the Call Plan Worksheet
        // [THEN] Record cannot be deleted
        asserterror CAPWorkSheetName59FDW.Delete(true);
        LibraryAssert.ExpectedError(CAPWorkSheetEntryExistErr);
    end;

    [Test]
    procedure T26_CallPlanWorksheetNamewithoutRecords()
    // [USER STORY] 2.2 Delete “Call Plan Worksheet” Name with records
    var
        NewWorksheetName: Code[10];
    begin
        // [SCENARIO #26] Deleting Call Plan Worksheet name without records
        // [GIVEN] Call Plan Worksheet page exists
        // [GIVEN] Call Plan Worksheet exists without records in it
        // [GIVEN] Go to “Call Plan Worksheet” page through tell me function
        // [GIVEN] Click on the Call Plan Worksheet name
        NewWorksheetName := LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW);
        LibraryCallPlanMgmt59FDW.CreateCAPWorksheetName(CAPWorkSheetName59FDW, NewWorksheetName);
        // [GIVEN] Click on assist button on the call plan worksheet name field
        // [GIVEN] Select the worksheet name and click on delete
        // [WHEN] Try to delete the Call Plan Worksheet
        // [THEN] Record get deleted
        LibraryCallPlanMgmt59FDW.DeleteCAPWorksheetName(CAPWorkSheetName59FDW, NewWorksheetName);
    end;

    [Test]
    procedure T31_ToaccesstheCallPlanStructuredirectlyfromtheShipToAddresscardpages()
    // [USER STORY] 4.2 Call Plan Structure: Ship-To Address
    begin
        // [SCENARIO #31] To access the Call Plan Structure directly from the Ship-To Address card pages
        // [GIVEN] Ship-To Addresses for customer C0011 exists
        // [GIVEN] Ship-To code 1 exists
        // [GIVEN] Execute Customers by using Tell me function
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        LibraryCallPlanMgmt59FDW.CreateShipToAddressList(ShiptoAddress, Customer);
        CustomerList.OpenEdit();
        CustomerList.GoToRecord(Customer);
        // [GIVEN] clicked on the related button
        // [GIVEN] Customer dropdown exists
        // [GIVEN] Ship To Address button exists
        // [GIVEN] Clicked on the Related button in the Ship To Address page
        ShiptoAddressList.Trap();
        CustomerList.ShipToAddresses.Invoke();
        ShiptoAddressList.GoToRecord(ShiptoAddress);
        // [WHEN] Execute the call plan structure from Ship-To Address page
        // [THEN] Call Plan Structure from the Ship-To-Address is executed
        CAPSetupCustShipToAddr59FDWPage.Trap();
        ShiptoAddressList.CAPS59FDW.Invoke();
        CAPSetupCustShipToAddr59FDWPage.Close();
        ShiptoAddressList.Close();
        CustomerList.Close();
    end;

    [Test]
    procedure T41_Toeditthecallplanworksheetentry()
    // [USER STORY] 5.2 Edit and update Worksheet entry
    var
        NewWorksheetName: Code[10];
    begin
        // [SCENARIO #41] To edit the call plan worksheet entry
        // [GIVEN] Call plan worksheet page exists
        // [GIVEN] Execute Call Plan Worksheet page through tell me function
        // [GIVEN] Call Plan Worksheet names as Default exists
        NewWorksheetName := LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW);
        LibraryCallPlanMgmt59FDW.CreateCAPWorksheetName(CAPWorkSheetName59FDW, NewWorksheetName);
        // [GIVEN] Call plan worksheet records exists
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        LibraryCallPlanMgmt59FDW.CreateWorksheetEntry(CAPWorkSheetEntry59FDWTable, NewWorksheetName, 2, Customer, 20220425D, SalesPersonPurchaser.Code, 20220426D, 20220426D, CAPWorkSheetEntry59FDWTable."Call Plan Status"::Completed, 120000T);
        // [WHEN] Edit and update the call plan worksheet entry
        LibraryCallPlanMgmt59FDW.EditCAPWorkSheetName(CAPWorkSheetEntry59FDWTable, NewWorksheetName, 3, Customer, 20220428D, SalesPersonPurchaser.Code, 20220429D, 20220429D, CAPWorkSheetEntry59FDWTable."Call Plan Status"::New);
        // [THEN] Call plan worksheet entry is edited and updated
        LibraryAssert.AreEqual(CAPWorkSheetEntry59FDWTable."Worksheet Name", NewWorksheetName, 'Not Updated the Worksheet Name');
        LibraryAssert.AreEqual(CAPWorkSheetEntry59FDWTable."Customer No.", Customer."No.", 'Not Updated the Customer Number');
        LibraryAssert.AreEqual(CAPWorkSheetEntry59FDWTable."Call Date", 20220428D, 'Not Updated the Call Date Value');
        LibraryAssert.AreEqual(CAPWorkSheetEntry59FDWTable."Inside Salesperson Code", SalesPersonPurchaser.Code, 'Not Updated the Inside Salesperson Code');
        LibraryAssert.AreEqual(CAPWorkSheetEntry59FDWTable."Shipment Date", 20220429D, 'Not Updated the Shipment Date');
        LibraryAssert.AreEqual(CAPWorkSheetEntry59FDWTable."Delivery Date", 20220429D, 'Not Updated the Delivery Date');
        LibraryAssert.AreEqual(CAPWorkSheetEntry59FDWTable."Call Plan Status", CAPWorkSheetEntry59FDWTable."Call Plan Status"::New, 'Not Updated the Call Plan Status Value');
    end;

    [Test]
    procedure T42_Toverifythecolorchangeinthecallplanstatus()
    // [USER STORY] 5.2 Edit and update Worksheet entry
    var
        StyleExprText: Text;
        NewWorksheetName: Code[10];
    begin
        // [SCENARIO #42] To verify the color change in the call plan status
        // [GIVEN] Call plan worksheet page exists
        // [GIVEN] Execute Call Plan Worksheet through the tell me function
        // [GIVEN] Call Plan Worksheet name has the name as Default
        NewWorksheetName := LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW);
        LibraryCallPlanMgmt59FDW.CreateCAPWorksheetName(CAPWorkSheetName59FDW, NewWorksheetName);
        // [GIVEN] All records are visible without any filter
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        LibraryCallPlanMgmt59FDW.CreateWorksheetEntry(CAPWorkSheetEntry59FDWTable, NewWorksheetName, 2, Customer, 20220425D, SalesPersonPurchaser.Code, 20220426D, 20220426D, CAPWorkSheetEntry59FDWTable."Call Plan Status"::Completed, 120000T);
        // [GIVEN] Call Plan Status of New exists
        // [GIVEN] Call Plan Status of Completed exists
        // [GIVEN] Call Plan Status of Retry exists
        // [WHEN] Change the call plan status and observe color change
        // [THEN] Selected the call plan status to Retry and it showed Orange color
        LibraryCallPlanMgmt59FDW.EditCAPWorkSheetName(CAPWorkSheetEntry59FDWTable, NewWorksheetName, 4, Customer, 20220528D, SalesPersonPurchaser.Code, 20220429D, 20220529D, CAPWorkSheetEntry59FDWTable."Call Plan Status"::Retry);
        CallplanWorksheetMgt59FDW.UpdateStatusEntry(CAPWorkSheetEntry59FDWTable, StyleExprText);
        LibraryAssert.AreEqual(StyleExprText, 'Ambiguous', 'The Value of Call Plan Status is not Ambiguous');
        // [THEN] Selected the call plan status to complete and it showed Green color
        LibraryCallPlanMgmt59FDW.EditCAPWorkSheetName(CAPWorkSheetEntry59FDWTable, NewWorksheetName, 5, Customer, 20220628D, SalesPersonPurchaser.Code, 20220629D, 20220629D, CAPWorkSheetEntry59FDWTable."Call Plan Status"::Completed);
        CallplanWorksheetMgt59FDW.UpdateStatusEntry(CAPWorkSheetEntry59FDWTable, StyleExprText);
        LibraryAssert.AreEqual(StyleExprText, 'Favorable', 'The Value of Call Plan Status is not Favorable');
        // [THEN] Selected the call plan status to new and it showed default color
        LibraryCallPlanMgmt59FDW.EditCAPWorkSheetName(CAPWorkSheetEntry59FDWTable, NewWorksheetName, 6, Customer, 20220428D, SalesPersonPurchaser.Code, 20220429D, 20220429D, CAPWorkSheetEntry59FDWTable."Call Plan Status"::New);
        CallplanWorksheetMgt59FDW.UpdateStatusEntry(CAPWorkSheetEntry59FDWTable, StyleExprText);
        LibraryAssert.AreEqual(StyleExprText, 'Strong', 'The Value of Call Plan Status is not Strong');
    end;

    [Test]
    procedure T46_Toseewhichrecordsareapproachingtothecutofftimeforalldaysifthisrestrictionhasbeenenabledandwithintheduration()
    // [USER STORY] 5.5 show cut-off time in worksheet
    var
        RecordRef: RecordRef;
        NewWorksheetName: Code[10];
        NewLineNumber: Integer;
    begin
        // [SCENARIO #46] To see which records are approaching to the cut-off time for all days, if this restriction has been enabled and within the duration
        Initialize();
        // [GIVEN] User has the permission to access and modify the call plan worksheet
        // [GIVEN] Cut-off time is 17:00 in Call Plan Setup exists
        // [GIVEN] Cut-off warning time is 30 minutes in Call Plan Setup exists
        // [GIVEN] Customer C0011 included in Cut-off time restriction
        // [GIVEN] Sales order for customer C0011 with sales order line for item 0011 exists
        // [GIVEN] Shipment date is 2/25/2022 (Wednesday) exists
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        LibrarySales.CreateShipToAddress(ShiptoAddress, Customer."No.");
        // [GIVEN] Execute Call Plan Worksheet through the Tell me 
        CAPWorkSheetEntry59FDW.OpenEdit();
        // [GIVEN] Execute the worksheet page with the worksheet name has Default
        NewWorksheetName := LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW);
        RecordRef.GetTable(CAPWorkSheetEntry59FDWTable);
        NewLineNumber := LibraryUtility.GetNewLineNo(RecordRef, CAPWorkSheetEntry59FDWTable.FieldNo("Line No."));
        LibraryCallPlanMgmt59FDW.CreateNewCAPWorksheetName(CAPWorkSheetName59FDW, NewWorksheetName, 'New sales worksheet added');
        LibraryCallPlanMgmt59FDW.CreateWorksheetEntry(CAPWorkSheetEntry59FDWTable, NewWorksheetName, NewLineNumber, Customer, 20220222D, SalesPersonPurchaser.Code, 20220225D, 20220228D, CAPWorkSheetEntry59FDWTable."Call Plan Status"::New, 170000T);
        // [GIVEN] Generate the Call plan lines on date 2/23/2022 for the customer C0011
        // [GIVEN] worksheet entry is inserted
        // [GIVEN] Execute the call plan worksheet when the local time is between 16:30 to 16:59
        // [WHEN] Show the Cut-off time in the Call plan worksheet
        // [THEN] Cut-off time is showed warning with an orange color
        LibraryAssert.AreEqual(LibraryCallPlanMgmt59FDW.OrderEntryCutofftimeWarningShow(CAPWorkSheetEntry59FDWTable, CallPlanSetupTable59FDW, 164000T), 'Ambiguous', 'Warnings Not Updated');
        CAPWorkSheetEntry59FDW.Close();
    end;

    [Test]
    procedure T47_IdentifytheexceedingCutofftimewiththecolor()
    // [USER STORY] 5.5 show cut-off time in worksheet
    var
        RecordRef: RecordRef;
        NewWorksheetName: Code[10];
        NewLineNumber: Integer;
    begin
        // [SCENARIO #47] Identify the exceeding Cut-off time with the color
        // [GIVEN] Customer C0011 included in Cut-off time restriction
        Initialize();
        // [GIVEN] Sales order for customer C0011 with sales order line for item 0011 exists
        // [GIVEN] Shipment date is 2/25/2022 (Wednesday) exists
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        LibrarySales.CreateShipToAddress(ShiptoAddress, Customer."No.");
        // [GIVEN] Execute "Call Plan Worksheet" in the Tell me function
        CAPWorkSheetEntry59FDW.OpenEdit();
        // [GIVEN] Execute the worksheet page with the worksheet name has "Default"
        NewWorksheetName := LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW);
        RecordRef.GetTable(CAPWorkSheetEntry59FDWTable);
        NewLineNumber := LibraryUtility.GetNewLineNo(RecordRef, CAPWorkSheetEntry59FDWTable.FieldNo("Line No."));
        LibraryCallPlanMgmt59FDW.CreateNewCAPWorksheetName(CAPWorkSheetName59FDW, NewWorksheetName, 'New sales worksheet added');
        LibraryCallPlanMgmt59FDW.CreateWorksheetEntry(CAPWorkSheetEntry59FDWTable, NewWorksheetName, NewLineNumber, Customer, 20220222D, SalesPersonPurchaser.Code, 20220225D, 20220228D, CAPWorkSheetEntry59FDWTable."Call Plan Status"::New, 170000T);
        // [GIVEN] Generate the Call plan lines on date 2/25/2022 for the customer C0011 exists
        // [GIVEN] worksheet entry is inserted
        // [GIVEN] Cut-off time is 17:00 in Call Plan Setup exists
        // [GIVEN] Cut-off warning time is 30 minutes in Call Plan Setup exists
        // [GIVEN] Red colour indicates the exceeding time over the cut-off time
        // [WHEN] Execute the call plan worksheet when the local time is greater than or equal to 17:00
        // [THEN] Call Plan Worksheet executed
        // [THEN] Cut-off time is showed warning with red color
        LibraryAssert.AreEqual(LibraryCallPlanMgmt59FDW.OrderEntryCutofftimeWarningShow(CAPWorkSheetEntry59FDWTable, CallPlanSetupTable59FDW, 170000T), 'Unfavorable', 'Warnings Not Updated');
        CAPWorkSheetEntry59FDW.Close();
    end;

    [Test]
    procedure T48_IdentifytheDefaultCutofftimewiththecolor()
    // [USER STORY] 5.5 show cut-off time in worksheet
    var
        RecordRef: RecordRef;
        NewWorksheetName: Code[10];
        NewLineNumber: Integer;
    begin
        // [SCENARIO #48] Identify the Default Cut-off time with the color
        // [GIVEN] Customer C0011 included in Cut-off time restriction
        Initialize();
        // [GIVEN] Sales order for customer C0011 with sales order line for item 0011 exists
        // [GIVEN] Shipment date is 2/25/2022 (Wednesday) exists
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        LibrarySales.CreateShipToAddress(ShiptoAddress, Customer."No.");
        // [GIVEN] Execute "Call Plan Worksheet" in the Tell me function
        CAPWorkSheetEntry59FDW.OpenEdit();
        // [GIVEN] Execute the worksheet page with the worksheet name has "Default"
        NewWorksheetName := LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW);
        RecordRef.GetTable(CAPWorkSheetEntry59FDWTable);
        NewLineNumber := LibraryUtility.GetNewLineNo(RecordRef, CAPWorkSheetEntry59FDWTable.FieldNo("Line No."));
        LibraryCallPlanMgmt59FDW.CreateNewCAPWorksheetName(CAPWorkSheetName59FDW, NewWorksheetName, 'New sales worksheet added');
        LibraryCallPlanMgmt59FDW.CreateWorksheetEntry(CAPWorkSheetEntry59FDWTable, NewWorksheetName, NewLineNumber, Customer, 20220222D, SalesPersonPurchaser.Code, 20220225D, 20220228D, CAPWorkSheetEntry59FDWTable."Call Plan Status"::New, 170000T);
        // [GIVEN] Generate the Call plan lines on date 2/25/2022 for the customer C0011 exists
        // [GIVEN] worksheet entry is inserted
        // [GIVEN] Cut-off time is 17:00 in Call Plan Setup exists
        // [GIVEN] Cut-off warning time is 30 minutes in Call Plan Setup exists
        // [GIVEN] Black colour indicates the default time of the cut-off time
        // [WHEN] Execute the call plan worksheet when the local time is less than 16:30
        // [THEN] Call Plan Worksheet executed
        // [THEN] Cut-off time is showed with black color
        LibraryAssert.AreEqual(LibraryCallPlanMgmt59FDW.OrderEntryCutofftimeWarningShow(CAPWorkSheetEntry59FDWTable, CallPlanSetupTable59FDW, 162900T), 'Standard', 'Warnings Not Updated');
        CAPWorkSheetEntry59FDW.Close();
    end;

    [Test]
    procedure T33_ToinsertanindividualCallPlanStructurerecordforeachshipmentdayoftheweek()
    // [USER STORY] 4.3 Call Plan Structure: Insert/Modify/Delete “CPS” Records
    begin
        // [SCENARIO #33] To insert an individual Call Plan Structure record for any ‘shipment’ day of the week
        // [GIVEN] Customer C0011 exists
        // [GIVEN] Customer C0011 is included in Call Plan exists
        // [GIVEN] Ship- To Code 1 Route A exists
        // [GIVEN] Ship- To Code 2 Route B exists
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        LibrarySales.CreateShipToAddress(ShiptoAddress, Customer."No.");
        // [GIVEN] Execute customers by using Tell me function
        CustomerList.OpenEdit();
        CustomerList.GoToRecord(Customer);
        CustomerCard.OpenEdit();
        // [GIVEN] clicked on the related button
        // [GIVEN] Customer dropdown exists
        // [GIVEN] Call Plan Setup exists
        CAPSetupCustShipToAddr59FDW.Trap();
        CustomerCard.CAPS59FDW.Invoke();
        // [GIVEN] Call Plan Structure exists in the call plan setup page
        // [GIVEN] Ship-To code as 1 exists
        // [GIVEN] Starting date as 1/18/2022 exists
        // [GIVEN] Ending date as 2/18/2022 exists
        // [GIVEN] Shipment day as Tuesday exists
        // [GIVEN] Call day as Monday exists
        // [GIVEN] Call Window Starting time as 9:00 AM exists
        // [GIVEN] Call Window End time as 10:00 AM exists
        // [GIVEN] Frequency value as weekly exists
        // [WHEN] Insert record in Call Plan structure
        // [THEN] Individual record has been inserted in Call Plan Structure
        LibraryCallPlanMgmt59FDW.CreateCallplanheader(ShipToAddressCapSetup59FDW, Customer);
        LibraryCallPlanMgmt59FDW.CreateCallplanStructure(CAPStructure59FDW, Customer."No.", 20220425D, 20220429D, WeekDay59FDW::Friday, WeekDay59FDW::Thursday, 103000T, 163000T, ShiptoAddress.Code, 'Bussiness Central');
        CAPStructure59FDW.TestField("Starting Date", 20220425D);
        CAPSetupCustShipToAddr59FDW.Close();
        CustomerCard.Close();
        CustomerList.Close();
    end;

    [Test]
    procedure T34_ToModifyanindividualCallPlanStructurerecordforeachshipmentdayoftheweek()
    // [USER STORY] 4.3 Call Plan Structure: Insert/Modify/Delete “CPS” Records
    begin
        // [SCENARIO #34] To Modify an individual Call Plan Structure record for each ‘shipment’ day of the week
        // [GIVEN] Customer C0011 exists
        // [GIVEN] Customer C0011 is included in Call Plan exists
        // [GIVEN] Ship- To Code 1 Route A exists
        // [GIVEN] Ship- To Code 2 Route B exists
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        LibrarySales.CreateShipToAddress(ShiptoAddress, Customer."No.");
        // [GIVEN] Execute customers by using Tell me function
        CustomerList.OpenEdit();
        CustomerList.GoToRecord(Customer);
        CustomerCard.OpenEdit();
        // [GIVEN] Customer dropdown exists
        // [GIVEN] Call Plan Setup exists
        CAPSetupCustShipToAddr59FDW.Trap();
        CustomerCard.CAPS59FDW.Invoke();
        // [GIVEN] Call Plan Structure exists in the call plan setup page
        // [GIVEN] Call plan structure record exists
        // [GIVEN] Shipment day Wednesday exists
        // [GIVEN] Call Window Starting time 10:00 AM exists
        // [GIVEN] Call Window End time 11:00 AM exists
        // [GIVEN] Note value as N/A exists
        LibraryCallPlanMgmt59FDW.CreateCallplanStructure(CAPStructure59FDW, Customer."No.", 20220425D, 20220429D, WeekDay59FDW::Friday, WeekDay59FDW::Thursday, 103000T, 163000T, ShiptoAddress.Code, 'Bussiness Central');
        // [WHEN] Modify same record in the Call plan structure table
        // [THEN] Individual record has been modified in Call Plan Structure
        CAPStructure59FDW.Validate("Call Day", WeekDay59FDW::Sunday);
        CAPStructure59FDW.Modify(true);
        CAPStructure59FDW.TestField("Call Day", WeekDay59FDW::Sunday);
        CAPSetupCustShipToAddr59FDW.Close();
        CustomerCard.Close();
        CustomerList.Close();
    end;

    procedure T35_ToAddanotherrecordintheCallPlanStructure()
    // [USER STORY] 4.3 Call Plan Structure: Insert/Modify/Delete “CPS” Records
    begin
        // [SCENARIO #35] To Add another record in the Call Plan Structure
        // [GIVEN] Customer C0011 exists
        // [GIVEN] Customer C0011 is included in Call Plan exists
        // [GIVEN] Ship- To Code 1 Route A exists
        // [GIVEN] Ship- To Code 2 Route B exists
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        LibrarySales.CreateShipToAddress(ShiptoAddress, Customer."No.");
        // [GIVEN] Execute customers by using Tell me function
        CustomerList.OpenEdit();
        CustomerList.GoToRecord(Customer);
        CustomerCard.OpenEdit();
        // [GIVEN] clicked on the related button
        // [GIVEN] Customer dropdown exists
        // [GIVEN] Call Plan Setup exists
        CAPSetupCustShipToAddr59FDW.Trap();
        CustomerCard.CAPS59FDW.Invoke();
        // [GIVEN] Call Plan Structure exists in the call plan setup page
        // [GIVEN] Ship-To code as 2 exists
        // [GIVEN] Starting date as 1/18/2022 exists
        // [GIVEN] Ending date as 3/19/2022 exists
        // [GIVEN] Shipment day as Friday exists
        // [GIVEN] Call day as Wednesday exists
        // [GIVEN] Call Window Starting time as 9:00 AM exists
        // [GIVEN] Call Window End time as 11:00 AM exists
        // [GIVEN] Note value as N/A exists
        // [GIVEN] Frequency value as weekly exists
        LibraryCallPlanMgmt59FDW.CreateCallplanStructure(CAPStructure59FDW, Customer."No.", 20220425D, 20220429D, WeekDay59FDW::Thursday, WeekDay59FDW::Thursday, 103000T, 163000T, ShiptoAddress.Code, 'Bussiness Central');
        // [WHEN] Add another record in Call Plan Structure
        // [THEN] Another record is added in Call Plan Structure
        LibraryCallPlanMgmt59FDW.CreateCallplanStructure(CAPStructure59FDW, Customer."No.", 20220425D, 20220429D, WeekDay59FDW::Saturday, WeekDay59FDW::Thursday, 103000T, 163000T, ShiptoAddress.Code, 'Bussiness Central');
        CAPStructure59FDW.TestField("Shipment Day", WeekDay59FDW::Saturday);
        CAPSetupCustShipToAddr59FDW.Close();
        CustomerCard.Close();
        CustomerList.Close();
    end;

    [Test]
    procedure T36_ToEntertheduplicaterecordintheCallPlanStructure()
    // [USER STORY] 4.3 Call Plan Structure: Insert/Modify/Delete “CPS” Records
    var
        DuplicateRecordErr: Label 'The record in table Call Plan structure already exists.';
    begin
        // [SCENARIO #36] To Enter the duplicate record in the Call Plan Structure
        // [GIVEN] Customer C0011 exists
        // [GIVEN] Customer C0011 is included in Call Plan exists
        // [GIVEN] Ship- To Code 1 Route A exists
        // [GIVEN] Ship- To Code 2 Route B exists
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        LibrarySales.CreateShipToAddress(ShiptoAddress, Customer."No.");
        // [GIVEN] Execute customers by using Tell me function
        CustomerList.OpenEdit();
        CustomerList.GoToRecord(Customer);
        CustomerCard.OpenEdit();
        // [GIVEN] clicked on the related button
        // [GIVEN] Customer dropdown exists
        // [GIVEN] Call Plan Setup exists
        CAPSetupCustShipToAddr59FDW.Trap();
        CustomerCard.CAPS59FDW.Invoke();
        // [GIVEN] Call Plan Structure exists in the call plan setup page
        // [GIVEN] Call plan structure record exists
        // [GIVEN] New records exists
        LibraryCallPlanMgmt59FDW.CreateCallplanStructure(CAPStructure59FDW, Customer."No.", 20220425D, 20220429D, WeekDay59FDW::Saturday, WeekDay59FDW::Thursday, 103000T, 163000T, ShiptoAddress.Code, 'Bussiness Central');
        // [WHEN] Enter the duplicate record
        // [THEN] Entered the new records as same as previous records and throws validation error
        LibraryCallPlanMgmt59FDW.CreateCallplanStructure(CAPStructure59FDW, Customer."No.", 20220425D, 20220429D, WeekDay59FDW::Saturday, WeekDay59FDW::Thursday, 103000T, 163000T, ShiptoAddress.Code, 'Bussiness Central');
        asserterror CAPSetupCustShipToAddr59FDW.CallPlanStructure."Shipment Day".SetValue(WeekDay59FDW::Saturday);
        LibraryAssert.ExpectedError(DuplicateRecordErr);
        CAPSetupCustShipToAddr59FDW.Close();
        CustomerCard.Close();
        CustomerList.Close();
    end;

    [Test]
    procedure T37_ToaddrecordwithanemptyStartingDate()
    // [USER STORY] 4.3 Call Plan Structure: Insert/Modify/Delete “CPS” Records
    var
        StartingDateErr: Label 'Starting Date must be filled in. Enter a value';
    begin
        // [SCENARIO #37] To add record with an empty “Starting Date" and it throws validation error "Starting Date must be filled in. Enter a value"
        // [GIVEN] Customer C0011 exists
        // [GIVEN] Customer C0011 is included in Call Plan
        // [GIVEN] Ship- To Code 1 Route A exists
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        LibrarySales.CreateShipToAddress(ShiptoAddress, Customer."No.");
        // [GIVEN] Execute customers by using Tell me function
        CustomerList.OpenEdit();
        CustomerList.GoToRecord(Customer);
        CustomerCard.OpenEdit();
        // [GIVEN] clicked on the related button
        // [GIVEN] Customer dropdown exists
        // [GIVEN] Call Plan Setup exists
        CAPSetupCustShipToAddr59FDW.Trap();
        CustomerCard.CAPS59FDW.Invoke();
        // [GIVEN] Call Plan Structure exists in the call plan setup page
        // [GIVEN] Shipment day Wednesday exists
        // [GIVEN] Call Day Monday exists
        // [GIVEN] Call Window Starting time 10:00 AM exists
        // [GIVEN] Call Window Ending time 11:00 AM exsits
        // [GIVEN] Note value as N/A exists
        // [GIVEN] Frequency value as weekly exists
        LibraryCallPlanMgmt59FDW.CreateCallplanStructure(CAPStructure59FDW, Customer."No.", 20220425D, 20220429D, WeekDay59FDW::Thursday, WeekDay59FDW::Thursday, 103000T, 163000T, ShiptoAddress.Code, 'Bussiness Central');
        // [WHEN] Add record with an empty Starting Date
        // [THEN] Records cannot be added without Starting Date and throws validation error
        asserterror CAPSetupCustShipToAddr59FDW.CallPlanStructure."Starting Date".SetValue(0D);
        LibraryAssert.ExpectedError(StartingDateErr);
        CAPSetupCustShipToAddr59FDW.Close();
        CustomerCard.Close();
        CustomerList.Close();
    end;

    [Test]
    procedure T38_Todeletetherecordsonthecallplanstructurepage()
    // [USER STORY] 4.3 Call Plan Structure: Insert/Modify/Delete “CPS” Records
    begin
        // [SCENARIO #38] To delete the records on the "call plan structure" page
        // [GIVEN] Customer C0011 exists
        // [GIVEN] Customer C0011 is included in Call Plan
        // [GIVEN] Ship- To Code 1 Route A exists
        // [GIVEN] Ship- To Code 2 Route B exists
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        LibrarySales.CreateShipToAddress(ShiptoAddress, Customer."No.");
        // [GIVEN] Execute customers by using Tell me function
        CustomerList.OpenEdit();
        CustomerList.GoToRecord(Customer);
        CustomerCard.OpenEdit();
        // [GIVEN] clicked on the related button
        // [GIVEN] Customer dropdown exists
        // [GIVEN] Call Plan Setup exists
        CAPSetupCustShipToAddr59FDW.Trap();
        CustomerCard.CAPS59FDW.Invoke();
        // [GIVEN] Call Plan Structure exists in the call plan setup page
        LibraryCallPlanMgmt59FDW.CreateCallplanStructure(CAPStructure59FDW, Customer."No.", 20220428D, 20220429D, WeekDay59FDW::Thursday, WeekDay59FDW::Thursday, 103000T, 163000T, ShiptoAddress.Code, 'Bussiness Central');
        // [WHEN] Delete the current line for C0011 customer in the Call plan structure
        // [THEN] The customer record has been deleted
        LibraryCallPlanMgmt59FDW.DeletingCAPStructureRecords(CAPStructure59FDW, CAPStructure59FDW."Starting Date");
        CAPSetupCustShipToAddr59FDW.Close();
        CustomerCard.Close();
        CustomerList.Close();
    end;

    [Test]
    procedure T49_TocreateanewSalesOrderforthecustomerdirectlyfromtheWorksheet()
    // [USER STORY] 5.6 Create Sales order from Call Plan worksheet
    var
        RecordRef: RecordRef;
        NewWorksheetName: Code[10];
        NewLineNumber: Integer;
        OrderNo: Code[20];
    begin
        // [SCENARIO #49] To create a new Sales Order for the customer directly from the Worksheet
        // [GIVEN] Customer C0011 included in the call Plan
        // [GIVEN] The source for inside salesperson is Call Plan in the General Call Plan Setup
        // [GIVEN] Inside salesperson code is Anita exists
        // [GIVEN] Shipment date is 2/25/2022 (Wednesday) exists
        // [GIVEN] Peter is the Default Salesperson code for Customer C0011
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        LibrarySales.CreateShipToAddress(ShiptoAddress, Customer."No.");
        // [GIVEN] Execute Call Plan Worksheet in the tell me function
        CAPWorkSheetEntry59FDW.OpenEdit();
        // [GIVEN] Worksheet name Anita exists in the Worksheet page
        // [GIVEN] Execute the Generate Call plan lines on date 2/25/2022 for customer C0011
        // [GIVEN] Execute the record in the worksheet entry
        NewWorksheetName := LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW);
        RecordRef.GetTable(CAPWorkSheetEntry59FDWTable);
        NewLineNumber := LibraryUtility.GetNewLineNo(RecordRef, CAPWorkSheetEntry59FDWTable.FieldNo("Line No."));
        LibraryCallPlanMgmt59FDW.CreateNewCAPWorksheetName(CAPWorkSheetName59FDW, NewWorksheetName, 'New sales worksheet added');
        LibraryCallPlanMgmt59FDW.CreateWorksheetEntry(CAPWorkSheetEntry59FDWTable, SalesPersonPurchaser, Customer, WeekDay59FDW, ShiptoAddress, CallPlanStatus, CAPWorkSheetName59FDW, NewLineNumber);
        // [GIVEN] Execute New Sales order button in the ribbon of the Worksheet lines
        // [WHEN] Creating a New Sales order from Call Plan Worksheet
        // [THEN] New Sales order is created from Call Plan worksheet
        SalesOrder.Trap();
        CAPWorkSheetEntry59FDW.CurrentWorkSheetName.SetValue(NewWorksheetName);
        CAPWorkSheetEntry59FDW.GoToRecord(CAPWorkSheetEntry59FDWTable);
        CAPWorkSheetEntry59FDW.NewSalesOrder.Invoke();
        OrderNo := Format(SalesOrder."No.".Value);
        SalesOrder.Close();
        SalesHeader.Get(SalesHeader."Document Type"::Order, OrderNo);
        LibraryAssert.AreEqual(SalesHeader."Sell-to Customer No.", Customer."No.", 'Sales Order Not Created');
        CAPWorkSheetEntry59FDW.Close();
    end;

    [Test]
    [HandlerFunctions('ConfirmHandler,ChooseSalesperson')]
    procedure T55_InsideSalespersonCodeinSalesOrder59FDW()
    // [USER STORY] 7.1 Inside Salesperson Code in Sales Order
    var
        SalespersonsPurchasersPage: TestPage "Salespersons/Purchasers";
        SalesPersonValue: Code[20];
    begin
        // [SCENARIO #56] Update Inside Salesperson Code in Sales Order
        // [GIVEN] Sales order page exists
        // [GIVEN] Customer C0011 exists
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        LibraryCallPlanMgmt59FDW.CreateCustomerCallplan(ShipToAddressCapSetup59FDW, Customer, false, false);
        // [GIVEN] Customer C0011 is included in Call Plan
        LibraryCallPlanMgmt59FDW.SetIncludeinCallPlanForCustomer(Customer, SalesPersonPurchaser, ShiptoAddress);
        // [GIVEN] Sales Order for Customer C0011 exists
        LibraryCallPlanMgmt59FDW.CreateSalesHeader(SalesHeader, Customer."No.");
        // [GIVEN] Salesperson Peter exists
        // [GIVEN] Execute Sales order through the tell me function
        SalesList.OpenEdit();
        SalesList.GoToRecord(SalesHeader);
        SalesOrderCard.OpenEdit();
        // [GIVEN] Execute Sales order for Customer C0011 in the sales order document page
        // [GIVEN] General tab on the Sales order exists
        // [GIVEN] Inside Sales person lookup exists in the General tab
        SalespersonsPurchasersPage.Trap();
        // [WHEN] Update the Inside Salesperson code
        SalesOrderCard.InsideSalespersonCode59FDW.Lookup();
        SalespersonsPurchasersPage.OpenEdit();
        // [THEN] Inside Salesperson code is updated
        SalesPersonValue := Format(SalesOrderCard.InsideSalespersonCode59FDW.Value);
        LibraryAssert.AreEqual(SalesPersonValue, SalesPersonPurchaser.Code, 'Both are equal');
        SalesOrderCard.Close();
    end;

    [ModalPageHandler]
    procedure ChooseSalesperson(var SalespersonsPurchasersPage: TestPage "Salespersons/Purchasers")
    begin
        SalespersonsPurchasersPage.GoToRecord(SalesPersonPurchaser);
        SalespersonsPurchasersPage.OK().Invoke();
    end;

    [Test]
    procedure T45_ToseehowmanySalesOrdersrelatetothecallplanworksheetentrywithamatchforsamecustomernoshiptocodeandshipmentdate()
    // [USER STORY] 5.3 Information on how many sales orders are related to the worksheet entry, as well as the number of exists Worksheet records.
    var
        RecordRef: RecordRef;
        NewWorksheetName: Code[10];
        NewLineNumber: Integer;
        WorksheetNamePage: Code[10];
        WorksheetNameList: Code[10];
        WorksheetCustNo: Code[20];
        SalesOrderListCustNo: Code[20];

    begin
        // [SCENARIO #45] To see how many Sales Orders relate to the call plan worksheet entry, with a match for same customer no., ship-to code, and shipment date
        Initialize();
        // [GIVEN] User has the permission to access and modify the call plan worksheet
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        LibraryCallPlanMgmt59FDW.CreateShipToAddressList(ShiptoAddress, Customer);
        // [GIVEN] Sales order for customer C0011 with sales order lines for item 0011 exists
        // [GIVEN] Call Date is 2/23/2022 exists
        // [GIVEN] Shipment date is 2/25/2022 exists
        // [GIVEN] Shipment day Wednesday exists
        // [GIVEN] Execute Call Plan Worksheet through the Tell me function
        // [GIVEN] Execute the worksheet page with the worksheet name has Default
        NewWorksheetName := LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW);
        RecordRef.GetTable(CAPWorkSheetEntry59FDWTable);
        NewLineNumber := LibraryUtility.GetNewLineNo(RecordRef, CAPWorkSheetEntry59FDWTable.FieldNo("Line No."));
        LibraryCallPlanMgmt59FDW.CreateNewCAPWorksheetName(CAPWorkSheetName59FDW, NewWorksheetName, 'New sales worksheet added');
        LibraryCallPlanMgmt59FDW.CreateWorksheetEntry(CAPWorkSheetEntry59FDWTable, SalesPersonPurchaser, Customer, WeekDay59FDW, ShiptoAddress, CallPlanStatus, CAPWorkSheetName59FDW, NewLineNumber);
        LibraryCallPlanMgmt59FDW.CreateSalesOrder(SalesHeader, CAPWorkSheetEntry59FDWTable, Status::open, DocumentType::Order, Customer);
        // [GIVEN] Generate Call plan lines on date 2/23/2022 for the customer C0011
        // [GIVEN] Automatically 1 worksheet entry is inserted
        CAPWorkSheetEntry59FDW.OpenEdit();
        CAPWorkSheetEntry59FDW.CurrentWorkSheetName.SetValue(NewWorksheetName);
        CAPWorkSheetEntry59FDW.GoToRecord(CAPWorkSheetEntry59FDWTable);
        // [GIVEN] Call Plan orders is count of Call Plan Worksheet records with match for Call Date, Customer, Ship-To
        LibraryCallPlanMgmt59FDW.UpdateCallPlanOrders(CAPWorkSheetEntry59FDWTable);
        // [GIVEN] Existing orders is related Sales order for Customer or Ship-To and for same shipment Date
        LibraryCallPlanMgmt59FDW.UpdateExistingOrders(CAPWorkSheetEntry59FDWTable);
        // [WHEN] Execute Call Plan orders and EXisting Orders value in the Call Plan Worksheet record for the Customer C0011
        SalesOrderList.Trap();
        CAPWorkSheetEntry59FDW."Existing Orders".Drilldown();
        CallPlanOrders59FDW.Trap();
        CAPWorkSheetEntry59FDW."Call Plan Orders".Drilldown();
        // [THEN] Sales order list page for the Existing order to the Customer C0011 exists
        SalesOrderList.GoToRecord(SalesHeader);
        WorksheetCustNo := Format(CAPWorkSheetEntry59FDW."Customer No.".Value);
        SalesOrderListCustNo := Format(SalesOrderList."Sell-to Customer No.".Value);
        // [THEN] Call Plan orders pop-up window for the customer C0011 exists
        CallPlanOrders59FDW.GoToRecord(CAPWorkSheetEntry59FDWTable);
        WorksheetNamePage := Format(CAPWorkSheetEntry59FDW.CurrentWorkSheetName.Value);
        WorksheetNameList := Format(CallPlanOrders59FDW."Call Plan Worksheet Name".Value);
        // [THEN] Call Plan Worksheet Name exists in the Call Plan orders tab
        // [THEN] Call Plan Status exists in the Call Plan orders tab
        // [THEN] Call Date exists in the Call Plan orders tab
        // [THEN] Inside Salesperson Code exists in the Call Plan orders tab
        // [THEN] Shipment date exists in the Call Plan orders tab
        // [THEN] Shipment day exists in the Call Plan orders tab
        // [THEN] Note text field exists in the Call Plan orders tab
        // [THEN] Call plan orers and Existing order with the number 1 exists
        LibraryAssert.AreEqual(CAPWorkSheetEntry59FDWTable."Call Plan Orders", CAPWorkSheetEntry59FDWTable."Existing Orders", 'Existing orders and Call plan orders are not equal');
        LibraryAssert.AreEqual(WorksheetNameList, WorksheetNamePage, 'Worksheetpage value did not pass data to worksheetlist page properly');
        LibraryAssert.AreEqual(WorksheetCustNo, SalesOrderListCustNo, 'Sales Order did not pass data to Sales Order list page properly');
        SalesOrderList.Close();
        CallPlanOrders59FDW.Close();
        CAPWorkSheetEntry59FDW.Close();
    end;

    [Test]
    [HandlerFunctions('CallPlanLineGenerationRequestPageHandler')]
    procedure T52_Togeneratenewrecordsinthecallplanworksheetfromwithintheworksheetitself()
    // [USER STORY] 6.1 Generate new records in the call plan worksheet
    var
        WorksheetName: Code[10];
    begin
        // [SCENARIO #52] To generate new records in the call plan worksheet, from within the worksheet itself
        Initialize();
        // [GIVEN] Call Plan Worksheet name AVS exists
        WorksheetName := LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW);
        LibraryCallPlanMgmt59FDW.CreateNewCAPWorksheetName(CAPWorkSheetName59FDW, WorksheetName, 'New worksheet generated');
        // [GIVEN] Inside salesperson code is AVS exists
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        // [GIVEN] Customer C0011 is included in Call Plan
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        LibraryCallPlanMgmt59FDW.CreateCustomerCallplan(ShipToAddressCapSetup59FDW, Customer, false, false);
        // [GIVEN] Call plan structure in the Call plan setup page has been set up for Customer C0011
        LibraryCallPlanMgmt59FDW.CreateCallplanStructure(CAPStructure59FDW, Customer."No.", 20220509D, 20220513D, WeekDay59FDW::Thursday, WeekDay59FDW::Wednesday, 090000T, 160000T, '', 'Call line 1');
        // [GIVEN] Shipment day on Tuesday for Customer C0011 exists
        // [GIVEN] Call day on Monday for Customer C0011 exists
        LibraryCallPlanMgmt59FDW.SetCallDayShipmentDay(Customer, SalesPersonPurchaser);
        // [GIVEN] Customer C0015 is included in Call Plan
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        LibraryCallPlanMgmt59FDW.CreateCustomerCallplan(ShipToAddressCapSetup59FDW, Customer, false, false);
        // [GIVEN] Call plan structure in the Call plan setup page has been set up for Customer C0015      
        LibraryCallPlanMgmt59FDW.CreateCallplanStructure(CAPStructure59FDW, Customer."No.", 20220509D, 20220513D, WeekDay59FDW::Friday, WeekDay59FDW::Wednesday, 080000T, 150000T, '', 'Call line 2');
        // [GIVEN] Shipment day on Tuesday for Customer C0015 exists
        // [GIVEN] Call day on Monday for Customer C0015 exists
        LibraryCallPlanMgmt59FDW.SetCallDayShipmentDay(Customer, SalesPersonPurchaser);
        // [GIVEN] Execute the Call plan worksheet through the tell me function
        CAPWorkSheetEntry59FDW.OpenEdit();
        // [GIVEN] Execute the worksheet name AVS
        CAPWorkSheetEntry59FDW.CurrentWorkSheetName.SetValue(WorksheetName);
        // [GIVEN] Generate Call Plan Lines button exists on the worksheet page
        // [GIVEN] Generate Call Plan Lines page exists
        Commit();// Write transaction
        CAPWorkSheetEntry59FDW.CreateCallPlanLines.Invoke();
        // [GIVEN] Option Fast tab exists in the Generate Call Plan Lines page
        // [GIVEN] Worksheet name exists
        // [GIVEN] Call Date exists
        // [GIVEN] Day of the Week exists
        // [GIVEN] Clear Existing lines button with boolean value exists
        // [GIVEN] Filter Fast tab exists in the Generate Call Plan Lines page
        // [GIVEN] Inside Sales person exists with the drodown exists
        // [GIVEN] Customer No exists
        // [GIVEN] Responsibility Centre No exists
        // [WHEN] Generate the Call Plan lines for Call date 3/21/2022 in the Call Plan Worksheet
        // [THEN] Call Plan Lines are generated
        CAPWorkSheetEntry59FDWTable.SetRange("Worksheet Name", CAPWorkSheetName59FDW.Name);
        CAPWorkSheetEntry59FDWTable.FindFirst();
        LibraryCallPlanMgmt59FDW.CheckDataInWorksheetEntry(CAPWorkSheetEntry59FDWTable);
        CAPWorkSheetEntry59FDW.Close();
    end;

    [RequestPageHandler]
    procedure CallPlanLineGenerationRequestPageHandler(var GenerateCallPlanLines59FDW: TestRequestPage GenerateCallPlanLines59FDW)
    begin
        LibraryCallPlanMgmt59FDW.SetReportData(GenerateCallPlanLines59FDW, 20220511D, LibraryCallPlanMgmt59FDW.GetWeekDay(20220511D), false);
        GenerateCallPlanLines59FDW.OK().Invoke();
    end;

    [Test]
    [HandlerFunctions('MoveWorkSheetLinesDataHandler')]
    procedure T51_TomoveasingleCallplanlinefromoneworksheettoanother()
    // [USER STORY] 5.7 Ability to move a call plan record to a different worksheet name
    begin
        // [SCENARIO #51] To move a single Call plan line from one worksheet to another
        // [GIVEN] Execute the Call Plan Worksheet using tell me function
        CAPWorkSheetEntry59FDW.OpenEdit();
        // [GIVEN] Call Plan Worksheet page exists
        // [GIVEN] Call Plan Worksheet name “Default” exists
        FirstWorkSheetName := LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW);
        LibraryCallPlanMgmt59FDW.CreateCAPWorksheetName(CAPWorkSheetName59FDW, FirstWorkSheetName);
        // [GIVEN] Call Plan Worksheet name “Peter” exists
        SecondWorkSheetName := LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW);
        LibraryCallPlanMgmt59FDW.CreateCAPWorksheetName(CAPWorkSheetName59FDW, SecondWorkSheetName);
        // [GIVEN] Record exists on worksheet “Default” for customer C0011
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        LibraryCallPlanMgmt59FDW.CreateWorksheetEntry(CAPWorkSheetEntry59FDWTable, FirstWorkSheetName, 10000, Customer, 20220510D, SalesPersonPurchaser.Code, 20220511D, 20220512D, CAPWorkSheetEntry59FDWTable."Call Plan Status"::New, 120000T);
        // [GIVEN] Execute the Call Plan Worksheet “Default”
        // [GIVEN] Call plan line is selected
        CAPWorkSheetEntry59FDW.CurrentWorkSheetName.SetValue(FirstWorkSheetName);
        Commit();//
        CAPWorkSheetEntry59FDWTable.SetFilter("Worksheet Name", FirstWorkSheetName);
        CAPWorkSheetEntry59FDWTable.SetFilter("Line No.", '%1', 10000);
        CAPWorkSheetEntry59FDWTable.FindSet();
        MoveWorkSheetLines59FDW.GetParameters(CAPWorkSheetEntry59FDWTable);
        // [GIVEN] Click on "Actions" on the ribbon of the worksheet
        // [GIVEN] Click on "Move Lines"
        // [GIVEN] Move Work sheet Lines page exists
        // [GIVEN] No. of selected lines field exists
        NoOfSelectedLines := CAPWorkSheetEntry59FDWTable.Count();
        // [GIVEN] From Call Plan Worksheet name field exists
        // [GIVEN] To Call Plan Worksheet name dropdown exists
        // [GIVEN] Click on To Call Plan Worksheet name dropdown
        // [GIVEN] Select peter from Call Plan Worksheet dropdown
        ToWorkSheetName := SecondWorkSheetName;
        // [GIVEN] Execute the ok button
        MoveWorkSheetLines59FDW.RunModal();
        // [WHEN] Move line from the Call Plan Worksheet "Default" to "Peter"
        // [THEN] The line is now moved successfully
        CAPWorkSheetEntry59FDWTable.Reset();
        CAPWorkSheetEntry59FDWTable.SetRange("Worksheet Name", ToWorkSheetName);
        CAPWorkSheetEntry59FDWTable.FindFirst();
        LibraryAssert.AreEqual(CAPWorkSheetEntry59FDWTable."Worksheet Name", ToWorkSheetName, 'Move Lines action does not transfer selected line to destination worksheet name');
        LibraryAssert.AreEqual(CAPWorkSheetEntry59FDWTable.Count(), NoOfSelectedLines, 'Selected Line not moved by MoveLines action');
        Clear(FirstWorkSheetName);
        Clear(SecondWorkSheetName);
        Clear(NoOfSelectedLines);
        CAPWorkSheetEntry59FDW.Close();
    end;

    [Test]
    [HandlerFunctions('MoveWorkSheetLinesDataHandler')]
    procedure T52_TomovemultipleCallplanlinesfromoneworksheettoanother()
    // [USER STORY] 5.7 Ability to move a call plan record to a different worksheet name
    begin
        // [SCENARIO #52] To move multiple Call plan lines from one worksheet to another
        // [GIVEN] Execute the Call Plan Worksheet using tell me function
        CAPWorkSheetEntry59FDW.OpenEdit();
        Clear(MoveWorkSheetLines59FDW);
        // [GIVEN] Call Plan Worksheet page exists
        // [GIVEN] Call Plan Worksheet name “Default” exists
        FirstWorkSheetName := LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW);
        LibraryCallPlanMgmt59FDW.CreateCAPWorksheetName(CAPWorkSheetName59FDW, FirstWorkSheetName);
        // [GIVEN] Call Plan Worksheet name “Peter” exists
        SecondWorkSheetName := LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW);
        LibraryCallPlanMgmt59FDW.CreateCAPWorksheetName(CAPWorkSheetName59FDW, SecondWorkSheetName);
        // [GIVEN] 5 Records exists on worksheet “Default” for customer C0011
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        LibraryCallPlanMgmt59FDW.CreateWorksheetEntry(CAPWorkSheetEntry59FDWTable, FirstWorkSheetName, 10000, Customer, 20220510D, SalesPersonPurchaser.Code, 20220511D, 20220512D, CAPWorkSheetEntry59FDWTable."Call Plan Status"::New, 120000T);
        LibraryCallPlanMgmt59FDW.CreateWorksheetEntry(CAPWorkSheetEntry59FDWTable, FirstWorkSheetName, 20000, Customer, 20220511D, SalesPersonPurchaser.Code, 20220512D, 20220513D, CAPWorkSheetEntry59FDWTable."Call Plan Status"::New, 120000T);
        LibraryCallPlanMgmt59FDW.CreateWorksheetEntry(CAPWorkSheetEntry59FDWTable, FirstWorkSheetName, 30000, Customer, 20220512D, SalesPersonPurchaser.Code, 20220513D, 20220514D, CAPWorkSheetEntry59FDWTable."Call Plan Status"::New, 120000T);
        LibraryCallPlanMgmt59FDW.CreateWorksheetEntry(CAPWorkSheetEntry59FDWTable, FirstWorkSheetName, 40000, Customer, 20220513D, SalesPersonPurchaser.Code, 20220514D, 20220515D, CAPWorkSheetEntry59FDWTable."Call Plan Status"::New, 120000T);
        LibraryCallPlanMgmt59FDW.CreateWorksheetEntry(CAPWorkSheetEntry59FDWTable, FirstWorkSheetName, 50000, Customer, 20220514D, SalesPersonPurchaser.Code, 20220515D, 20220516D, CAPWorkSheetEntry59FDWTable."Call Plan Status"::New, 120000T);
        // [GIVEN] Execute the Call Plan Worksheet “Default”
        // [GIVEN] 3 call plan lines are selected
        CAPWorkSheetEntry59FDW.CurrentWorkSheetName.SetValue(FirstWorkSheetName);
        Commit();//
        CAPWorkSheetEntry59FDWTable.SetFilter("Worksheet Name", FirstWorkSheetName);
        CAPWorkSheetEntry59FDWTable.SetFilter("Line No.", '%1|%2|%3', 10000, 30000, 50000);
        CAPWorkSheetEntry59FDWTable.FindSet();
        MoveWorkSheetLines59FDW.GetParameters(CAPWorkSheetEntry59FDWTable);
        // [GIVEN] Click on "Actions" on the ribbon of the worksheet
        // [GIVEN] Click on "Move Lines"
        // [GIVEN] Move Work sheet Lines page exists
        // [GIVEN] No. of selected lines field exists
        NoOfSelectedLines := CAPWorkSheetEntry59FDWTable.Count();
        // [GIVEN] From Call Plan Worksheet name field exists
        // [GIVEN] To Call Plan Worksheet name dropdown exists
        // [GIVEN] Click on To Call Plan Worksheet name dropdown
        // [GIVEN] Select peter from Call Plan Worksheet dropdown
        ToWorkSheetName := SecondWorkSheetName;
        // [GIVEN] Execute the ok button
        MoveWorkSheetLines59FDW.RunModal();
        // [WHEN] Move lines from the Call Plan Worksheet "Default" to "Peter"
        // [THEN] The lines are now moved successfully
        CAPWorkSheetEntry59FDWTable.Reset();
        CAPWorkSheetEntry59FDWTable.SetRange("Worksheet Name", ToWorkSheetName);
        CAPWorkSheetEntry59FDWTable.FindFirst();
        LibraryAssert.AreEqual(CAPWorkSheetEntry59FDWTable."Worksheet Name", ToWorkSheetName, 'Move Lines action does not transfer selected lines to destination worksheet name');
        LibraryAssert.AreEqual(CAPWorkSheetEntry59FDWTable.Count(), NoOfSelectedLines, 'Selected Lines not moved by MoveLines action');
        CAPWorkSheetEntry59FDW.Close();
    end;

    [RequestPageHandler]
    procedure MoveWorkSheetLinesDataHandler(var MoveWorkSheetLines59FDWData: TestRequestPage MoveWorkSheetLines59FDW)
    begin
        MoveWorkSheetLines59FDWData.NoOfSelectedLinesPage.SetValue(NoOfSelectedLines);
        MoveWorkSheetLines59FDWData.ToCallPlanWorksheetNamePage.SetValue(ToWorkSheetName);
        MoveWorkSheetLines59FDWData.OK().Invoke();
    end;

    [Test]
    procedure T1_ToseetheInsideSalespersonCodeinthePostedSalesshipmentdocumentpage()
    // [USER STORY] 9.1 Inside Salesperson Code in Posted Sales shipment
    var
        PostedSalesDocumentNo: Code[20];
    begin
        // [SCENARIO #1] To see the Inside Salesperson Code in the Posted Sales shipment document page
        // [GIVEN] Call Plan Worksheet page exists
        // [GIVEN] Customer C0011 exists
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        // [GIVEN] Customer C0011 is included in Call Plan
        // [GIVEN] Salesperson "Anita" exists
        // [THEN] Shipment day is 5/26/2022 Thusdrsday in the Call Plan Sturcutre exists
        // [THEN] Call day is 5/27/2022 Friday in the Call Plan Strucutre exists
        // [GIVEN] Execute Call Plan Worksheet through the tell me function
        // [GIVEN] The Worksheet name "Anita" exists in the Worksheet page exists
        // [GIVEN] Execute on the Worksheet entry record
        // [GIVEN] Execute on the button New Sales Order in the ribbon of the Worksheet lines
        // [GIVEN] Sales Order page gets opened
        // [GIVEN] Inside Salesperson code is Anita in the Sales order exists
        LibrarySales.CreateSalesHeader(SalesHeader, "Sales Document Type"::"Order", Customer."No.");
        SalesHeader.Validate(InsideSalespersonCode59FDW, SalesPersonPurchaser.Code);
        // [GIVEN] Execute sales lines for item 0011
        // [GIVEN] Quantity 10 for the item 0011 exists
        LibraryInventory.CreateItem(Item);
        LibrarySales.CreateSalesLine(SalesLine, SalesHeader, SalesLine.Type::Item, Item."No.", 10);
        // [GIVEN] Quantity To Ship 10 for the item 0011 exists
        SalesLine.Validate("Qty. to Ship", 10);
        // [GIVEN] Execute Posting button in the Sales order page
        // [GIVEN] Execute Post button in the Posting button
        PostedSalesDocumentNo := LibrarySales.PostSalesDocument(SalesHeader, true, false);
        // [GIVEN] Assing Ship in the popup window
        // [GIVEN] Open the Posted Sales Shipment document
        SalesShipmentHeader.Get(PostedSalesDocumentNo);
        // [WHEN] Check if the Inside Salesperson code Anita is displayed in the Posted Sales Shipment Document
        // [THEN] Checked and the Insided Salesperson Code Anita is displayed in the Posted Sales Shipment Document
        LibraryAssert.AreEqual(SalesShipmentHeader.InsideSalespersonCode59FDW, SalesHeader.InsideSalespersonCode59FDW, 'InsideSalesPersondCode Were Empty ');
    end;

    [Test]
    procedure T60_CallPlanStatustoCompleteinrelationtoNewSalesOrderprocess()
    // [USER STORY] 7.4 Update 'Call Plan Status' to 'Complete' in relation to 'New Sales Order' process
    begin
        // [SCENARIO #60] Call Plan Status' to 'Complete' in relation to 'New Sales Order' process
        // [GIVEN] Call Plan Setup page exists
        Initialize();
        // [GIVEN] Source for Inside Salesperson Code as Call Plan exist
        // [GIVEN] Customer C0011 exists
        CAPWorkSheetEntry59FDW.OpenEdit();
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        // [GIVEN] Customer C0011 is included in Call plan
        // [GIVEN] Inside salesperson for Customer C0011 = Jackson exists
        FirstWorkSheetName := LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW);
        LibraryCallPlanMgmt59FDW.CreateCAPWorksheetName(CAPWorkSheetName59FDW, FirstWorkSheetName);
        // [GIVEN] Call day in the Call Plan Setup for customer C0011 = Friday exists
        // [GIVEN] Shipment day in the Call Plan Structure for customer C0011 = Saturday exists
        // [GIVEN] Starting date = 03/23/2022 exists from call plan structure
        // [GIVEN] Execute the "Call Plan Worksheet" in the Tell me function
        // [GIVEN] Worksheet has the name "Jackson" exists
        // [GIVEN] Execute the worksheet jackson
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        LibraryCallPlanMgmt59FDW.CreateWorksheetEntry(CAPWorkSheetEntry59FDWTable, FirstWorkSheetName, 10000, Customer, 20220510D, SalesPersonPurchaser.Code, 20220511D, 20220512D, CAPWorkSheetEntry59FDWTable."Call Plan Status"::New, 120000T);
        // [GIVEN] Call Plan Status = "New" exists for the Worksheet record
        // [GIVEN] Select the record
        CAPWorkSheetEntry59FDW.CurrentWorkSheetName.SetValue(FirstWorkSheetName);
        Commit(); // saving current progress
        // [GIVEN] Click on the button "New Sales Order" in the ribbon of the Worksheet lines
        SalesOrder.Trap();
        CAPWorkSheetEntry59FDW.GoToRecord(CAPWorkSheetEntry59FDWTable);
        CAPWorkSheetEntry59FDW.NewSalesOrder.Invoke();
        SalesOrder.Close();
        // [GIVEN] Sales Order gets created
        // [GIVEN] Return to the worksheet page
        CAPWorkSheetEntry59FDWTable.Get(FirstWorkSheetName, 10000);
        // [WHEN] Verify call plan status is updated as Completed
        // [THEN] Call Plan status is updated as "Completed"
        LibraryAssert.AreEqual(CAPWorkSheetEntry59FDWTable."Call Plan Status", CallPlanStatus::Completed, 'Call Plan status not updated to Completed');
        CAPWorkSheetEntry59FDW.Close();
    end;

    [Test]
    [HandlerFunctions('GenerateCallPlanLinesRequestPage')]
    procedure T53_Tofilterontherequestpagewhengeneratingcallplanlines()
    // [USER STORY] 6.2 Ability to filter on the request page when generating call plan lines
    var
        NewWorksheetName: Code[10];
    begin
        // [SCENARIO #53] To filter on the request page when generating call plan lines
        Initialize();
        // [GIVEN] Call Plan Worksheet page exists
        // [GIVEN] Call Plan Worksheet name “AVS” exists
        NewWorksheetName := LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW);
        LibraryCallPlanMgmt59FDW.CreateNewCAPWorksheetName(CAPWorkSheetName59FDW, NewWorksheetName, 'New worksheet generated');
        // [GIVEN] Inside salesperson is “AVS”
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        // [GIVEN] Customer C0011 has been set to be included in the call plan
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        LibraryCallPlanMgmt59FDW.CreateCustomerCallplan(ShipToAddressCapSetup59FDW, Customer, true, false);
        // [GIVEN] Call plan structure in the Call plan setup page has been set up for Customer C0011
        LibraryCallPlanMgmt59FDW.CreateCallplanStructure(CAPStructure59FDW, Customer."No.", 20220509D, 20220513D, WeekDay59FDW::Thursday, WeekDay59FDW::Wednesday, 090000T, 160000T, '', 'Call line 1');
        // [GIVEN] Call day on Monday for Customer C0011 exists
        // [GIVEN] Shipment day on Tuesday for Customer C0011 exists
        LibraryCallPlanMgmt59FDW.SetCallDayShipmentDay(Customer, SalesPersonPurchaser);
        // [GIVEN] Customer C0015 has been set to be included in the call plan
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        LibraryCallPlanMgmt59FDW.CreateCustomerCallplan(ShipToAddressCapSetup59FDW, Customer, true, false);
        // [GIVEN] Call plan structure in the Call plan setup page has been set up for Customer C0015
        LibraryCallPlanMgmt59FDW.CreateCallplanStructure(CAPStructure59FDW, Customer."No.", 20220509D, 20220513D, WeekDay59FDW::Friday, WeekDay59FDW::Wednesday, 080000T, 150000T, '', 'Call line 2');
        // [GIVEN] Call day on Monday for Customer C0015 exists
        // [GIVEN] Shipment day on Tuesday for Customer C0015 exists
        LibraryCallPlanMgmt59FDW.SetCallDayShipmentDay(Customer, SalesPersonPurchaser);
        // [GIVEN] Execute the Call Plan Worksheet through the “tell me” Function
        CAPWorkSheetEntry59FDW.OpenEdit();
        // [GIVEN] Execute the worksheet name “AVS”
        CAPWorkSheetEntry59FDW.CurrentWorkSheetName.SetValue(NewWorksheetName);
        // [GIVEN] Click on the button “Generate Call Plan lines” on the worksheet page
        Commit();// Write transaction
        CAPWorkSheetEntry59FDW.CreateCallPlanLines.Invoke();
        // [GIVEN] Request Page is executed
        // [GIVEN] Customer No. filter value = C0015
        // [GIVEN] Ship-to code filter value = 1
        // [GIVEN] Inside salesperson code filter value = AVS
        // NewInsideCode := LibraryUtility.GenerateRandomCode(Customer.FieldNo(InsideSalespersonCode59FDW), Database::Customer);
        // LibraryCallPlanMgmt59FDW.CreateInsidesalespersonCode(Customer, NewInsideCode);
        // [GIVEN] Required filter applied for Responsibility Center
        // [GIVEN] Execute ok button
        // [WHEN] Generate the Call Plan lines for Call date 3/21/2022 in the Call Plan Worksheet
        // [THEN] Call plan lines get generated for the Filtered records
        CAPWorkSheetEntry59FDWTable.SetRange("Worksheet Name", CAPWorkSheetName59FDW.Name);
        CAPWorkSheetEntry59FDWTable.FindFirst();
        LibraryCallPlanMgmt59FDW.CheckDataInWorksheetEntry(CAPWorkSheetEntry59FDWTable);
        CAPWorkSheetEntry59FDW.Close();
    end;

    [RequestPageHandler]
    procedure GenerateCallPlanLinesRequestPage(var GenerateCallPlanLines59FDW: TestRequestPage GenerateCallPlanLines59FDW)
    begin
        LibraryCallPlanMgmt59FDW.SetReportData(GenerateCallPlanLines59FDW, 20220511D, LibraryCallPlanMgmt59FDW.GetWeekDay(20220511D), false);
        LibraryCallPlanMgmt59FDW.SetFiltersForRequestPage(Customer, GenerateCallPlanLines59FDW, SalesPersonPurchaser, ShiptoAddress);
        GenerateCallPlanLines59FDW.OK().Invoke();
    end;

    [Test]
    [HandlerFunctions('GenerateCallPlanLineforSamecalldaysAndDifferentshipmentdays')]
    procedure T57_Callstructurerecordsforsamecalldaysanddifferentshipmentdaysgenerates2records()
    // [USER STORY] 6.3 Call structure records in the call plan worksheet
    var
        NewWorksheetName: Code[10];
    begin
        // [SCENARIO #57] Call Structure records for same call days and different shipment days generates 2 records
        Initialize();
        // [GIVEN] Call Plan Setup page exists
        // [GIVEN] Call Plan worksheet name "AVS" exists
        NewWorksheetName := LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW);
        LibraryCallPlanMgmt59FDW.CreateCAPWorksheetName(CAPWorkSheetName59FDW, NewWorksheetName);
        // [GIVEN] Inside salesperson "AVS" for customer C0011 exists
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        // [GIVEN] Customer C0011 has been included in the call plan
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        LibraryCallPlanMgmt59FDW.CreateCustomerCallplan(ShipToAddressCapSetup59FDW, Customer, true, false);
        // [GIVEN] Call plan structure has been set up for Customer C0011
        LibraryCallPlanMgmt59FDW.CreateCallplanStructure(CAPStructure59FDW, Customer."No.", 20220301D, 20220331D, WeekDay59FDW::Tuesday, WeekDay59FDW::Monday, 090000T, 160000T, '', 'Call line 1');
        LibraryCallPlanMgmt59FDW.CreateCallplanStructure(CAPStructure59FDW, Customer."No.", 20220301D, 20220331D, WeekDay59FDW::Friday, WeekDay59FDW::Monday, 070000T, 110000T, '', 'Call line 2');
        // [GIVEN] Call day of record 1 in the Call Plan Setup for customer C0011 = Monday exists
        // [GIVEN] Call day of record 2 in the Call Plan Setup for customer C0011 = Monday exists
        // [GIVEN] Shipment day of record 1 in the Call Plan Setup for customer C0011 = Tuesday exists
        // [GIVEN] Shipment day of record 2 in the Call Plan Setup for customer C0011 = Friday exists
        // [GIVEN] Open the Call plan setup by using Tell me function
        // [GIVEN] Open the worksheet name "AVS"
        CAPWorkSheetEntry59FDW.OpenEdit();
        CAPWorkSheetEntry59FDW.CurrentWorkSheetName.SetValue(NewWorksheetName);
        // [GIVEN] Click on the button "Generate Call Plan lines" on the worksheet page
        Commit();// Write transaction
        CAPWorkSheetEntry59FDW.CreateCallPlanLines.Invoke();
        // [GIVEN] Call date = 3/21/2022 exists
        // [GIVEN] Inside salesperson filter as "AVS" exists
        // [GIVEN] User clicks on "OK"
        // [WHEN] Try to update Worksheet with the call plan records structure
        // [THEN] Worksheet is updated with 2 records
        CAPWorkSheetEntry59FDWTable.SetRange("Worksheet Name", CAPWorkSheetName59FDW.Name);
        LibraryCallPlanMgmt59FDW.GetAllRecords(CAPWorkSheetEntry59FDWTable);
        CAPWorkSheetEntry59FDW.Close();
    end;

    [RequestPageHandler]
    procedure GenerateCallPlanLineforSamecalldaysAndDifferentshipmentdays(var GenerateCallPlanLines59FDW: TestRequestPage GenerateCallPlanLines59FDW)
    begin
        LibraryCallPlanMgmt59FDW.SetReportData(GenerateCallPlanLines59FDW, 20220321D, LibraryCallPlanMgmt59FDW.GetWeekDay(20220321D), true);
        GenerateCallPlanLines59FDW.OK().Invoke();
    end;

    [Test]
    procedure T70_TosettheInsideSalespersonCodeinSalesOrderfromCallPlanWorksheetwhensourceisUsersetupandhasnoUsersetuprecords()
    var
        SalesLines: Record "Sales Line";
    begin
        // [USER STORY] 9.2 “Inside Salesperson Code” in Posted Sales Invoice
        // [SCENARIO #71] To create the Posted Sales invoice document
        // [GIVEN] Call Plan Worksheet page exists
        // [GIVEN] Customer C0011 exists
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        // [GIVEN] Salesperson "Anita" exists
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        // [GIVEN] Customer C0011 is included in Call Plan
        // [GIVEN] Execute Call Plan Worksheet through the tell me function
        // [GIVEN] The Worksheet name "Anita" exists in the Worksheet page exists
        // [GIVEN] Call date is 5/11/2022 (Wednesday) in the Call Plan Strucutre exists
        // [GIVEN] Execute Generate Call Plan lines on date 5/11/2022(Wednesday) for Customer C0011
        // [GIVEN] Execute on the Worksheet entry record 
        // [GIVEN] Execute on the button New Sales Order in the ribbon of the Worksheet lines
        LibraryCallPlanMgmt59FDW.CreateSalesHeader(SalesHeader, Customer."No.");
        SalesHeader.Validate(InsideSalespersonCode59FDW, SalesPersonPurchaser.Code);
        // [GIVEN] Sales Order page gets opened
        // [GIVEN] Inside Salesperson code is Anita in the Sales order exists
        LibraryInventory.CreateItem(Item);
        // [GIVEN] Execute sales lines for item 0011
        LibrarySales.CreateSalesLine(SalesLines, SalesHeader, SalesLines.Type::Item, Item."No.", 10);
        // [GIVEN] Quantity 10 for the item 0011 exists
        // [GIVEN] Quantity To Ship 10 for the item 0011 exists
        SalesLines.Validate("Qty. to Ship", 10);
        // [GIVEN] Execute Posting button in the Sales order page
        // [GIVEN] Execute Post button in the Posting button
        SalesShipmentHeader.Get(LibrarySales.PostSalesDocument(SalesHeader, true, false));
        // [GIVEN] Assign Ship in the popup window
        // [GIVEN] Open the Posted Sales Shipment document
        // [GIVEN] New Posted Sales Shipment docutment exists
        // [GIVEN] Execute Post button in the Posting ribbon
        // [GIVEN] Assign Invoice in the popup window
        SalesInvoiceHeader.Get(LibrarySales.PostSalesDocument(SalesHeader, false, true));
        // [WHEN] Create the Posted Sales invoice document
        // [THEN] Posted Sales invoice document is created
        LibraryAssert.AreEqual(SalesInvoiceHeader.InsideSalespersonCode59FDW, SalesHeader.InsideSalespersonCode59FDW, 'Value not updated in sales invoice header');
    end;

    [Test]
    [HandlerFunctions('CallPlanLineGenerationRequestPageHandler')]
    procedure T56_TosettheInsideSalespersonCodeinSalesOrderfromCallPlanWorksheet()
    // [USER STORY] 7.2 Inside Salesperson Code in Sales Order When created from the Call Plan worksheet
    var
        NewWorksheetName: Code[10];
        OrderNo: Code[10];
    begin
        // [SCENARIO #56] To set the Inside Salesperson Code in Sales Order from Call Plan Worksheet
        Initialize();
        // [GIVEN] Call Plan Setup page exists
        CallPlanSetup59FDW.OpenEdit();
        // [GIVEN] Source for Inside Salesperson Code as Call Plan exist
        LibraryCallPlanMgmt59FDW.CreateCallPlanSetup(CallPlanSetupTable59FDW, InsideSalespersonCode::"Call plan");
        // [GIVEN] Customer C0011 exists
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        // [GIVEN] Customer C0011 is included in Call Plan
        // [GIVEN] Call Plan Worksheet Name = Anita exists
        NewWorksheetName := LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW);
        LibraryCallPlanMgmt59FDW.CreateNewCAPWorksheetName(CAPWorkSheetName59FDW, NewWorksheetName, 'New worksheet name is created');
        // [GIVEN] Inside Salesperson Code = "Anita" exists from worksheet
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        LibraryCallPlanMgmt59FDW.CreateCustomerCallplan(ShipToAddressCapSetup59FDW, Customer, true, false);
        // [GIVEN] In call plan structure "Shipment Day" = Saturday exists
        LibraryCallPlanMgmt59FDW.CreateCallplanStructure(CAPStructure59FDW, Customer."No.", 20220509D, 20220513D, WeekDay59FDW::Friday, WeekDay59FDW::Wednesday, 080000T, 150000T, '', 'Call line 2');
        // [GIVEN] Shipment date = 3/26/2022 exists
        // [GIVEN] Call date = 3/25/2022 exists
        // [GIVEN] Execute the "Call Plan Worksheet" in the Tell me function
        CAPWorkSheetEntry59FDW.OpenEdit();
        CAPWorkSheetEntry59FDW.CurrentWorkSheetName.SetValue(NewWorksheetName);
        // [GIVEN] Open the worksheet page named Anita
        // [GIVEN] Execute on Generates Call Plan lines
        Commit();//Write transaction
        CAPWorkSheetEntry59FDW.CreateCallPlanLines.Invoke();
        // [GIVEN] Select Call date as 3/25/2022
        // [GIVEN] Execute Ok button
        // [GIVEN] Execute on the Worksheet entry record
        SalesOrderCard.Trap();
        CAPWorkSheetEntry59FDWTable.Get(NewWorksheetName, 10000);
        CAPWorkSheetEntry59FDW.GoToRecord(CAPWorkSheetEntry59FDWTable);
        CAPWorkSheetEntry59FDW.NewSalesOrder.Invoke();
        OrderNo := Format(SalesOrderCard."No.".Value);
        SalesOrderCard.Close();
        SalesHeader.Get(SalesHeader."Document Type"::Order, OrderNo);
        // [GIVEN] Execute New Sales Order button in the ribbon of the Worksheet lines
        // [GIVEN] Sales Order gets Opened
        // [WHEN] Verify the Inside Salesperson Code in Sales Order
        // [THEN] Inside Salesperson Code is verified as "Anita"
        LibraryAssert.AreEqual(CAPWorkSheetEntry59FDWTable."Inside Salesperson Code", SalesHeader.InsideSalespersonCode59FDW, 'Salesperson Value not updated from worksheeet in salesorder');
        CAPWorkSheetEntry59FDW.Close();
        CallPlanSetup59FDW.Close();
    end;

    [Test]
    procedure T57_TosettheInsideSalespersonCodeinSalesOrderfromUserSetup()
    // [USER STORY] 7.2 Inside Salesperson Code in Sales Order When created from the Call Plan worksheet
    var
        RecordRef: RecordRef;
        NewWorkSheetName: Code[10];
        OrderNo: Code[10];
        NewLineNo: Integer;
    begin
        // [SCENARIO #57] To set the Inside Salesperson Code in Sales Order from User Setup
        Initialize();
        // [GIVEN] Call plan setup page exists
        CallPlanSetup59FDW.OpenEdit();
        LibraryCallPlanMgmt59FDW.CreateCallPlanSetup(CallPlanSetupTable59FDW, InsideSalespersonCode::"Call plan");
        // [GIVEN] Source for inside sales person as User Setup exists
        CallPlanSetup59FDW."Source for Inside Salesperson Code".SetValue(CallPlanSetupTable59FDW."InsideSalesperson Code"::"User setup");
        // [GIVEN] Customer C0011 exists
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        // [GIVEN] Call Plan Worksheet Name = Anita exists
        NewWorkSheetName := LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW);
        LibraryCallPlanMgmt59FDW.CreateNewCAPWorksheetName(CAPWorkSheetName59FDW, NewWorkSheetName, 'Worksheet is created');
        // [GIVEN] Inside Salesperson Code = Anita exists from worksheet
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        LibraryCallPlanMgmt59FDW.CreateCustomerCallplan(ShipToAddressCapSetup59FDW, Customer, true, false);
        // [GIVEN] In call plan structure "Shipment Day" = Saturday exists
        LibraryCallPlanMgmt59FDW.CreateCallplanStructure(CAPStructure59FDW, Customer."No.", 20220320D, 20220330D, WeekDay59FDW::Saturday, WeekDay59FDW::Friday, 080000T, 150000T, '', 'Call line 2');
        RecordRef.GetTable(CAPWorkSheetEntry59FDWTable);
        NewLineNo := LibraryUtility.GetNewLineNo(RecordRef, CAPWorkSheetEntry59FDWTable.FieldNo("Line No."));
        // [GIVEN] Shipment date = 3/26/2022 exists
        // [GIVEN] Call date = 3/25/2022 exists
        LibraryCallPlanMgmt59FDW.CreateWorksheetEntry(CAPWorkSheetEntry59FDWTable, NewWorkSheetName, NewLineNo, Customer, 20220325D, SalesPersonPurchaser.Code, 20220326D, 20220327D, CAPWorkSheetEntry59FDWTable."Call Plan Status"::New, 150000T);
        // [GIVEN] User ID record = DIN exists
        // [GIVEN] Inside Salesperson Code = "Anu" exists from User Setup record DIN
        LibraryCallPlanMgmt59FDW.InsertSalesPersonCodeInUserSetUp(UserSetup);
        // [GIVEN] Execute the "Call Plan Worksheet" in the Tell me function
        CAPWorkSheetEntry59FDW.OpenEdit();
        CAPWorkSheetEntry59FDW.CurrentWorkSheetName.SetValue(NewWorkSheetName);
        // [GIVEN] Open the worksheet page named Anita
        // [GIVEN] Execute on Generates Call Plan lines
        // [GIVEN] Select Call date as 3/25/2022
        // [GIVEN] Execute on Ok button
        // [GIVEN] Execute on the Worksheet entry record
        // [GIVEN] Execute on the button New Sales Order in the ribbon of the Worksheet lines
        SalesOrderCard.Trap();
        CAPWorkSheetEntry59FDWTable.Get(NewWorkSheetName, NewLineNo);
        CAPWorkSheetEntry59FDW.GoToRecord(CAPWorkSheetEntry59FDWTable);
        CAPWorkSheetEntry59FDW.NewSalesOrder.Invoke();
        OrderNo := Format(SalesOrderCard."No.".Value);
        SalesOrderCard.Close();
        SalesHeader.Get(SalesHeader."Document Type"::Order, OrderNo);
        // [GIVEN] Sales Order gets opened
        // [WHEN] Verify the Inside Salesperson Code in Sales Order
        // [THEN] Inside Salesperson Code is verified as "Anu"
        LibraryAssert.AreEqual(UserSetup."Salespers./Purch. Code", SalesHeader.InsideSalespersonCode59FDW, 'Does not updates usersetup salesperson value in sales order');
        CAPWorkSheetEntry59FDW.Close();
        CallPlanSetup59FDW.Close();
    end;

    [Test]
    procedure T58_TosettheblankInsideSalespersonCodeinSalesOrderfromUserSetup()
    // [USER STORY] 7.2 Inside Salesperson Code in Sales Order When created from the Call Plan worksheet
    var
        RecordRef: RecordRef;
        NewWorksheetName: Code[10];
        OrderNo: Code[10];
        NewLineNo: Integer;
    begin
        // [SCENARIO #58] To set the blank Inside Salesperson Code in Sales Order from User Setup
        Initialize();
        // [GIVEN] Call plan setup page exists
        CallPlanSetup59FDW.OpenEdit();
        LibraryCallPlanMgmt59FDW.CreateCallPlanSetup(CallPlanSetupTable59FDW, InsideSalespersonCode::"Call plan");
        // [GIVEN] Source for inside sales person as User Setup exists
        CallPlanSetup59FDW."Source for Inside Salesperson Code".SetValue(CallPlanSetupTable59FDW."InsideSalesperson Code"::"User setup");
        // [GIVEN] Customer C0011 exists
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        // [GIVEN] Call Plan Worksheet Name = Anita exists
        NewWorksheetName := LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW);
        LibraryCallPlanMgmt59FDW.CreateNewCAPWorksheetName(CAPWorkSheetName59FDW, NewWorksheetName, 'Worksheet is created');
        // [GIVEN] Inside Salesperson Code = Anita exists from worksheet
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        LibraryCallPlanMgmt59FDW.CreateCustomerCallplan(ShipToAddressCapSetup59FDW, Customer, true, false);
        // [GIVEN] In call plan structure "Shipment Day" = Saturday exists
        LibraryCallPlanMgmt59FDW.CreateCallplanStructure(CAPStructure59FDW, Customer."No.", 20220320D, 20220330D, WeekDay59FDW::Saturday, WeekDay59FDW::Friday, 080000T, 150000T, '', 'Call line 2');
        RecordRef.GetTable(CAPWorkSheetEntry59FDWTable);
        NewLineNo := LibraryUtility.GetNewLineNo(RecordRef, CAPWorkSheetEntry59FDWTable.FieldNo("Line No."));
        // [GIVEN] Shipment date = 3/26/2022 exists
        // [GIVEN] Call date = 3/25/2022 exists
        LibraryCallPlanMgmt59FDW.CreateWorksheetEntry(CAPWorkSheetEntry59FDWTable, NewWorksheetName, NewLineNo, Customer, 20220325D, SalesPersonPurchaser.Code, 20220326D, 20220327D, CAPWorkSheetEntry59FDWTable."Call Plan Status"::New, 150000T);
        // [GIVEN] User ID record = DIN exists
        // [GIVEN] Inside Salesperson Code not exists from User Setup record DIN
        LibraryCallPlanMgmt59FDW.SetBlankValueForSalesPerson(UserSetup);
        // [GIVEN] Execute the "Call Plan Worksheet" in the Tell me function
        CAPWorkSheetEntry59FDW.OpenEdit();
        // [GIVEN] Open the worksheet page named "Anita"
        CAPWorkSheetEntry59FDW.CurrentWorkSheetName.SetValue(NewWorksheetName);
        // [GIVEN] Execute on Generates Call Plan lines
        // [GIVEN] Select Call date as 3/25/2022
        // [GIVEN] Execute on Ok button
        // [GIVEN] Execute on the Worksheet entry record
        // [GIVEN] Execute on the button New Sales Order in the ribbon of the Worksheet lines
        SalesOrderCard.Trap();
        CAPWorkSheetEntry59FDWTable.Get(NewWorksheetName, NewLineNo);
        CAPWorkSheetEntry59FDW.GoToRecord(CAPWorkSheetEntry59FDWTable);
        CAPWorkSheetEntry59FDW.NewSalesOrder.Invoke();
        OrderNo := Format(SalesOrderCard."No.".Value);
        SalesOrderCard.Close();
        SalesHeader.Get(SalesHeader."Document Type"::Order, OrderNo);
        // [GIVEN] Sales Order gets opened
        // [WHEN] Verify the Inside Salesperson Code in Sales Order is blank
        // [THEN] Inside Salesperson Code is verified as blank
        LibraryAssert.AreEqual(UserSetup."Salespers./Purch. Code", SalesHeader.InsideSalespersonCode59FDW, 'Salesperson value exists in sales order but usersetup has blank value');
        CAPWorkSheetEntry59FDW.Close();
        CallPlanSetup59FDW.Close();
    end;

    [Test]
    [HandlerFunctions('CallPlanLineGenerationRequestPageHandler')]
    procedure T59_TosettheInsideSalespersonCodeinSalesOrderfromCallPlanWorksheetwhensourceisUsersetupandhasnoUsersetuprecords()
    // [USER STORY] 7.2 Inside Salesperson Code in Sales Order When created from the Call Plan worksheet
    var
        NewWorksheetName: Code[10];
        OrderNo: Code[10];
    begin
        // [SCENARIO #59] To set the Inside Salesperson Code in Sales Order from Call Plan Worksheet when source is User setup and has no User setup records
        Initialize();
        // [GIVEN] Call plan setup page exists
        CallPlanSetup59FDW.OpenEdit();
        LibraryCallPlanMgmt59FDW.CreateCallPlanSetup(CallPlanSetupTable59FDW, InsideSalespersonCode::"Call plan");
        // [GIVEN] Source for inside sales person as User Setup exists
        CallPlanSetup59FDW."Source for Inside Salesperson Code".SetValue(CallPlanSetupTable59FDW."InsideSalesperson Code"::"User setup");
        // [GIVEN] Customer C0011 exists
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        // [GIVEN] Call Plan Worksheet Name = Anita exists
        NewWorksheetName := LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW);
        LibraryCallPlanMgmt59FDW.CreateNewCAPWorksheetName(CAPWorkSheetName59FDW, NewWorksheetName, 'Worksheet is created');
        // [GIVEN] Inside Salesperson Code = "Anita" exists from worksheet
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        LibraryCallPlanMgmt59FDW.CreateCustomerCallplan(ShipToAddressCapSetup59FDW, Customer, true, false);
        // [GIVEN] In call plan structure "Shipment Day" = Saturday exists
        LibraryCallPlanMgmt59FDW.CreateCallplanStructure(CAPStructure59FDW, Customer."No.", 20220509D, 20220513D, WeekDay59FDW::Friday, WeekDay59FDW::Wednesday, 080000T, 150000T, '', 'Call line 2');
        // [GIVEN] Shipment date = 3/26/2022 exists
        // [GIVEN] Call date = 3/25/2022 exists
        // [GIVEN] No records exists from the User setup table
        UserSetup.DeleteAll();
        // [GIVEN] Execute the "Call Plan Worksheet" in the Tell me function
        CAPWorkSheetEntry59FDW.OpenEdit();
        CAPWorkSheetEntry59FDW.CurrentWorkSheetName.SetValue(NewWorksheetName);
        // [GIVEN] Open the worksheet page named Anita
        // [GIVEN] Execute on Generates Call Plan lines
        Commit();//Write transaction
        CAPWorkSheetEntry59FDW.CreateCallPlanLines.Invoke();
        // [GIVEN] Select Call date as 3/25/2022
        // [GIVEN] Execute on Ok button
        // [GIVEN] Execute on the Worksheet entry record
        // [GIVEN] Execute on the button New Sales Order in the ribbon of the Worksheet lines
        // [GIVEN] Sales Order gets opened
        SalesOrderCard.Trap();
        CAPWorkSheetEntry59FDWTable.Get(NewWorksheetName, 10000);
        CAPWorkSheetEntry59FDW.GoToRecord(CAPWorkSheetEntry59FDWTable);
        CAPWorkSheetEntry59FDW.NewSalesOrder.Invoke();
        OrderNo := Format(SalesOrderCard."No.".Value);
        SalesOrderCard.Close();
        SalesHeader.Get(SalesHeader."Document Type"::Order, OrderNo);
        // [WHEN] Verify the Inside Salesperson Code in Sales Order from Call Plan worksheet
        // [THEN] Inside Salesperson Code is verified as "Anita"
        LibraryAssert.AreEqual(CAPWorkSheetEntry59FDWTable."Inside Salesperson Code", SalesHeader.InsideSalespersonCode59FDW, 'Salesperson value from worksheet does not exists');
        CAPWorkSheetEntry59FDW.Close();
        CallPlanSetup59FDW.Close();
    end;

    [Test]
    procedure T64_TogetanInsideSalespersonCodevaluefromtheCallPlanSetup()
    // [USER STORY] 7.3 Inside Salesperson Code’ in Sales Order When not created from the Call Plan worksheet
    begin
        // [SCENARIO #64] To get an Inside Salesperson Code value from the Call Plan Setup
        // [GIVEN] Call Plan Setup page exists
        // [GIVEN] Source of InsideSalesperson code in the Call Plan Setup exists
        Initialize();
        // [GIVEN] Customer C0011 exists
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        LibrarySales.CreateShipToAddress(ShiptoAddress, Customer."No.");
        // [GIVEN] Customer C0011 included in the Call Plan
        // [GIVEN] InsideSalesperson code "Peter" for customer C0011 exists
        Customer.Validate(InsideSalespersonCode59FDW, SalesPersonPurchaser.Code);
        Customer.Modify(true);
        // [GIVEN] Call date is Friday in the Call Plan Structure exists
        // [GIVEN] Shipment Day is Saturday in the Call Plan Structure exists
        LibraryCallPlanMgmt59FDW.CreateCallplanheader(ShipToAddressCapSetup59FDW, Customer);
        LibraryCallPlanMgmt59FDW.CreateCallplanStructure(CAPStructure59FDW, Customer."No.", 20220509D, 20220513D, WeekDay59FDW::Friday, WeekDay59FDW::Saturday, 090000T, 160000T, ShiptoAddress.Code, 'Call line 1');
        // [GIVEN] Execute Sales order list page through the tell me function
        // [GIVEN] Execute New button in the Sales order list page
        // [GIVEN] Assign the value as C0011
        // [GIVEN] Assign the value Breda as Ship-To address
        LibrarySales.CreateSalesHeader(SalesHeader, "Sales Document Type"::"Order", Customer."No.");
        // [WHEN] Get Inside Salesperson Code on Sales Order
        // [THEN] Inside Salesperson code got with the value "peter"
        LibraryAssert.AreEqual(SalesHeader.InsideSalespersonCode59FDW, Customer.InsideSalespersonCode59FDW, 'InsideSalesPersonCode From Customer Were Not Updated');
    end;

    [Test]
    procedure T65_TogetanInsideSalespersonCodevaluefromUserSetup()
    // [USER STORY] 7.3 Inside Salesperson Code’ in Sales Order When not created from the Call Plan worksheet
    begin
        // [SCENARIO #65] To get an Inside Salesperson Code value from User Setup
        Initialize();
        // [GIVEN] Call Plan Setup page exists
        // [GIVEN] Source of InsideSalesperson code in the Call Plan Setup exists
        CallPlanSetupTable59FDW.Validate("InsideSalesperson Code", InsideSalespersonCode::"User Setup");
        CallPlanSetupTable59FDW.Modify(true);
        // [GIVEN] Customer C0011 exists
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        LibrarySales.CreateShipToAddress(ShiptoAddress, Customer."No.");
        // [GIVEN] User Setup page exists
        // [GIVEN] Salesperson code "Anita" exists in the User ID
        LibraryCallPlanMgmt59FDW.CreateUserSetup(UserSetup);
        UserSetup.Validate("Salespers./Purch. Code", SalesPersonPurchaser.Code);
        UserSetup.Modify(true);
        // [GIVEN] Salesperson code "Peter" for customer C0011 exists
        // [GIVEN] Ship-To code Breda is included in Call plan
        // [GIVEN] Call date is Friday in the Call Plan Structure exists
        // [GIVEN] Shipment Day is Saturday in the Call Plan Structure exists
        LibraryCallPlanMgmt59FDW.CreateCallplanheader(ShipToAddressCapSetup59FDW, Customer);
        LibraryCallPlanMgmt59FDW.CreateCallplanStructure(CAPStructure59FDW, Customer."No.", 20220509D, 20220513D, WeekDay59FDW::Friday, WeekDay59FDW::Saturday, 090000T, 160000T, ShiptoAddress.Code, 'Call line 1');
        // [GIVEN] Execute Sales order list page through the tell me function
        // [GIVEN] Execute New button in the Sales order list pag
        // [GIVEN] Assign the value as C0011
        // [GIVEN] Assign the value Breda as Ship-To address
        LibrarySales.CreateSalesHeader(SalesHeader, "Sales Document Type"::"Order", Customer."No.");
        // [WHEN] Get Inside Salesperson Code on Sales Order
        // [THEN] Inside Salesperson code got with the Anita value from the User ID
        // CallPlanSetup59FDWTestPage.Close();
        LibraryAssert.AreEqual(SalesHeader.InsideSalespersonCode59FDW, UserSetup."Salespers./Purch. Code", 'InsideSalesPersonCode From UserSetup Were Not Updated ');
    end;

    [Test]
    [HandlerFunctions('ConfirmHandler,MessageHandler')]
    procedure T66_TogetNotificationwhenthereisblankInsideSalespersoncodeinbothCallplanandUserSetup()
    // [USER STORY] 7.3 Inside Salesperson Code’ in Sales Order When not created from the Call Plan worksheet
    var
        InsideSalesPersonMsg: Label '''Inside Salesperson Code'' could not be automatically specified, because no salesperson is set up on the User Setup page for user [%1]. Please select a value manually.', Comment = '%1=User ID';
    begin
        // [SCENARIO #66] To get Notification when there is blank Inside Salesperson code in both Call plan and User Setup
        Initialize();
        // [GIVEN] Call Plan Setup page exists
        // [GIVEN] User Setup page exists
        // [GIVEN] Source of InsideSalesperson code in the Call Plan Setup exists
        CallPlanSetupTable59FDW.Validate("InsideSalesperson Code", InsideSalespersonCode::"User Setup");
        CallPlanSetupTable59FDW.Modify(true);
        // [GIVEN] User ID has empty records exists
        UserSetup.DeleteAll(true);
        // [GIVEN] Customer C0011 exists
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        // Customer.Validate(InsideSalespersonCode59FDW, '');
        // Customer.Modify(true);
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        LibrarySales.CreateShipToAddress(ShiptoAddress, Customer."No.");
        // [GIVEN] Customer C0011 included in the Call Plan
        LibraryCallPlanMgmt59FDW.CreateCallplanheader(ShipToAddressCapSetup59FDW, Customer);
        // [GIVEN] Salesperson code empty for customer C0011 exists
        // [GIVEN] Ship-To code Breda is included in Call plan
        // [GIVEN] Call date is Friday in the Call Plan Structure exists
        // [GIVEN] Shipment Day is Saturday in the Call Plan Structure exists
        LibraryCallPlanMgmt59FDW.CreateCallplanStructure(CAPStructure59FDW, Customer."No.", 20220509D, 20220513D, WeekDay59FDW::Friday, WeekDay59FDW::Saturday, 090000T, 160000T, ShiptoAddress.Code, 'Call line 1');
        // [GIVEN] Execute Sales order list page through the tell me function
        SalesOrderList.OpenEdit();
        // [GIVEN] Execute New button in the Sales order list page
        SalesOrderCard.OpenEdit();
        // [GIVEN] Assign the value as C0011
        // [GIVEN] Assign the value Breda as Ship-To address
        // [WHEN] Get Inside Salesperson Code on Sales Order
        // [THEN] Inside Salesperson code got the Notification 'Inside Salesperson Code' could not be automatically specified, because no salesperson is set up on the User Setup page for user [user ID]. Please select a value manually.
        SalesOrderCard."Sell-to Customer No.".SetValue(Customer."No.");
        LibraryAssert.ExpectedMessage(InsideSalesPersonCodeErrorMessage, StrSubstNo(InsideSalesPersonMsg, UserId));
        SalesOrderCard.Close();
        SalesOrderList.Close();
    end;

    [MessageHandler]
    procedure MessageHandler(MessageText: Text[1024])
    begin
        InsideSalesPersonCodeErrorMessage := MessageText;
    end;

    [Test]
    [HandlerFunctions('CallPlanLineGenerationRequestPageHandler')]
    procedure T78_TocreatewiththefrequencyofweeklyintheCallPlanStructure()
    // [USER STORY] 11.4 Call Plan Frequency: Weekly logic
    var
        WorksheetName: Code[10];
    begin
        // [SCENARIO #78] To create with the frequency of "weekly" in the Call Plan Structure
        Initialize();
        // [GIVEN] Call Plan Setup page exists
        // [GIVEN] Call Plan Worksheet page exists
        // [GIVEN] Customer C0011 is included in Call Plan
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        LibraryCallPlanMgmt59FDW.CreateCustomerCallplan(ShipToAddressCapSetup59FDW, Customer, true, false);
        // [GIVEN] Call Plan Structure for customer C0011 exists
        // [GIVEN] Shipment date = Thursday exists
        // [GIVEN] Call day = Wednesday exists
        // [GIVEN] Frequency = Weekly exists
        // [GIVEN] Last Creation date = 5/4/2022 exists
        LibraryCallPlanMgmt59FDW.CreateCallplanStructure(CAPStructure59FDW, Customer."No.", 20220426D, 20220513D, WeekDay59FDW::Thursday, WeekDay59FDW::Wednesday, 090000T, 160000T, '', 'Call line 1');
        CAPStructure59FDW.Validate("Last Creation Date", 20220504D);
        CAPStructure59FDW.Validate(Frequency, CAPStructure59FDW.Frequency::Weekly);
        CAPStructure59FDW.Modify(true);
        // [GIVEN] Execute Call Plan Worksheet through the tell me function
        WorksheetName := LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW);
        LibraryCallPlanMgmt59FDW.CreateNewCAPWorksheetName(CAPWorkSheetName59FDW, WorksheetName, 'New worksheet generated');
        CAPWorkSheetEntry59FDW.OpenEdit();
        CAPWorkSheetEntry59FDW.CurrentWorkSheetName.SetValue(WorksheetName);
        // [GIVEN] Execute Generate call plan lines on date 5/4/2022
        // [GIVEN] Call Plan lines are generated on date 5/4/2022 exists
        // [GIVEN] Shipment day Thursday in the Call Plan Structure exists
        // [GIVEN] Call day Wednesday in the Call Plan Structure exists
        // [GIVEN] Execute Call Plan Worksheet through the tell me function
        // [GIVEN] Execute Generate call plan lines on date 5/11/2022
        Commit();// Write transaction
        CAPWorkSheetEntry59FDW.CreateCallPlanLines.Invoke();
        // [WHEN] Create the Call Plan Worksheet records based on Weekly logic
        // [THEN] Call Plan Worksheet records are created on 5/11/2022 based on Weekly logic
        CAPWorkSheetEntry59FDWTable.SetRange("Worksheet Name", WorksheetName);
        CAPWorkSheetEntry59FDWTable.FindFirst();
        LibraryAssert.AreEqual(CAPWorkSheetEntry59FDWTable."Call Date", CalcDate('<7D>', CAPStructure59FDW."Last Creation Date"), 'No Matched Records For Weekly');
        CAPWorkSheetEntry59FDW.Close();
    end;

    [Test]
    [HandlerFunctions('CallPlanLineGenerationRequestPageHandler')]
    procedure T77_WhenthefrequencyisbiweeklyCallplanrecordisgeneratedforthesameCallPlanStructuretwoweeksago()
    // [USER STORY] 11.3 Call Plan Frequency: Bi-Weekly logic
    var
        WorksheetName: Code[10];
    begin
        // [SCENARIO #77] When the frequency is bi-weekly, Call plan record is generated for the same Call Plan Structure two weeks ago.
        Initialize();
        // [GIVEN] Call Plan Setup page exists
        // [GIVEN] Source for Inside Salesperson Code as Call Plan exists
        // [GIVEN] Customer C0011 exists
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        // [GIVEN] Customer C0011 is included in Call plan
        LibraryCallPlanMgmt59FDW.CreateCustomerCallplan(ShipToAddressCapSetup59FDW, Customer, true, false);
        // [GIVEN] Call plan structure for customer C0011 exists
        // [GIVEN] Shipment Day = Thursday exists
        // [GIVEN] Call day = Wednesday exists
        LibraryCallPlanMgmt59FDW.CreateCallplanStructure(CAPStructure59FDW, Customer."No.", 20220426D, 20220513D, WeekDay59FDW::Thursday, WeekDay59FDW::Wednesday, 090000T, 160000T, '', 'Call line 1');
        // [GIVEN] Frequency= Bi-Weekly exists
        CAPStructure59FDW.Validate(Frequency, CAPStructure59FDW.Frequency::"Bi-Weekly");
        // [GIVEN] Last creation date = 4/22/2022 exists
        CAPStructure59FDW.Validate("Last Creation Date", 20220427D);
        CAPStructure59FDW.Modify(true);
        // [GIVEN] Execute the Call Plan Worksheet in the Tell me function
        CAPWorkSheetEntry59FDW.OpenEdit();
        // [GIVEN] Execute Generate call plan lines on date 4/27/2022
        WorksheetName := LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW);
        LibraryCallPlanMgmt59FDW.CreateNewCAPWorksheetName(CAPWorkSheetName59FDW, WorksheetName, 'New worksheet generated');
        CAPWorkSheetEntry59FDW.CurrentWorkSheetName.SetValue(WorksheetName);
        // [GIVEN] Call Plan lines are generated on date 4/27/2022 exists
        // [GIVEN] Shipment day Thursday in the Call Plan Structure exists
        // [GIVEN] Call day Friday in the Call Plan Structure exists
        // [GIVEN] Execute Call Plan Worksheet through the tell me function
        // [GIVEN] Execute Generate call plan lines on date 5/11/2022
        Commit();// Write transaction
        CAPWorkSheetEntry59FDW.CreateCallPlanLines.Invoke();
        // [WHEN] Create the Call Plan Worksheet records based on Bi-weekly logic
        // [THEN] Call Plan record is generated on 5/11/2022
        CAPWorkSheetEntry59FDWTable.SetRange("Worksheet Name", WorksheetName);
        CAPWorkSheetEntry59FDWTable.FindFirst();
        LibraryAssert.AreEqual(CAPWorkSheetEntry59FDWTable."Call Date", CalcDate('<14D>', CAPStructure59FDW."Last Creation Date"), 'No Matched Records For Weekly');
        CAPWorkSheetEntry59FDW.Close();
    end;

    [Test]
    procedure T70_Toupdatetheincludeforcutofftimerestrictioninthesalesorder()
    // [USER STORY] 8.1 Field in Sales Order to control whether Cut-off time restriction is in effect
    var
        RecordRef: RecordRef;
        NewWorksheetName: Code[10];
        OrderNo: Code[20];
        NewLineNumber: Integer;

    begin
        // [SCENARIO #70] To Update the Include for Cut-off Time Restriction in the Sales Order
        Initialize();
        // [GIVEN] Call Plan Worksheet page exists
        // [GIVEN] Customer C0011 exists
        LibrarySales.CreateCustomer(Customer);
        // [GIVEN] Customer C0011 is included in Call Plan
        // [GIVEN] Customer C0011 is included in Cut-off restrictions in the Call Plan Setup
        LibraryCallPlanMgmt59FDW.CreateCustomerCallplan(ShipToAddressCapSetup59FDW, Customer, true, true);
        // [GIVEN] Sales Order for Customer C0011 exists
        // [GIVEN] Inside Salesperson code is "Jackson" exists
        // [GIVEN] Call day is Monday for customer C0011 in the call plan structure exists
        // [GIVEN] Shipment day is Tuesday for customer C0011 in the call plan structure exists
        // [GIVEN] Execute Call Plan Worksheet through the tell me function
        CAPWorkSheetEntry59FDW.OpenEdit();
        // [GIVEN] The Worksheet name "Jackson" exists in the Worksheet page exists
        NewWorksheetName := LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW);
        RecordRef.GetTable(CAPWorkSheetEntry59FDWTable);
        NewLineNumber := LibraryUtility.GetNewLineNo(RecordRef, CAPWorkSheetEntry59FDWTable.FieldNo("Line No."));
        LibraryCallPlanMgmt59FDW.CreateNewCAPWorksheetName(CAPWorkSheetName59FDW, NewWorksheetName, 'New sales worksheet added');
        LibraryCallPlanMgmt59FDW.CreateWorksheetEntry(CAPWorkSheetEntry59FDWTable, NewWorksheetName, NewLineNumber, Customer, 20220222D, SalesPersonPurchaser.Code, 20220225D, 20220228D, CAPWorkSheetEntry59FDWTable."Call Plan Status"::New, 170000T);
        // [GIVEN] Generate Call Plan lines  on date 3/21/2022 for customer C0011
        // [GIVEN] Inside Salespercode code is Jackson for this entry exists
        // [GIVEN] Execute New Sales Order button in the Call Plan Worksheet page
        SalesOrder.Trap();
        CAPWorkSheetEntry59FDW.CurrentWorkSheetName.SetValue(NewWorksheetName);
        CAPWorkSheetEntry59FDW.GoToRecord(CAPWorkSheetEntry59FDWTable);
        CAPWorkSheetEntry59FDW.NewSalesOrder.Invoke();
        OrderNo := Format(SalesOrder."No.".Value);
        SalesOrder.Close();
        SalesHeader.Get(SalesHeader."Document Type"::Order, OrderNo);
        // [GIVEN] Include for Cut-off Time Restriction in the Sales Order exists with the boolean values
        // [WHEN] Update the Include for Cut-off Time Restriction in the Sales order 
        // [THEN] Include for Cut-off Time Restriction is updated to enabled status
        LibraryAssert.AreEqual(ShipToAddressCapSetup59FDW."Inc.forCutoffTimeRestriction", SalesHeader.IncludeforCutoffTime59FDW, 'IncludeforCutoffTime Value is not Equal');
        CAPWorkSheetEntry59FDW.Close();
    end;

    [Test]
    procedure T72_CutoffTimeRestrictionpreventsinsertingSalesline()
    // [USER STORY] 8.2 Cut-off Time Restriction prevents Sales Line insert / modify / delete
    var
        RecordRef: RecordRef;
        NewWorksheetName: Code[10];
        NewLineNumber: Integer;
        OrderDay: Enum WeekDay59FDW;
        OrderDayCutOffTime: Time;
        InsertModifyErr: Label 'It is not possible to edit the sales lines anymore, because based on the call day linked to the shipment day of the order, the cut-off time for this order was set up to be [#1########,#2######], which has passed. ', Comment = '%1=WeekDay, %2=CurrentDayCutOffTime';
    begin
        // [SCENARIO #72] Cut-off Time Restriction prevents inserting Sales line
        // [GIVEN] Call Plan Setup page exists
        // [GIVEN] Order entry Cut-off time restriction during the week for all days is set to 15:00
        // [GIVEN] Order entry Cut-off time restriction during the weekends is set to 00:00
        LibraryCallPlanMgmt59FDW.CreateCallPlanSetup(CallPlanSetupTable59FDW, InsideSalespersonCode::"Call plan");
        // [GIVEN] Customer C0011 exists
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        // [GIVEN] Customer C0011 is included in Call plan
        // [GIVEN] Customer C0011 is included in Cut-off time restrictions
        LibraryCallPlanMgmt59FDW.CreateCustomerCallplan(ShipToAddressCapSetup59FDW, Customer, true, true);
        // [GIVEN] Call plan structure for customer C0011 exists
        // [GIVEN] Shipment Day = Friday exists
        // [GIVEN] Call day = Thursday exists
        // [GIVEN] Salesperson “Jackson” exists for customer C0011
        // [GIVEN] Execute the Call Plan Worksheet in the Tell me function
        CAPWorkSheetEntry59FDW.OpenEdit();
        // [GIVEN] Worksheet has the name “Jackson” exists
        // [GIVEN] Execute the Worksheet Jackson
        // [GIVEN] Generate Call Plan lines on date 3/24/2022 for customer C0011
        // [GIVEN] Inside Salesperson code for the worksheet entry is “Jackson” exists
        NewWorksheetName := LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW);
        RecordRef.GetTable(CAPWorkSheetEntry59FDWTable);
        NewLineNumber := LibraryUtility.GetNewLineNo(RecordRef, CAPWorkSheetEntry59FDWTable.FieldNo("Line No."));
        LibraryCallPlanMgmt59FDW.CreateNewCAPWorksheetName(CAPWorkSheetName59FDW, NewWorksheetName, 'New sales worksheet added');
        LibraryCallPlanMgmt59FDW.CreateWorksheetEntry(CAPWorkSheetEntry59FDWTable, NewWorksheetName, NewLineNumber, Customer, 20220522D, SalesPersonPurchaser.Code, 20220526D, 20220528D, CAPWorkSheetEntry59FDWTable."Call Plan Status"::New, 170000T);
        CAPWorkSheetEntry59FDW.CurrentWorkSheetName.SetValue(NewWorksheetName);
        CAPWorkSheetEntry59FDW.GoToRecord(CAPWorkSheetEntry59FDWTable);
        // [GIVEN] Sales order page gets opened
        // [GIVEN] Sales order included in the cut-off time restrictions exists
        LibrarySales.CreateSalesHeader(SalesHeader, "Sales Document Type"::"Order", Customer."No.");
        SalesHeader.Validate(IncludeforCutoffTime59FDW, true);
        SalesHeader.Validate("Order Date", 20220606D);
        SalesHeader.Modify(true);
        OrderDay := LibraryCallPlanMgmt59FDW.GetWeekDay(SalesHeader."Order Date");
        OrderDayCutOffTime := LibraryCallPlanMgmt59FDW.UpdateCutoffTimeFromSetup(OrderDay, CallPlanSetupTable59FDW);
        // [GIVEN] System time = 15:00 exists
        // [WHEN] Insert sales Lines for item
        LibraryInventory.CreateItem(Item);
        LibrarySales.CreateSalesLine(SalesLine, SalesHeader, SalesLine.Type::Item, Item."No.", 7);
        // Error notification message is thrown as Cut off time for this order has passed
        asserterror LibraryCallPlanMgmt59FDW.IsSalesLineValidForInsert(SalesHeader, OrderDayCutOffTime, 20220606D, 120000T);
        LibraryAssert.ExpectedError(InsertModifyErr);
        CAPWorkSheetEntry59FDW.Close();
    end;

    [Test]
    procedure T73_CutoffTimeRestrictionpreventsmodifyingSalesline()
    // [USER STORY] 8.2 Cut-off Time Restriction prevents Sales Line insert / modify / delete
    var
        RecordRef: RecordRef;
        NewWorksheetName: Code[10];
        NewLineNumber: Integer;
        OrderDay: Enum WeekDay59FDW;
        OrderDayCutOffTime: Time;
        InsertModifyErr: Label 'It is not possible to edit the sales lines anymore, because based on the call day linked to the shipment day of the order, the cut-off time for this order was set up to be [#1########,#2######], which has passed. ', Comment = '%1=WeekDay, %2=CurrentDayCutOffTime';
    begin
        // [SCENARIO #73] Cut-off Time Restriction prevents modifying Sales line
        // [GIVEN] Call Plan Setup page exists
        // [GIVEN] Order entry Cut-off time restriction during the week for all days is set to 15:00
        // [GIVEN] Order entry Cut-off time restriction during the weekends is set to 00:00
        LibraryCallPlanMgmt59FDW.CreateCallPlanSetup(CallPlanSetupTable59FDW, InsideSalespersonCode::"Call plan");
        // [GIVEN] Customer C0011 exists
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        // [GIVEN] Customer C0011 is included in Call plan
        // [GIVEN] Customer C0011 is included in Cut-off time restrictions
        LibraryCallPlanMgmt59FDW.CreateCustomerCallplan(ShipToAddressCapSetup59FDW, Customer, true, true);
        // [GIVEN] Call plan structure for customer C0011 exists
        // [GIVEN] Shipment Day = Friday exists
        // [GIVEN] Call day = Thursday exists
        // [GIVEN] Starting date = 3/20/2022 exists
        // [GIVEN] Salesperson “Jackson” exists for customer C0011
        // [GIVEN] Execute the Call Plan Worksheet in the Tell me function
        CAPWorkSheetEntry59FDW.OpenEdit();
        // [GIVEN] Worksheet has the name “Jackson” exists
        // [GIVEN] Execute the Worksheet Jackson
        // [GIVEN] Generate Call Plan lines on date 3/24/2022 for customer C0011
        // [GIVEN] Inside Salesperson code for the worksheet entry is “Jackson” exists
        NewWorksheetName := LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW);
        RecordRef.GetTable(CAPWorkSheetEntry59FDWTable);
        NewLineNumber := LibraryUtility.GetNewLineNo(RecordRef, CAPWorkSheetEntry59FDWTable.FieldNo("Line No."));
        LibraryCallPlanMgmt59FDW.CreateNewCAPWorksheetName(CAPWorkSheetName59FDW, NewWorksheetName, 'New sales worksheet added');
        LibraryCallPlanMgmt59FDW.CreateWorksheetEntry(CAPWorkSheetEntry59FDWTable, NewWorksheetName, NewLineNumber, Customer, 20220522D, SalesPersonPurchaser.Code, 20220526D, 20220528D, CAPWorkSheetEntry59FDWTable."Call Plan Status"::New, 170000T);
        CAPWorkSheetEntry59FDW.CurrentWorkSheetName.SetValue(NewWorksheetName);
        CAPWorkSheetEntry59FDW.GoToRecord(CAPWorkSheetEntry59FDWTable);
        // [GIVEN] Sales order page gets opened
        // [GIVEN] Sales order included in the cut-off time restrictions exists
        LibrarySales.CreateSalesHeader(SalesHeader, "Sales Document Type"::"Order", Customer."No.");
        SalesHeader.Validate(IncludeforCutoffTime59FDW, true);
        SalesHeader.Validate("Order Date", 20220606D);
        SalesHeader.Modify(true);
        OrderDay := LibraryCallPlanMgmt59FDW.GetWeekDay(SalesHeader."Order Date");
        OrderDayCutOffTime := LibraryCallPlanMgmt59FDW.UpdateCutoffTimeFromSetup(OrderDay, CallPlanSetupTable59FDW);
        // [GIVEN] System time = 15:05 exists
        // [GIVEN] Sales Line for item 0011 exists
        LibraryInventory.CreateItem(Item);
        // Quantity = 10 exists in the sales line for item 0011
        LibrarySales.CreateSalesLine(SalesLine, SalesHeader, SalesLine.Type::Item, Item."No.", 7);
        // Change the Quantity on the sales line
        asserterror LibraryCallPlanMgmt59FDW.IsSalesLineValidForModify(SalesHeader, SalesLine, OrderDayCutOffTime, 20220606D, 120000T, 2);
        // Error notification message is thrown as Cut off time for this order has passed
        LibraryAssert.ExpectedError(InsertModifyErr);
        CAPWorkSheetEntry59FDW.Close();
    end;

    [Test]
    procedure T74_CutoffTimeRestrictionpreventsdeletingSalesline()
    // [USER STORY] 8.2 Cut-off Time Restriction prevents Sales Line insert / modify / delete
    var
        RecordRef: RecordRef;
        NewWorksheetName: Code[10];
        NewLineNumber: Integer;
        OrderDay: Enum WeekDay59FDW;
        OrderDayCutOffTime: Time;
        DeleteErr: Label 'It is not possible to delete the sales lines anymore, because based on the call day linked to the shipment day of the order, the cut-off time for this order was set up to be [#1########,#2######], which has passed. ', Comment = '%1=WeekDay, %2=CurrentDayCutOffTime';
    begin
        // [SCENARIO #74] Cut-off Time Restriction prevents deleting Sales line
        // [GIVEN] Call Plan Setup page exists
        // [GIVEN] Order entry Cut-off time restriction during the week for all days is set to 15:00
        // [GIVEN] Order entry Cut-off time restriction during the weekends is set to 00:00
        LibraryCallPlanMgmt59FDW.CreateCallPlanSetup(CallPlanSetupTable59FDW, InsideSalespersonCode::"Call plan");
        // [GIVEN] Customer C0011 exists
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        // [GIVEN] Customer C0011 is included in Call plan
        // [GIVEN] Customer C0011 is included in Cut-off time restrictions
        LibraryCallPlanMgmt59FDW.CreateCustomerCallplan(ShipToAddressCapSetup59FDW, Customer, true, true);
        // [GIVEN] Call plan structure for customer C0011 exists
        // [GIVEN] Shipment Day = Friday exists
        // [GIVEN] Call day = Thursday exists
        // [GIVEN] Starting date = 3/20/2022 exists
        // [GIVEN] Salesperson “Jackson” exists for customer C0011
        // [GIVEN] Execute the Call Plan Worksheet in the Tell me function
        CAPWorkSheetEntry59FDW.OpenEdit();
        // [GIVEN] Worksheet has the name “Jackson” exists
        // [GIVEN] Execute the Worksheet Jackson
        // [GIVEN] Generate Call Plan lines on date 3/24/2022 for customer C0011
        // [GIVEN] Inside Salesperson code for the worksheet entry is “Jackson” exists
        NewWorksheetName := LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW);
        RecordRef.GetTable(CAPWorkSheetEntry59FDWTable);
        NewLineNumber := LibraryUtility.GetNewLineNo(RecordRef, CAPWorkSheetEntry59FDWTable.FieldNo("Line No."));
        LibraryCallPlanMgmt59FDW.CreateNewCAPWorksheetName(CAPWorkSheetName59FDW, NewWorksheetName, 'New sales worksheet added');
        LibraryCallPlanMgmt59FDW.CreateWorksheetEntry(CAPWorkSheetEntry59FDWTable, NewWorksheetName, NewLineNumber, Customer, 20220522D, SalesPersonPurchaser.Code, 20220526D, 20220528D, CAPWorkSheetEntry59FDWTable."Call Plan Status"::New, 170000T);
        CAPWorkSheetEntry59FDW.CurrentWorkSheetName.SetValue(NewWorksheetName);
        CAPWorkSheetEntry59FDW.GoToRecord(CAPWorkSheetEntry59FDWTable);
        // [GIVEN] Execute the button “New Sales Order” in the ribbon of the Worksheet lines
        // [GIVEN] Sales order page gets opened
        // [GIVEN] Sales order included in the cut-off time restrictions exists
        LibrarySales.CreateSalesHeader(SalesHeader, "Sales Document Type"::"Order", Customer."No.");
        SalesHeader.Validate(IncludeforCutoffTime59FDW, true);
        SalesHeader.Validate("Order Date", 20220606D);
        SalesHeader.Modify(true);
        OrderDay := LibraryCallPlanMgmt59FDW.GetWeekDay(SalesHeader."Order Date");
        OrderDayCutOffTime := LibraryCallPlanMgmt59FDW.UpdateCutoffTimeFromSetup(OrderDay, CallPlanSetupTable59FDW);
        // [GIVEN] System time = 15:05 exists
        // [GIVEN] Sales Line for item 0011 exists
        LibraryInventory.CreateItem(Item);
        LibrarySales.CreateSalesLine(SalesLine, SalesHeader, SalesLine.Type::Item, Item."No.", 7);
        // Delete the sales line
        SalesLine.Delete(true);
        asserterror LibraryCallPlanMgmt59FDW.IsSalesLineValidForDelete(SalesHeader, OrderDayCutOffTime, 20220606D, 120000T);
        // Error notification message is thrown as 'Not possible to delete' Cut off time for this order has passed
        LibraryAssert.ExpectedError(DeleteErr);
        CAPWorkSheetEntry59FDW.Close();
    end;

    [Test]
    [HandlerFunctions('GenerateCallPlanLinesforSameCallDayAndSameShipmentDay')]
    procedure T68_GeneratingCallPlanLinesWhenBothCallDaysAndShipmentDaysAreSameForMultipleRecordsFromCustomerCallPlanStructure()
    // [USER STORY] 4.5 Call Plan Structure: Customer/Ship-To Starting Date Conditions
    var
        NewWorksheetName: Code[10];
    begin
        // [SCENARIO #68] Generating Call Plan Lines When Both Call Days And Shipment Days Are Same For Multiple Records From 'Customer' Call Plan Structure
        Initialize();
        // [GIVEN] Customer C0011 exists
        // [GIVEN] Customer C0011 is included in Call Plan 
        // [GIVEN] Call Plan worksheet name "AVS" exists
        NewWorksheetName := LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW);
        LibraryCallPlanMgmt59FDW.CreateCAPWorksheetName(CAPWorkSheetName59FDW, NewWorksheetName);
        // [GIVEN] Inside salesperson "AVS" for Customer C0011 exists
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        // [GIVEN] Call plan Structure has been set up for Customer C0011
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        LibraryCallPlanMgmt59FDW.CreateCustomerCallplan(ShipToAddressCapSetup59FDW, Customer, true, false);
        // [GIVEN] Starting Date of record 1 in the Call Plan Setup for Customer C0011 = 01/01/2022 exists
        // [GIVEN] Shipment day of record 1 in the Call Plan Setup for Customer C0011 = Friday exists
        // [GIVEN] Call day of record 1 in the Call Plan Setup for Customer C0011 = Thursday exists
        LibraryCallPlanMgmt59FDW.CreateCallplanStructure(CAPStructure59FDW, Customer."No.", 20220101D, 20220131D, WeekDay59FDW::Friday, WeekDay59FDW::Thursday, 090000T, 160000T, '', 'Call line 1');
        // [GIVEN] Starting Date of record 2 in the Call Plan Setup for customer C0011 = 01/05/2022 exists
        // [GIVEN] Shipment day of record 2 in the Call Plan Setup for customer C0011 = Friday exists
        // [GIVEN] Call day of record 2 in the Call Plan Setup for customer C0011 = Thursday exists
        LibraryCallPlanMgmt59FDW.CreateCallplanStructure(CAPStructure59FDW, Customer."No.", 20220105D, 20220131D, WeekDay59FDW::Friday, WeekDay59FDW::Thursday, 070000T, 110000T, '', 'Call line 2');
        // [GIVEN] Execute the “Call plan worksheet” page through tell me function
        CAPWorkSheetEntry59FDW.OpenEdit();
        CAPWorkSheetEntry59FDW.CurrentWorkSheetName.SetValue(NewWorksheetName);
        // [GIVEN] Execute on Generates Call Plan lines 
        Commit();//write transaction
        CAPWorkSheetEntry59FDW.CreateCallPlanLines.Invoke();
        // [GIVEN] Call date = 01/06/2022 exists
        // [GIVEN] Call day = Thursday exists
        // [GIVEN] Execute on Ok button
        // [WHEN] Update Call Plan Worksheet with the most recent starting date record
        // [THEN] Worksheet is updated with 'record 2'
        CAPWorkSheetEntry59FDWTable.SetRange("Worksheet Name", CAPWorkSheetName59FDW.Name);
        LibraryCallPlanMgmt59FDW.GetAllRecords(CAPWorkSheetEntry59FDWTable);
        LibraryCallPlanMgmt59FDW.CheckDataInWorksheetEntry(CAPWorkSheetEntry59FDWTable);
        CAPWorkSheetEntry59FDW.Close();
    end;

    [RequestPageHandler]
    procedure GenerateCallPlanLinesforSameCallDayAndSameShipmentDay(var GenerateCallPlanLines59FDW: TestRequestPage GenerateCallPlanLines59FDW)
    begin
        LibraryCallPlanMgmt59FDW.SetReportData(GenerateCallPlanLines59FDW, 20220106D, LibraryCallPlanMgmt59FDW.GetWeekDay(20220106D), false);
        GenerateCallPlanLines59FDW.OK().Invoke();
    end;

    [Test]
    [HandlerFunctions('GenerateCallPlanLinesforSameCallDayAndSameShipmentDay')]
    procedure T69_GeneratingCallPlanLinesWhenRecordsHavingSameShipmentDaysAndDifferentCallDaysFromShipToAddressCallPlanStructure()
    // [USER STORY] 4.5 Call Plan Structure: Customer/Ship-To Starting Date Conditions
    var
        NewWorksheetName: Code[10];
    begin
        // [SCENARIO #69] Generating Call Plan Lines Wen Records Having Same Shipment Days And Different Call Days From 'Ship To Address' Call Plan Structure
        Initialize();
        // [GIVEN] Customer C0011 exists
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        LibraryCallPlanMgmt59FDW.CreateShipToAddressList(ShiptoAddress, Customer);
        // [GIVEN] Customer C0011 is included in Call Plan
        LibraryCallPlanMgmt59FDW.CreateCustomerCallplan(ShipToAddressCapSetup59FDW, Customer, true, false);
        // [GIVEN] Call Plan worksheet name "AVS" exists
        NewWorksheetName := LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW);
        LibraryCallPlanMgmt59FDW.CreateCAPWorksheetName(CAPWorkSheetName59FDW, NewWorksheetName);
        // [GIVEN] Inside salesperson "AVS" from Ship To Address exists
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        // [GIVEN] Call plan structure in the Call plan setup page has been set up for Ship To Address
        // [GIVEN] Starting Date of record 1 in the Call Plan Setup from Ship To Address for Customer C0011 = 01/06/2022 exists
        // [GIVEN] Shipment day of record 1 in the Call Plan Setup from Ship To Address for Customer C0011 = Friday exists
        // [GIVEN] Call day of record 1 in the Call Plan Setup from Ship To Address for Customer C0011 = Thursday exists
        LibraryCallPlanMgmt59FDW.CreateCallplanStructure(CAPStructure59FDW, Customer."No.", 20220106D, 20220131D, WeekDay59FDW::Friday, WeekDay59FDW::Thursday, 090000T, 160000T, '', 'Call line 1');
        // [GIVEN] Starting Date of record 2 in the Call Plan Setup from Ship To Address for customer C0011 = 01/20/2022 exists
        // [GIVEN] Shipment day of record 2 in the Call Plan Setup from Ship To Address for customer C0011 = Friday exists
        // [GIVEN] Call day of record 2 in the Call Plan Setup from Ship To Address for Customer C0011 = Monday exists
        LibraryCallPlanMgmt59FDW.CreateCallplanStructure(CAPStructure59FDW, Customer."No.", 20220120D, 20220131D, WeekDay59FDW::Friday, WeekDay59FDW::Monday, 090000T, 160000T, '', 'Call line 2');
        // [GIVEN] Execute the “Call plan worksheet” page through tell me function
        CAPWorkSheetEntry59FDW.OpenEdit();
        CAPWorkSheetEntry59FDW.CurrentWorkSheetName.SetValue(NewWorksheetName);
        // [GIVEN] Execute on Generates Call Plan lines 
        Commit();//write transaction
        CAPWorkSheetEntry59FDW.CreateCallPlanLines.Invoke();
        // [GIVEN] Call date = 01/06/2022 exists
        // [GIVEN] Call day = Thursday exists
        // [GIVEN] Execute on Ok button
        // [WHEN] Try to update Call Plan Worksheet with the most recent starting date record
        // [THEN] Worksheet is updated with 'record 1'
        CAPWorkSheetEntry59FDWTable.SetRange("Worksheet Name", CAPWorkSheetName59FDW.Name);
        LibraryCallPlanMgmt59FDW.GetAllRecords(CAPWorkSheetEntry59FDWTable);
        LibraryCallPlanMgmt59FDW.CheckDataInWorksheetEntry(CAPWorkSheetEntry59FDWTable);
        CAPWorkSheetEntry59FDW.Close();
    end;

    [Test]
    [HandlerFunctions('ConfirmHandler,MessageHandler')]
    procedure T75_ToRestoreInsideSalespersonCodefromtheArchivedSalesOrder()
    var
        SalesLines: Record "Sales Line";
        SalesHeaderArchive: Record "Sales Header Archive";
    begin
        // [SCENARIO #75] To Restore ‘Inside Salesperson Code’ from the Archived Sales Order
        // [GIVEN] Call Plan Setup page exists
        CallPlanSetup59FDW.OpenEdit();
        // [GIVEN] Source for Inside Salesperson Code as Call Plan exists
        LibraryCallPlanMgmt59FDW.CreateCallPlanSetup(CallPlanSetupTable59FDW, CallPlanSetupTable59FDW."InsideSalesperson Code"::"Call plan");
        // [GIVEN] Customer C0013 exists
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        // [GIVEN] Customer C0013 is included in Call plan
        LibraryCallPlanMgmt59FDW.CreateCustomerCallplan(ShipToAddressCapSetup59FDW, Customer, true, false);
        // [GIVEN] Call plan structure for customer C0013 exists
        // [GIVEN] Shipment Day = Friday exists
        // [GIVEN] Call day = Thursday exists
        // [GIVEN] Salesperson "Anita" exists for customer C0013
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        // [GIVEN] Execute the Call Plan Worksheet in the Tell me function
        // [GIVEN] Worksheet has the name Anita exists
        // [GIVEN] Execute the Worksheet Anita
        // [GIVEN] Generate Call Plan lines on date 3/24/2022 for customer C0013     
        // [GIVEN] Execute the button "New Sales Order" in the ribbon of the Worksheet lines
        LibraryCallPlanMgmt59FDW.CreateSalesHeader(SalesHeader, Customer."No.");
        // [GIVEN] Inside Salesperson Code "Anita" exists
        SalesHeader.Validate(InsideSalespersonCode59FDW, SalesPersonPurchaser.Code);
        LibraryInventory.CreateItem(Item);
        // [GIVEN] Sales line for item 0012 exists
        LibrarySales.CreateSalesLine(SalesLines, SalesHeader, SalesLines.Type::Item, Item."No.", 10);
        // [GIVEN] Quantity = 10 exists
        // [GIVEN] Qty to ship = 10 exists
        SalesLines.Validate("Qty. to Ship", 10);
        // [GIVEN] Execute on "Archive Document" from the ribbon
        LibraryCallPlanMgmt59FDW.ArchiveSalesDocument(SalesHeader);
        // [GIVEN] Sales Order gets archived
        // [GIVEN] Execute the Sales Orders Archive page using tell me function
        // [GIVEN] Sales Orders Archive page exists
        // [GIVEN] Inside Salesperson code field is visible and verified as "Anita"
        SalesHeaderArchive.SetRange("Document Type", SalesHeaderArchive."Document Type"::Order);
        SalesHeaderArchive.SetRange("No.", SalesHeader."No.");
        SalesHeaderArchive.FindFirst();
        SalesHeaderArchive.Validate(InsideSalespersonCode59FDW, SalesHeader.InsideSalespersonCode59FDW);
        // [WHEN] Execute the Restore button in the ribbon
        LibraryCallPlanMgmt59FDW.RestoreSalesDocument(SalesHeaderArchive);
        // [THEN] Inside Salesperson code gets restored from the Archived Sales Order
        LibraryAssert.AreEqual(SalesHeaderArchive.InsideSalespersonCode59FDW, SalesHeader.InsideSalespersonCode59FDW, 'Value not restored in sales header from saler header archive');
        CallPlanSetup59FDW.Close();
    end;

    [Test]
    [HandlerFunctions('ConfirmHandler,MessageHandler')]
    procedure T80_DeliverydateCallPlanWorksheetwhenShippingAgentServiceCodeShiptoAddressCallPlanandShippingtimefromCustomerCardblank()
    var
        SalesLines: Record "Sales Line";
        SalesHeaderArchive: Record "Sales Header Archive";
    begin
        // [SCENARIO #74] Inside Salesperson Code on the Archived Sales Order have the value from the base Sales Order.
        // [GIVEN] Call Plan Setup page exists
        CallPlanSetup59FDW.OpenEdit();
        // [GIVEN] Source for Inside Salesperson Code as Call Plan exists
        LibraryCallPlanMgmt59FDW.CreateCallPlanSetup(CallPlanSetupTable59FDW, CallPlanSetupTable59FDW."InsideSalesperson Code"::"Call plan");
        // [GIVEN] Customer C0012 exists
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        // [GIVEN] Customer C0012 is included in Call plan
        LibraryCallPlanMgmt59FDW.CreateCustomerCallplan(ShipToAddressCapSetup59FDW, Customer, true, false);
        // [GIVEN] Call plan structure for customer C0012 exists
        // [GIVEN] Shipment Day = Friday exists
        // [GIVEN] Call day = Thursday exists
        // [GIVEN] Salesperson "Peter" exists for customer C0012
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        // [GIVEN] Execute the Call Plan Worksheet in the Tell me function
        // [GIVEN] Worksheet has the name Peter exists
        // [GIVEN] Execute the Worksheet Peter
        // [GIVEN] Generate Call Plan lines on date 3/24/2022 for customer C0012     
        // [GIVEN] Execute the button "New Sales Order" in the ribbon of the Worksheet lines
        LibraryCallPlanMgmt59FDW.CreateSalesHeader(SalesHeader, Customer."No.");
        // [GIVEN] Inside Salesperson Code "Peter" exists
        SalesHeader.Validate(InsideSalespersonCode59FDW, SalesPersonPurchaser.Code);
        LibraryInventory.CreateItem(Item);
        // [GIVEN] Sales line for item 0011 exists
        LibrarySales.CreateSalesLine(SalesLines, SalesHeader, SalesLines.Type::Item, Item."No.", 10);
        // [GIVEN] Quantity = 10 exists
        // [GIVEN] Qty to ship = 10 exists
        SalesLines.Validate("Qty. to Ship", 10);
        // [GIVEN] Execute on "Archive Document" from the ribbon
        LibraryCallPlanMgmt59FDW.ArchiveSalesDocument(SalesHeader);
        // [GIVEN] Sales Order gets archived
        // [GIVEN] Execute the Sales Orders Archive page using tell me function
        // [GIVEN] Sales Orders Archive page exists
        SalesHeaderArchive.SetRange("Document Type", SalesHeaderArchive."Document Type"::Order);
        SalesHeaderArchive.SetRange("No.", SalesHeader."No.");
        SalesHeaderArchive.FindFirst();
        // [WHEN] Verify Inside Salesperson code field is visible on the Archived Sales Order and has the value from the base Sales Order
        // [THEN] Inside Salesperson code field is visible and verified as "Peter"
        LibraryAssert.AreEqual(SalesHeader.InsideSalespersonCode59FDW, SalesHeaderArchive.InsideSalespersonCode59FDW, 'Value not updated in sales archive from sales header');
        CallPlanSetup59FDW.Close();
    end;

    [Test]
    [HandlerFunctions('CallPlanLineGenerationRequestPageHandler')]
    procedure T61_DeliverydateinCallPlanWorksheetwhenShippingAgentServiceCodeexistsinShipToAddress()
    // [USER STORY] 6.4 Call Plan worksheet: Delivery date
    var
        NewWorkSheetName: Code[10];
        OrderNo: Code[20];
    begin
        // [SCENARIO #61] Delivery date in Call Plan Worksheet when 'Shipping Agent Service Code' exists in Ship To Addres
        // [GIVEN] Customer C0011 exists
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        // [GIVEN] Customer C0011 is included in Call Plan
        LibraryCallPlanMgmt59FDW.CreateShipToCode(Customer, ShiptoAddress);
        // [GIVEN] Call plan structure in the Call plan setup page has been set up for Ship To Address
        LibraryCallPlanMgmt59FDW.CreateCustomerCallplan(ShipToAddressCapSetup59FDW, Customer, true, false);
        LibraryCallPlanMgmt59FDW.CreateCustomerShipToCallPlan(ShipToAddressCapSetup59FDW, Customer, ShiptoAddress, true);
        LibraryCallPlanMgmt59FDW.CreateCallplanStructure(CAPStructure59FDW, Customer."No.", 20220509D, 20220531D, WeekDay59FDW::Friday, WeekDay59FDW::Wednesday, 080000T, 150000T, ShiptoAddress.Code, 'Call line 2');
        // [GIVEN] Call Plan worksheet name “AVS” exists
        NewWorkSheetName := LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW);
        LibraryCallPlanMgmt59FDW.CreateNewCAPWorksheetName(CAPWorkSheetName59FDW, NewWorkSheetName, 'New worksheet generated');
        // [GIVEN] Inside salesperson is “AVS” exists
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        // [GIVEN] Shipping Agent Service Code = 4 days exists
        LibraryCallPlanMgmt59FDW.CreateServiceAgentCodeForShipToAddress(CAPStructure59FDW, ShiptoAddress, ShippingAgentServices, ShippingAgent);
        ShiptoAddress.Validate("Shipping Agent Code", ShippingAgent.Code);
        ShiptoAddress.Validate("Shipping Agent Service Code", ShippingAgentServices.Code);
        // [GIVEN] Starting date = 05/01/2022 exists from call plan structure
        // [GIVEN] Shipment day = Tuesday exists
        // [GIVEN] Shipment date = 05/03/2022 exists
        // [GIVEN] Call day = Monday exists
        // [GIVEN] Execute the Call Plan Worksheet AVS using tell me function
        CAPWorkSheetEntry59FDW.OpenEdit();
        CAPWorkSheetEntry59FDW.CurrentWorkSheetName.SetValue(NewWorkSheetName);
        // [GIVEN] Click on generate call plan lines
        Commit();// write transaction
        CAPWorkSheetEntry59FDW.CreateCallPlanLines.Invoke();
        // [GIVEN] Call date = 05/02/2022 exists
        // [GIVEN] Execute on the ok button
        // [GIVEN] Click on New Sales Order button
        SalesOrderCard.Trap();
        CAPWorkSheetEntry59FDWTable.Get(NewWorkSheetName, 10000);
        CAPWorkSheetEntry59FDW.GoToRecord(CAPWorkSheetEntry59FDWTable);
        CAPWorkSheetEntry59FDW.NewSalesOrder.Invoke();
        OrderNo := Format(SalesOrderCard."No.".Value);
        SalesOrderCard.Close();
        // [WHEN] Sales order page gets opened
        SalesHeader.Get(SalesHeader."Document Type"::Order, OrderNo);
        // [THEN] Delivery date  in sales order gets updated as "05/07/2022"
        LibraryAssert.AreEqual(CAPWorkSheetEntry59FDWTable."Delivery Date", SalesHeader."Requested Delivery Date", 'Delivery not updated in sales order');
        CAPWorkSheetEntry59FDW.Close();
    end;

    [Test]
    [HandlerFunctions('CallPlanLineGenerationRequestPageHandler')]
    procedure T62_DeliverydateinCallPlanWorksheetfromCustomerCardwhenShippingAgentServiceCodefromShipToAddressisblank()
    // [USER STORY] 6.4 Call Plan worksheet: Delivery date
    var
        NewWorksheetName: Code[10];
        OrderNo: Code[20];
    begin
        // [SCENARIO #62] Delivery date in Call Plan Worksheet from Customer Card when 'Shipping Agent Service Code from Ship To Address' is blank
        // [GIVEN] Customer C0011 exists
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        LibraryCallPlanMgmt59FDW.CreateShipToCode(Customer, ShiptoAddress);
        // [GIVEN] Customer C0011 is included in Call Plan
        LibraryCallPlanMgmt59FDW.CreateCustomerCallplan(ShipToAddressCapSetup59FDW, Customer, true, false);
        LibraryCallPlanMgmt59FDW.CreateCustomerShipToCallPlan(ShipToAddressCapSetup59FDW, Customer, ShiptoAddress, true);
        // [GIVEN] Call plan structure in the Call plan setup page has been set up for Customers C0011
        LibraryCallPlanMgmt59FDW.CreateCallplanStructure(CAPStructure59FDW, Customer."No.", 20220509D, 20220531D, WeekDay59FDW::Friday, WeekDay59FDW::Wednesday, 080000T, 150000T, ShiptoAddress.Code, 'Call line 2');
        // [GIVEN] Call Plan worksheet name “AVS” exists
        NewWorksheetName := LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW);
        LibraryCallPlanMgmt59FDW.CreateNewCAPWorksheetName(CAPWorkSheetName59FDW, NewWorksheetName, 'Worksheet is generated');
        // [GIVEN] Inside salesperson is “AVS” exists
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        // [GIVEN] Shipping Agent Service Code from Ship To Address is blank exists
        LibraryCallPlanMgmt59FDW.CreateServiceAgentForCustomer(CAPStructure59FDW, Customer, ShiptoAddress, ShippingAgentServices, ShippingAgent);
        // [GIVEN] Shipping FastTab exists for customer C0011
        // [GIVEN] Shipping time on customer card C0011 = 2 days
        // [GIVEN] Starting date = 05/01/2022 exists from call plan structure
        // [GIVEN] Shipment day = Tuesday exists
        // [GIVEN] Shipment date = 05/03/2022 exists
        // [GIVEN] Call day = Monday exists
        Customer.Validate("Shipping Agent Code", ShippingAgent.Code);
        Customer.Validate("Shipping Agent Service Code", ShippingAgentServices.Code);
        Customer.Validate("Shipping Time", ShippingAgentServices."Shipping Time");
        // [GIVEN] Execute the Call Plan Worksheet AVS using tell me function
        CAPWorkSheetEntry59FDW.OpenEdit();
        CAPWorkSheetEntry59FDW.CurrentWorkSheetName.SetValue(NewWorksheetName);
        // [GIVEN] Click on generate call plan lines
        Commit();// Write tranasaction
        CAPWorkSheetEntry59FDW.CreateCallPlanLines.Invoke();
        // [GIVEN] Call date = 05/02/2022 exists
        // [GIVEN] Execute on the ok button
        // [GIVEN] Click on New Sales Order button
        SalesOrderCard.Trap();
        CAPWorkSheetEntry59FDWTable.Get(NewWorksheetName, 10000);
        CAPWorkSheetEntry59FDW.GoToRecord(CAPWorkSheetEntry59FDWTable);
        CAPWorkSheetEntry59FDW.NewSalesOrder.Invoke();
        OrderNo := Format(SalesOrderCard."No.".Value);
        SalesOrderCard.Close();
        // [WHEN] Sales order page gets opened
        SalesHeader.Get(SalesHeader."Document Type"::Order, OrderNo);
        // [THEN] Delivery date  in sales order gets updated as "05/07/2022"
        LibraryAssert.AreEqual(SalesHeader."Requested Delivery Date", CAPWorkSheetEntry59FDWTable."Delivery Date", 'Delivery date not updted in sales order from worksheet entry');
        CAPWorkSheetEntry59FDW.Close();
    end;

    [Test]
    [HandlerFunctions('CallPlanLineGenerationRequestPageHandler')]
    procedure T63_DeliverydateinCallPlanWorksheetwhenbothShippingAgentServiceCodeShiptoAddressCallPlanandShippingtimeCustomerCardblank()
    // [USER STORY] 6.4 Call Plan worksheet: Delivery date
    var
        NewWorksheetName: Code[10];
        OrderNo: Code[20];
    begin
        // [SCENARIO #63] Delivery date in Call Plan Worksheet when both 'Shipping Agent Service Code from Ship to Address Call Plan' and 'Shipping time from Customer Card' is blank
        Initialize();
        // [GIVEN] Customer C0011 exists
        LibraryCallPlanMgmt59FDW.CreateCustomer(Customer);
        LibraryCallPlanMgmt59FDW.CreateShipToCode(Customer, ShiptoAddress);
        // [GIVEN] Customer C0011 is included in Call Plan
        LibraryCallPlanMgmt59FDW.CreateCustomerCallplan(ShipToAddressCapSetup59FDW, Customer, true, false);
        LibraryCallPlanMgmt59FDW.CreateCustomerShipToCallPlan(ShipToAddressCapSetup59FDW, Customer, ShiptoAddress, true);
        // [GIVEN] Call plan structure in the Call plan setup page has been set up for Customers C0011
        LibraryCallPlanMgmt59FDW.CreateCallplanStructure(CAPStructure59FDW, Customer."No.", 20220509D, 20220531D, WeekDay59FDW::Friday, WeekDay59FDW::Wednesday, 080000T, 150000T, ShiptoAddress.Code, 'Call line 3');
        // [GIVEN] Call Plan worksheet name “AVS” exists
        NewWorksheetName := LibraryUtility.GenerateRandomCode(CAPWorkSheetName59FDW.FieldNo(Name), Database::CAPWorkSheetName59FDW);
        LibraryCallPlanMgmt59FDW.CreateNewCAPWorksheetName(CAPWorkSheetName59FDW, NewWorksheetName, 'Worksheet is generated');
        // [GIVEN] Inside salesperson is “AVS” exists
        LibraryCallPlanMgmt59FDW.CreateSalesPerson(SalesPersonPurchaser);
        // [GIVEN] Shipping Agent Service Code from Ship To Address' is blank exists
        // [GIVEN] Shipping FastTab exists for customer C0011
        // [GIVEN] Shipping time on customer card C0011 is blank exists
        LibraryCallPlanMgmt59FDW.CreateShippingTimeInCustomer(CAPStructure59FDW, Customer);
        // [GIVEN] Starting date = 05/01/2022 exists from call plan structure
        // [GIVEN] Shipment day = Tuesday exists
        // [GIVEN] Shipment date = 05/03/2022 exists
        // [GIVEN] Call day = Monday exists
        Customer.Validate("Shipping Time", ShippingAgentServices."Shipping Time");
        // [GIVEN] Execute the Call Plan Worksheet AVS using tell me function
        CAPWorkSheetEntry59FDW.OpenEdit();
        CAPWorkSheetEntry59FDW.CurrentWorkSheetName.SetValue(NewWorksheetName);
        // [GIVEN] Click on generate call plan lines
        Commit(); // Write transaction
        CAPWorkSheetEntry59FDW.CreateCallPlanLines.Invoke();
        // [GIVEN] Call date = 05/02/2022 exists
        // [GIVEN] Execute on the ok button
        // [GIVEN] Click on New Sales Order button
        SalesOrderCard.Trap();
        CAPWorkSheetEntry59FDWTable.Get(NewWorksheetName, 10000);
        CAPWorkSheetEntry59FDW.GoToRecord(CAPWorkSheetEntry59FDWTable);
        CAPWorkSheetEntry59FDW.NewSalesOrder.Invoke();
        OrderNo := Format(SalesOrderCard."No.".Value);
        SalesOrderCard.Close();
        // [WHEN] Sales order page gets opened
        SalesHeader.Get(SalesHeader."Document Type"::Order, OrderNo);
        // [THEN] Delivery date  in sales order gets updated as "05/07/2022"
        LibraryAssert.AreEqual(SalesHeader."Requested Delivery Date", CAPWorkSheetEntry59FDWTable."Delivery Date", 'Delivery date not updated in sales order from worksheet entry');
        CAPWorkSheetEntry59FDW.Close();
    end;

    [Test]
    procedure T81_SetupaResponsibilityCenterCallPlanSetup()
    // [USER STORY] 13.1 Responsibility Center Call Plan Setup
    var
        NewResponsibilityCenterCode: Code[10];
    begin
        // [SCENARIO #81] Set up a Responisiblity Center Call Plan Setup
        // [GIVEN] Responsibility page exists
        ResponsibilityCenterCard.OpenEdit();
        // [GIVEN] Call Plan Setup page exists
        // [GIVEN] Execute Responsibility Centers through the tell me function
        // [GIVEN] Assign LONDON in the Responsibility page
        NewResponsibilityCenterCode := LibraryUtility.GenerateRandomCode(ResponsibilityCenter.FieldNo(Code), Database::"Responsibility Center");
        LibraryCallPlanMgmt59FDW.CreateResponsibilityCenterCode(ResponsibilityCenter, NewResponsibilityCenterCode);
        // [GIVEN] Related button exists in the Responsibility Center card page
        // [GIVEN] Call Plan Setup exists in the Related button
        // [WHEN] Open the Call Plan Setup from the Responsibilty Center card page
        // [THEN] Call Plan Setup is opened from the Responsibility Center card page
        ResponsibilityCenterCard.GoToRecord(ResponsibilityCenter);
        ResponsibilityCenterCAPS59FDW.Trap();
        ResponsibilityCenterCard.CAPS59FDW.Invoke();
        ResponsibilityCenterCard.Close();
        ResponsibilityCenterCAPS59FDW.Close();
    end;
}