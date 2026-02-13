/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-02-04      Create new "Posted Purchase Invoice" page extension
2                               Pull out "Sales Order No.", "Remarks" field
*/

//HS.1+
pageextension 50016 "ATU_Posted Purchase Invoice" extends "Posted Purchase Invoice"
{
    layout
    {
        addlast(General)
        {
            //HS.2+
            field("ATU_Sales Order No."; Rec."ATU_Sales Order No.")
            {
                ApplicationArea = All;
            }
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