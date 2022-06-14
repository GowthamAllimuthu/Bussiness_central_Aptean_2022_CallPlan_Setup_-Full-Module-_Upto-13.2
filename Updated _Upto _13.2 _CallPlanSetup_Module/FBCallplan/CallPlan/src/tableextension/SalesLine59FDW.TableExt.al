tableextension 70241765 SalesLine59FDW extends "Sales Line"
{
    fields
    {
        modify(Quantity)
        {
            trigger OnAfterValidate()
            var
                SalesHeader: Record "Sales Header";
            begin
                IsSalesLineValidForModifyingQuantity(SalesHeader);
            end;
        }
    }

    trigger OnBeforeInsert()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        IsSalesLineValidForInsertion(SalesHeader, SalesLine);
    end;

    trigger OnBeforeDelete()
    var
        SalesHeader: Record "Sales Header";
    begin
        IsSalesLineValidForDeletion(SalesHeader);
    end;

    internal procedure GetCurrentDay(OrderDate: Date) WeekDay59FDW: Enum WeekDay59FDW
    var
        RecordDate: Record Date;
    begin
        if RecordDate.Get(RecordDate."Period Type"::Date, OrderDate) then
            WeekDay59FDW := Enum::WeekDay59FDW.FromInteger(RecordDate."Period No.");
        exit(WeekDay59FDW);
    end;

    internal procedure GetCurrentDayCutOffTimeFromCallPlanSetup(var WeekDay: Enum WeekDay59FDW)
    var
        CallplanSetup: Record CallPlanSetup59FDW;
    begin
        CallPlanSetup59FDW.Get();
        if WeekDay = WeekDay::" " then
            exit;
        CallplanSetup.Get();
        case WeekDay of
            WeekDay::Monday:
                CurrentDayCutOffTime59FDW := CallplanSetup."Monday Cut-off Time";
            WeekDay::Tuesday:
                CurrentDayCutOffTime59FDW := CallplanSetup."Tuesday Cut-off Time";
            WeekDay::Wednesday:
                CurrentDayCutOffTime59FDW := CallplanSetup."Wednesday Cut-off Time";
            WeekDay::Thursday:
                CurrentDayCutOffTime59FDW := CallplanSetup."Thursday Cut-off Time";
            WeekDay::Friday:
                CurrentDayCutOffTime59FDW := CallplanSetup."Friday Cut-off Time";
            WeekDay::Saturday:
                CurrentDayCutOffTime59FDW := CallplanSetup."Saturday Cut-off Time";
            WeekDay::Sunday:
                CurrentDayCutOffTime59FDW := CallplanSetup."Sunday Cut-off Time";
        end;
    end;

    internal procedure IsSalesLineValidForDeletion(var SalesHeader: Record "Sales Header")
    begin
        if (Rec."Document Type" <> Rec."Document Type"::Order) or
        (Rec.Type <> Rec.Type::Item) or ((Quantity = 0) and (xRec.Quantity = 0)) then
            exit;
        SalesHeader.Get(Rec."Document Type", Rec."Document No.");
        if not SalesHeader.IncludeforCutoffTime59FDW then
            exit;
        WeekDay59FDW := GetCurrentDay(SalesHeader."Order Date");
        GetCurrentDayCutOffTimeFromCallPlanSetup(WeekDay59FDW);
        if SalesHeader."Order Date" = Today then
            if (CurrentDayCutOffTime59FDW <> 0T) and (CurrentDayCutOffTime59FDW <= Time) then
                Error(DeleteErr, WeekDay59FDW, CurrentDayCutOffTime59FDW);
    end;

    internal procedure IsSalesLineValidForInsertion(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    begin
        if (Rec."Document Type" <> Rec."Document Type"::Order) or
        (Rec.Type <> Rec.Type::Item) then
            exit;
        SalesHeader.Get(Rec."Document Type", Rec."Document No.");
        if not SalesHeader.IncludeforCutoffTime59FDW then
            exit;
        SalesLine.SetRange("Document Type", "Document Type");
        SalesLine.SetRange("Document No.", "Document No.");
        SalesLine.SetFilter("Line No.", '<>%1', "Line No.");
        SalesLine.SetFilter("Quantity Shipped", '<>%1', 0);
        if not SalesLine.IsEmpty() then
            exit;
        WeekDay59FDW := GetCurrentDay(SalesHeader."Order Date");
        GetCurrentDayCutOffTimeFromCallPlanSetup(WeekDay59FDW);
        if SalesHeader."Order Date" = Today then
            if (CurrentDayCutOffTime59FDW <> 0T) and (CurrentDayCutOffTime59FDW <= Time) then
                Error(InsertModifyErr, WeekDay59FDW, CurrentDayCutOffTime59FDW);
    end;

    internal procedure IsSalesLineValidForModifyingQuantity(var SalesHeader: Record "Sales Header")
    begin
        if (Rec."Document Type" <> Rec."Document Type"::Order) or
        (Rec.Type <> Rec.Type::Item) then
            exit;
        SalesHeader.Get(Rec."Document Type", Rec."Document No.");
        if not SalesHeader.IncludeforCutoffTime59FDW then
            exit;
        WeekDay59FDW := GetCurrentDay(SalesHeader."Order Date");
        GetCurrentDayCutOffTimeFromCallPlanSetup(WeekDay59FDW);
        if SalesHeader."Order Date" = Today then
            if Quantity <> xRec.Quantity then
                if (CurrentDayCutOffTime59FDW <> 0T) and (CurrentDayCutOffTime59FDW <= Time) then
                    Error(InsertModifyErr, WeekDay59FDW, CurrentDayCutOffTime59FDW);
    end;

    var
        CallPlanSetup59FDW: Record CallPlanSetup59FDW;
        CurrentDayCutOffTime59FDW: Time;
        WeekDay59FDW: Enum WeekDay59FDW;
        InsertModifyErr: Label 'It is not possible to edit the sales lines anymore, because based on the call day linked to the shipment day of the order, the cut-off time for this order was set up to be [#1########,#2######], which has passed. ', Comment = '%1=WeekDay, %2=CurrentDayCutOffTime';
        DeleteErr: Label 'It is not possible to delete the sales lines anymore, because based on the call day linked to the shipment day of the order, the cut-off time for this order was set up to be [#1########,#2######], which has passed. ', Comment = '%1=WeekDay, %2=CurrentDayCutOffTime';
}