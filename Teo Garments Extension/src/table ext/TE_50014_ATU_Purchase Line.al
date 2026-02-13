/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-02-03      Create new "Purchase Line" table extension
2                               Add new "Customer PO No.", "Colour", "Code No.", "Factory Shipped Date" field
*/

//HS.1+
tableextension 50014 "ATU_Purchase Line" extends "Purchase Line"
{
    fields
    {
        //HS.2+
        field(50001; "ATU_Customer PO No."; Code[20])
        {
            Caption = 'Customer PO No.';
        }
        field(50002; ATU_Colour; Text[50])
        {
            Caption = 'Colour';
        }
        field(50003; "ATU_Code No."; Code[20])
        {
            Caption = 'Code No.';
        }
        field(50004; "ATU_Factory Shipped Date"; Date)
        {
            Caption = 'Factory Shipped Date';
        }
        //HS.2-
    }
}
//HS.1-