/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-01-21      Create new "THL Posted Tax Invoice" report
*/

//HS.1+
report 50007 "ATU_THL Posted Tax Invoice"
{
    Caption = 'ATU THL Tax Invoice';
    DefaultRenderingLayout = "ATU_THL Posted Tax Invoice";
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.";
            RequestFilterHeading = 'Sales Invoice Header';
            CalcFields = Amount, "Amount Including VAT";
            column(ATU_CompanyInfoPicture; ATU_gCompanyInfo.Picture) { }
            column(ATU_CompanyAddr1; ATU_gCompanyAddress[1]) { }
            column(ATU_CompanyAddr2; ATU_gCompanyAddress[2]) { }
            column(ATU_CompanyAddr3; ATU_gCompanyAddress[3]) { }
            column(ATU_CompanyAddr4; ATU_gCompanyAddress[4]) { }
            column(ATU_CompanyAddr5; ATU_gCompanyAddress[5]) { }
            column(ATU_BillToAddr1; ATU_gBillToAddress[1]) { }
            column(ATU_BillToAddr2; ATU_gBillToAddress[2]) { }
            column(ATU_BillToAddr3; ATU_gBillToAddress[3]) { }
            column(ATU_BillToAddr4; ATU_gBillToAddress[4]) { }
            column(ATU_BillToAddr5; ATU_gBillToAddress[5]) { }
            column(ATU_BillToAddr6; ATU_gBillToAddress[6]) { }
            column(ATU_BillToAddr7; ATU_gBillToAddress[7]) { }
            column(ATU_InvoiceNo; "No.") { }
            column(ATU_Date; Format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(ATU_Remarks; ATU_Remarks) { }
            column(ATU_SubTotalAmt; Amount) { }
            column(ATU_DiscountAmt; ATU_gReportMgmt.ATU_GetDiscountAmount("Sales Invoice Header")) { }
            column(ATU_GSTAmt; "Amount Including VAT" - Amount) { }
            column(ATU_TotalAmt; "Amount Including VAT") { }
            column(ATU_TotalAmtInText; ATU_gTotalAmtInText) { }
            column(ATU_BankTransfer; StrSubstNo('Bank Transfer: %1', ATU_gCompanyInfo."Bank Name")) { }
            column(ATU_BankCode; StrSubstNo('Bank Code: %1', ATU_gReportMgmt.ATU_GetBankCode(ATU_gCompanyInfo."Bank Account No."))) { }
            column(ATU_BankAccountNo; StrSubstNo('Account Number: %1', ATU_gCompanyInfo."Bank Account No.")) { }
            column(ATU_PayNowUEN; StrSubstNo('PayNow UEN: %1', ATU_gCompanyInfo."Registration No.")) { }
            column(ATU_PayNowQRCode; '') { }
            column(ATU_AmountCaption; StrSubstNo('AMOUNT %1', ATU_gReportMgmt.ATU_GetCurrencyCode("Currency Code"))) { }
            column(ATU_GSTPercentageCaption; StrSubstNo('GST %1%', ATU_gReportMgmt.ATU_GetTaxPercentage("Sales Invoice Header"))) { }
            column(ATU_TotalAmtCaption; StrSubstNo('TOTAL (%1)', ATU_gReportMgmt.ATU_GetCurrencyCode("Currency Code"))) { }

            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLinkReference = "Sales Invoice Header";
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.");
                column(ATU_Line_RunningNo; ATU_gRunningNoFormat) { }
                column(ATU_Line_RefNo; "No.") { }
                column(ATU_Line_Description; Description) { }
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
                Clear(ATU_gTotalAmtInText);

                ATU_gReportMgmt.ATU_GetCompanyAddressForTHL(ATU_gCompanyInfo, ATU_gCompanyAddress);
                ATU_gReportMgmt.ATU_GetSalesBillToAddress("Sales Invoice Header", ATU_gBillToAddress);

                ATU_gTotalAmtInText := ATU_gConvertAmtInWord.ATU_FormatNoText("Amount Including VAT", ATU_gReportMgmt.ATU_GetCurrencyCode("Currency Code"), 'CENTS');
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
    }

    rendering
    {
        layout("ATU_THL Posted Tax Invoice")
        {
            Type = RDLC;
            LayoutFile = './src/report layout/RL_50007_ATU_THL Posted Tax Invoice.rdl';
        }
    }

    labels
    {
        ATU_ReportCaption = 'TAX INVOICE';
        ATU_PageCaption = 'Page';
        ATU_ToCaption = 'TO:';
        ATU_DateCaption = 'DATE';
        ATU_InvoiceNoCaption = 'INVOICE NO.';
        ATU_RemarksCaption = 'REMARKS:';
        ATU_SNoCaption = 'SNo';
        ATU_RefNoCaption = 'REF NO.';
        ATU_DescriptionCaption = 'DESCRIPTION';
        ATU_SubTotalCaption = 'SUBTOTAL';
        ATU_DiscountCaption = 'DISCOUNT';
        ATU_Footer1Caption = 'This is a computer-generated invoice.';
        ATU_Footer2Caption = 'No signature is required.';
        ATU_Footer3Caption = 'E. &. O. E';
        ATU_CrossedChequeCaption = 'Crossed cheque is to be made payable to:';
    }

    trigger OnInitReport()
    begin
        ATU_gCompanyInfo.Get();
        ATU_gCompanyInfo.CalcFields(Picture);
    end;

    var
        ATU_gReportMgmt: Codeunit "ATU_Report Management";
        ATU_gConvertAmtInWord: Codeunit "ATU_Convert Amount In Word";
        ATU_gCompanyInfo: Record "Company Information";
        ATU_gCompanyAddress: array[5] of Text[500];
        ATU_gBillToAddress: array[7] of Text[150];
        ATU_gRunningNo: Integer;
        ATU_gRunningNoFormat: Text[5];
        ATU_gTotalAmtInText: Text;
}
//HS.1-