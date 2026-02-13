/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-02-09      Create new "Company Information" page extension
2                               Pull out "PayNow QR Code" field
*/

//HS.1+
pageextension 50021 "ATU_Company Information" extends "Company Information"
{
    layout
    {
        //HS.2+
        addlast(Payments)
        {
            field("ATU_PayNow QR Code"; Rec."ATU_PayNow QR Code")
            {
                ApplicationArea = All;
            }
        }
        //HS.2-
    }
}
//HS.1-