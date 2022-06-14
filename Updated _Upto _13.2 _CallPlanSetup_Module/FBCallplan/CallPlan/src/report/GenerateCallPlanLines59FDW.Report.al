report 70241756 GenerateCallPlanLines59FDW
{
    Caption = 'Generate Call Plan';
    ProcessingOnly = true;
    Extensible = false;
    UsageCategory = None;
    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = InsideSalespersonCode59FDW, "No.", "Responsibility Center", "Ship-to Code";
            trigger OnPreDataItem()
            begin
                CurrReport.Break();
            end;
        }
        dataitem(CustomerDataSet; Customer)
        {
            DataItemTableView = sorting("No.");
            dataitem(CallplanCustomer; ShipToAddressCapSetup59FDW)
            {
                DataItemTableView = sorting("customer no.") where("Include in Call Plan" = filter(true), "Ship-to Code" = filter(''));
                DataItemLink = "customer no." = field("no.");

                dataitem(CAPStructureCustomer; CAPStructure59FDW)
                {
                    DataItemTableView = sorting("Customer No.", "Ship-To Code", "Starting Date", "Shipment Day") where("Ship-To Code" = filter(''));
                    DataItemLink = "customer no." = field("customer no."), "Ship-to code" = field("Ship-to code");

                    trigger OnPreDataItem()
                    begin
                        if Customer.GetFilter("Ship-to Code") <> '' then
                            CurrReport.Break();
                        Ascending(false);
                        SetRange("Call Day", DayoftheWeekReport);
                        SetFilter("Starting Date", '<=%1', CallDateReport);
                        TempWeekDayAsInteger.DeleteAll();
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        if (CAPStructureCustomer."Ending Date" <> 0D) and (CAPStructureCustomer."Ending Date" < CallDateReport) then
                            CurrReport.Skip();
                        if not TempWeekDayAsInteger.Get(CAPStructureCustomer."Shipment Day".AsInteger()) then begin
                            TempWeekDayAsInteger.Init();
                            TempWeekDayAsInteger.Number := CAPStructureCustomer."Shipment Day".AsInteger();
                            TempWeekDayAsInteger.Insert();
                            InsertCallPlanLines(CAPStructureCustomer);
                        end;
                    end;
                }
                dataitem(CallplanAddress; ShipToAddressCapSetup59FDW)
                {
                    DataItemTableView = sorting("customer no.") where("Include in Call Plan" = filter(true), "Ship-to Code" = filter(<> ''));
                    DataItemLink = "customer no." = field("customer no.");
                    dataitem(CAPStructureShipToAddress; CAPStructure59FDW)
                    {
                        DataItemTableView = sorting("Customer No.", "Ship-To Code", "Starting Date", "Shipment Day") where("Ship-To Code" = filter(<> ''));
                        DataItemLink = "customer no." = field("customer no."), "Ship-to code" = field("Ship-to code");

                        trigger OnPreDataItem()
                        begin
                            Ascending(false);
                            SetRange("Call Day", DayoftheWeekReport);
                            SetFilter("Starting Date", '<=%1', CallDateReport);
                            TempWeekDayAsInteger.DeleteAll();
                        end;

                        trigger OnAfterGetRecord()
                        begin
                            if (CAPStructureShipToAddress."Ending Date" <> 0D) and (CAPStructureShipToAddress."Ending Date" < CallDateReport) then
                                CurrReport.Skip();
                            if not TempWeekDayAsInteger.Get(CAPStructureShipToAddress."Shipment Day".AsInteger()) then begin
                                TempWeekDayAsInteger.Init();
                                TempWeekDayAsInteger.Number := CAPStructureShipToAddress."Shipment Day".AsInteger();
                                TempWeekDayAsInteger.Insert();
                                InsertCallPlanLines(CAPStructureShipToAddress);
                            end;
                        end;
                    }

                    trigger OnPreDataItem()
                    begin
                        if Customer.GetFilter("Ship-to Code") <> '' then
                            SetFilter("Ship-to Code", Customer.GetFilter("Ship-to Code"));
                    end;
                }
            }

            trigger OnPreDataItem()
            begin
                CheckRequestPageDetails();
                if Customer.GetFilter("No.") <> '' then
                    SetFilter("No.", Customer.GetFilter("No."));

                if Customer.GetFilter("Responsibility Center") <> '' then
                    SetFilter("Responsibility Center", Customer.GetFilter("Responsibility Center"));

                if Customer.GetFilter(InsideSalespersonCode59FDW) <> '' then
                    SetFilter(InsideSalespersonCode59FDW, Customer.GetFilter(InsideSalespersonCode59FDW));
            end;

            trigger OnPostDataItem()
            begin
                GenerateCallPlanLines();
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(WorksheetNamepage; WorksheetName)
                    {
                        Caption = 'Worksheet Name';
                        applicationarea = CallPlanAppArea59FDW;
                        Editable = false;
                        ToolTip = 'Specifies the name of the worksheet for which the call plan lines are to be generated.';
                    }
                    field(CallDatePage; CallDateReport)
                    {
                        Caption = 'Call Date';
                        applicationarea = CallPlanAppArea59FDW;
                        ToolTip = 'Specifies the call date for which to generate call plan lines';
                        ShowMandatory = true;
                        NotBlank = true;
                        trigger OnValidate()
                        begin
                            DayoftheWeekReport := GetWeekDay(CallDateReport);
                        end;
                    }
                    field(DayoftheWeekPage; DayoftheWeekReport)
                    {
                        Caption = 'Day of the Week';
                        applicationarea = CallPlanAppArea59FDW;
                        Editable = false;
                        ToolTip = 'Specifies the day of the week corresponding with the selected call date';
                    }
                    field(ClearExistingLinesPage; ClearExistingLinesReport)
                    {
                        Caption = 'Clear Existing Lines';
                        applicationarea = CallPlanAppArea59FDW;
                        ToolTip = 'Specifies whether the existing lines in the call plan worksheet will be deleted before adding the new lines.  When not deleting them and adding to the existing lines, generated lines that would be duplicates will be skipped.';
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            WorksheetName := SetWorkSheetName();
            CallDateReport := WorkDate();
            DayoftheWeekReport := GetWeekDay(CallDateReport);
        end;
    }

    var
        TempCAPWorkSheetEntry59FDW: Record CAPWorkSheetEntry59FDW temporary;
        RecordDate: Record Date;
        TempWeekDayAsInteger: Record Integer temporary;
        WorksheetName: Code[10];
        CallDateReport: Date;
        DayoftheWeekReport: Enum WeekDay59FDW;
        ClearExistingLinesReport: Boolean;
        OrderEntryCutOffTime: Time;
        TempLineNo: Integer;

    local procedure SetWorkSheetName(): Code[10]
    begin
        exit(WorksheetName);
    end;

    internal procedure GetParameters(CurrentWorksheetName: Code[10])
    begin
        WorksheetName := CurrentWorksheetName;
    end;

    local procedure GetLastWorksheetLineNo(): Integer
    var
        CAPWorkSheetEntry59FDW: Record CAPWorkSheetEntry59FDW;
    begin
        CAPWorkSheetEntry59FDW.SetRange("Worksheet Name", WorksheetName);
        if CAPWorkSheetEntry59FDW.FindLast() then
            exit(CAPWorkSheetEntry59FDW."Line No.");
    end;

    local procedure DeleteWorksheetLines()
    var
        CAPWorkSheetEntry59FDW: Record CAPWorkSheetEntry59FDW;
    begin
        CAPWorkSheetEntry59FDW.SetRange("Worksheet Name", WorksheetName);
        if not CAPWorkSheetEntry59FDW.IsEmpty() then
            CAPWorkSheetEntry59FDW.DeleteAll();
    end;

    local procedure CheckRequestPageDetails()
    var
        WorksheetNameErr: Label 'Worksheet name cannot be blank.';
        DayOfTheWeekErr: Label 'Call Day cannot be blank.';
    begin
        if WorksheetName = '' then
            Error(WorksheetNameErr);
        if DayoftheWeekReport = DayoftheWeekReport::" " then
            Error(DayOfTheWeekErr);
    end;

    local procedure InsertTempCallPlanLines(CAPStructure59FDW: Record CAPStructure59FDW)
    begin
        TempLineNo := TempLineNo + 10000;
        TempCAPWorkSheetEntry59FDW.Init();
        TempCAPWorkSheetEntry59FDW."Worksheet Name" := WorksheetName;
        TempCAPWorkSheetEntry59FDW."Line No." := TempLineNo;
        TempCAPWorkSheetEntry59FDW.Validate("Call Date", CallDateReport);
        TempCAPWorkSheetEntry59FDW.Validate("Customer No.", CAPStructure59FDW."Customer No.");
        TempCAPWorkSheetEntry59FDW.Validate("Ship-To Code", CAPStructure59FDW."Ship-To Code");
        TempCAPWorkSheetEntry59FDW.Note := CAPStructure59FDW.Note;
        TempCAPWorkSheetEntry59FDW."Call Window Starting Time" := CAPStructure59FDW."Call Window Starting Time";
        TempCAPWorkSheetEntry59FDW."Call Window Ending Time" := CAPStructure59FDW."Call Window Ending Time";
        TempCAPWorkSheetEntry59FDW."Inside Salesperson Code" := CustomerDataSet.InsideSalespersonCode59FDW;
        TempCAPWorkSheetEntry59FDW.Blocked := CustomerDataSet.Blocked;
        TempCAPWorkSheetEntry59FDW."Shipment Date" := GetShipmentDate(CallDateReport);
        TempCAPWorkSheetEntry59FDW."Shipment Day" := CAPStructure59FDW."Shipment Day";
        TempCAPWorkSheetEntry59FDW."Responsibility Center " := GetResponsibilityCenter(CAPStructure59FDW);
        TempCAPWorkSheetEntry59FDW."Delivery Date" := GetDeliveryDate(CAPStructure59FDW, TempCAPWorkSheetEntry59FDW."Shipment Date");
        TempCAPWorkSheetEntry59FDW."Delivery Day" := GetWeekDay(TempCAPWorkSheetEntry59FDW."Delivery Date");
        TempCAPWorkSheetEntry59FDW.Insert();
        UpdateLastCreationDate(TempCAPWorkSheetEntry59FDW, CAPStructure59FDW);
    end;

    local procedure GetResponsibilityCenter(var CAPStructure59FDW: Record CAPStructure59FDW) ResponsibilityCenter: Code[10];
    var
        Customer: Record Customer;
    begin
        Customer.Get(CAPStructure59FDW."Customer No.");
        ResponsibilityCenter := Customer."Responsibility Center";
    end;

    local procedure GenerateCallPlanLines()
    var
        CAPWorkSheetEntry59FDW: Record CAPWorkSheetEntry59FDW;
        CallplanLineNo: Integer;
    begin
        if TempCAPWorkSheetEntry59FDW.FindSet() then begin
            if ClearExistingLinesReport then
                DeleteWorksheetLines()
            else
                CallplanLineNo := GetLastWorksheetLineNo();
            repeat
                CallplanLineNo := CallplanLineNo + 10000;
                CAPWorkSheetEntry59FDW.TransferFields(TempCAPWorkSheetEntry59FDW, true);
                CAPWorkSheetEntry59FDW."Line No." := CallplanLineNo;
                CAPWorkSheetEntry59FDW."Order Entry Cut-off Time" := GetOrderEntryCutOffTime(TempCAPWorkSheetEntry59FDW);
                CAPWorkSheetEntry59FDW.Insert();
            until TempCAPWorkSheetEntry59FDW.Next() = 0;
        end;
    end;

    local procedure GetOrderEntryCutOffTime(var TempCAPWorkSheetEntry59FDW: Record CAPWorkSheetEntry59FDW) OrderEntryCutOffTime: Time
    begin
        if TempCAPWorkSheetEntry59FDW."Responsibility Center " <> '' then
            OrderEntryCutOffTime := GetOrderEntryCutOffTimeFromResponsibilityCenter(TempCAPWorkSheetEntry59FDW."Responsibility Center ")
        else
            OrderEntryCutOffTime := GetOrderEntryCutOffTimeFromCallPlanSetup();
    end;

    local procedure GetShipmentDate(CurrentCallDate: Date) ShipmentDate: Date;
    var
        Differencedays: Integer;
    begin
        Differencedays := CAPStructureCustomer."Shipment Day".AsInteger() - CAPStructureCustomer."Call Day".AsInteger();
        ShipmentDate := CurrentCallDate + Differencedays;
    end;

    local procedure GetDeliveryDate(CAPStructure59FDW: Record CAPStructure59FDW; ShipmentDate: Date): Date
    var
        Customer: Record Customer;
        ShipToAddress: Record "Ship-to Address";
        ShippingAgentServices: Record "Shipping Agent Services";
    begin
        if ShipmentDate = 0D then
            exit;

        if ShipToAddress.Get(CAPStructure59FDW."Customer No.", CAPStructure59FDW."Ship-To Code") then
            if ShippingAgentServices.Get(ShipToAddress."Shipping Agent Code", ShipToAddress."Shipping Agent Service Code") then
                exit(CalcDate(ShippingAgentServices."Shipping Time", ShipmentDate));

        if Customer.Get(CAPStructure59FDW."Customer No.") then
            if ShippingAgentServices.Get(Customer."Shipping Agent Code", Customer."Shipping Agent Service Code") then
                exit(CalcDate(ShippingAgentServices."Shipping Time", ShipmentDate))
            else
                exit(CalcDate(Customer."Shipping Time", ShipmentDate));
        exit(ShipmentDate);
    end;

    local procedure GetWeekDay(CurrentDate: Date) WeekDay: Enum WeekDay59FDW
    begin
        if RecordDate.Get(RecordDate."Period Type"::Date, CurrentDate) then
            WeekDay := Enum::WeekDay59FDW.FromInteger(RecordDate."Period No.");
    end;

    local procedure InsertCallPlanLines(var CAPStructure59FDW: Record CAPStructure59FDW)
    var
        NewCallDate: Date;
    begin
        if CAPStructure59FDW."Last Creation Date" = 0D then
            InsertTempCallPlanLines(CAPStructure59FDW);
        if CAPStructure59FDW."Last Creation Date" <> 0D then begin
            NewCallDate := GenerateNewCallDate(CAPStructure59FDW);
            if (CAPStructure59FDW."Last Creation Date" < CAPStructure59FDW."Ending Date") or (CAPStructure59FDW."Ending Date" = 0D) then
                if NewCallDate = CallDateReport then
                    InsertTempCallPlanLines(CAPStructure59FDW);
        end;
    end;

    local procedure GenerateNewCallDate(var CAPStructure59FDW: Record CAPStructure59FDW) NewCallDate: Date
    begin
        if CAPStructure59FDW.Frequency = CAPStructure59FDW.Frequency::Weekly then
            NewCallDate := CalcDate('<1W>', CAPStructure59FDW."Last Creation Date");
        if CAPStructure59FDW.Frequency = CAPStructure59FDW.Frequency::"Bi-Weekly" then
            NewCallDate := CalcDate('<2W>', CAPStructure59FDW."Last Creation Date");
    end;

    local procedure UpdateLastCreationDate(var TempCAPWorkSheetEntry59FDW: Record CAPWorkSheetEntry59FDW; var CAPStructure59FDW: Record CAPStructure59FDW)
    begin
        CAPStructure59FDW."Last Creation Date" := TempCAPWorkSheetEntry59FDW."Call Date";
        CAPStructure59FDW.Modify(true);
    end;

    local procedure GetOrderEntryCutOffTimeFromCallPlanSetup() OrderEntryCutOffTime: Time
    var
        CallPlanSetup59FDW: Record CallPlanSetup59FDW;
    begin
        CallPlanSetup59FDW.Get();
        case DayoftheWeekReport of
            DayoftheWeekReport::Monday:
                OrderEntryCutOffTime := CallPlanSetup59FDW."Monday Cut-off Time";
            DayoftheWeekReport::Tuesday:
                OrderEntryCutOffTime := CallPlanSetup59FDW."Tuesday Cut-off Time";
            DayoftheWeekReport::Wednesday:
                OrderEntryCutOffTime := CallPlanSetup59FDW."Wednesday Cut-off Time";
            DayoftheWeekReport::Thursday:
                OrderEntryCutOffTime := CallPlanSetup59FDW."Thursday Cut-off Time";
            DayoftheWeekReport::Friday:
                OrderEntryCutOffTime := CallPlanSetup59FDW."Friday Cut-off Time";
            DayoftheWeekReport::Saturday:
                OrderEntryCutOffTime := CallPlanSetup59FDW."Saturday Cut-off Time";
            DayoftheWeekReport::Sunday:
                OrderEntryCutOffTime := CallPlanSetup59FDW."Sunday Cut-off Time";
        end
    end;

    local procedure GetOrderEntryCutOffTimeFromResponsibilityCenter(ResponsibilityCenterCode: Code[10]) OrderEntryCutOffTime: Time
    var
        ResponsibilityCenterCAPS59FDW: Record ResponsibilityCenterCAPS59FDW;
    begin
        ResponsibilityCenterCAPS59FDW.Get(ResponsibilityCenterCode);
        case DayoftheWeekReport of
            DayoftheWeekReport::Monday:
                OrderEntryCutOffTime := ResponsibilityCenterCAPS59FDW."Monday Cut-off Time";
            DayoftheWeekReport::Tuesday:
                OrderEntryCutOffTime := ResponsibilityCenterCAPS59FDW."Tuesday Cut-off Time";
            DayoftheWeekReport::Wednesday:
                OrderEntryCutOffTime := ResponsibilityCenterCAPS59FDW."Wednesday Cut-off Time";
            DayoftheWeekReport::Thursday:
                OrderEntryCutOffTime := ResponsibilityCenterCAPS59FDW."Thursday Cut-off Time";
            DayoftheWeekReport::Friday:
                OrderEntryCutOffTime := ResponsibilityCenterCAPS59FDW."Friday Cut-off Time";
            DayoftheWeekReport::Saturday:
                OrderEntryCutOffTime := ResponsibilityCenterCAPS59FDW."Saturday Cut-off Time";
            DayoftheWeekReport::Sunday:
                OrderEntryCutOffTime := ResponsibilityCenterCAPS59FDW."Sunday Cut-off Time";
        end
    end;
}