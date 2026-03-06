/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-03-03      Create new "Get Shipment Lines" page extension
2                               Pull out "Shipment Buyer Order No." field
*/

//HS.1+
pageextension 50023 "ATU_Get Shipment Lines" extends "Get Shipment Lines"
{
    layout
    {
        //HS.2+
        addafter(Description)
        {
            field("ATU_Shipment Buyer Order No."; Rec."ATU_Shipment Buyer Order No.")
            {
                ApplicationArea = All;
                Caption = 'Customer PO No.';
            }
        }
        //HS.2-
    }
}
//HS.1-