codeunit 70241759 ApplicationAreaMgmtSubscr59FDW
{
    Access = Internal;

    var
        CallPlanAreaErr: Label 'Call Plan Area should be part of Dynamics 365 Business Central Essentials in order for the Call Plan extension to work.', MaxLength = 150;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Application Area Mgmt.", 'OnGetEssentialExperienceAppAreas', '', false, false)]
    local procedure RegisterCallplanExtensionOnGetEssentialExperienceAppAreas(var TempApplicationAreaSetup: Record "Application Area Setup" temporary)
    begin
        TempApplicationAreaSetup.CallPlanAppArea59FDW := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Application Area Mgmt.", 'OnValidateApplicationAreas', '', false, false)]
    local procedure VerifyApplicationAreasOnValidateApplicationAreas(ExperienceTierSetup: Record "Experience Tier Setup"; TempApplicationAreaSetup: Record "Application Area Setup" temporary)
    begin
        if ExperienceTierSetup.Essential then
            if not TempApplicationAreaSetup.CallPlanAppArea59FDW then
                Error(CallPlanAreaErr);
    end;
}


