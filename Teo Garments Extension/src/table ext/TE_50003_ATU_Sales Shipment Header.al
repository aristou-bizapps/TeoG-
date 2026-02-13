/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-01-20      Create new "Sales Shipment Header" table extension
2                               Add new "Remarks" field
3               2026-02-03      Add new "Purchase Order No.", "Vendor Invoice No." field
*/

//HS.1+
tableextension 50003 "ATU_Sales Shipment Header" extends "Sales Shipment Header"
{
    fields
    {
        //HS.2+
        field(50001; ATU_Remarks; Text[2048])
        {
            Caption = 'Remarks';
        }
        //HS.2-
        //HS.3+
        field(50002; "ATU_Purchase Order No."; Code[20])
        {
            Caption = 'Purchase Order No.';
        }
        field(50003; "ATU_Vendor Invoice No."; Code[20])
        {
            Caption = 'Vendor Invoice No.';
        }
        //HS.3-
    }
}
//HS.1-