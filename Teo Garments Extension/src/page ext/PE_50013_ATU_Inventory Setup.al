/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-02-03      Create new "Inventory Setup" page extension
2                               Pull out "Default Gen. Prod. Posting Group" field
*/

//HS.1+
pageextension 50013 "ATU_Inventory Setup" extends "Inventory Setup"
{
    layout
    {
        //HS.2+
        addafter("Default Costing Method")
        {
            field("ATU_Def Gen Prod Posting Group"; Rec."ATU_Def Gen Prod Posting Group")
            {
                ApplicationArea = All;
            }
        }
        //HS.2-
    }
}
//HS.1-