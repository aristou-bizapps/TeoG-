/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-01-20      Create new "Sales Cr.Memo Header" table extension
2                               Add new "Remarks" field
*/

//HS.1+
tableextension 50004 "ATU_Sales Cr.Memo Header" extends "Sales Cr.Memo Header"
{
    fields
    {
        //HS.2+
        field(50001; ATU_Remarks; Text[2048])
        {
            Caption = 'Remarks';
        }
        //HS.2-
    }
}
//HS.1-