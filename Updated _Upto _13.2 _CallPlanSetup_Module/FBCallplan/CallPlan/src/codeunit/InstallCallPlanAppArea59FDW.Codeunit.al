codeunit 70241758 InstallCallPlanAppArea59FDW
{
    Subtype = Install;
    Access = Internal;
    trigger OnInstallAppPerCompany()
    var
        EnableCallPlanAppArea59FDW: Codeunit EnableCallPlanAppArea59FDW;
    begin
        if (EnableCallPlanAppArea59FDW.IsCallplanApplicationAreaEnabled()) then
            exit;
        EnableCallPlanAppArea59FDW.EnableCallplanExtension();
    end;

}