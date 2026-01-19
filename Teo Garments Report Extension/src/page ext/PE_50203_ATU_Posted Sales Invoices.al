pageextension 50203 "ATU_Posted Sales Invoices" extends "Posted Sales Invoices"
{
    actions
    {
        addafter(Print)
        {
            action("ATU_Print Debit Note")
            {
                ApplicationArea = All;
                Caption = 'Print Debit Note';
                Image = Print;

                trigger OnAction()
                var
                    ATU_lSalesInvHdr: Record "Sales Invoice Header";
                begin
                    CurrPage.SetSelectionFilter(ATU_lSalesInvHdr);
                    Report.RunModal(Report::"ATU_Debit Note", true, false, ATU_lSalesInvHdr);
                end;
            }
        }
        addafter(Print_Promoted)
        {
            actionref(ATU_PrintDebitNote_Promoted; "ATU_Print Debit Note") { }
        }
    }
}