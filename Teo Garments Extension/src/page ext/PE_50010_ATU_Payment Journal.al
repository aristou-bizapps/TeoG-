/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-01-25      Create new "Payment Journal" page extension
2                               Add new action to print the "Payment Voucher" report
*/

//HS.1+
pageextension 50010 "ATU_Payment Journal" extends "Payment Journal"
{
    actions
    {
        //HS.2+
        addafter(ApplyEntries)
        {
            action("ATU_Payment Voucher")
            {
                ApplicationArea = All;
                Caption = 'Payment Voucher';
                Image = Report;

                trigger OnAction()
                var
                    ATU_lGJL: Record "Gen. Journal Line";
                begin
                    ATU_lGJL.Reset();
                    ATU_lGJL.SetRange("Journal Template Name", Rec."Journal Template Name");
                    ATU_lGJL.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    ATU_lGJL.SetRange("Document No.", Rec."Document No.");
                    if ATU_lGJL.FindSet() then
                        Report.RunModal(Report::"ATU_Payment Voucher", true, false, ATU_lGJL);
                end;
            }
        }

        addafter(ApplyEntries_Promoted)
        {
            actionref(ATUPaymentVoucher_Promoted; "ATU_Payment Voucher") { }
        }
        //HS.2-
    }
}
//HS.1-