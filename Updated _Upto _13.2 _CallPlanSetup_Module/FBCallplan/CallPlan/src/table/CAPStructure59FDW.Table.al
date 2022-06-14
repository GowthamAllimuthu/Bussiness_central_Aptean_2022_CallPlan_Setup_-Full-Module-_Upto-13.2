table 70241759 CAPStructure59FDW
{
    Caption = 'Call Plan structure';
    Extensible = false;
    Access = Internal;
    fields
    {
        field(1; "Shipment Day"; Enum WeekDay59FDW)
        {
            DataClassification = CustomerContent;
            Caption = 'Shipment Day';
            NotBlank = true;
            trigger OnValidate()
            begin
                UpdateCallDay();
            end;
        }
        field(2; "Call Day"; Enum WeekDay59FDW)
        {
            DataClassification = CustomerContent;
            Caption = 'Call Day';
        }
        field(3; "Call Window Starting Time"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Call Window Starting Time';
            trigger OnValidate()
            begin
                if "Call Window Ending Time" = 0T then
                    exit;
                if "Call Window Starting Time" > "Call Window Ending Time" then
                    Error('Call Window Starting Time cannot be after Call Window Ending Time.');
            end;
        }
        field(4; "Call Window Ending Time"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Call Window Ending Time';
            trigger OnValidate()
            begin
                if "Call Window Ending Time" < "Call Window Starting Time" then
                    Error('Call Window Ending Date cannot be before Call Window Starting Time');
            end;
        }
        field(5; "Starting Date"; Date)
        {
            DataClassification = CustomerContent;
            NotBlank = true;
            Caption = 'Starting Date';
            trigger OnValidate()
            begin
                if "Ending Date" <> 0D then
                    if "Starting Date" > "Ending Date" then
                        Error('Starting Date cannot be after Ending Date');
            end;
        }
        field(6; "Ending Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Ending Date';
            trigger OnValidate()
            begin
                if "Ending Date" <> 0D then
                    if "Ending Date" < "Starting Date" then
                        Error('Ending Date cannot be before Starting Date');
            end;
        }
        field(7; Note; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Note';
        }
        field(8; Frequency; Option)
        {
            OptionMembers = Weekly,"Bi-Weekly";
            DataClassification = CustomerContent;
            Caption = 'Frequency';
        }
        field(9; "Last Creation Date"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Last Creation Date';
        }
        field(10; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer;
            NotBlank = true;
            Caption = 'Customer No.';
        }
        field(11; "Ship-To Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Ship-to Address".Code where("Customer No." = field("Customer No."), Code = field("Ship-To Code"));
            ValidateTableRelation = true;
            Caption = 'Ship-To Code';
        }
    }
    keys
    {
        key(PK; "Customer No.", "Ship-To Code", "Starting Date", "Shipment Day")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(Brick; Frequency, "Shipment Day", "Call Day", "Call Window Starting Time", "Call Window Ending Time")
        {

        }
    }

    trigger OnInsert()
    begin
        CallDayValidation();
    end;

    trigger OnModify()
    begin
        CallDayValidation();
    end;

    local procedure CallDayValidation()
    var
        CallDayBlankErr: Label 'Call day is required when shipment day has been filled in the call plan structure';
    begin
        if "Shipment Day" <> "Shipment Day"::" " then
            if "Call Day" = "Call Day"::" " then
                Error(CallDayBlankErr);
    end;

    local procedure UpdateCallDay()
    var
        CallplanSetup: Record CallPlanSetup59FDW;
    begin
        if "Shipment Day" = "Shipment Day"::" " then
            exit;
        CallplanSetup.Get();
        case "Shipment Day" of
            "Shipment Day"::Monday:
                "Call Day" := CallplanSetup."Call Day for Monday Shipment";
            "Shipment Day"::Tuesday:
                "Call Day" := CallplanSetup."Call Day for Tuesday Shipment";
            "Shipment Day"::Wednesday:
                "Call Day" := CallplanSetup."Call Day for Wednesday Shipment";
            "Shipment Day"::Thursday:
                "Call Day" := CallplanSetup."Call Day for Thursday Shipment";
            "Shipment Day"::Friday:
                "Call Day" := CallplanSetup."Call Day for Friday Shipment";
            "Shipment Day"::Saturday:
                "Call Day" := CallplanSetup."Call Day for Saturday Shipment";
            "Shipment Day"::Sunday:
                "Call Day" := CallplanSetup."Call Day for Sunday Shipment";
        end
    end;
}