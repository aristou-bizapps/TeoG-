/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-01-20      Create new "Tax Invoice" report
*/

//HS.1+
report 50003 "ATU_Tax Invoice"
{
    Caption = 'ATU Tax Invoice';
    DefaultRenderingLayout = "ATU_Tax Invoice";
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
            column(ATU_ShipToAddr1; ATU_gShipToAddress[1]) { }
            column(ATU_ShipToAddr2; ATU_gShipToAddress[2]) { }
            column(ATU_ShipToAddr3; ATU_gShipToAddress[3]) { }
            column(ATU_ShipToAddr4; ATU_gShipToAddress[4]) { }
            column(ATU_ShipToAddr5; ATU_gShipToAddress[5]) { }
            column(ATU_InvoiceNo; "No.") { }
            column(ATU_Date; Format("Posting Date", 0, '<Day,2>-<Month Text,3>-<Year4>')) { }
            column(ATU_SalesTerm; "Payment Terms Code") { }
            column(ATU_DateOfExport; '') { }
            column(ATU_CountryOfOrigin; '') { }
            column(ATU_PortOfLoading; '') { }
            column(ATU_PortOfDischarge; '') { }
            column(ATU_FinalDestination; '') { }
            column(ATU_PONo; "External Document No.") { }
            column(ATU_SubTotalAmt; Amount) { }
            column(ATU_DiscountAmt; ATU_gReportMgmt.ATU_GetDiscountAmount("Sales Invoice Header")) { }
            column(ATU_TaxAmt; "Amount Including VAT" - Amount) { }
            column(ATU_TotalAmt; "Amount Including VAT") { }
            column(ATU_AmountCaption; StrSubstNo('AMOUNT(%1)', ATU_gReportMgmt.ATU_GetCurrencyCode("Currency Code"))) { }
            column(ATU_DiscountPercentageCaption; StrSubstNo('DISCOUNT %1%', ATU_gReportMgmt.ATU_GetDiscountPercentage("Sales Invoice Header"))) { }
            column(ATU_TaxPercentageCaption; StrSubstNo('TAX %1%', ATU_gReportMgmt.ATU_GetTaxPercentage("Sales Invoice Header"))) { }
            column(ATU_TotalCaption; StrSubstNo('TOTAL (%1)', ATU_gReportMgmt.ATU_GetCurrencyCode("Currency Code"))) { }
            column(ATU_ForCompanyCaption; StrSubstNo('for %1', UpperCase(ATU_gCompanyInfo.Name))) { }
            column(ATU_ReportCaption; ATU_gReportCaption) { }

            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLinkReference = "Sales Invoice Header";
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.");
                column(ATU_Line_RunningNo; ATU_gRunningNoFormat) { }
                column(ATU_Line_StyleNo; "No.") { }
                column(ATU_Line_Description; Description) { }
                column(ATU_Line_Quantity; Quantity) { }
                column(ATU_Line_UOM; "Unit of Measure Code") { }
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
                ATU_gReportMgmt.ATU_GetSalesShipToAddress("Sales Invoice Header", ATU_gShipToAddress);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
    }

    rendering
    {
        layout("ATU_Tax Invoice")
        {
            Type = RDLC;
            LayoutFile = './src/report layout/RL_50003_ATU_Tax Invoice.rdl';
        }
    }

    labels
    {
        ATU_PageCaption = 'Page';
        ATU_ToCaption = 'TO:';
        ATU_ShipperExporterCaption = 'SHIPPER/EXPORTER:';
        ATU_DateCaption = 'DATE';
        ATU_InvoiceNoCaption = 'INVOICE NO.';
        ATU_SalesTermCaption = 'SALES TERM';
        ATU_DateOfExportCaption = 'DATE OF EXPORT';
        ATU_CountryOfOriginCaption = 'COUNTRY OF ORIGIN';
        ATU_PortOfLoadingCaption = 'PORT OF LOADING';
        ATU_FinalDestinationCaption = 'FINAL DESTINATION';
        ATU_PortOfDischargeCaption = 'PORT OF DISCHARGE';
        ATU_PONoCaption = 'PO NO.';
        ATU_SNCaption = 'S/N';
        ATU_StyleNoCaption = 'STYLE NO.';
        ATU_DescriptionCaption = 'DESCRIPTION';
        ATU_QuantityCaption = 'QUANTITY';
        ATU_UOMCaption = 'UOM';
        ATU_UnitPriceCaption = 'UNIT PRICE';
        ATU_SubTotalCaption = 'SUB TOTAL';

    }

    trigger OnInitReport()
    begin
        ATU_gCompanyInfo.Get();
        ATU_gCompanyInfo.CalcFields(Picture);

        ATU_gIsTGCCompany := ATU_gFunctionMgmt.ATU_IsTGCCompany();
        if ATU_gIsTGCCompany then
            ATU_gReportCaption := 'TAX INVOICE'
        else
            ATU_gReportCaption := 'INVOICE';
    end;

    var
        ATU_gReportMgmt: Codeunit "ATU_Report Management";
        ATU_gFunctionMgmt: Codeunit "ATU_Function Management";
        ATU_gCompanyInfo: Record "Company Information";
        ATU_gCompanyAddress: array[4] of Text[500];
        ATU_gBillToAddress, ATU_gShipToAddress : array[5] of Text[150];
        ATU_gRunningNo: Integer;
        ATU_gRunningNoFormat: Text[5];
        ATU_gIsTGCCompany: Boolean;
        ATU_gReportCaption: Text[20];
}
//HS.1-