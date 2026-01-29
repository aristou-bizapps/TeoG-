/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-01-20      Create new "Posted Sales Credit Memos" page extension
2                               Add new action to print the "Credit Note" report
*/

//HS.1+
pageextension 50003 "ATU_Posted Sales Credit Memos" extends "Posted Sales Credit Memos"
{
    actions
    {
        //HS.2+
        addafter("&Print")
        {
            action("ATU_Credit Note")
            {
                ApplicationArea = All;
                Caption = 'Credit Note';
                Image = Report;

                trigger OnAction()
                var
                    ATU_lSalesCMHdr: Record "Sales Cr.Memo Header";
                begin
                    CurrPage.SetSelectionFilter(ATU_lSalesCMHdr);
                    Report.RunModal(Report::"ATU_Credit Note", true, false, ATU_lSalesCMHdr);
                end;
            }
        }

        addafter("&Print_Promoted")
        {
            actionref(ATU_CreditNote_Promoted; "ATU_Credit Note") { }
        }
        //HS.2-
    }
}
//HS.1-