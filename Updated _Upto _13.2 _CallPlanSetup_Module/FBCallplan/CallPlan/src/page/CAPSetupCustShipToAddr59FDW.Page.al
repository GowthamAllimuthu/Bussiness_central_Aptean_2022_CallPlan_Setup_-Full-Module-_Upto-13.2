page 70241761 CAPSetupCustShipToAddr59FDW
{
    PageType = Document;
    SourceTable = ShipToAddressCapSetup59FDW;
    Caption = 'Call Plan Setup';
    UsageCategory = None;
    Extensible = false;
    InsertAllowed = false;
    DataCaptionExpression = DataCaption();
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Include in Call Plan"; Rec."Include in Call Plan")
                {
                    ApplicationArea = CallPlanAppArea59FDW;
                    ToolTip = 'Specifies if this customer/ship-to address is to be included in the call plan.';
                    Caption = 'Include in Call Plan';
                    Importance = Promoted;
                }
                field("Inc.forCutoffTimeRestriction"; Rec."Inc.forCutoffTimeRestriction")
                {
                    ApplicationArea = CallPlanAppArea59FDW;
                    ToolTip = 'Specifies if the customer is included in the cut-off time restrictions. If so, sales lines for this customer will no longer be editable after a certain ''cut-off time'' (set up at the Call Plan Setup page), related to the order''s shipment date.';
                    Caption = 'Include for Cut-off Time Restriction';
                    Visible = CutOffVisible;
                }
                group(Contact)
                {
                    ShowCaption = false;
                    field("Call Plan Contact Code"; Rec."Call Plan Contact Code")
                    {
                        ApplicationArea = CallPlanAppArea59FDW;
                        ToolTip = 'Specifies the contact no. to be used when contacting the customer in the context of the call plan.';
                        Caption = 'Contact No.';
                        trigger OnValidate()
                        begin
                            ContactOnAfterValidate();
                        end;
                    }
                    field("Call Plan Contact Name"; Rec."Call Plan Contact Name")
                    {
                        ApplicationArea = CallPlanAppArea59FDW;
                        ToolTip = 'Specifies the name of the contact to be used when contacting the customer in the context of the call plan.';
                        Editable = ContactEditable;
                        Caption = 'Contact Name';
                        trigger OnValidate()
                        begin
                            ContactOnAfterValidate();
                        end;
                    }
                    field("Call Plan Phone No."; Rec."Call Plan Phone No.")
                    {
                        ApplicationArea = CallPlanAppArea59FDW;
                        ToolTip = 'Specifies the phone number of the contact to be used when contacting the customer in the context of the call plan.';
                        Editable = true;
                        Caption = 'Contact Phone No.';
                    }
                    field("Call Plan E-Mail"; Rec."Call Plan E-Mail")
                    {
                        ApplicationArea = CallPlanAppArea59FDW;
                        ToolTip = 'Specifies the E-mail of the contact to be used when contacting the customer in the context of the call plan.';
                        Editable = true;
                        Caption = 'Contact E-Mail';
                    }
                }
            }
            part(CallPlanStructure; CAPSShipToAddressSubform59FDW)
            {
                ApplicationArea = CallPlanAppArea59FDW;
                Caption = 'Call Plan Structure';
                Editable = DynamicEditable;
                Enabled = Rec."Customer No." <> '';
                SubPageLink = "Customer No." = field("Customer No."), "Ship-To Code" = field("Ship-to Code");
                UpdatePropagation = Both;
            }
        }
    }
    var
        [InDataSet]
        DynamicEditable: Boolean;
        [InDataSet]
        ContactEditable: Boolean;
        [InDataSet]
        CutOffVisible: Boolean;

    trigger OnAfterGetCurrRecord()
    begin
        DynamicEditable := CurrPage.Editable;
        ActivateFields();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        CAPStructure: Record CAPStructure59FDW;
        CPSLineExistsConfirmTextQst: Label 'The customer is set up to be included in the call plan, but no call days are set up in the Call Plan Structure table. Are you sure you want to continue without creating lines?';
    begin
        if Rec."Include in Call Plan" then begin
            CAPStructure.SetRange("Customer No.", Rec."Customer No.");
            CAPStructure.SetRange("Ship-To Code", Rec."Ship-to Code");
            if CAPStructure.IsEmpty() then
                if not Confirm(CPSLineExistsConfirmTextQst, false) then
                    exit(false);
        end;
        exit(true);
    end;

    trigger OnInit()
    begin
        ContactEditable := true;
    end;

    local procedure ContactOnAfterValidate()
    begin
        ActivateFields();
    end;

    local procedure ActivateFields()
    begin
        ContactEditable := Rec."Call Plan Contact Code" = '';
    end;

    local procedure DataCaption(): Text[250]
    begin
        if Rec."Ship-to Code" <> '' then
            exit(Rec."Customer No." + ' - ' + Rec."Customer Name" + ' - ' + Rec."Ship-to Code")
        else
            exit(Rec."Customer No." + ' - ' + Rec."Customer Name");
    end;

    internal procedure SetCutOffVisible(NewVisibility: Boolean)
    begin
        CutOffVisible := NewVisibility;
    end;
}