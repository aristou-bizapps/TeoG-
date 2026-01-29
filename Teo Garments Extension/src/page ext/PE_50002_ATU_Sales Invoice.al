/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-01-20      Create new "Sales Invoice" page extension
2                               Add new action to print the "Unposted Tax Invoice" for THL Company
3                               Pull out "Remarks" field
*/

//HS.1+
pageextension 50002 "ATU_Sales Invoice" extends "Sales Invoice"
{
    layout
    {
        addlast(General)
        {
            //HS.3+
            field(ATU_Remarks; Rec.ATU_Remarks)
            {
                ApplicationArea = All;
                MultiLine = true;
            }
            //HS.3-
        }
    }

    actions
    {
        //HS.2+
        addafter(ProformaInvoice)
        {
            action("ATU_THL Tax Invoice")
            {
                ApplicationArea = All;
                Caption = 'THL Tax Invoice';
                Image = Report;
                Visible = ATU_gIsTHLCompany;

                trigger OnAction()
                var
                    ATU_lSalesHeader: Record "Sales Header";
                begin
                    CurrPage.SetSelectionFilter(ATU_lSalesHeader);
                    Report.RunModal(Report::"ATU_THL Unposted Tax Invoice", true, false, ATU_lSalesHeader);
                end;
            }
        }

        addafter(ProformaInvoice_Promoted)
        {
            actionref(ATU_THLTaxInvoice_Promoted; "ATU_THL Tax Invoice") { }
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