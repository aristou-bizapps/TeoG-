/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-02-03      Create new "Sales Order" page extension
2                               Pull out "Purchase Order No.", "Vendor Invoice No." field
*/

//HS.1+
pageextension 50014 "ATU_Sales Order" extends "Sales Order"
{
    layout
    {
        addlast(General)
        {
            //HS.2+
            field("ATU_Purchase Order No."; Rec."ATU_Purchase Order No.")
            {
                ApplicationArea = All;
            }
            field("ATU_Vendor Invoice No."; Rec."ATU_Vendor Invoice No.")
            {
                ApplicationArea = All;
            }
            //HS.2-
        }
    }
}
//HS.1-