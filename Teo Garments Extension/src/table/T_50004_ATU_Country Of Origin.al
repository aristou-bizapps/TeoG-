/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-02-02      Create new "Country Of Origin" table
*/

//HS.1+
table 50004 "ATU_Country Of Origin"
{
    Caption = 'Country of Origin';

    fields
    {
        field(50001; ATU_Code; Code[50])
        {
            Caption = 'Code';
        }
    }

    keys
    {
        key(ATU_PK; ATU_Code) { }
    }
}
//HS.1-