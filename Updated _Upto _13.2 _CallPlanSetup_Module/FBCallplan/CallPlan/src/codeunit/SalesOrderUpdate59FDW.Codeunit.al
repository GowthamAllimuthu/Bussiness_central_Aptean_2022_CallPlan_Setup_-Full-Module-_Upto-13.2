codeunit 70241764 SalesOrderUpdate59FDW
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterCheckSellToCust', '', true, true)]
    local procedure SalesHeaderOnAfterCheckSellToCust(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header"; Customer: Record "Customer"; CurrentFieldNo: Integer)
    var
        CreateSalesOrder59FDW: Codeunit CreateSalesOrder59FDW;
    begin
        CreateSalesOrder59FDW.UpdateInsideSalesPersoncode(SalesHeader, Customer);
        CreateSalesOrder59FDW.UpdateIncludeforCutoffTime(SalesHeader);
    end;
}