/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-02-04      Create new "General Ledger Entries" page extension
2                               Pull out "Purchase Order No." field
*/

//HS.1+
pageextension 50019 "ATU_General Ledger Entries" extends "General Ledger Entries"
{
    layout
    {
        //HS.2+
        addafter("Document No.")
        {
            field("ATU_Purchase Order No."; Rec."ATU_Purchase Order No.")
            {
                ApplicationArea = All;
            }
            field("ATU_Sales Order No."; Rec."ATU_Sales Order No.")
            {
                ApplicationArea = All;
            }
        }
        //HS.2-
    }
}
//HS.1-