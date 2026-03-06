/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-02-27      Create new "FA Depreciation Books Subform" page extension
2                               Pull out "Salvage Value" field
*/

//HS.1+
pageextension 50022 "ATU_FA Depreciation Books Sub." extends "FA Depreciation Books Subform"
{
    layout
    {
        addlast(Control1)
        {
            //HS.2+
            field("Salvage Value"; Rec."Salvage Value")
            {
                ApplicationArea = All;
            }
            //HS.2-
        }
    }
}
//HS.1-