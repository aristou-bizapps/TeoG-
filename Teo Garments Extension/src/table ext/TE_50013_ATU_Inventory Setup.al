/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-02-03      Create new "Inventory Setup" table extension
2                               Add new "Default Gen. Prod. Posting Group" field
*/

//HS.1+
tableextension 50013 "ATU_Inventory Setup" extends "Inventory Setup"
{
    fields
    {
        //HS.2+
        field(50001; "ATU_Def Gen Prod Posting Group"; Code[20])
        {
            Caption = 'Default Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        //HS.2-
    }
}
//HS.1-