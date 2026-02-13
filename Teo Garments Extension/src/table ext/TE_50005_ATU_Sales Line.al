/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-01-28      Create new "Sales Line" table extension
2                               Add some new fields
*/

//HS.1+
tableextension 50005 "ATU_Sales Line" extends "Sales Line"
{
    fields
    {
        //HS.2+
        field(50001; "ATU_Buyer No."; Code[20])
        {
            Caption = 'Buyer No.';
        }
        field(50002; "ATU_Buyer Name"; Text[100])
        {
            Caption = 'Buyer Name';

            trigger OnLookup()
            var
                ATU_lCustomer: Record Customer;
            begin
                ATU_lCustomer.Reset();
                if Page.RunModal(Page::"Customer List", ATU_lCustomer) = Action::LookupOK then begin
                    Rec."ATU_Buyer No." := ATU_lCustomer."No.";
                    Rec."ATU_Buyer Name" := ATU_lCustomer.Name;
                end;
            end;
        }
        field(50003; "ATU_Supplier No."; Code[20])
        {
            Caption = 'Supplier No.';
        }
        field(50004; "ATU_Supplier Name"; Text[100])
        {
            Caption = 'Supplier Name';

            trigger OnLookup()
            var
                ATU_lVendor: Record Vendor;
            begin
                ATU_lVendor.Reset();
                if Page.RunModal(Page::"Vendor List", ATU_lVendor) = Action::LookupOK then begin
                    Rec."ATU_Supplier No." := ATU_lVendor."No.";
                    Rec."ATU_Supplier Name" := ATU_lVendor.Name;
                end;
            end;
        }
        field(50005; ATU_Agent; Code[20])
        {
            Caption = 'Agent';
        }
        field(50006; ATU_Gender; Text[50])
        {
            Caption = 'Gender';
            TableRelation = ATU_Gender;
        }
        field(50007; "ATU_Shipment Buyer Order No."; Code[20])
        {
            Caption = 'Shipment Buyer Order No.';
        }
        field(50008; "ATU_Fiber Content"; Text[50])
        {
            Caption = 'Fiber Content';
        }
        field(50009; ATU_Colour; Text[50])
        {
            Caption = 'Colour';
        }
        field(50010; ATU_Dim; Code[50])
        {
            Caption = 'Dim';
        }
        field(50011; ATU_Division; Text[50])
        {
            Caption = 'Division';
            TableRelation = ATU_Division;
        }
        field(50012; ATU_Season; Code[20])
        {
            Caption = 'Season';
        }
        field(50013; ATU_Knitted; Code[20])
        {
            Caption = 'Knitted';
        }
        field(50014; "ATU_Teo Commission"; Decimal)
        {
            Caption = 'Teo Commission';
        }
        field(50015; "ATU_Agent Commission"; Decimal)
        {
            Caption = 'Agent Commission';
        }
        field(50016; "ATU_Factory Unit Price"; Decimal)
        {
            Caption = 'Factory Unit Price';
        }
        field(50017; "ATU_Shipping Method"; Code[20])
        {
            Caption = 'Shipping Method';
        }
        field(50018; "ATU_Request Ship Date"; Date)
        {
            Caption = 'Request Ship Date';
        }
        field(50019; "ATU_Factory Shipped Date"; Date)
        {
            Caption = 'Factory Shipped Date';
        }
        field(50020; "ATU_Factory Name"; Text[100])
        {
            Caption = 'Factory Name';
            TableRelation = "ATU_Factory Name";
        }
        field(50021; "ATU_Country Of Origin"; Code[50])
        {
            Caption = 'Country of Origin';
            TableRelation = "ATU_Country Of Origin";
        }
        field(50022; "ATU_Country Of Destination"; Code[50])
        {
            Caption = 'Country of Destination';
            TableRelation = "ATU_Country Of Destination";
        }
        field(50023; "ATU_Port Of Loading"; Text[50])
        {
            Caption = 'Port of Loading';
        }
        field(50024; "ATU_Port Of Discharge"; Text[50])
        {
            Caption = 'Port of Discharge';
        }
        //HS.2-
    }
}
//HS.1-