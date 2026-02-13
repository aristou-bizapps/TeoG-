/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-02-02      Create new "Gender" table
*/

//HS.1+
table 50001 ATU_Gender
{
    Caption = 'Gender';

    fields
    {
        field(50001; ATU_Name; Text[50])
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