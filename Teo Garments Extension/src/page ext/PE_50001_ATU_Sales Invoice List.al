/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-01-20      Create new "Sales Invoice List" page extension
2                               Add new action to print the "Unposted Tax Invoice" for THL Company
*/

//HS.1+
pageextension 50001 "ATU_Sales Invoice List" extends "Sales Invoice List"
{
    actions
    {
        //HS.2+
        addafter("P&osting")
        {
            group("ATU_Print/Send")
            {
                Caption = 'Print/Send';
                Visible = ATU_gIsTHLCompany;
                action("ATU_THL Tax Invoice")
                {
                    ApplicationArea = All;
                    Caption = 'THL Tax Invoice';
                    Image = Report;

                    trigger OnAction()
                    var
                        ATU_lSalesHeader: Record "Sales Header";
                    begin
                        CurrPage.SetSelectionFilter(ATU_lSalesHeader);
                        Report.RunModal(Report::"ATU_THL Unposted Tax Invoice", true, false, ATU_lSalesHeader);
                    end;
                }
            }
        }

        addafter(Category_Category5)
        {
            group(ATU_PrintSend_Promoted)
            {
                Caption = 'Print/Send';
                Visible = ATU_gIsTHLCompany;
                actionref(ATU_THLTaxInvoice_Promoted; "ATU_THL Tax Invoice") { }
            }
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