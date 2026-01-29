/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-01-20      Create new "Sales Credit Memo" page extension
2                               Pull out "Remarks" field
*/

//HS.1+
pageextension 50009 "ATU_Sales Credit Memo" extends "Sales Credit Memo"
{
    layout
    {
        addlast(General)
        {
            //HS.2+
            field(ATU_Remarks; Rec.ATU_Remarks)
            {
                ApplicationArea = All;
                MultiLine = true;
            }
            //HS.2-
        }
    }
}
//HS.1-