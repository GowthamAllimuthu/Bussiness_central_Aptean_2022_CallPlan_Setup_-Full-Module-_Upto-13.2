table 70241761 ShipToAddressCapSetup59FDW
{
    Access = Internal;
    Extensible = false;
    Caption = 'Call Plan Setup - Customer / Ship To Address';
    fields
    {
        field(5; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer;
            Caption = 'Customer No.';
            NotBlank = true;
        }
        field(6; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            DataClassification = CustomerContent;
            TableRelation = "Ship-to Address".Code where("Customer No." = field("Customer No."));
        }
        field(10; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            DataClassification = CustomerContent;
        }
        field(11; "Ship-to Name"; Text[100])
        {
            Caption = 'Ship-to Name';
            DataClassification = CustomerContent;
        }
        field(15; "Include in Call Plan"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Include in Call Plan';
            trigger OnValidate()
            begin
                IncludeInCallPlanShipToCode();
            end;
        }
        field(25; "Call Plan Contact Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Contact Code';
            TableRelation = Contact;
            trigger OnLookup()
            begin
                LookupContactList();
            end;

            trigger OnValidate()
            begin
                UpdateContact();
            end;
        }
        field(26; "Call Plan Contact Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Contact Name';
            trigger OnLookup()
            begin
                LookupContactList();
            end;

            trigger OnValidate()
            begin
                CreateNewContactFromName();
            end;
        }
        field(27; "Call Plan Phone No."; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
            trigger OnValidate()
            begin
                UpdatePhoneNo();
            end;
        }
        field(28; "Call Plan E-Mail"; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
            trigger OnValidate()
            begin
                UpdateEMail();
            end;
        }
        field(30; "Inc.forCutoffTimeRestriction"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Include for Cut-off Time Restriction';
            trigger OnValidate()
            begin
                NotifyCutOffRestriction("Inc.forCutoffTimeRestriction");
            end;
        }
    }
    keys
    {
        key(PK; "Customer No.", "Ship-to Code")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        Customer: Record Customer;
        ShipToAddress: Record "Ship-to Address";
    begin
        if Customer.Get("Customer No.") then
            "Customer Name" := Customer.Name;
        if ShipToAddress.Get("Customer No.", "Ship-to Code") then
            "Ship-to Name" := ShipToAddress.Name;
    end;

    local procedure LookupContactList()
    var
        ContactBusinessRelation: Record "Contact Business Relation";
        Contact: Record Contact;
        TempShipToAddressCapSetup: Record ShipToAddressCapSetup59FDW temporary;
    begin
        Contact.FilterGroup(2);
        if ContactBusinessRelation.FindByRelation(ContactBusinessRelation."Link to Table"::Customer, "Customer No.") then
            Contact.SetRange("Company No.", ContactBusinessRelation."Contact No.")
        else
            Contact.SetRange("Company No.", '');
        if "Call Plan Contact Code" <> '' then
            if Contact.Get("Call Plan Contact Code") then;
        if Page.RunModal(0, Contact) = Action::LookupOK then begin
            TempShipToAddressCapSetup.Copy(Rec);
            Find();
            TransferFields(TempShipToAddressCapSetup, false);
            Validate("Call Plan Contact Code", Contact."No.");
        end;
    end;

    local procedure CheckCustomerContactRelation(Contact: Record Contact)
    var
        ContactBusinessRelation: Record "Contact Business Relation";
        Customer: Record Customer;
        ContactRelationErr: Label 'Contact %1 %2 is not related to customer %3 %4.', Comment = '%1 = Call Plan Contact Code ; %2 = Call Plan Contact Name ; %3 = Customer No ; %4 = Customer Name';
    begin
        Customer.Get("Customer No.");
        ContactBusinessRelation.FindOrRestoreContactBusinessRelation(Contact, Customer, ContactBusinessRelation."Link to Table"::Customer);
        if Contact."Company No." <> ContactBusinessRelation."Contact No." then
            Error(ContactRelationErr, Contact."No.", Contact.Name, Customer."No.", Customer.Name);
    end;

    internal procedure NotifyCutOffRestriction(Enabled: Boolean)
    var
        CallPlanSetup: Record CallPlanSetup59FDW;
        IncludeCutOffRestrictionErr: Label 'Not possible to turn on the toggle ''Include for Cut-off Time Restriction'', because on the general Call Plan Setup page the toggle ''Enable Cut-of Time Restrictions'' is turned off.';
    begin
        CallPlanSetup.Get();
        if not (CallPlanSetup."Enable Cut-off Restrictions") then
            Error(IncludeCutOffRestrictionErr);
    end;

    internal procedure IncludeInCallPlanShipToCode()
    var
        ShipToAddressCapSetup59FDW: Record ShipToAddressCapSetup59FDW;
        IncludeCAPErrorErr: Label 'Not possible to include this ship-to address in the call plan, since the customer itself is not set up to be included in the call plan (on the page ''Call Plan Setup'' for the customer).';
        ExcludeCAPErrorErr: Label 'Not possible exclude this customer from the call plan, since one or more of the customers ship-to addresses are set up to be included in the call plan (on the page Call Plan Setup from the ship-to address(es)).';
    begin
        if "Ship-to Code" <> '' then begin
            if not "Include in Call Plan" then
                exit;
            ShipToAddressCapSetup59FDW.SetRange("Customer No.", "Customer No.");
            ShipToAddressCapSetup59FDW.SetFilter("Ship-to Code", '%1', '');
            ShipToAddressCapSetup59FDW.SetRange("Include in Call Plan", true);
            if ShipToAddressCapSetup59FDW.IsEmpty() then
                Error(IncludeCAPErrorErr);
        end else begin
            if "Include in Call Plan" then
                exit;
            ShipToAddressCapSetup59FDW.SetRange("Customer No.", "Customer No.");
            ShipToAddressCapSetup59FDW.SetFilter("Ship-to Code", '<>%1', '');
            ShipToAddressCapSetup59FDW.SetRange("Include in Call Plan", true);
            if not ShipToAddressCapSetup59FDW.IsEmpty() then
                Error(ExcludeCAPErrorErr);
        end;
    end;

    internal procedure UpdateContact()
    var
        Contact: Record Contact;
    begin
        "Call Plan Contact Name" := '';
        "Call Plan Phone No." := '';
        "Call Plan E-Mail" := '';
        if "Call Plan Contact Code" <> '' then begin
            Contact.Get("Call Plan Contact Code");
            CheckCustomerContactRelation(Contact);
            "Call Plan Contact Name" := Contact.Name;
            if Contact."Phone No." <> '' then
                "Call Plan Phone No." := Contact."Phone No.";
            if Contact."E-Mail" <> '' then
                "Call Plan E-Mail" := Contact."E-Mail";
        end;
    end;

    internal procedure CreateNewContactFromName()
    var
        MarketingSetup: Record "Marketing Setup";
        UpdateContactFromCustomer59FDW: Codeunit UpdateContactFromCustomer59FDW;
    begin
        if MarketingSetup.Get() then
            if MarketingSetup."Bus. Rel. Code for Customers" <> '' then
                if (xRec."Call Plan Contact Name" = '') and (xRec."Call Plan Contact Code" = '') and ("Call Plan Contact Name" <> '') then begin
                    Modify();
                    UpdateContactFromCustomer59FDW.InsertNewContactPersonShipToAddress(Rec);
                    Modify(true);
                end;
    end;

    local procedure ValidatePhoneNumber()
    var
        Counts: Integer;
        Check_Value: Integer;
        PhoneNoInvalidErr: Label 'Enter a valid phone number, characters are not allowed';
    begin
        for Counts := 1 to StrLen(Rec."Call Plan Phone No.") do begin
            Check_Value := "Call Plan Phone No."[Counts];
            if not (Check_Value in ['0' .. '9']) then
                FieldError("Call Plan Phone No.", PhoneNoInvalidErr);
        end;
    end;

    local procedure ValidateEMail()
    var
        MailManagement: Codeunit "Mail Management";
    begin
        if "Call Plan E-Mail" <> '' then
            MailManagement.CheckValidEmailAddresses("Call Plan E-Mail");
    end;

    local procedure UpdatePhoneNo()
    var
        Contact: Record Contact;
    begin
        ValidatePhoneNumber();
        if Contact.Get("Call Plan Contact Code") then begin
            Contact."Phone No." := "Call Plan Phone No.";
            Contact.Modify();
        end;
    end;

    local procedure UpdateEMail()
    var
        Contact: Record Contact;
    begin
        ValidateEMail();
        if Contact.Get("Call Plan Contact Code") then begin
            Contact."E-Mail" := "Call Plan E-Mail";
            Contact.Modify();
        end;
    end;
}