pageextension 50201 "ATU_Posted Sales Credit Memos" extends "Posted Sales Credit Memos"
{
    actions
    {
        addafter("&Print")
        {
            action("ATU_Print Credit Note")
            {
                ApplicationArea = All;
                Caption = 'Print Credit Note';
                Image = Print;

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
            actionref(ATU_PrintCreditNote_Promoted; "ATU_Print Credit Note") { }
        }
    }
}