/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-01-20      Create new "Sales Invoice Header" table extension
2                               Add new "Remarks" field
*/

//HS.1+
tableextension 50002 "ATU_Sales Invoice Header" extends "Sales Invoice Header"
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