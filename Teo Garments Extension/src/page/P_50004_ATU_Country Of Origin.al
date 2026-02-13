/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-02-02      Create new "Country of Origin" page
*/

//HS.1+
page 50004 "ATU_Country of Origin"
{
    ApplicationArea = All;
    Caption = 'ATU Country of Origin';
    UsageCategory = Lists;
    PageType = List;
    SourceTable = "ATU_Country Of Origin";

    layout
    {
        area(Content)
        {
            repeater(ATU_General)
            {
                Caption = 'General';
                field(ATU_Code; Rec.ATU_Code)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
//HS.1-