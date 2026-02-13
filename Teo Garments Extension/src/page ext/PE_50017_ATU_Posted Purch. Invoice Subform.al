/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-02-04      Create new "Posted Purch. Invoice Subform" page extension
2                               Pull out "Customer PO No.", "Colour", "Code No.", "Factory Shipped Date" field
*/

//HS.1+
pageextension 50017 "ATU_Posted Purch. Inv. Subform" extends "Posted Purch. Invoice Subform"
{
    layout
    {
        //HS.2+
        addafter(Quantity)
        {
            field("ATU_Customer PO No."; Rec."ATU_Customer PO No.")
            {
                ApplicationArea = All;
            }
            field(ATU_Colour; Rec.ATU_Colour)
            {
                ApplicationArea = All;
            }
            field("ATU_Code No."; Rec."ATU_Code No.")
            {
                ApplicationArea = All;
            }
            field("ATU_Factory Shipped Date"; Rec."ATU_Factory Shipped Date")
            {
                ApplicationArea = All;
            }
        }
        //HS.2-
    }
}
//HS.1-