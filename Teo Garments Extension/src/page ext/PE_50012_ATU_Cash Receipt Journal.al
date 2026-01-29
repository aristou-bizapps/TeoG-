/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-01-28      Create new "Cash Receipt Journal" page extension
2                               Add new action to print the "Cash Receipt Voucher" report
*/

//HS.1+
pageextension 50012 "ATU_Cash Receipt Journal" extends "Cash Receipt Journal"
{
    actions
    {
        //HS.2+
        addafter("Apply Entries")
        {
            action("ATU_Cash Receipt Voucher")
            {
                ApplicationArea = All;
                Caption = 'Cash Receipt Voucher';
                Image = Report;

                trigger OnAction()
                var
                    ATU_lGJL: Record "Gen. Journal Line";
                begin
                    ATU_lGJL.Reset();
                    ATU_lGJL.SetRange("Journal Template Name", Rec."Journal Template Name");
                    ATU_lGJL.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    ATU_lGJL.SetRange("Account Type", ATU_lGJL."Account Type"::Customer);
                    if ATU_lGJL.FindSet() then
                        Report.RunModal(Report::"ATU_Cash Receipt Voucher", true, false, ATU_lGJL);
                end;
            }
        }

        addafter("Apply Entries_Promoted")
        {
            actionref(ATUCashReceiptVoucher_Promoted; "ATU_Cash Receipt Voucher") { }
        }
        //HS.2-
    }
}
//HS.1-