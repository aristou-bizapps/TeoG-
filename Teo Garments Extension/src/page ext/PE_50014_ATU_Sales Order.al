/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-02-03      Create new "Sales Order" page extension
2                               Pull out "Purchase Order No.", "Vendor Invoice No." field
3               2026-03-02      Make "Posting Date" and "Document Date" as non-editable
4                               Pull out "Manual Invoice No."
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
            //HS.4+
            field("ATU_Manual Invoice No."; Rec."ATU_Manual Invoice No.")
            {
                ApplicationArea = All;
            }
            //HS.4-
        }
        //HS.3+
        modify("Posting Date")
        {
            Editable = false;
        }
        modify("Document Date")
        {
            Editable = false;
        }
        //HS.3-
    }
}
//HS.1-