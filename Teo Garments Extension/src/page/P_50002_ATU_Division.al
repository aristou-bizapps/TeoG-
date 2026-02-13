/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-02-02      Create new "Division" page
*/

//HS.1+
page 50002 ATU_Division
{
    ApplicationArea = All;
    Caption = 'ATU Division';
    UsageCategory = Lists;
    PageType = List;
    SourceTable = ATU_Division;

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