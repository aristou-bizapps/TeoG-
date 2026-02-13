/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-02-03      Create new "Purch. Cr. Memo Hdr." table extension
2                               Add new "Sales Order No.", "Remarks" field
*/

//HS.1+
tableextension 50011 "ATU_Purch. Cr. Memo Hdr." extends "Purch. Cr. Memo Hdr."
{
    fields
    {
        //HS.2+
        field(50002; "ATU_Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
        }
        field(50003; ATU_Remarks; Text[500])
        {
            Caption = 'Remarks';
        }
        //HS.2-
    }
}
//HS.1-