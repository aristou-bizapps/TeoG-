/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-02-02      Create new "Purchase Header" table extension
2                               Add new "Is PO Created From SO" field
*/

//HS.1+
tableextension 50009 "ATU_Purchase Header" extends "Purchase Header"
{
    fields
    {
        //HS.2+
        field(50001; "ATU_Is PO Created From SO"; Boolean)
        {
            Caption = 'Is PO Created From SO';
        }
        //HS.2-
    }
}
//HS.1-