codeunit 70241756 CallplanWorksheetMgt59FDW
{
    Access = Internal;
    internal procedure LookupName(var CurrentWorkSheetName: Code[10]; var CAPWorkSheetEntry: Record CAPWorkSheetEntry59FDW)
    var
        CAPWorkSheetName: Record CAPWorkSheetName59FDW;
    begin
        //At the time of selecting different worksheet names, to make sure the worksheet lines are inserted.
        Commit();
        if Page.RunModal(0, CAPWorkSheetName) = Action::LookupOK then begin
            CurrentWorkSheetName := CAPWorkSheetName.Name;
            FilterName(CurrentWorkSheetName, CAPWorkSheetEntry);
        end;
    end;

    internal procedure CheckName(CurrentWorkSheetName: Code[10])
    var
        CAPWorkSheetName: Record CAPWorkSheetName59FDW;
    begin
        CAPWorkSheetName.Get(CurrentWorkSheetName);
    end;

    internal procedure FilterName(CurrentWorkSheetName: Code[10]; var CAPWorkSheetEntry: Record CAPWorkSheetEntry59FDW)
    begin
        CAPWorkSheetEntry.FilterGroup := 2;
        CAPWorkSheetEntry.SetRange(CAPWorkSheetEntry."Worksheet Name", CurrentWorkSheetName);
        CAPWorkSheetEntry.FilterGroup := 0;
        if CAPWorkSheetEntry.FindFirst() then;
    end;

    internal procedure WorkSheetSelection(var CAPWorkSheetName: Record CAPWorkSheetName59FDW)
    var
        CAPWorkSheetEntry: Record CAPWorkSheetEntry59FDW;
        CAPWorkSheetEntryPage: Page CAPWorkSheetEntry59FDW;
    begin
        CAPWorkSheetName.TestField(Name);
        CAPWorkSheetEntry.FilterGroup := 2;
        CAPWorkSheetEntry.SetRange("Worksheet Name", CAPWorkSheetName.Name);
        CAPWorkSheetEntry.FilterGroup := 0;
        CAPWorkSheetEntryPage.SetTableView(CAPWorkSheetEntry);
        CAPWorkSheetEntryPage.GetCurrentSheetName(CAPWorkSheetName.Name, true);
        CAPWorkSheetEntryPage.Run();
    end;

    internal procedure FilterWorkSheetName(var CurrentWorkSheetName: Code[10]; var CAPWorkSheetEntry: Record CAPWorkSheetEntry59FDW)
    var
        CAPWorkSheetName: Record CAPWorkSheetName59FDW;
    begin
        if not CAPWorkSheetName.Get(CurrentWorkSheetName) then
            CurrentWorkSheetName := '';
        CAPWorkSheetEntry.FilterGroup := 2;
        CAPWorkSheetEntry.SetRange(CAPWorkSheetEntry."Worksheet Name", CurrentWorkSheetName);
        CAPWorkSheetEntry.FilterGroup := 0;
    end;

    internal procedure UpdateStatusEntry(CAPWorkSheetEntry: Record CAPWorkSheetEntry59FDW; var StyleExprText: Text)
    begin
        case CAPWorkSheetEntry."Call Plan Status" of
            CAPWorkSheetEntry."Call Plan Status"::New:
                StyleExprText := 'Strong';
            CAPWorkSheetEntry."Call Plan Status"::Completed:
                StyleExprText := 'Favorable';
            CAPWorkSheetEntry."Call Plan Status"::Retry:
                StyleExprText := 'Ambiguous';
        end;
    end;

    internal procedure UpdateOrderEntryCutOffTime(CAPWorkSheetEntry: Record CAPWorkSheetEntry59FDW; var OrderEntryCutOffStyle: Text)
    begin
        OrderEntryCutOffStyle := 'Standard';
        ResponsibilityCenterCAPS59FDW.SetRange("Responsibility Center Code", CAPWorkSheetEntry."Responsibility Center ");
        if (CAPWorkSheetEntry."Responsibility Center " <> '') and not (ResponsibilityCenterCAPS59FDW.IsEmpty) then begin
            if (CAPWorkSheetEntry."Order Entry Cut-off Time" = 0T) or (Time = 0T) then
                exit;
            UpdateOrderEntryCutoffTimeFromResponsibilityCenter(CAPWorkSheetEntry, OrderEntryCutOffStyle);
        end else begin
            if (CAPWorkSheetEntry."Order Entry Cut-off Time" = 0T) or (Time = 0T) then
                exit;
            UpdateOrderEntryCutoffTimeFromCallPlanSetup(CAPWorkSheetEntry, OrderEntryCutOffStyle);
        end;
    end;

    local procedure UpdateOrderEntryCutoffTimeFromCallPlanSetup(CAPWorkSheetEntry: Record CAPWorkSheetEntry59FDW; var OrderEntryCutOffStyle: Text)
    var
        WarningMinutes: Duration;
    begin
        GetCallPlanSetup(CallPlanSetup59FDW);
        if not CallPlanSetup59FDW."Enable Cut-off Restrictions" then
            exit;
        WarningMinutes := 1000 * CallPlanSetup59FDW."Cut-off Warning Minutes" * 60;
        case true of
            (CallPlanSetup59FDW."Cut-off Warning Minutes" <> 0) and (Time >= (CAPWorkSheetEntry."Order Entry Cut-off Time" - WarningMinutes)) and (Time < CAPWorkSheetEntry."Order Entry Cut-off Time"):
                OrderEntryCutOffStyle := 'Ambiguous';
            (Time > CAPWorkSheetEntry."Order Entry Cut-off Time"):
                OrderEntryCutOffStyle := 'Unfavorable';
        end;
    end;

    local procedure UpdateOrderEntryCutoffTimeFromResponsibilityCenter(CAPWorkSheetEntry: Record CAPWorkSheetEntry59FDW; var OrderEntryCutOffStyle: Text)
    var
        WarningMinutes: Duration;
    begin
        ResponsibilityCenterCAPS59FDW.Get(CAPWorkSheetEntry."Responsibility Center ");
        if not ResponsibilityCenterCAPS59FDW."Enable Cut-off Restrictions" then
            exit;
        WarningMinutes := 1000 * ResponsibilityCenterCAPS59FDW."Cut-off Warning Minutes" * 60;
        case true of
            (ResponsibilityCenterCAPS59FDW."Cut-off Warning Minutes" <> 0) and (Time >= (CAPWorkSheetEntry."Order Entry Cut-off Time" - WarningMinutes)) and (Time < CAPWorkSheetEntry."Order Entry Cut-off Time"):
                OrderEntryCutOffStyle := 'Ambiguous';
            (Time > CAPWorkSheetEntry."Order Entry Cut-off Time"):
                OrderEntryCutOffStyle := 'Unfavorable';
        end;
    end;

    local procedure GetCallPlanSetup(var CallPlanSetup: Record CallPlanSetup59FDW)
    begin
        if CallPlanSetupRead then
            exit;
        CallPlanSetup.Get();
        CallPlanSetupRead := true;
    end;

    var
        CallPlanSetup59FDW: Record CallPlanSetup59FDW;
        ResponsibilityCenterCAPS59FDW: Record ResponsibilityCenterCAPS59FDW;
        CallPlanSetupRead: Boolean;
}