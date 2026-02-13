/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-02-02      Create new "Factory Name" page
*/

//HS.1+
page 50003 "ATU_Factory Name"
{
    ApplicationArea = All;
    Caption = 'ATU Factory Name';
    UsageCategory = Lists;
    PageType = List;
    SourceTable = "ATU_Factory Name";

    layout
    {
        area(Content)
        {
            repeater(ATU_General)
            {
                Caption = 'General';
                field(ATU_Name; Rec.ATU_Name)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
//HS.1-