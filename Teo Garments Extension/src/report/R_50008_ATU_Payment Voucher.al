/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-01-21      Create new "Payment Voucher" report
*/

//HS.1+
report 50008 "ATU_Payment Voucher"
{
    Caption = 'ATU Payment Voucher';
    DefaultRenderingLayout = "ATU_Payment Voucher";
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.");
            RequestFilterFields = "Journal Template Name", "Journal Batch Name", "Document No.";
            column(ATU_CompanyInfoPicture; ATU_gCompanyInfo.Picture) { }
            column(ATU_CompanyAddr1; ATU_gCompanyAddress[1]) { }
            column(ATU_CompanyAddr2; ATU_gCompanyAddress[2]) { }
            column(ATU_CompanyAddr3; ATU_gCompanyAddress[3]) { }
            column(ATU_CompanyAddr4; ATU_gCompanyAddress[4]) { }
            column(ATU_VendorAddr1; ATU_gVendorAddress[1]) { }
            column(ATU_VendorAddr2; ATU_gVendorAddress[2]) { }
            column(ATU_VendorAddr3; ATU_gVendorAddress[3]) { }
            column(ATU_VendorAddr4; ATU_gVendorAddress[4]) { }
            column(ATU_VendorAddr5; ATU_gVendorAddress[5]) { }
            column(ATU_VendorAddr6; ATU_gVendorAddress[6]) { }
            column(ATU_VendorAddr7; ATU_gVendorAddress[7]) { }
            column(ATU_JnlTemplateName; "Journal Template Name") { }
            column(ATU_JnlBatchName; "Journal Batch Name") { }
            column(ATU_PVNo; "Document No.") { }
            column(ATU_Date; Format("Posting Date", 0, '<Day,2>-<Month Text,3>-<Year4>')) { }
            column(ATU_BankAcctID; '') { }
            column(ATU_PaymentMode; "Payment Method Code") { }
            column(ATU_ReferenceNo; "External Document No.") { }
            column(ATU_VendorNo; ATU_gReportMgmt.ATU_GetVendorNo("Account Type", "Account No.")) { }
            column(ATU_Remarks; "Message to Recipient") { }
            column(ATU_TotalAmount; ATU_gTotalAmount) { }
            column(ATU_TotalAmountInText; ATU_gTotalAmountInText) { }
            column(ATU_PreparedBy; UserId) { }
            column(ATU_ApprovedBy; '') { }
            column(ATU_ReceivedBy; '') { }
            column(ATU_PaymentAmountCaption; StrSubstNo('Payment Amount (%1)', ATU_gReportMgmt.ATU_GetCurrencyCode("Currency Code"))) { }

            dataitem("Vendor Ledger Entry 1"; "Vendor Ledger Entry")
            {
                DataItemLinkReference = "Gen. Journal Line";
                DataItemLink = "Applies-to ID" = field("Document No."), "Vendor No." = field("Account No.");
                DataItemTableView = sorting("Entry No.");
                column(ATU_VLE1_EntryNo; "Entry No.") { }
                column(ATU_VLE1_Date; Format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                column(ATU_VLE1_DocumentNo; "Document No.") { }
                column(ATU_VLE1_Description; Description) { }
                column(ATU_VLE1_PaymentAmount; ATU_gVLE1_PaymentAmount) { }

                trigger OnAfterGetRecord()
                begin
                    Clear(ATU_gVLE1_PaymentAmount);

                    if "Document Type" = "Document Type"::Invoice then begin
                        if "Gen. Journal Line"."Currency Factor" <> 0 then
                            ATU_gVLE1_PaymentAmount := Abs((1 / "Gen. Journal Line"."Currency Factor") * "Amount to Apply")
                        else
                            ATU_gVLE1_PaymentAmount := Abs("Amount to Apply");
                    end else begin
                        if "Gen. Journal Line"."Currency Factor" <> 0 then
                            ATU_gVLE1_PaymentAmount := (1 / "Gen. Journal Line"."Currency Factor") * "Amount to Apply" * -1
                        else
                            ATU_gVLE1_PaymentAmount := "Amount to Apply" * -1;
                    end;
                end;
            }

            dataitem("Vendor Ledger Entry 2"; "Vendor Ledger Entry")
            {
                DataItemLinkReference = "Gen. Journal Line";
                DataItemLink = "Document Type" = field("Applies-to Doc. Type"), "Document No." = field("Applies-to Doc. No.");
                DataItemTableView = sorting("Entry No.");
                column(ATU_VLE2_EntryNo; "Entry No.") { }
                column(ATU_VLE2_Date; Format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                column(ATU_VLE2_DocumentNo; "Document No.") { }
                column(ATU_VLE2_Description; Description) { }
                column(ATU_VLE2_PaymentAmount; ATU_gVLE2_PaymentAmount) { }

                trigger OnAfterGetRecord()
                begin
                    Clear(ATU_gVLE2_PaymentAmount);

                    if "Document Type" = "Document Type"::Invoice then begin
                        if "Gen. Journal Line"."Currency Factor" <> 0 then
                            ATU_gVLE2_PaymentAmount := Abs((1 / "Gen. Journal Line"."Currency Factor") * "Amount to Apply")
                        else
                            ATU_gVLE2_PaymentAmount := Abs("Amount to Apply");
                    end else begin
                        if "Gen. Journal Line"."Currency Factor" <> 0 then
                            ATU_gVLE2_PaymentAmount := (1 / "Gen. Journal Line"."Currency Factor") * "Amount to Apply" * -1
                        else
                            ATU_gVLE2_PaymentAmount := "Amount to Apply" * -1;
                    end;
                end;
            }

            dataitem("ATU_Vendor_Gen. Journal Line"; "Gen. Journal Line")
            {
                DataItemLinkReference = "Gen. Journal Line";
                DataItemLink = "Journal Template Name" = field("Journal Template Name"), "Journal Batch Name" = field("Journal Batch Name"),
                                        "Document No." = field("Document No.");
                DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.") where("Account Type" = const(Vendor),
                                                    "Applies-to Doc. No." = filter(''), "Applies-to ID" = filter(''));
                column(ATU_Vend_GJL_LineNo; "Line No.") { }
                column(ATU_Vend_GJL_Date; Format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                column(ATU_Vend_GJL_DocumentNo; "Document No.") { }
                column(ATU_Vend_GJL_Description; Description) { }
                column(ATU_Vend_GJL_PaymentAmount; "Amount (LCY)") { }
            }

            dataitem("Cust. Ledger Entry 1"; "Cust. Ledger Entry")
            {
                DataItemLinkReference = "Gen. Journal Line";
                DataItemLink = "Applies-to ID" = field("Document No."), "Customer No." = field("Account No.");
                DataItemTableView = sorting("Entry No.");
                column(ATU_CLE1_EntryNo; "Entry No.") { }
                column(ATU_CLE1_Date; Format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                column(ATU_CLE1_DocumentNo; "Document No.") { }
                column(ATU_CLE1_Description; Description) { }
                column(ATU_CLE1_PaymentAmount; ATU_gCLE1_PaymentAmount) { }

                trigger OnAfterGetRecord()
                begin
                    Clear(ATU_gCLE1_PaymentAmount);

                    if "Document Type" = "Document Type"::Invoice then begin
                        if "Gen. Journal Line"."Currency Factor" <> 0 then
                            ATU_gCLE1_PaymentAmount := Abs((1 / "Gen. Journal Line"."Currency Factor") * "Amount to Apply")
                        else
                            ATU_gCLE1_PaymentAmount := Abs("Amount to Apply");
                    end else begin
                        if "Gen. Journal Line"."Currency Factor" <> 0 then
                            ATU_gCLE1_PaymentAmount := (1 / "Gen. Journal Line"."Currency Factor") * "Amount to Apply" * -1
                        else
                            ATU_gCLE1_PaymentAmount := "Amount to Apply" * -1;
                    end;
                end;
            }

            dataitem("Cust. Ledger Entry 2"; "Cust. Ledger Entry")
            {
                DataItemLinkReference = "Gen. Journal Line";
                DataItemLink = "Document Type" = field("Applies-to Doc. Type"), "Document No." = field("Applies-to Doc. No.");
                DataItemTableView = sorting("Entry No.");
                column(ATU_CLE2_EntryNo; "Entry No.") { }
                column(ATU_CLE2_Date; Format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                column(ATU_CLE2_DocumentNo; "Document No.") { }
                column(ATU_CLE2_Description; Description) { }
                column(ATU_CLE2_PaymentAmount; ATU_gCLE2_PaymentAmount) { }

                trigger OnAfterGetRecord()
                begin
                    Clear(ATU_gCLE2_PaymentAmount);

                    if "Document Type" = "Document Type"::Invoice then begin
                        if "Gen. Journal Line"."Currency Factor" <> 0 then
                            ATU_gCLE2_PaymentAmount := Abs((1 / "Gen. Journal Line"."Currency Factor") * "Amount to Apply")
                        else
                            ATU_gCLE2_PaymentAmount := Abs("Amount to Apply");
                    end else begin
                        if "Gen. Journal Line"."Currency Factor" <> 0 then
                            ATU_gCLE2_PaymentAmount := (1 / "Gen. Journal Line"."Currency Factor") * "Amount to Apply" * -1
                        else
                            ATU_gCLE2_PaymentAmount := "Amount to Apply" * -1;
                    end;
                end;
            }

            dataitem("ATU_Customer_Gen. Journal Line"; "Gen. Journal Line")
            {
                DataItemLinkReference = "Gen. Journal Line";
                DataItemLink = "Journal Template Name" = field("Journal Template Name"), "Journal Batch Name" = field("Journal Batch Name"),
                                        "Document No." = field("Document No.");
                DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.") where("Account Type" = const(Customer),
                                                    "Applies-to Doc. No." = filter(''), "Applies-to ID" = filter(''));
                column(ATU_Cust_GJL_LineNo; "Line No.") { }
                column(ATU_Cust_GJL_Date; Format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                column(ATU_Cust_GJL_DocumentNo; "Document No.") { }
                column(ATU_Cust_GJL_Description; Description) { }
                column(ATU_Cust_GJL_PaymentAmount; "Amount (LCY)") { }
            }

            dataitem("ATU_GLAccount_Gen. Journal Line"; "Gen. Journal Line")
            {
                DataItemLinkReference = "Gen. Journal Line";
                DataItemLink = "Journal Template Name" = field("Journal Template Name"), "Journal Batch Name" = field("Journal Batch Name"),
                                        "Document No." = field("Document No.");
                DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.") where("Account Type" = const("G/L Account"));
                column(ATU_GLAccount_GJL_LineNo; "Line No.") { }
                column(ATU_GLAccount_GJL_Date; Format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>')) { }
                column(ATU_GLAccount_GJL_DocumentNo; "External Document No.") { }
                column(ATU_GLAccount_GJL_Description; Description) { }
                column(ATU_GLAccount_GJL_PaymentAmount; "Amount (LCY)") { }
            }

            trigger OnAfterGetRecord()
            begin
                ATU_gReportMgmt.ATU_GetCompanyAddress(ATU_gCompanyInfo, ATU_gCompanyAddress);
                ATU_gReportMgmt.ATU_GetVendorAddress("Account Type", "Account No.", ATU_gVendorAddress);

                if not ATU_gListofDocumentNo.Contains("Document No.") then begin
                    ATU_gListofDocumentNo.Add("Document No.");
                    Clear(ATU_gTotalAmountInText);

                    ATU_gTotalAmount := Round(ATU_gReportMgmt.ATU_GetTotalAmountForVoucher("Gen. Journal Line"), 0.01, '=');
                    ATU_gTotalAmountInText := ATU_gConvertAmtInWord.ATU_FormatNoText(ATU_gTotalAmount, ATU_gReportMgmt.ATU_GetCurrencyCode("Currency Code"), 'CENTS');
                end;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
    }

    rendering
    {
        layout("ATU_Payment Voucher")
        {
            Type = RDLC;
            LayoutFile = './src/report layout/RL_50008_ATU_Payment Voucher.rdl';
        }
    }

    labels
    {
        ATU_ReportCaption = 'PAYMENT VOUCHER';
        ATU_PVNoCaption = 'PV NO.';
        ATU_DateCaption = 'DATE';
        ATU_BankAcctIDCaption = 'BANK ACCT ID';
        ATU_PaymentModeCaption = 'PAYMENT MODE';
        ATU_ReferenceNoCaption = 'REFERENCE NO.';
        ATU_VendorNoCaption = 'VENDOR NO.';
        ATU_RemarksCaption = 'REMARKS:';
        ATU_PayToCaption = 'Pay To:';
        ATU_DateNormalCaption = 'Date';
        ATU_DocumentNoCaption = 'Document No.';
        ATU_DescriptionCaption = 'Description';
        ATU_TotalAmountCaption = 'Total Amount';
        ATU_PreparedByCaption = 'Prepared by';
        ATU_ApprovedByCaption = 'Approved by';
        ATU_ReceivedByCaption = 'Received by';
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
        ATU_gCompanyAddress: array[4] of Text[500];
        ATU_gVendorAddress: array[7] of Text[150];
        ATU_gTotalAmount, ATU_gVLE1_PaymentAmount, ATU_gVLE2_PaymentAmount, ATU_gCLE1_PaymentAmount, ATU_gCLE2_PaymentAmount : Decimal;
        ATU_gListofDocumentNo: List of [Code[20]];
        ATU_gTotalAmountInText: Text;
}
//HS.1-