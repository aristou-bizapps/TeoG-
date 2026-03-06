/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-03-03      Create new "Vendor Card" page extension
2                               Pull out "Ship-to Address" field
*/

//HS.1+
pageextension 50024 "ATU_Vendor Card" extends "Vendor Card"
{
    layout
    {
        //HS.2+
        addafter("Post Code")
        {
            field("ATU_Ship-to Address"; Rec."ATU_Ship-to Address")
            {
                ApplicationArea = All;
            }
        }
        //HS.2-
    }
}
//HS.1-