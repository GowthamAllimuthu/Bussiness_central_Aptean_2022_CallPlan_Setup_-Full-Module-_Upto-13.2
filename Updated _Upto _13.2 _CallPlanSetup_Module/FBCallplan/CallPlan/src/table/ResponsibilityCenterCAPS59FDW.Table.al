table 70241760 ResponsibilityCenterCAPS59FDW
{
    Caption = 'Call Plan Setup-[respons Center Code]';
    Extensible = false;
    Access = Internal;
    fields
    {
        field(1; "Responsibility Center Code"; Code[10])
        {
            DataClassification = CustomerContent;
            NotBlank = true;
            Caption = 'Responsibility Center Code';
        }
        field(2; "Call Day for Monday Shipment"; Enum WeekDay59FDW)
        {
            DataClassification = CustomerContent;
            Caption = 'For Monday Shipment';
        }
        field(3; "Call Day for Tuesday Shipment"; Enum WeekDay59FDW)
        {
            DataClassification = CustomerContent;
            Caption = 'For Tuesday Shipment';
        }
        field(4; "Call Day for Wednesday Shipment"; Enum WeekDay59FDW)
        {
            DataClassification = CustomerContent;
            Caption = 'For Wednesday Shipment';
        }
        field(5; "Call Day for Thursday Shipment"; Enum WeekDay59FDW)
        {
            DataClassification = CustomerContent;
            Caption = 'For Thursday Shipment';
        }
        field(6; "Call Day for Friday Shipment"; Enum WeekDay59FDW)
        {
            DataClassification = CustomerContent;
            Caption = 'For Friday Shipment';
        }
        field(7; "Call Day for Saturday Shipment"; Enum WeekDay59FDW)
        {
            DataClassification = CustomerContent;
            Caption = 'For Saturday Shipment';
        }
        field(8; "Call Day for Sunday Shipment"; Enum WeekDay59FDW)
        {
            DataClassification = CustomerContent;
            Caption = 'For Sunday Shipment';
        }
        field(9; "Enable Cut-off Restrictions"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Enable Cut-off Restrictions';

            trigger OnValidate()
            begin
                DisablingCuttoffTime("Enable Cut-off Restrictions");
            end;
        }
        field(10; "Cut-off Warning Minutes"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Cut-off Warning Minutes';
        }
        field(11; "Monday Cut-off Time"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Monday';
            InitValue = 000000T;

            trigger OnValidate()
            begin
                if "Monday Cut-off Time" = 0T then
                    "Monday Cut-off Time" := 000000T;
                if "Monday Cut-off Time" <> xRec."Monday Cut-off Time" then
                    "Monday Cut-off Time" := EditingCutOffTime(FieldCaption("Monday Cut-off Time"), "Monday Cut-off Time", xRec."Monday Cut-off Time");
            end;
        }
        field(12; "Tuesday Cut-off Time"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Tuesday';
            InitValue = 000000T;

            trigger OnValidate()
            begin
                if "Tuesday Cut-off Time" = 0T then
                    "Tuesday Cut-off Time" := 000000T;
                if "Tuesday Cut-off Time" <> xRec."Tuesday Cut-off Time" then
                    "Tuesday Cut-off Time" := EditingCutOffTime(FieldCaption("Tuesday Cut-off Time"), "Tuesday Cut-off Time", xRec."Tuesday Cut-off Time");
            end;
        }
        field(13; "Wednesday Cut-off Time"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Wednesday';
            InitValue = 000000T;

            trigger OnValidate()
            begin
                if "Wednesday Cut-off Time" = 0T then
                    "Wednesday Cut-off Time" := 000000T;
                if "Wednesday Cut-off Time" <> xRec."Wednesday Cut-off Time" then
                    "Wednesday Cut-off Time" := EditingCutOffTime(FieldCaption("Wednesday Cut-off Time"), "Wednesday Cut-off Time", xRec."Wednesday Cut-off Time");
            end;
        }
        field(14; "Thursday Cut-off Time"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Thursday';
            InitValue = 000000T;

            trigger OnValidate()
            begin
                if "Thursday Cut-off Time" = 0T then
                    "Thursday Cut-off Time" := 000000T;
                if "Thursday Cut-off Time" <> xRec."Thursday Cut-off Time" then
                    "Thursday Cut-off Time" := EditingCutOffTime(FieldCaption("Thursday Cut-off Time"), "Thursday Cut-off Time", xRec."Thursday Cut-off Time");
            end;
        }
        field(15; "Friday Cut-off Time"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Friday';
            InitValue = 000000T;

            trigger OnValidate()
            begin
                if "Friday Cut-off Time" = 0T then
                    "Friday Cut-off Time" := 000000T;
                if "Friday Cut-off Time" <> xRec."Friday Cut-off Time" then
                    "Friday Cut-off Time" := EditingCutOffTime(FieldCaption("Friday Cut-off Time"), "Friday Cut-off Time", xRec."Friday Cut-off Time");
            end;
        }
        field(16; "Saturday Cut-off Time"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Saturday';
            InitValue = 000000T;

            trigger OnValidate()
            begin
                if "Saturday Cut-off Time" = 0T then
                    "Saturday Cut-off Time" := 000000T;
                if "Saturday Cut-off Time" <> xRec."Saturday Cut-off Time" then
                    "Saturday Cut-off Time" := EditingCutOffTime(FieldCaption("Saturday Cut-off Time"), "Saturday Cut-off Time", xRec."Saturday Cut-off Time");
            end;
        }
        field(17; "Sunday Cut-off Time"; Time)
        {
            DataClassification = CustomerContent;
            Caption = 'Sunday';
            InitValue = 000000T;

            trigger OnValidate()
            begin
                if "Sunday Cut-off Time" = 0T then
                    "Sunday Cut-off Time" := 000000T;
                if "Sunday Cut-off Time" <> xRec."Sunday Cut-off Time" then
                    "Sunday Cut-off Time" := EditingCutOffTime(FieldCaption("Sunday Cut-off Time"), "Sunday Cut-off Time", xRec."Sunday Cut-off Time");
            end;
        }
    }
    keys
    {
        key(PK; "Responsibility Center Code")
        {
            Clustered = true;
        }
    }

    local procedure DisablingCuttoffTime(var EnableCutOffRestriction: Boolean)
    var
        ShipToAddressCapSetup59FDW: Record ShipToAddressCapSetup59FDW;
        DisableCutOffTimeQst: Label 'Are you sure you want to turn off the toggle ''Enable Cut-off Time Restrictions''? On the specific call plan setup for one or more customers/ship-to addresses is specified to include them for cut-of time restrictions. These settings will be turned off as well.  ';
    begin
        ShipToAddressCapSetup59FDW.SetRange("Inc.forCutoffTimeRestriction", true);
        if ShipToAddressCapSetup59FDW.IsEmpty then
            exit;
        if not EnableCutOffRestriction then
            if not Confirm(DisableCutOffTimeQst, false) then begin
                EnableCutOffRestriction := true;
                exit;
            end;
        UpdateCutOffTimeRestrictionShipToAddressCapSetup(ShipToAddressCapSetup59FDW);
    end;

    local procedure UpdateCutOffTimeRestrictionShipToAddressCapSetup(var ShipToAddressCapSetup59FDW: Record ShipToAddressCapSetup59FDW)
    begin
        if ShipToAddressCapSetup59FDW.FindSet() then
            repeat
                ShipToAddressCapSetup59FDW."Inc.forCutoffTimeRestriction" := false;
                ShipToAddressCapSetup59FDW.Modify();
            until ShipToAddressCapSetup59FDW.Next() = 0;
    end;

    internal procedure EditingCutOffTime(Day: Text; CutOffTime: Time; xRecCutOffTime: Time): Time
    var
        SalesHeader: Record "Sales Header";
        EditingCutOffTimeQst: Label 'Are you sure you want to edit the cut-off time for [%1]? One or more active sales documents/call plan lines exist that are currently making use of this time. ', Comment = '%1=Day';
    begin
        SalesHeader.SetRange(IncludeforCutoffTime59FDW, true);
        if not SalesHeader.IsEmpty() then
            if not Confirm(EditingCutOffTimeQst, false, Day) then
                exit(xRecCutOffTime);
        exit(CutOffTime);
    end;
}