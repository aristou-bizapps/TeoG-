/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-01-20      Create new "Purchase Order Standard" report
*/

//HS.1+
report 50005 "ATU_Purchase Order Standard"
{
    Caption = 'ATU Purchase Order Standard';
    DefaultRenderingLayout = "ATU_Purchase Order Standard";
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Order));
            RequestFilterFields = "Document Type", "No.", "Sell-to Customer No.";
            RequestFilterHeading = 'Purchase Header';
            CalcFields = Amount, "Amount Including VAT";
            column(ATU_CompanyInfoPicture; ATU_gCompanyInfo.Picture) { }
            column(ATU_CompanyAddr1; ATU_gCompanyAddress[1]) { }
            column(ATU_CompanyAddr2; ATU_gCompanyAddress[2]) { }
            column(ATU_CompanyAddr3; ATU_gCompanyAddress[3]) { }
            column(ATU_CompanyAddr4; ATU_gCompanyAddress[4]) { }
            column(ATU_BuyFromAddr1; ATU_gBuyFromAddress[1]) { }
            column(ATU_BuyFromAddr2; ATU_gBuyFromAddress[2]) { }
            column(ATU_BuyFromAddr3; ATU_gBuyFromAddress[3]) { }
            column(ATU_BuyFromAddr4; ATU_gBuyFromAddress[4]) { }
            column(ATU_BuyFromAddr5; ATU_gBuyFromAddress[5]) { }
            column(ATU_BuyFromAddr6; ATU_gBuyFromAddress[6]) { }
            column(ATU_ShipToAddr1; ATU_gShipToAddress[1]) { }
            column(ATU_ShipToAddr2; ATU_gShipToAddress[2]) { }
            column(ATU_ShipToAddr3; ATU_gShipToAddress[3]) { }
            column(ATU_ShipToAddr4; ATU_gShipToAddress[4]) { }
            column(ATU_ShipToAddr5; ATU_gShipToAddress[5]) { }
            column(ATU_ShipToAddr6; ATU_gShipToAddress[6]) { }
            column(ATU_PayToAddr1; ATU_gPayToAddress[1]) { }
            column(ATU_PayToAddr2; ATU_gPayToAddress[2]) { }
            column(ATU_PayToAddr3; ATU_gPayToAddress[3]) { }
            column(ATU_PayToAddr4; ATU_gPayToAddress[4]) { }
            column(ATU_PayToAddr5; ATU_gPayToAddress[5]) { }
            column(ATU_PayToAddr6; ATU_gPayToAddress[6]) { }
            column(ATU_IsPOPendingApproval; ATU_gReportMgmt.ATU_IsPOPendingApproval(Status)) { }
            column(ATU_DocumentNo; "No.") { }
            column(ATU_Date; Format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(ATU_RevisionDateRefNo; '') { }
            column(ATU_Buyer; '') { }
            column(ATU_SeasonSuppRef; '') { }
            column(ATU_DeliveryDate; Format("Expected Receipt Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
            column(ATU_Currency; ATU_gReportMgmt.ATU_GetCurrencyCode("Currency Code")) { }
            column(ATU_TradeTerm; '') { }
            column(ATU_SalesTerm; "Payment Terms Code") { }
            column(ATU_NetTotalAmt; Amount) { }
            column(ATU_TaxTotalAmt; "Amount Including VAT" - Amount) { }
            column(ATU_TotalAmt; "Amount Including VAT") { }
            column(ATU_Remarks; ATU_Remarks) { }
            column(ATU_IssuedBy; UserId) { }
            column(ATU_VerifiedBy; '') { }
            column(ATU_ApprovedBy; ATU_gReportMgmt.ATU_GetPOApprovedBy("Purchase Header")) { }

            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLinkReference = "Purchase Header";
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
                column(ATU_Line_RunningNo; ATU_gRunningNoFormat) { }
                column(ATU_Line_StyleNo; "No.") { }
                column(ATU_Line_ItemNo; ATU_gItemNo) { }
                column(ATU_Line_Description; Description) { }
                column(ATU_Line_CustomerPONo; "ATU_Customer PO No.") { }
                column(ATU_Line_Colour; ATU_Colour) { }
                column(ATU_Line_Unit; "Unit of Measure Code") { }
                column(ATU_Line_Qty; Quantity) { }
                column(ATU_Line_Price; "Direct Unit Cost") { }
                column(ATU_Line_Total; "Line Amount") { }

                trigger OnAfterGetRecord()
                begin
                    Clear(ATU_gRunningNoFormat);
                    Clear(ATU_gItemNo);

                    if Type <> Type::" " then begin
                        ATU_gRunningNo += 1;
                        ATU_gRunningNoFormat := Format(ATU_gRunningNo);

                        if Type = Type::Item then
                            ATU_gItemNo := "No.";
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Clear(ATU_gRunningNo);

                ATU_gReportMgmt.ATU_GetCompanyAddress(ATU_gCompanyInfo, ATU_gCompanyAddress);
                ATU_gReportMgmt.ATU_GetPurchaseBuyFromAddress("Purchase Header", ATU_gBuyFromAddress);
                ATU_gReportMgmt.ATU_GetPurchaseShipToAddress("Purchase Header", ATU_gShipToAddress);
                ATU_gReportMgmt.ATU_GetPurchasePayToAddress("Purchase Header", ATU_gPayToAddress);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
    }

    rendering
    {
        layout("ATU_Purchase Order Standard")
        {
            Type = RDLC;
            LayoutFile = './src/report layout/RL_50005_ATU_Purchase Order Standard.rdl';
        }
    }

    labels
    {
        ATU_ReportCaption = 'PURCHASE ORDER-STANDARD';
        ATU_PendingApprovalCaption = 'PENDING APPROVAL';
        ATU_DateCaption = 'DATE:';
        ATU_RevisionDateRefNoCaption = 'Revision Date (Ref No.):';
        ATU_NoCaption = 'NO.:';
        ATU_PagesCaption = 'Pages:';
        ATU_SupplierAddressCaption = 'Supplier Address:';
        ATU_DeliveryAddressCaption = 'Delivery Address:';
        ATU_BillingAddressCaption = 'Billing Address:';
        ATU_BuyerCaption = 'Buyer';
        ATU_SeasonSuppRefCaption = 'Season (SuppRef)';
        ATU_DeliveryCaption = 'Delivery (dd/mm/yyyy)';
        ATU_CurrencyCaption = 'Currency';
        ATU_TradeTermCaption = 'Trade Term';
        ATU_SalesTermCaption = 'Sales Term';
        ATU_ItemCaption = 'ITEM';
        ATU_ItemNoCaption = 'ITEM NO.';
        ATU_StyleNoCaption = 'STYLE NO.';
        ATU_DescriptionCaption = 'DESCRIPTION';
        ATU_CustomerPONoCaption = 'CUSTOMER PO#';
        ATU_ColourCaption = 'COLOUR';
        ATU_UnitCaption = 'UNIT';
        ATU_QtyCaption = 'QTY';
        ATU_PriceCaption = 'PRICE';
        ATU_TotalCaption = 'TOTAL';
        ATU_RemarksCaption = 'Remarks:';
        ATU_NetTotalCaption = 'NET TOTAL';
        ATU_TaxTotalCaption = 'TAX TOTAL';
        ATU_IssuedByCaption = 'ISSUED BY';
        ATU_VerifiedByCaption = 'VERIFIED BY';
        ATU_ApprovedByCaption = 'APPROVED BY';
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
        ATU_gBuyFromAddress, ATU_gShipToAddress, ATU_gPayToAddress : array[6] of Text[150];
        ATU_gRunningNo: Integer;
        ATU_gRunningNoFormat: Text[5];
        ATU_gItemNo: Code[20];
}
//HS.1-