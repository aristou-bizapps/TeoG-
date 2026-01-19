report 50202 "ATU_Debit Note"
{
    Caption = 'ATU Debit Note';
    DefaultRenderingLayout = "ATU_Debit Note";
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.";
            RequestFilterHeading = 'Posted Sales Invoice';
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
            column(ATU_InvNo; "No.") { }
            column(ATU_Date; Format("Posting Date", 0, '<Day,2>-<Month Text,3>-<Year4>')) { }
            column(ATU_Terms; "Payment Terms Code") { }
            column(ATU_YourPO; "Your Reference") { }
            column(ATU_RefNo; "External Document No.") { }
            column(ATU_Remark; '') { }
            column(ATU_NetTotalAmt; Amount) { }
            column(ATU_DiscountAmt; ATU_gReportMgmt.ATU_GetDiscountAmount("Sales Invoice Header")) { }
            column(ATU_TaxAmt; "Amount Including VAT" - Amount) { }
            column(ATU_TotalAmt; "Amount Including VAT") { }
            column(ATU_AmountCaption; StrSubstNo('AMOUNT(%1)', ATU_gReportMgmt.ATU_GetCurrencyCode("Currency Code"))) { }
            column(ATU_NetTotalCaption; StrSubstNo('NET TOTAL %1', ATU_gReportMgmt.ATU_GetCurrencyCode("Currency Code"))) { }
            column(ATU_TaxPercentageCaption; StrSubstNo('TAX %1%', ATU_gReportMgmt.ATU_GetTaxPercentage("Sales Invoice Header"))) { }
            column(ATU_TotalCaption; StrSubstNo('TOTAL %1', ATU_gReportMgmt.ATU_GetCurrencyCode("Currency Code"))) { }
            column(ATU_ForCompanyCaption; StrSubstNo('for %1', ATU_gCompanyInfo.Name)) { }

            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLinkReference = "Sales Invoice Header";
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
                ATU_gReportMgmt.ATU_GetSalesBillToAddress("Sales Invoice Header", ATU_gBillToAddress);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
    }

    rendering
    {
        layout("ATU_Debit Note")
        {
            Type = RDLC;
            LayoutFile = './src/report layout/RL_50202_ATU_Debit Note.rdl';
        }
    }

    labels
    {
        ATU_ReportCaption = 'DEBIT NOTE';
        ATU_InvNoCaption = 'INV NO.';
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
        ATU_gBillToAddress: array[5] of Text[150];
        ATU_gRunningNo: Integer;
        ATU_gRunningNoFormat: Text[5];
}