table 70241758 CAPWorkSheetEntry59FDW
{
    Caption = 'Call Plan Work Sheet Entry';
    Access = Internal;
    LookupPageId = CallPlanOrders59FDW;
    DrillDownPageId = CallPlanOrders59FDW;
    fields
    {
        field(1; "Worksheet Name"; Code[10])
        {
            DataClassification = CustomerContent;
            NotBlank = true;
            Caption = 'Worksheet Name';
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.';
        }
        field(3; "Call Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Call Date';
        }
        field(4; "Inside Salesperson Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Salesperson/Purchaser";
            ValidateTableRelation = true;
            Caption = 'Inside Salesperson Code';
        }
        field(5; "Shipment Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Shipment Date';
            trigger OnValidate()
            begin
                "Shipment Day" := GetDayOfWeek("Shipment Date");
            end;
        }
        field(6; "Shipment Day"; Enum WeekDay59FDW)
        {
            DataClassification = CustomerContent;
            Caption = 'Shipment Day';
        }
        field(7; "Delivery Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Delivery Date';
            trigger OnValidate()
            begin
                "Delivery Day" := GetDayOfWeek("Delivery Date");
            end;
        }
        field(8; "Delivery Day"; Enum WeekDay59FDW)
        {
            DataClassification = CustomerContent;
            Caption = 'Delivery Day';
        }
        field(9; "Call Plan Status"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = New,Completed,Retry;
            Caption = 'Call Plan Status';
        }
        field(10; "Call Plan Orders"; Integer)
        {
            Caption = 'Call Plan Orders';
            FieldClass = FlowField;
            CalcFormula = count(CAPWorkSheetEntry59FDW where("Customer No." = field("Customer No."), "Ship-To Code" = field("Ship-To Code"), "Call Date" = field("Call Date")));
            Editable = false;
        }
        field(11; "Existing Orders"; Integer)
        {
            Caption = 'Existing Orders';
            FieldClass = FlowField;
            CalcFormula = count("Sales Header" where("Document Type" = const(Order), "Sell-to Customer No." = field("Customer No."), "Ship-to Code" = field("Ship-To Code"), "Shipment Date" = field("Shipment Date")));
            Editable = false;
        }
        field(12; "Blocked"; Enum "Customer Blocked")
        {
            DataClassification = CustomerContent;
            Caption = 'Blocked';
        }
        field(13; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer No.';
            TableRelation = Customer;
            ValidateTableRelation = true;
            trigger OnValidate()
            begin
                UpdateContactDetails();
            end;
        }
        field(14; "Ship-To Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Ship-To Code';
            TableRelation = "Ship-to Address".Code where("Customer No." = field("Customer No."));
            trigger OnValidate()
            begin
                UpdateContactDetails();
            end;
        }
        field(15; "Ship-To Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Ship-To Name';
        }
        field(16; "Contact Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Contact Name';
        }
        field(17; "Phone No."; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(18; "E-mail"; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'E-mail';
            ExtendedDatatype = EMail;
        }
        field(19; "Call Window Starting Time"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Call Window Starting Time';
        }
        field(20; "Call Window Ending Time"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Call Window Ending Time';
        }
        field(21; "Order Entry Cut-off Time"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Order Entry Cut-off Time';
        }
        field(22; "Note"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Note';
        }
        field(23; "Responsibility Center "; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
            ValidateTableRelation = true;
        }
        field(24; "Customer Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Customer Name';
        }
    }

    keys
    {
        key(PK; "Worksheet Name", "Line No.")
        {
            Clustered = true;
        }
        key(SK1; "Call Window Starting Time")
        {

        }
    }
    fieldgroups
    {
        fieldgroup(Brick; "Call Plan Status", "Worksheet Name", "Call Date", "Inside Salesperson Code", "Shipment Date")
        {
        }
    }
    local procedure GetDayOfWeek(CurrentDate: Date) WeekDay: Enum WeekDay59FDW
    var
        RecordDate: Record Date;
    begin
        if RecordDate.Get(RecordDate."Period Type"::Date, CurrentDate) then
            WeekDay := Enum::WeekDay59FDW.FromInteger(RecordDate."Period No.");

        exit(WeekDay);
    end;

    local procedure UpdateContactDetails()
    begin
        ClearContactDetails();
        GetCustomerDetails();
        GetAddressDetails();
        GetContactDetails();
    end;

    local procedure ClearContactDetails()
    begin
        if "Customer No." = '' then begin
            "Customer Name" := '';
            "Ship-To Code" := '';
        end;
        "Ship-To Name" := '';
        "Contact Name" := '';
        "Phone No." := '';
        "E-mail" := '';
        Blocked := Blocked::" ";
    end;

    local procedure GetCustomerDetails()
    var
        Customer: Record Customer;
    begin
        if Customer.Get("Customer No.") then begin
            "Customer Name" := Customer.Name;
            Blocked := Customer.Blocked;
        end;
    end;

    local procedure GetAddressDetails()
    var
        ShipToAddress: Record "Ship-to Address";
    begin
        if ShipToAddress.Get("Customer No.", "Ship-To Code") then
            "Ship-To Name" := ShipToAddress.Name;
    end;

    local procedure GetContactDetails()
    var
        ShipToAddressCapSetup: Record ShipToAddressCapSetup59FDW;
    begin
        if ShipToAddressCapSetup.Get("Customer No.", "Ship-To Code") then begin
            "Contact Name" := ShipToAddressCapSetup."Call Plan Contact Name";
            "Phone No." := ShipToAddressCapSetup."Call Plan Phone No.";
            "E-mail" := ShipToAddressCapSetup."Call Plan E-Mail";
        end;
    end;
}