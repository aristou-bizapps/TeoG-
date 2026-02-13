/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-02-02      Create new "Factory Name" table
*/

//HS.1+
table 50003 "ATU_Factory Name"
{
    Caption = 'Factory Name';

    fields
    {
        field(50001; ATU_Name; Text[100])
        {
            Caption = 'Name';
        }
    }

    keys
    {
        key(ATU_PK; ATU_Name) { }
    }
}
//HS.1-