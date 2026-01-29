/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-01-28      Create new "Sales Invoice Line" table extension
2                               Add some new fields
*/

//HS.1+
tableextension 50006 "ATU_Sales Invoice Line" extends "Sales Invoice Line"
{
    fields
    {
        //HS.2+
        field(50001; ATU_Supplier; Code[20])
        {
            Caption = 'Supplier';
        }
        field(50002; ATU_Agent; Code[20])
        {
            Caption = 'Agent';
        }
        field(50003; ATU_Gender; Text[150])
        {
            Caption = 'Gender';
        }
        field(50004; "ATU_Shipment Buyer Order No."; Code[20])
        {
            Caption = 'Shipment Buyer Order No.';
        }
        field(50005; "ATU_Fiber Content"; Text[150])
        {
            Caption = 'Fiber Content';
        }
        field(50006; ATU_Colour; Text[150])
        {
            Caption = 'Colour';
        }
        field(50007; ATU_Dim; Code[20])
        {
            Caption = 'Dim';
        }
        field(50008; ATU_Division; Text[150])
        {
            Caption = 'Division';
        }
        field(50009; ATU_Season; Code[20])
        {
            Caption = 'Season';
        }
        field(50010; ATU_Knitted; Code[20])
        {
            Caption = 'Knitted';
        }
        field(50011; "ATU_Teo Commission"; Decimal)
        {
            Caption = 'Teo Commission';
        }
        field(50012; "ATU_Agent Commission"; Decimal)
        {
            Caption = 'Agent Commission';
        }
        field(50013; "ATU_Shipping Method"; Code[20])
        {
            Caption = 'Shipping Method';
        }
        field(50014; "ATU_Request Ship Date"; Date)
        {
            Caption = 'Request Ship Date';
        }
        field(50015; "ATU_Fty Shipped Date"; Date)
        {
            Caption = 'Fty Shipped Date';
        }
        field(50016; "ATU_Factory Name"; Text[150])
        {
            Caption = 'Factory Name';
        }
        field(50017; "ATU_Country of Origin"; Code[20])
        {
            Caption = 'Country of Origin';
        }
        field(50018; "ATU_Port of Loading"; Text[150])
        {
            Caption = 'Port of Loading';
        }
        field(50019; "ATU_Port of Discharge"; Text[150])
        {
            Caption = 'Port of Discharge';
        }
        field(50020; "ATU_Country of Destination"; Code[20])
        {
            Caption = 'Country of Destination';
        }
        field(50021; "ATU_Factory Unit Price"; Decimal)
        {
            Caption = 'Factory Unit Price';
        }
        //HS.2-
    }
}
//HS.1-