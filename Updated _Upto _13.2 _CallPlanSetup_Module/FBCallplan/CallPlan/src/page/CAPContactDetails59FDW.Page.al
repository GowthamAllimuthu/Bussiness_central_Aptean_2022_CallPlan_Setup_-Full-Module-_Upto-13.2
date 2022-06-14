page 70241759 CAPContactDetails59FDW
{
    Caption = 'Contact Details';
    SourceTable = CAPWorkSheetEntry59FDW;
    PageType = CardPart;
    Editable = false;
    Extensible = false;
    UsageCategory = None;
    layout
    {
        area(Content)
        {

            field("Contact Name"; Rec."Contact Name")
            {
                ApplicationArea = CallPlanAppArea59FDW;
                ToolTip = 'Specifies the name of the contact to be used when contacting the customer in the context of the call plan.This field is automatically filled from the call plan set up.';
            }
            field("Phone No."; Rec."Phone No.")
            {
                ApplicationArea = CallPlanAppArea59FDW;
                ToolTip = 'Specifies the phone number of the contact to be used when contacting the customer in the context of the call plan.This field is automatically filled from the call plan set up.';
            }
            field("E-mail"; Rec."E-mail")
            {
                ApplicationArea = CallPlanAppArea59FDW;
                ToolTip = 'Specifies the E-mail of the contact to be used when contacting the customer in the context of the call plan.This field is automatically filled from the call plan set up.';
                trigger OnDrillDown()
                var
                    TempEmailItem: Record "Email Item" temporary;
                    EmailScenario: Enum "Email Scenario";
                begin
                    Rec.TestField("Customer No.");
                    TempEmailItem.AddSourceDocument(Database::Customer, Rec.SystemId);
                    TempEmailItem."Send to" := Rec."E-mail";
                    TempEmailItem.Send(false, EmailScenario::Default);
                end;
            }

        }
    }

}