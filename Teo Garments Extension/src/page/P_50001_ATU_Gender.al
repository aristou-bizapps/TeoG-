/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-02-02      Create new "Gender" page
*/

//HS.1+
page 50001 ATU_Gender
{
    ApplicationArea = All;
    Caption = 'ATU Gender';
    UsageCategory = Lists;
    PageType = List;
    SourceTable = ATU_Gender;

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