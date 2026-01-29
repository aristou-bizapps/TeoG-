/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-01-20      Create new "Posted Sales Invoices" page extension
2                               Add new action to print the "Debit Note" report
*/

//HS.1+
pageextension 50005 "ATU_Posted Sales Invoices" extends "Posted Sales Invoices"
{
    actions
    {
        //HS.2+
        addafter(Print)
        {
            action("ATU_Debit Note")
            {
                ApplicationArea = All;
                Caption = 'Debit Note';
                Image = Report;

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
            actionref(ATU_DebitNote_Promoted; "ATU_Debit Note") { }
        }
        //HS.2-
    }

    trigger OnOpenPage()
    begin
        ATU_gIsTHLCompany := ATU_gFunctionMgmt.ATU_IsTHLCompany();
    end;

    var
        ATU_gFunctionMgmt: Codeunit "ATU_Function Management";
        ATU_gIsTHLCompany: Boolean;
}
//HS.1-