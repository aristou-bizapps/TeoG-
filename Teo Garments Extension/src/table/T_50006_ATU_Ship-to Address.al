/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-03-02      Create new "Ship-to Address" table
*/

//HS.1+
table 50006 "ATU_Ship-to Address"
{
    Caption = 'Ship-to Address';

    fields
    {
        field(50001; "ATU_Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(50002; "ATU_Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(50003; "ATU_Ship-to Address"; Text[150])
        {
            Caption = 'Ship-to Address';
        }
    }

    keys
    {
        key(ATU_PK; "ATU_Entry No.")
        {
            Clustered = true;
        }
    }
}
//HS.1-