/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-03-05      Create new "Cust. Ledger Entry" table extension
2                               Add new "Manual Invoice No." field
*/

//HS.1+
tableextension 50025 "ATU_Cust. Ledger Entry" extends "Cust. Ledger Entry"
{
    fields
    {
        //HS.2+
        field(50001; "ATU_Manual Invoice No."; Code[20])
        {
            Caption = 'Manual Invoice No.';
        }
        //HS.2-
    }
}
//HS.1-