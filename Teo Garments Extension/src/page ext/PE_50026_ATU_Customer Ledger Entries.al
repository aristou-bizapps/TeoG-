/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-03-05      Create new "Customer Ledger Entries" page extension
2                               Pull out "Manual Invoice No." field
*/

//HS.1+
pageextension 50026 "ATU_Customer Ledger Entries" extends "Customer Ledger Entries"
{
    layout
    {
        //HS.2+
        addafter("Document No.")
        {
            field("ATU_Manual Invoice No."; Rec."ATU_Manual Invoice No.")
            {
                ApplicationArea = All;
            }
        }
        //HS.2-
    }
}
//HS.1-