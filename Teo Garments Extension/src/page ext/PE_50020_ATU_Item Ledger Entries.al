/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-02-04      Create new "Item Ledger Entries" page extension
2                               Pull out new fields
*/

//HS.1+
pageextension 50020 "ATU_Item Ledger Entries" extends "Item Ledger Entries"
{
    layout
    {
        //HS.2+
        addafter("Location Code")
        {
            field("ATU_Buyer No."; Rec."ATU_Buyer No.")
            {
                ApplicationArea = All;
            }
            field("ATU_Buyer Name"; Rec."ATU_Buyer Name")
            {
                ApplicationArea = All;
            }
            field("ATU_Supplier No."; Rec."ATU_Supplier No.")
            {
                ApplicationArea = All;
            }
            field("ATU_Supplier Name"; Rec."ATU_Supplier Name")
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
            field("ATU_Factory Shipped Date"; Rec."ATU_Factory Shipped Date")
            {
                ApplicationArea = All;
            }
            field("ATU_Factory Name"; Rec."ATU_Factory Name")
            {
                ApplicationArea = All;
            }
            field("ATU_Country Of Origin"; Rec."ATU_Country Of Origin")
            {
                ApplicationArea = All;
            }
            field("ATU_Country Of Destination"; Rec."ATU_Country Of Destination")
            {
                ApplicationArea = All;
            }
            field("ATU_Port Of Loading"; Rec."ATU_Port Of Loading")
            {
                ApplicationArea = All;
            }
            field("ATU_Port Of Discharge"; Rec."ATU_Port Of Discharge")
            {
                ApplicationArea = All;
            }
            field("ATU_Code No."; Rec."ATU_Code No.")
            {
                ApplicationArea = All;
            }
        }
        //HS.2-
    }
}
//HS.1-