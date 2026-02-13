/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-02-02      Create new "Country of Destination" page
*/

//HS.1+
page 50005 "ATU_Country of Destination"
{
    ApplicationArea = All;
    Caption = 'ATU Country of Destination';
    UsageCategory = Lists;
    PageType = List;
    SourceTable = "ATU_Country Of Destination";

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