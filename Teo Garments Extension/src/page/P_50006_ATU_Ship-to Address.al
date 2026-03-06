/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-03-02      Create new "Ship-to Address" page
*/

//HS.1+
page 50006 "ATU_Ship-to Address"
{
    ApplicationArea = All;
    Caption = 'ATU Ship-to Address';
    UsageCategory = Lists;
    PageType = List;
    SourceTable = "ATU_Ship-to Address";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(ATU_General)
            {
                Caption = 'General';
                field("ATU_Vendor No."; Rec."ATU_Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("ATU_Ship-to Address"; Rec."ATU_Ship-to Address")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
//HS.1-