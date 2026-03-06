/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-02-04      Create new "Gen. Journal Line" table extension
2                               Add new "Purchase Order No.", "Sales Order No." fields
3               2026-03-05      Add new "Manual Invoice No." field
*/

//HS.1+
tableextension 50019 "ATU_Gen. Journal Line" extends "Gen. Journal Line"
{
    fields
    {
        //HS.2+
        field(50001; "ATU_Purchase Order No."; Code[20])
        {
            Caption = 'Purchase Order No.';
        }
        field(50002; "ATU_Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
        }
        //HS.2-
        //HS.3+
        field(50003; "ATU_Manual Invoice No."; Code[20])
        {
            Caption = 'Manual Invoice No.';
        }
        //HS.3-
    }
}
//HS.1-