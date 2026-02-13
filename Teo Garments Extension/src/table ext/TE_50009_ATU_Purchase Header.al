/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-02-02      Create new "Purchase Header" table extension
2                               Add new "Is PO Created From SO" field
3               2026-02-03      Add new "Sales Order No.", "Remarks" field
*/

//HS.1+
tableextension 50009 "ATU_Purchase Header" extends "Purchase Header"
{
    fields
    {
        //HS.2+
        field(50001; "ATU_Is PO Created From SO"; Boolean)
        {
            Caption = 'Is PO Created From SO';
        }
        //HS.2-
        //HS.3+
        field(50002; "ATU_Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            TableRelation = "Sales Header"."No." where("Document Type" = const(Order));
        }
        field(50003; ATU_Remarks; Text[500])
        {
            Caption = 'Remarks';
        }
        //HS.3-
    }
}
//HS.1-