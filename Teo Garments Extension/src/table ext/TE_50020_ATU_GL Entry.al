/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-02-04      Create new "G/L Entry" table extension
2                               Add new "Purchase Order No.", "Sales Order No." fields
*/

//HS.1+
tableextension 50020 "ATU_G/L Entry" extends "G/L Entry"
{
    fields
    {
        //HS.2+
        field(50001; "ATU_Purchase Order No."; Code[20])
        {
            Caption = 'Purchase Order No.';
        }
        field(50002; "ATU_Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
        }
        //HS.2-
    }
}
//HS.1-