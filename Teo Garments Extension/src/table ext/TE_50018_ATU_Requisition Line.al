/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-02-04      Create new "Requisition Line" table extension
2                               Add some new fields
*/

//HS.1+
tableextension 50018 "ATU_Requisition Line" extends "Requisition Line"
{
    fields
    {
        //HS.2+
        field(50001; "ATU_Shipment Buyer Order No."; Code[20])
        {
            Caption = 'Shipment Buyer Order No.';
        }
        field(50002; ATU_Colour; Text[150])
        {
            Caption = 'Colour';
        }
        field(50003; "ATU_Factory Unit Price"; Decimal)
        {
            Caption = 'Factory Unit Price';
        }
        field(50004; "ATU_Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
        }
        field(50005; "ATU_Factory Shipped Date"; Date)
        {
            Caption = 'Factory Shipped Date';
        }
        //HS.2-
    }
}
//HS.1-