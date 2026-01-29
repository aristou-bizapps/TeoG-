/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-01-20      Create new "Credit Note" report
*/

//HS.1+
report 50001 "ATU_Credit Note"
{
    Caption = 'ATU Credit Note';
    DefaultRenderingLayout = "ATU_Credit Note";
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Sales Cr.Memo Header"; "Sales Cr.Memo Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.";
            RequestFilterHeading = 'Posted Sales Credit Memo';
            CalcFields = Amount, "Amount Including VAT";
            column(ATU_CompanyInfoPicture; ATU_gCompanyInfo.Picture) { }
            column(ATU_CompanyAddr1; ATU_gCompanyAddress[1]) { }
            column(ATU_CompanyAddr2; ATU_gCompanyAddress[2]) { }
            column(ATU_CompanyAddr3; ATU_gCompanyAddress[3]) { }
            column(ATU_CompanyAddr4; ATU_gCompanyAddress[4]) { }
            column(ATU_BillToAddr1; ATU_gBillToAddress[1]) { }
            column(ATU_BillToAddr2; ATU_gBillToAddress[2]) { }
            column(ATU_BillToAddr3; ATU_gBillToAddress[3]) { }
            column(ATU_BillToAddr4; ATU_gBillToAddress[4]) { }
            column(ATU_BillToAddr5; ATU_gBillToAddress[5]) { }
            column(ATU_BillToAddr6; ATU_gBillToAddress[6]) { }
            column(ATU_BillToAddr7; ATU_gBillToAddress[7]) { }
            column(ATU_InvNo; "No.") { }
            column(ATU_Date; Format("Posting Date", 0, '<Day,2>-<Month Text,3>-<Year4>')) { }
            column(ATU_Terms; "Payment Terms Code") { }
            column(ATU_YourPO; "Your Reference") { }
            column(ATU_RefNo; "External Document No.") { }
            column(ATU_Remark; ATU_Remarks) { }
            column(ATU_NetTotalAmt; Amount) { }
            column(ATU_DiscountAmt; ATU_gReportMgmt.ATU_GetDiscountAmount("Sales Cr.Memo Header")) { }
            column(ATU_TaxAmt; "Amount Including VAT" - Amount) { }
            column(ATU_TotalAmt; "Amount Including VAT") { }
            column(ATU_AmountCaption; StrSubstNo('AMOUNT(%1)', ATU_gReportMgmt.ATU_GetCurrencyCode("Currency Code"))) { }
            column(ATU_NetTotalCaption; StrSubstNo('NET TOTAL %1', ATU_gReportMgmt.ATU_GetCurrencyCode("Currency Code"))) { }
            column(ATU_TaxPercentageCaption; StrSubstNo('TAX %1%', ATU_gReportMgmt.ATU_GetTaxPercentage("Sales Cr.Memo Header"))) { }
            column(ATU_TotalCaption; StrSubstNo('TOTAL %1', ATU_gReportMgmt.ATU_GetCurrencyCode("Currency Code"))) { }
            column(ATU_ForCompanyCaption; StrSubstNo('for %1', ATU_gCompanyInfo.Name)) { }

            dataitem("Sales Cr.Memo Line"; "Sales Cr.Memo Line")
            {
                DataItemLinkReference = "Sales Cr.Memo Header";
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.");
                column(ATU_Line_RunningNo; ATU_gRunningNoFormat) { }
                column(ATU_Line_Description; Description) { }
                column(ATU_Line_Qty; Quantity) { }
                column(ATU_Line_Unit; "Unit of Measure Code") { }
                column(ATU_Line_UnitPrice; "Unit Price") { }
                column(ATU_Line_Amount; "Line Amount") { }

                trigger OnAfterGetRecord()
                begin
                    Clear(ATU_gRunningNoFormat);

                    if Type <> Type::" " then begin
                        ATU_gRunningNo += 1;
                        ATU_gRunningNoFormat := Format(ATU_gRunningNo);
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Clear(ATU_gRunningNo);

                ATU_gReportMgmt.ATU_GetCompanyAddress(ATU_gCompanyInfo, ATU_gCompanyAddress);
                ATU_gReportMgmt.ATU_GetSalesBillToAddress("Sales Cr.Memo Header", ATU_gBillToAddress);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
    }

    rendering
    {
        layout("ATU_Credit Note")
        {
            Type = RDLC;
            LayoutFile = './src/report layout/RL_50001_ATU_Credit Note.rdl';
        }
    }

    labels
    {
        ATU_ReportCaption = 'CREDIT NOTE';
        ATU_CNNoCaption = 'CREDIT NOTE NO.';
        ATU_DateCaption = 'DATE';
        ATU_TermsCaption = 'TERMS';
        ATU_YourPOCaption = 'YOUR PO';
        ATU_RefNoCaption = 'REF NO.';
        ATU_PageCaption = 'PAGE';
        ATU_RemarkCaption = 'REMARK';
        ATU_ItemCaption = 'ITEM';
        ATU_DescriptionCaption = 'DESCRIPTION';
        ATU_QtyCaption = 'QTY';
        ATU_UnitCaption = 'UNIT';
        ATU_UnitPriceCaption = 'UNIT PRICE';
        ATU_DiscountCaption = 'DISCOUNT';
    }

    trigger OnInitReport()
    begin
        ATU_gCompanyInfo.Get();
        ATU_gCompanyInfo.CalcFields(Picture);
    end;

    var
        ATU_gReportMgmt: Codeunit "ATU_Report Management";
        ATU_gCompanyInfo: Record "Company Information";
        ATU_gCompanyAddress: array[4] of Text[500];
        ATU_gBillToAddress: array[7] of Text[150];
        ATU_gRunningNo: Integer;
        ATU_gRunningNoFormat: Text[5];
}
//HS.1-