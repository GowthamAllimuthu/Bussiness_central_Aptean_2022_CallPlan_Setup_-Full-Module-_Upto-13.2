page 70241760 ResponsibilityCenterCAPS59FDW
{
    PageType = Card;
    Caption = 'Call Plan Setup';
    UsageCategory = None;
    SourceTable = ResponsibilityCenterCAPS59FDW;
    InsertAllowed = false;
    DeleteAllowed = false;
    Extensible = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Enable Cut-off Restrictions"; Rec."Enable Cut-off Restrictions")
                {
                    ToolTip = 'Specifies if the cut-off time restrictions should be enabled. When enabled, it becomes possible to include specific customers/ship-to addresses for cut-off time restrictions. When set up to be included, this means sales lines for those customers will no longer be editable after a certain ''cut-off time'', related to the order''s shipment date.';
                    ApplicationArea = CallPlanAppArea59FDW;
                }
                field("Cut-off Warning Minutes"; Rec."Cut-off Warning Minutes")
                {
                    ToolTip = 'Specifies the number of minutes in advance to each day''s cut-off time that a warning will be given (in the form of a color change inside the call plan), informing that sales lines for the related customer''s sales order may no longer be edited after that time.';
                    ApplicationArea = CallPlanAppArea59FDW;
                }
            }
            group("Default Call Days")
            {
                Caption = 'Default Call Days';

                field("Call Day for Monday Shipment"; Rec."Call Day for Monday Shipment")
                {
                    ToolTip = 'Specifies the day on which customers should be called regarding sales orders that are to be shipped to them on a Monday. This value is only used as a default value to enable quick setup; call days will need to be set up per specific customer/ship-to address.';
                    ApplicationArea = CallPlanAppArea59FDW;
                }
                field("Call Day for Tuesday Shipment"; Rec."Call Day for Tuesday Shipment")
                {
                    ToolTip = 'Specifies the day on which customers should be called regarding sales orders that are to be shipped to them on a Tuesday. This value is only used as a default value to enable quick setup; call days will need to be set up per specific customer/ship-to address.';
                    ApplicationArea = CallPlanAppArea59FDW;
                }
                field("Call Day for Wednesday Shipment"; Rec."Call Day for Wednesday Shipment")
                {
                    ToolTip = 'Specifies the day on which customers should be called regarding sales orders that are to be shipped to them on a Wednesday. This value is only used as a default value to enable quick setup; call days will need to be set up per specific customer/ship-to address.';
                    ApplicationArea = CallPlanAppArea59FDW;
                }
                field("Call Day for Thursday Shipment"; Rec."Call Day for Thursday Shipment")
                {
                    ToolTip = 'Specifies the day on which customers should be called regarding sales orders that are to be shipped to them on a Thursday. This value is only used as a default value to enable quick setup; call days will need to be set up per specific customer/ship-to address.';
                    ApplicationArea = CallPlanAppArea59FDW;
                }
                field("Call Day for Friday Shipment"; Rec."Call Day for Friday Shipment")
                {
                    ToolTip = 'Specifies the day on which customers should be called regarding sales orders that are to be shipped to them on a Friday. This value is only used as a default value to enable quick setup; call days will need to be set up per specific customer/ship-to address.';
                    ApplicationArea = CallPlanAppArea59FDW;
                }
                field("Call Day for Saturday Shipment"; Rec."Call Day for Saturday Shipment")
                {
                    ToolTip = 'Specifies the day on which customers should be called regarding sales orders that are to be shipped to them on a Saturday. This value is only used as a default value to enable quick setup; call days will need to be set up per specific customer/ship-to address.';
                    ApplicationArea = CallPlanAppArea59FDW;
                }
                field("Call Day for Sunday Shipment"; Rec."Call Day for Sunday Shipment")
                {
                    ToolTip = 'Specifies the day on which customers should be called regarding sales orders that are to be shipped to them on a Sunday. This value is only used as a default value to enable quick setup; call days will need to be set up per specific customer/ship-to address.';
                    ApplicationArea = CallPlanAppArea59FDW;
                }
            }
            group("Cut-off Times")
            {
                Caption = 'Cut-off Times';

                field("Monday Cut-off Time"; Rec."Monday Cut-off Time")
                {
                    ToolTip = 'Specifies the time after which changes to the Sales Order with the shipment date for a Monday will not be permitted.The Work Date on which the restriction will take effect depends on the setup for the Default Call Day "For Monday Shipment". Individual customers and sales orders may be configured to bypass the cut-off, with the "Include for Cut-Off Time" field set as "No".';
                    ApplicationArea = CallPlanAppArea59FDW;
                }
                field("Tuesday Cut-off Time"; Rec."Tuesday Cut-off Time")
                {
                    ToolTip = 'Specifies the time after which changes to the Sales Order with the shipment date for a Tuesday will not be permitted.The Work Date on which the restriction will take effect depends on the setup for the Default Call Day "For Tuesday Shipment". Individual customers and sales orders may be configured to bypass the cut-off, with the "Include for Cut-Off Time" field set as "No.';
                    ApplicationArea = CallPlanAppArea59FDW;
                }
                field("Wednesday Cut-off Time"; Rec."Wednesday Cut-off Time")
                {
                    ToolTip = 'Specifies the time after which changes to the Sales Order with the shipment date for a Wednesday will not be permitted. The Work Date on which the restriction will take effect depends on the setup for the Default Call Day "For Wednesday Shipment". Individual customers and sales orders may be configured to bypass the cut-off, with the "Include for Cut-Off Time" field set as "No".';
                    ApplicationArea = CallPlanAppArea59FDW;
                }
                field("Thursday Cut-off Time"; Rec."Thursday Cut-off Time")
                {
                    ToolTip = 'Specifies the time after which changes to the Sales Order with the shipment date for a Thursday will not be permitted. The Work Date on which the restriction will take effect depends on the setup for the Default Call Day "For Thursday Shipment". Individual customers and sales orders may be configured to bypass the cut-off, with the "Include for Cut-Off Time" field set as "No".';
                    ApplicationArea = CallPlanAppArea59FDW;
                }
                field("Friday Cut-off Time"; Rec."Friday Cut-off Time")
                {
                    ToolTip = 'Specifies the time after which changes to the Sales Order with the shipment date for a Friday will not be permitted. The Work Date on which the restriction will take effect depends on the setup for the Default Call Day "For Friday Shipment". Individual customers and sales orders may be configured to bypass the cut-off, with the "Include for Cut-Off Time" field set as "No".';
                    ApplicationArea = CallPlanAppArea59FDW;
                }
                field("Saturday Cut-off Time"; Rec."Saturday Cut-off Time")
                {
                    ToolTip = 'Specifies the time after which changes to the Sales Order with the shipment date for a Saturday will not be permitted. The Work Date on which the restriction will take effect depends on the setup for the Default Call Day "For Saturday Shipment". Individual customers and sales orders may be configured to bypass the cut-off, with the "Include for Cut-Off Time" field set as "No".';
                    ApplicationArea = CallPlanAppArea59FDW;
                }
                field("Sunday Cut-off Time"; Rec."Sunday Cut-off Time")
                {
                    ToolTip = 'Specifies the time after which changes to the Sales Order with the shipment date for a Sunday will not be permitted. The Work Date on which the restriction will take effect depends on the setup for the Default Call Day "For Sunday Shipment". Individual customers and sales orders may be configured to bypass the cut-off, with the "Include for Cut-Off Time" field set as "No".';
                    ApplicationArea = CallPlanAppArea59FDW;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CallPlanWorksheet59FDW)
            {
                Caption = 'Call Plan Worksheet';
                ApplicationArea = CallPlanAppArea59FDW;
                RunObject = page CAPWorkSheetNames59FDW;
                RunPageMode = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Image = Worksheets;
                ToolTip = 'View or create new call plan worksheets: lists of customers to be contacted by the sales department on a specific day of the week regarding their sales orders.';
            }
        }
    }

    var
        xResponsibilityCenterCAPS59FDW: Record ResponsibilityCenterCAPS59FDW;

    trigger OnOpenPage()
    begin
        xResponsibilityCenterCAPS59FDW := Rec;
    end;
}