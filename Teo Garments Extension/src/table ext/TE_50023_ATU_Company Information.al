/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-02-09      Create new "Company Information" table extension
2                               Add new "PayNow QR Code" field
*/

//HS.1+
tableextension 50023 "ATU_Company Information" extends "Company Information"
{
    fields
    {
        //HS.2+
        field(50001; "ATU_PayNow QR Code"; Blob)
        {
            Caption = 'PayNow QR Code';
            SubType = Bitmap;
        }
        //HS.2-
    }
}
//HS.1-