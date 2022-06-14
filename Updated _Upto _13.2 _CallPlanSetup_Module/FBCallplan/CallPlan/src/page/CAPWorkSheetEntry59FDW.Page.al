page 70241758 CAPWorkSheetEntry59FDW
{
    PageType = Worksheet;
    Caption = 'Call Plan Worksheet';
    ApplicationArea = CallPlanAppArea59FDW;
    UsageCategory = Tasks;
    LinksAllowed = false;
    InsertAllowed = false;
    SourceTable = CAPWorkSheetEntry59FDW;
    SourceTableView = sorting("Call Window Starting Time");
    PromotedActionCategories = 'New,Process,Navigation,Related';
    AutoSplitKey = true;
    SaveValues = true;
    Extensible = false;
    layout
    {
        area(Content)
        {
            field(CurrentWorkSheetName; CurrentWorkSheetName)
            {
                ApplicationArea = CallPlanAppArea59FDW;
                Caption = 'Call Plan Worksheet Name';
                Lookup = true;
                ToolTip = 'Specifies the name of the call plan worksheet. A worksheet displays a list of customers that need to be contacted regarding their sales orders for a particular date, by a specific sales person on a specific date.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CallplanWorksheetMgt59FDW.LookupName(CurrentWorkSheetName, Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    CallplanWorksheetMgt59FDW.CheckName(CurrentWorkSheetName);
                    CurrentWorkSheetNameOnAfterValidate();
                end;
            }

            repeater(GroupName)
            {
                Caption = 'GroupName';
                field("Worksheet Name"; Rec."Worksheet Name")
                {
                    ToolTip = 'Specifies the Worksheet Name.';
                    ApplicationArea = CallPlanAppArea59FDW;
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                    ApplicationArea = CallPlanAppArea59FDW;
                    ShowMandatory = true;
                    QuickEntry = false;
                    Visible = false;
                }
                field("Call Plan Status"; Rec."Call Plan Status")
                {
                    ToolTip = 'Specifies the status of the call plan: new - indicates the customer has not yet been called, retry - indicates that the customer has to be contacted (again) later for some reasons, completed - indicates that the customer has been called and any necessary sales order(s) has/have been created.';
                    ApplicationArea = CallPlanAppArea59FDW;
                    StyleExpr = StyleExprText;
                    trigger OnValidate()
                    begin
                        CallplanWorksheetMgt59FDW.UpdateStatusEntry(Rec, StyleExprText);
                    end;
                }
                field("Call Date"; Rec."Call Date")
                {
                    ToolTip = 'Specifies the date on which the customer should be contacted regarding sales orders with a shipment date as specified on the line.';
                    ApplicationArea = CallPlanAppArea59FDW;
                    ShowMandatory = true;
                }
                field("Inside Salesperson Code"; Rec."Inside Salesperson Code")
                {
                    ToolTip = 'Specifies the user responsible for calling the customer and accepting and entering their sales orders.';
                    ApplicationArea = CallPlanAppArea59FDW;
                    ShowMandatory = true;
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ToolTip = 'Specifies the shipment date of the sales orders regarding which the customer should be contacted.';
                    ApplicationArea = CallPlanAppArea59FDW;
                    ShowMandatory = true;
                }
                field("Shipment Day"; Rec."Shipment Day")
                {
                    ToolTip = 'Specifies the shipment day of the sales orders regarding which the customer should be contacted.';
                    ApplicationArea = CallPlanAppArea59FDW;
                    Editable = false;
                }
                field("Delivery Date"; Rec."Delivery Date")
                {
                    ToolTip = 'Specifies the date on which the shipment(s) will be delivered to the customer. The date is automatically calculated based on the shipping time (set up for the customer in general or specific Shipping Agent Service assigned to the customer / ship-to address).';
                    ApplicationArea = CallPlanAppArea59FDW;
                    QuickEntry = false;
                    ShowMandatory = true;
                }
                field("Delivery Day"; Rec."Delivery Day")
                {
                    ToolTip = 'Specifies the day on which the shipment(s) will be delivered to the customer. The day is automatically calculated based on the shipping time (set up for the customer in general or specific Shipping Agent Service assigned to the customer / ship-to address).';
                    ApplicationArea = CallPlanAppArea59FDW;
                    Editable = false;
                }
                field("Call Plan Orders"; Rec."Call Plan Orders")
                {
                    ToolTip = 'Specifies the amount of Call Plan Worksheet lines for this customer/ship-to address that are planned on the same call date. Due to weekends or other factors, it may be that a single call date is used for multiple orders for the customer (for example both a Saturday and Monday delivery are ordered on Friday). Also the field helps to identify when the same line also exists in another call plan worksheet by mistake.';
                    ApplicationArea = CallPlanAppArea59FDW;
                    Editable = false;
                }
                field("Existing Orders"; Rec."Existing Orders")
                {
                    ToolTip = 'Specifies the number of sales orders that exist with the same shipment date for the same customer/ship-to address.';
                    ApplicationArea = CallPlanAppArea59FDW;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        SalesHeader: Record "Sales Header";
                    begin
                        SalesHeader.SetCurrentKey("Document Type", "Sell-to Customer No.");
                        SalesHeader.SetRange("Sell-to Customer No.", Rec."Customer No.");
                        SalesHeader.SetRange("Ship-to Code", Rec."Ship-To Code");
                        SalesHeader.SetRange("Shipment Date", Rec."Shipment Date");
                        Page.Run(Page::"Sales Order List", SalesHeader);
                    end;
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Specifies which transactions with the customer cannot be processed (Ship, Invoice or All), for example, because the customer is insolvent.';
                    ApplicationArea = CallPlanAppArea59FDW;
                    Editable = false;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the number of the customer to be contacted.';
                    ApplicationArea = CallPlanAppArea59FDW;
                    Editable = false;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the name of the customer to be contacted.';
                    ApplicationArea = CallPlanAppArea59FDW;
                    Editable = false;
                }
                field("Ship-To Code"; Rec."Ship-To Code")
                {
                    ToolTip = 'Specifies the code of the shipment address to which the sales orders are to be shipped.';
                    ApplicationArea = CallPlanAppArea59FDW;
                    Editable = false;
                }
                field("Ship-To Name"; Rec."Ship-To Name")
                {
                    ToolTip = 'Specifies the name of the shipment address to which the sales orders are to be shipped.';
                    ApplicationArea = CallPlanAppArea59FDW;
                    Editable = false;
                }
                field("Call Window Starting Time"; Rec."Call Window Starting Time")
                {
                    ToolTip = 'Specifies the time from which the customer can be contacted on this call day.';
                    ApplicationArea = CallPlanAppArea59FDW;
                    Editable = false;
                }
                field("Call Window Ending Time"; Rec."Call Window Ending Time")
                {
                    ToolTip = 'Specifies the time until which the customer can be contacted on this call day.';
                    ApplicationArea = CallPlanAppArea59FDW;
                    Editable = false;
                }
                field("Order Entry Cut-off Time"; Rec."Order Entry Cut-off Time")
                {
                    ToolTip = 'Specifies the time after which any modification or insertion of new lines (of type ''item'') in sales orders for this customer and shipment date becomes restricted.This is applicable for orders which are included in cut-off time restrictions. A red color indicates the time has passed. A yellow color indicates the time is approaching (within a certain number of minutes as set up on the Call Plan Setup page).';
                    ApplicationArea = CallPlanAppArea59FDW;
                    StyleExpr = OrderEntryCutOffStyle;
                    Editable = false;
                }
                field(Note; Rec.Note)
                {
                    ToolTip = 'Specifies any additional information related to the call plan worksheet.';
                    ApplicationArea = CallPlanAppArea59FDW;
                    QuickEntry = false;
                }
                field("Responsibility Center "; Rec."Responsibility Center ")
                {
                    ToolTip = 'Specifies the value of the Responsibility Center  field.';
                    ApplicationArea = CallPlanAppArea59FDW;
                    Editable = false;
                    Visible = false;
                }
            }
        }
        area(FactBoxes)
        {
            part(ContactDetails; CAPContactDetails59FDW)
            {
                ApplicationArea = CallPlanAppArea59FDW;
                SubPageLink = "Worksheet Name" = field("Worksheet Name"), "Line No." = field("Line No.");
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(MoveLines)
            {
                ApplicationArea = CallPlanAppArea59FDW;
                Caption = 'Move Lines';
                Image = TransferToLines;
                ToolTip = 'Move the selected call plan lines from one call plan worksheet to another.';
                Enabled = EnableMoveLines;
                trigger OnAction()
                var
                    CAPWorkSheetEntry: Record CAPWorkSheetEntry59FDW;
                    MoveWorkSheetLines: Report MoveWorkSheetLines59FDW;
                begin
                    TestWorksheetName();
                    CurrPage.SetSelectionFilter(CAPWorkSheetEntry);
                    MoveWorkSheetLines.GetParameters(CAPWorkSheetEntry);
                    MoveWorkSheetLines.RunModal();
                    Clear(MoveWorkSheetLines);
                end;
            }
            action(Delete59FDW)
            {
                Caption = 'Delete';
                ApplicationArea = CallPlanAppArea59FDW;
                ToolTip = 'Delete the selected row.';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Enabled = EnableDelete;
                trigger OnAction()
                var
                    CAPWorkSheetEntry: Record CAPWorkSheetEntry59FDW;
                    DeleteConfirmTextQst: Label 'Go ahead and delete?';
                begin
                    TestWorksheetName();
                    if not Confirm(StrSubstNo(DeleteConfirmTextQst), false) then
                        exit;
                    CurrPage.SetSelectionFilter(CAPWorkSheetEntry);
                    CAPWorkSheetEntry.DeleteAll();
                end;
            }
            action(CreateCallPlanLines)
            {
                ApplicationArea = CallPlanAppArea59FDW;
                Caption = 'Generate Call Plan Lines';
                ToolTip = 'Generate call plan lines for this worksheet based on a specific call date.';
                Promoted = true;
                ShortcutKey = 'Alt+L';
                PromotedCategory = Process;
                PromotedOnly = true;
                Image = GetLines;
                trigger OnAction()
                var
                    GenerateCallPlan: Report GenerateCallPlanLines59FDW;
                begin
                    TestWorksheetName();
                    GenerateCallPlan.GetParameters(Rec."Worksheet Name");
                    GenerateCallPlan.RunModal();
                    Clear(GenerateCallPlan);
                end;
            }
            action(NewSalesOrder)
            {
                ApplicationArea = CallPlanAppArea59FDW;
                Caption = 'New Sales Order';
                Image = CreateDocument;
                ToolTip = 'Create a new sales order for the customer using the call plan line information (Ship-to Code, Inside Salesperson Code, Delivery Date, Shipment Date).';
                Promoted = true;
                ShortcutKey = 'Alt+S';
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    CAPWorkSheetEntry59FDW: Record CAPWorkSheetEntry59FDW;
                    CreateSalesOrder59FDW: Codeunit CreateSalesOrder59FDW;
                    SalesOrderLineErr: Label 'Please select a single line to proceed.';
                begin
                    TestWorksheetName();
                    CurrPage.SetSelectionFilter(CAPWorkSheetEntry59FDW);
                    if CAPWorkSheetEntry59FDW.Count > 1 then
                        Error(SalesOrderLineErr);
                    CreateSalesOrder59FDW.CreateNewSalesOrder(Rec);
                end;
            }

            action(SendEmail)
            {
                ApplicationArea = CallPlanAppArea59FDW;
                Caption = 'Send Email';
                Image = Email;
                ToolTip = 'Opens a blank Email from the call plan worksheet entry to send mail to the customer.';
                trigger OnAction()
                var
                    TempEmailItem: Record "Email Item" temporary;
                    EmailScenario: Enum "Email Scenario";
                begin
                    Rec.TestField("Customer No.");
                    TempEmailItem.AddSourceDocument(Database::Customer, Rec."Customer No.");
                    TempEmailItem."Send to" := Rec."E-mail";
                    TempEmailItem.Send(false, EmailScenario::Default);
                end;
            }
        }

        area(Navigation)
        {
            action(ViewSalesOrders)
            {
                ApplicationArea = CallPlanAppArea59FDW;
                Image = ViewOrder;
                ToolTip = 'View Sales Orders';
                Caption = 'View existing orders for the selected customer/ship-to address with the same shipment date.';
                ShortcutKey = 'Ctrl+Alt+S';
                RunObject = page "Sales Orders";
                RunPageView = sorting("Document Type", "Sell-to Customer No.", "Shipment No.", "Document No.");
                RunPageLink = "Sell-to Customer No." = field("Customer No.");
            }
        }
    }
    trigger OnOpenPage()
    begin
        if OpenedFromName then
            CurrentWorkSheetName := NewWorkSheetName;
        CallplanWorksheetMgt59FDW.FilterWorkSheetName(CurrentWorkSheetName, Rec);
    end;

    trigger OnAfterGetCurrRecord()
    var
        CAPWorkSheetEntry: Record CAPWorkSheetEntry59FDW;
    begin
        CallplanWorksheetMgt59FDW.UpdateStatusEntry(Rec, StyleExprText);
        CurrPage.SetSelectionFilter(CAPWorkSheetEntry);
        CallplanWorksheetMgt59FDW.UpdateOrderEntryCutOffTime(Rec, OrderEntryCutOffStyle);
        EnableMoveLines := Rec."Line No." <> 0;
        EnableDelete := Rec."Line No." <> 0;
    end;

    trigger OnAfterGetRecord()
    begin
        CallplanWorksheetMgt59FDW.UpdateStatusEntry(Rec, StyleExprText);
        CallplanWorksheetMgt59FDW.UpdateOrderEntryCutOffTime(Rec, OrderEntryCutOffStyle);
    end;

    var
        CallplanWorksheetMgt59FDW: Codeunit CallplanWorksheetMgt59FDW;
        CurrentWorkSheetName: Code[10];
        OpenedFromName: Boolean;
        NewWorkSheetName: Code[10];
        [InDataSet]
        StyleExprText: Text;
        [InDataSet]
        OrderEntryCutOffStyle: Text;
        [InDataSet]
        EnableMoveLines: Boolean;
        [InDataSet]
        EnableDelete: Boolean;

    local procedure CurrentWorkSheetNameOnAfterValidate()
    begin
        CurrPage.SaveRecord();
        CallplanWorksheetMgt59FDW.FilterName(CurrentWorkSheetName, Rec);
        CurrPage.Update(false);
    end;

    internal procedure GetCurrentSheetName(CurrentWorkSheetName: Code[10]; OpenedFromName: Boolean)
    begin
        NewWorkSheetName := CurrentWorkSheetName;
        OpenedFromName := OpenedFromName;
        CurrPage.Update(false);
    end;

    local procedure TestWorksheetName()
    begin
        Rec.TestField(Rec."Worksheet Name");
    end;
}