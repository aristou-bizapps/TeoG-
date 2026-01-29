/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-01-28      Create new "Sales Order Subform" page extension
2                               Pull out new fields
*/

//HS.1+
pageextension 50011 "ATU_Sales Order Subform" extends "Sales Order Subform"
{

    layout
    {
        addafter("Unit of Measure Code")
        {
            //HS.1+
            field(ATU_Supplier; Rec.ATU_Supplier)
            {
                ApplicationArea = All;
            }
            field(ATU_Agent; Rec.ATU_Agent)
            {
                ApplicationArea = All;
            }
            field(ATU_Gender; Rec.ATU_Gender)
            {
                ApplicationArea = All;
            }
            field("ATU_Shipment Buyer Order No."; Rec."ATU_Shipment Buyer Order No.")
            {
                ApplicationArea = All;
            }
            field("ATU_Fiber Content"; Rec."ATU_Fiber Content")
            {
                ApplicationArea = All;
            }
            field(ATU_Colour; Rec.ATU_Colour)
            {
                ApplicationArea = All;
            }
            field(ATU_Dim; Rec.ATU_Dim)
            {
                ApplicationArea = All;
            }
            field(ATU_Division; Rec.ATU_Division)
            {
                ApplicationArea = All;
            }
            field(ATU_Season; Rec.ATU_Season)
            {
                ApplicationArea = All;
            }
            field(ATU_Knitted; Rec.ATU_Knitted)
            {
                ApplicationArea = All;
            }
            field("ATU_Teo Commission"; Rec."ATU_Teo Commission")
            {
                ApplicationArea = All;
            }
            field("ATU_Agent Commission"; Rec."ATU_Agent Commission")
            {
                ApplicationArea = All;
            }
            field("ATU_Factory Unit Price"; Rec."ATU_Factory Unit Price")
            {
                ApplicationArea = All;
            }
            field("ATU_Shipping Method"; Rec."ATU_Shipping Method")
            {
                ApplicationArea = All;
            }
            field("ATU_Request Ship Date"; Rec."ATU_Request Ship Date")
            {
                ApplicationArea = All;
            }
            field("ATU_Fty Shipped Date"; Rec."ATU_Fty Shipped Date")
            {
                ApplicationArea = All;
            }
            field("ATU_Factory Name"; Rec."ATU_Factory Name")
            {
                ApplicationArea = All;
            }
            field("ATU_Country of Origin"; Rec."ATU_Country of Origin")
            {
                ApplicationArea = All;
            }
            field("ATU_Port of Loading"; Rec."ATU_Port of Loading")
            {
                ApplicationArea = All;
            }
            field("ATU_Port of Discharge"; Rec."ATU_Port of Discharge")
            {
                ApplicationArea = All;
            }
            field("ATU_Country of Destination"; Rec."ATU_Country of Destination")
            {
                ApplicationArea = All;
            }
            //HS.1-
        }
    }
}
//HS.1-