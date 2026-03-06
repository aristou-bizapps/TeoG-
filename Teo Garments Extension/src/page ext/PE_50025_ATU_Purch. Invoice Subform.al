/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-03-03      Create new "Purch. Invoice Subform" page extension
2                               Pull out "Salvage Value" field
*/

//HS.1+
pageextension 50025 "ATU_Purch. Invoice Subform" extends "Purch. Invoice Subform"
{
    layout
    {
        //HS.2+
        addafter("Location Code")
        {
            field("ATU_Salvage Value"; Rec."ATU_Salvage Value")
            {
                ApplicationArea = All;
            }
        }
        //HS.2-
    }
}
//HS.1-