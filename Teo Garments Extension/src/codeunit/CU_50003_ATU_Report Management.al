/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================
1       HS      2026-01-20      Create new "Report Management" codeunit
*/

//HS.1+
codeunit 50003 "ATU_Report Management"
{
    procedure ATU_GetCompanyAddress(ATU_pCompanyInfo: Record "Company Information"; var ATU_pCompanyAddress: array[4] of Text[500])
    var
        ATU_lCompanyAddrList: List of [Text[500]];
        ATU_lName: Label '%1 %2';
        ATU_lAddress1: Label '%1, %2 %3';
        ATU_lAddress2: Label '%1, %2, %3 %4';
        ATU_lTelFaxEmailWebsite: Label 't. %1  f. %2  e. %3  %4';
        ATU_lUENGSTRegNo: Label 'UEN No: %1  GST Reg No: %2';
        ATU_li: Integer;
    begin
        ATU_lCompanyAddrList.Add(StrSubstNo(ATU_lName, UpperCase(ATU_pCompanyInfo.Name), UpperCase(ATU_pCompanyInfo."Name 2")));
        if ATU_pCompanyInfo."Address 2" = '' then
            ATU_lCompanyAddrList.Add(StrSubstNo(ATU_lAddress1, ATU_pCompanyInfo.Address, ATU_pCompanyInfo.City, ATU_pCompanyInfo."Post Code"))
        else
            ATU_lCompanyAddrList.Add(StrSubstNo(ATU_lAddress2, ATU_pCompanyInfo.Address, ATU_pCompanyInfo."Address 2", ATU_pCompanyInfo.City, ATU_pCompanyInfo."Post Code"));
        ATU_lCompanyAddrList.Add(StrSubstNo(ATU_lTelFaxEmailWebsite, ATU_pCompanyInfo."Phone No.", ATU_pCompanyInfo."Fax No.", ATU_pCompanyInfo."E-Mail", ATU_pCompanyInfo."Home Page"));
        ATU_lCompanyAddrList.Add(StrSubstNo(ATU_lUENGSTRegNo, ATU_pCompanyInfo."Registration No.", ATU_pCompanyInfo."VAT Registration No."));

        if ATU_lCompanyAddrList.Count > 0 then begin
            for ATU_li := 1 to ATU_lCompanyAddrList.Count do begin
                ATU_pCompanyAddress[ATU_li] := ATU_lCompanyAddrList.Get(ATU_li);
            end;
        end;
    end;

    procedure ATU_GetCompanyAddressForTHL(ATU_pCompanyInfo: Record "Company Information"; var ATU_pCompanyAddress: array[5] of Text[500])
    var
        ATU_lCompanyAddrList: List of [Text[500]];
        ATU_lName: Label '%1';
        ATU_lAddress1: Label '%1, %2 %3';
        ATU_lAddress2: Label '%1, %2, %3 %4';
        ATU_lTelFaxEmail: Label 'Tel: %1  |  Fax: %2  |  Email: %3';
        ATU_lUENGSTRegNo: Label 'UEN: %1  |  GST Reg No: %2';
        ATU_lEmailWebsite: Label 'Email: %1  |  Website: %2';
        ATU_li: Integer;
    begin
        ATU_lCompanyAddrList.Add(StrSubstNo(ATU_lName, UpperCase(ATU_pCompanyInfo.Name)));
        if ATU_pCompanyInfo."Address 2" = '' then
            ATU_lCompanyAddrList.Add(StrSubstNo(ATU_lAddress1, ATU_pCompanyInfo.Address, ATU_pCompanyInfo.City, ATU_pCompanyInfo."Post Code"))
        else
            ATU_lCompanyAddrList.Add(StrSubstNo(ATU_lAddress2, ATU_pCompanyInfo.Address, ATU_pCompanyInfo."Address 2", ATU_pCompanyInfo.City, ATU_pCompanyInfo."Post Code"));
        ATU_lCompanyAddrList.Add(StrSubstNo(ATU_lTelFaxEmail, ATU_pCompanyInfo."Phone No.", ATU_pCompanyInfo."Fax No.", ATU_pCompanyInfo."E-Mail"));
        ATU_lCompanyAddrList.Add(StrSubstNo(ATU_lUENGSTRegNo, ATU_pCompanyInfo."Registration No.", ATU_pCompanyInfo."VAT Registration No."));
        ATU_lCompanyAddrList.Add(StrSubstNo(ATU_lEmailWebsite, ATU_pCompanyInfo."E-Mail", ATU_pCompanyInfo."Home Page"));

        if ATU_lCompanyAddrList.Count > 0 then begin
            for ATU_li := 1 to ATU_lCompanyAddrList.Count do begin
                ATU_pCompanyAddress[ATU_li] := ATU_lCompanyAddrList.Get(ATU_li);
            end;
        end;
    end;

    procedure ATU_GetSalesBillToAddress(ATU_pHeader: Variant; var ATU_pBillToAddress: array[7] of Text[150])
    var
        ATU_lBillToAddrList: List of [Text[150]];
        ATU_lRecRef: RecordRef;
        ATU_lBillToContact: Label 'ATTN: %1';
        ATU_li: Integer;
    begin
        Clear(ATU_pBillToAddress);
        ATU_lRecRef.GetTable(ATU_pHeader);

        if Format(ATU_lRecRef.Field(5).Value) <> '' then
            ATU_lBillToAddrList.Add(ATU_lRecRef.Field(5).Value);
        if Format(ATU_lRecRef.Field(7).Value) <> '' then
            ATU_lBillToAddrList.Add(ATU_lRecRef.Field(7).Value);
        if Format(ATU_lRecRef.Field(8).Value) <> '' then
            ATU_lBillToAddrList.Add(ATU_lRecRef.Field(8).Value);
        if Format(ATU_lRecRef.Field(9).Value) <> '' then
            ATU_lBillToAddrList.Add(StrSubstNo('%1 %2', ATU_lRecRef.Field(9).Value, ATU_lRecRef.Field(85).Value))
        else
            ATU_lBillToAddrList.Add(ATU_lRecRef.Field(85).Value);
        if Format(ATU_lRecRef.Field(87).Value) <> '' then
            ATU_lBillToAddrList.Add(ATU_GetCountryName(ATU_lRecRef.Field(87).Value));

        ATU_lBillToAddrList.Add('');

        if Format(ATU_lRecRef.Field(10).Value) <> '' then
            ATU_lBillToAddrList.Add(StrSubstNo(ATU_lBillToContact, ATU_lRecRef.Field(10).Value));

        if ATU_lBillToAddrList.Count > 0 then begin
            for ATU_li := 1 to ATU_lBillToAddrList.Count do begin
                ATU_pBillToAddress[ATU_li] := ATU_lBillToAddrList.Get(ATU_li);
            end;
        end;
    end;

    procedure ATU_GetSalesShipToAddress(ATU_pHeader: Variant; var ATU_pShipToAddress: array[5] of Text[150])
    var
        ATU_lShipToAddrList: List of [Text[150]];
        ATU_lRecRef: RecordRef;
        ATU_li: Integer;
    begin
        Clear(ATU_pShipToAddress);
        ATU_lRecRef.GetTable(ATU_pHeader);

        if Format(ATU_lRecRef.Field(13).Value) <> '' then
            ATU_lShipToAddrList.Add(ATU_lRecRef.Field(13).Value);
        if Format(ATU_lRecRef.Field(15).Value) <> '' then
            ATU_lShipToAddrList.Add(ATU_lRecRef.Field(15).Value);
        if Format(ATU_lRecRef.Field(16).Value) <> '' then
            ATU_lShipToAddrList.Add(ATU_lRecRef.Field(16).Value);
        if Format(ATU_lRecRef.Field(17).Value) <> '' then
            ATU_lShipToAddrList.Add(StrSubstNo('%1 %2', ATU_lRecRef.Field(17).Value, ATU_lRecRef.Field(91).Value))
        else
            ATU_lShipToAddrList.Add(ATU_lRecRef.Field(91).Value);
        if Format(ATU_lRecRef.Field(93).Value) <> '' then
            ATU_lShipToAddrList.Add(ATU_GetCountryName(ATU_lRecRef.Field(93).Value));

        if ATU_lShipToAddrList.Count > 0 then begin
            for ATU_li := 1 to ATU_lShipToAddrList.Count do begin
                ATU_pShipToAddress[ATU_li] := ATU_lShipToAddrList.Get(ATU_li);
            end;
        end;
    end;

    procedure ATU_GetPurchaseBuyFromAddress(ATU_pHeader: Variant; var ATU_pBuyFromAddress: array[6] of Text[150])
    var
        ATU_lBuyFromAddrList: List of [Text[150]];
        ATU_lRecRef: RecordRef;
        ATU_li: Integer;
        ATU_lVendor: Record Vendor;
        ATU_lTel: Label 'Tel: %1';
    begin
        Clear(ATU_pBuyFromAddress);
        ATU_lRecRef.GetTable(ATU_pHeader);

        if Format(ATU_lRecRef.Field(79).Value) <> '' then
            ATU_lBuyFromAddrList.Add(ATU_lRecRef.Field(79).Value);
        if Format(ATU_lRecRef.Field(81).Value) <> '' then
            ATU_lBuyFromAddrList.Add(ATU_lRecRef.Field(81).Value);
        if Format(ATU_lRecRef.Field(82).Value) <> '' then
            ATU_lBuyFromAddrList.Add(ATU_lRecRef.Field(82).Value);
        if Format(ATU_lRecRef.Field(83).Value) <> '' then
            ATU_lBuyFromAddrList.Add(StrSubstNo('%1 %2', ATU_lRecRef.Field(83).Value, ATU_lRecRef.Field(88).Value))
        else
            ATU_lBuyFromAddrList.Add(ATU_lRecRef.Field(88).Value);
        if Format(ATU_lRecRef.Field(90).Value) <> '' then
            ATU_lBuyFromAddrList.Add(ATU_GetCountryName(ATU_lRecRef.Field(90).Value));
        if Format(ATU_lRecRef.Field(2).Value) <> '' then begin
            ATU_lVendor.Reset();
            if ATU_lVendor.Get(Format(ATU_lRecRef.Field(2).Value)) then begin
                if ATU_lVendor."Phone No." <> '' then
                    ATU_lBuyFromAddrList.Add(StrSubstNo(ATU_lTel, ATU_lVendor."Phone No."));
            end;
        end;

        if ATU_lBuyFromAddrList.Count > 0 then begin
            for ATU_li := 1 to ATU_lBuyFromAddrList.Count do begin
                ATU_pBuyFromAddress[ATU_li] := ATU_lBuyFromAddrList.Get(ATU_li);
            end;
        end;
    end;

    procedure ATU_GetPurchaseShipToAddress(ATU_pHeader: Variant; var ATU_pShipToAddress: array[6] of Text[150])
    var
        ATU_lShipToAddrList: List of [Text[150]];
        ATU_lRecRef: RecordRef;
        ATU_li: Integer;
        ATU_lTel: Label 'Tel: %1';
    begin
        Clear(ATU_pShipToAddress);
        ATU_lRecRef.GetTable(ATU_pHeader);

        if Format(ATU_lRecRef.Field(13).Value) <> '' then
            ATU_lShipToAddrList.Add(ATU_lRecRef.Field(13).Value);
        if Format(ATU_lRecRef.Field(15).Value) <> '' then
            ATU_lShipToAddrList.Add(ATU_lRecRef.Field(15).Value);
        if Format(ATU_lRecRef.Field(16).Value) <> '' then
            ATU_lShipToAddrList.Add(ATU_lRecRef.Field(16).Value);
        if Format(ATU_lRecRef.Field(17).Value) <> '' then
            ATU_lShipToAddrList.Add(StrSubstNo('%1 %2', ATU_lRecRef.Field(17).Value, ATU_lRecRef.Field(91).Value))
        else
            ATU_lShipToAddrList.Add(ATU_lRecRef.Field(91).Value);
        if Format(ATU_lRecRef.Field(93).Value) <> '' then
            ATU_lShipToAddrList.Add(ATU_GetCountryName(ATU_lRecRef.Field(93).Value));
        if Format(ATU_lRecRef.Field(210).Value) <> '' then
            ATU_lShipToAddrList.Add(StrSubstNo(ATU_lTel, Format(ATU_lRecRef.Field(210).Value)));

        if ATU_lShipToAddrList.Count > 0 then begin
            for ATU_li := 1 to ATU_lShipToAddrList.Count do begin
                ATU_pShipToAddress[ATU_li] := ATU_lShipToAddrList.Get(ATU_li);
            end;
        end;
    end;

    procedure ATU_GetPurchasePayToAddress(ATU_pHeader: Variant; var ATU_pPayToAddress: array[6] of Text[150])
    var
        ATU_lPayToAddrList: List of [Text[150]];
        ATU_lRecRef: RecordRef;
        ATU_li: Integer;
        ATU_lVendor: Record Vendor;
        ATU_lTel: Label 'Tel: %1';
    begin
        Clear(ATU_pPayToAddress);
        ATU_lRecRef.GetTable(ATU_pHeader);

        if Format(ATU_lRecRef.Field(5).Value) <> '' then
            ATU_lPayToAddrList.Add(ATU_lRecRef.Field(5).Value);
        if Format(ATU_lRecRef.Field(7).Value) <> '' then
            ATU_lPayToAddrList.Add(ATU_lRecRef.Field(7).Value);
        if Format(ATU_lRecRef.Field(8).Value) <> '' then
            ATU_lPayToAddrList.Add(ATU_lRecRef.Field(8).Value);
        if Format(ATU_lRecRef.Field(9).Value) <> '' then
            ATU_lPayToAddrList.Add(StrSubstNo('%1 %2', ATU_lRecRef.Field(9).Value, ATU_lRecRef.Field(85).Value))
        else
            ATU_lPayToAddrList.Add(ATU_lRecRef.Field(85).Value);
        if Format(ATU_lRecRef.Field(87).Value) <> '' then
            ATU_lPayToAddrList.Add(ATU_GetCountryName(ATU_lRecRef.Field(87).Value));
        if Format(ATU_lRecRef.Field(4).Value) <> '' then begin
            ATU_lVendor.Reset();
            if ATU_lVendor.Get(Format(ATU_lRecRef.Field(4).Value)) then begin
                if ATU_lVendor."Phone No." <> '' then
                    ATU_lPayToAddrList.Add(StrSubstNo(ATU_lTel, ATU_lVendor."Phone No."));
            end;
        end;

        if ATU_lPayToAddrList.Count > 0 then begin
            for ATU_li := 1 to ATU_lPayToAddrList.Count do begin
                ATU_pPayToAddress[ATU_li] := ATU_lPayToAddrList.Get(ATU_li);
            end;
        end;
    end;

    procedure ATU_GetCustomerAddress(ATU_pCustomerNo: Code[20]; var ATU_pCustomerAddress: array[7] of Text[150])
    var
        ATU_lCustomer: Record Customer;
        ATU_lCustomerAddrList: List of [Text[150]];
        ATU_lCustomerContact: Label 'ATTN: %1';
        ATU_li: Integer;
    begin
        Clear(ATU_pCustomerAddress);

        if ATU_pCustomerNo <> '' then begin
            ATU_lCustomer.Reset();
            if ATU_lCustomer.Get(ATU_pCustomerNo) then begin
                if ATU_lCustomer.Name <> '' then
                    ATU_lCustomerAddrList.Add(ATU_lCustomer.Name);
                if ATU_lCustomer.Address <> '' then
                    ATU_lCustomerAddrList.Add(ATU_lCustomer.Address);
                if ATU_lCustomer."Address 2" <> '' then
                    ATU_lCustomerAddrList.Add(ATU_lCustomer."Address 2");
                if (ATU_lCustomer.City <> '') and (ATU_lCustomer."Post Code" <> '') then
                    ATU_lCustomerAddrList.Add(StrSubstNo('%1 %2', ATU_lCustomer.City, ATU_lCustomer."Post Code"))
                else if ATU_lCustomer.City <> '' then
                    ATU_lCustomerAddrList.Add(ATU_lCustomer.City)
                else if ATU_lCustomer."Post Code" <> '' then
                    ATU_lCustomerAddrList.Add(ATU_lCustomer."Post Code");
                if ATU_lCustomer."Country/Region Code" <> '' then
                    ATU_lCustomerAddrList.Add(ATU_GetCountryName(ATU_lCustomer."Country/Region Code"));

                ATU_lCustomerAddrList.Add('');

                if ATU_lCustomer.Contact <> '' then
                    ATU_lCustomerAddrList.Add(StrSubstNo(ATU_lCustomerContact, ATU_lCustomer.Contact));

                if ATU_lCustomerAddrList.Count > 0 then begin
                    for ATU_li := 1 to ATU_lCustomerAddrList.Count do begin
                        ATU_pCustomerAddress[ATU_li] := ATU_lCustomerAddrList.Get(ATU_li);
                    end;
                end;
            end;
        end;
    end;

    procedure ATU_GetVendorAddress(ATU_pAccountType: Enum "Gen. Journal Account Type"; ATU_pAccountNo: Code[20]; var ATU_pVendorAddress: array[7] of Text[150])
    var
        ATU_lVendor: Record Vendor;
        ATU_lVendorAddrList: List of [Text[150]];
        ATU_lVendorContact: Label 'ATTN: %1';
        ATU_li: Integer;
    begin
        Clear(ATU_pVendorAddress);

        if (ATU_pAccountType = ATU_pAccountType::Vendor) and (ATU_pAccountNo <> '') then begin
            ATU_lVendor.Reset();
            if ATU_lVendor.Get(ATU_pAccountNo) then begin
                if ATU_lVendor.Name <> '' then
                    ATU_lVendorAddrList.Add(ATU_lVendor.Name);
                if ATU_lVendor.Address <> '' then
                    ATU_lVendorAddrList.Add(ATU_lVendor.Address);
                if ATU_lVendor."Address 2" <> '' then
                    ATU_lVendorAddrList.Add(ATU_lVendor."Address 2");
                if (ATU_lVendor.City <> '') and (ATU_lVendor."Post Code" <> '') then
                    ATU_lVendorAddrList.Add(StrSubstNo('%1 %2', ATU_lVendor.City, ATU_lVendor."Post Code"))
                else if ATU_lVendor.City <> '' then
                    ATU_lVendorAddrList.Add(ATU_lVendor.City)
                else if ATU_lVendor."Post Code" <> '' then
                    ATU_lVendorAddrList.Add(ATU_lVendor."Post Code");
                if ATU_lVendor."Country/Region Code" <> '' then
                    ATU_lVendorAddrList.Add(ATU_GetCountryName(ATU_lVendor."Country/Region Code"));

                ATU_lVendorAddrList.Add('');

                if ATU_lVendor.Contact <> '' then
                    ATU_lVendorAddrList.Add(StrSubstNo(ATU_lVendorContact, ATU_lVendor.Contact));

                if ATU_lVendorAddrList.Count > 0 then begin
                    for ATU_li := 1 to ATU_lVendorAddrList.Count do begin
                        ATU_pVendorAddress[ATU_li] := ATU_lVendorAddrList.Get(ATU_li);
                    end;
                end;
            end;
        end;
    end;

    procedure ATU_GetTaxPercentage(ATU_pHeader: Variant): Decimal
    var
        ATU_lRecRef: RecordRef;
        ATU_lSalesCMLine: Record "Sales Cr.Memo Line";
        ATU_lSalesInvLine: Record "Sales Invoice Line";
        ATU_lSalesLine: Record "Sales Line";
    begin
        ATU_lRecRef.GetTable(ATU_pHeader);

        case ATU_lRecRef.Number of
            Database::"Sales Cr.Memo Header":
                begin
                    ATU_lSalesCMLine.Reset();
                    ATU_lSalesCMLine.SetRange("Document No.", Format(ATU_lRecRef.Field(3).Value));
                    ATU_lSalesCMLine.SetFilter("VAT %", '<>%1', 0);
                    if ATU_lSalesCMLine.FindFirst() then
                        exit(ATU_lSalesCMLine."VAT %");
                end;
            Database::"Sales Invoice Header":
                begin
                    ATU_lSalesInvLine.Reset();
                    ATU_lSalesInvLine.SetRange("Document No.", Format(ATU_lRecRef.Field(3).Value));
                    ATU_lSalesInvLine.SetFilter("VAT %", '<>%1', 0);
                    if ATU_lSalesInvLine.FindFirst() then
                        exit(ATU_lSalesInvLine."VAT %");
                end;
            Database::"Sales Header":
                begin
                    ATU_lSalesLine.Reset();
                    ATU_lSalesLine.SetRange("Document Type", ATU_lRecRef.Field(1).Value);
                    ATU_lSalesLine.SetRange("Document No.", Format(ATU_lRecRef.Field(3).Value));
                    ATU_lSalesLine.SetFilter("VAT %", '<>%1', 0);
                    if ATU_lSalesLine.FindFirst() then
                        exit(ATU_lSalesLine."VAT %");
                end;
        end;

        exit(0);
    end;

    procedure ATU_GetCurrencyCode(ATU_pCurrCode: Code[10]): Code[10]
    var
        ATU_lGLSetup: Record "General Ledger Setup";
    begin
        if ATU_pCurrCode <> '' then
            exit(ATU_pCurrCode)
        else begin
            ATU_lGLSetup.Get();
            ATU_lGLSetup.TestField("LCY Code");
            exit(ATU_lGLSetup."LCY Code");
        end;
    end;

    procedure ATU_GetDiscountAmount(ATU_pHeader: Variant): Decimal
    var
        ATU_lRecRef: RecordRef;
        ATU_lSalesCMLine: Record "Sales Cr.Memo Line";
        ATU_lSalesInvLine: Record "Sales Invoice Line";
        ATU_lSalesLine: Record "Sales Line";
    begin
        ATU_lRecRef.GetTable(ATU_pHeader);

        case ATU_lRecRef.Number of
            Database::"Sales Cr.Memo Header":
                begin
                    ATU_lSalesCMLine.Reset();
                    ATU_lSalesCMLine.SetRange("Document No.", Format(ATU_lRecRef.Field(3).Value));
                    ATU_lSalesCMLine.CalcSums("Line Discount Amount");
                    exit(ATU_lSalesCMLine."Line Discount Amount");
                end;
            Database::"Sales Invoice Header":
                begin
                    ATU_lSalesInvLine.Reset();
                    ATU_lSalesInvLine.SetRange("Document No.", Format(ATU_lRecRef.Field(3).Value));
                    ATU_lSalesInvLine.CalcSums("Line Discount Amount");
                    exit(ATU_lSalesInvLine."Line Discount Amount");
                end;
            Database::"Sales Header":
                begin
                    ATU_lSalesLine.Reset();
                    ATU_lSalesLine.SetRange("Document Type", ATU_lRecRef.Field(1).Value);
                    ATU_lSalesLine.SetRange("Document No.", Format(ATU_lRecRef.Field(3).Value));
                    ATU_lSalesLine.CalcSums("Line Discount Amount");
                    exit(ATU_lSalesLine."Line Discount Amount");
                end;
        end;
    end;

    procedure ATU_GetDiscountPercentage(ATU_pHeader: Variant): Text[10]
    var
        ATU_lRecRef: RecordRef;
        ATU_lDiscountAmt: Decimal;
        ATU_lSalesInvHdr: Record "Sales Invoice Header";
    begin
        ATU_lRecRef.GetTable(ATU_pHeader);

        ATU_lDiscountAmt := ATU_GetDiscountAmount(ATU_pHeader);
        if ATU_lDiscountAmt <> 0 then begin
            case ATU_lRecRef.Number of
                Database::"Sales Invoice Header":
                    begin
                        ATU_lSalesInvHdr.Reset();
                        ATU_lSalesInvHdr.SetRange("No.", Format(ATU_lRecRef.Field(3).Value));
                        ATU_lSalesInvHdr.SetAutoCalcFields(Amount);
                        if ATU_lSalesInvHdr.FindFirst() then begin
                            if ATU_lSalesInvHdr.Amount <> 0 then
                                exit(Format(Round(ATU_lDiscountAmt / ATU_lSalesInvHdr.Amount * 100, 0.01, '=')));
                        end;
                    end;
            end;
        end;

        exit('0');
    end;

    local procedure ATU_GetCountryName(ATU_pCountryCode: Code[10]): Text[50]
    var
        ATU_lCountryRegion: Record "Country/Region";
    begin
        ATU_lCountryRegion.Reset();
        if ATU_lCountryRegion.Get((ATU_pCountryCode)) then
            exit(ATU_lCountryRegion.Name);
    end;

    procedure ATU_IsPOPendingApproval(ATU_pPOStatus: Enum "Purchase Document Status"): Boolean
    begin
        if ATU_pPOStatus = ATU_pPOStatus::Released then
            exit(false);

        exit(true);
    end;

    procedure ATU_GetBankCode(ATU_pBankAccountNo: Text[30]): Code[20]
    var
        ATU_lBankAccount: Record "Bank Account";
    begin
        ATU_lBankAccount.Reset();
        ATU_lBankAccount.SetRange("Bank Account No.", ATU_pBankAccountNo);
        if ATU_lBankAccount.FindFirst() then
            exit(ATU_lBankAccount."No.");

        exit('');
    end;

    procedure ATU_GetBankAccountID(ATU_pBalAcctType: Enum "Gen. Journal Account Type"; ATU_pBalAcctNo: Code[20]): Code[20]
    begin
        if (ATU_pBalAcctType = ATU_pBalAcctType::"Bank Account") and (ATU_pBalAcctNo <> '') then
            exit(ATU_pBalAcctNo);

        exit('');
    end;

    procedure ATU_GetVendorNo(ATU_pAccountType: Enum "Gen. Journal Account Type"; ATU_pAccountNo: Code[20]): Code[20]
    begin
        if (ATU_pAccountType = ATU_pAccountType::Vendor) and (ATU_pAccountNo <> '') then
            exit(ATU_pAccountNo);

        exit('');
    end;

    procedure ATU_GetTotalAmountForVoucher(ATU_pGJL: Record "Gen. Journal Line"): Decimal
    var
        ATU_lGenJnlLine: Record "Gen. Journal Line";
        ATU_lVLE: Record "Vendor Ledger Entry";
        ATU_lTotalAmount: Decimal;
    begin
        ATU_lGenJnlLine.Reset();
        ATU_lGenJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Document No.");
        ATU_lGenJnlLine.SetRange("Journal Template Name", ATU_pGJL."Journal Template Name");
        ATU_lGenJnlLine.SetRange("Journal Batch Name", ATU_pGJL."Journal Batch Name");
        ATU_lGenJnlLine.SetRange("Document No.", ATU_pGJL."Document No.");
        if ATU_lGenJnlLine.FindSet() then begin
            repeat
                if (ATU_lGenJnlLine."Account Type" = ATU_lGenJnlLine."Account Type"::Vendor) and (ATU_lGenJnlLine."Account No." <> '') then begin
                    if (ATU_lGenJnlLine."Applies-to Doc. No." <> '') or (ATU_lGenJnlLine."Applies-to ID" <> '') then begin
                        if ATU_lGenJnlLine."Applies-to Doc. No." <> '' then begin
                            ATU_lVLE.Reset();
                            ATU_lVLE.SetCurrentKey("Document Type", "Document No.", "Vendor No.");
                            ATU_lVLE.SetRange("Document Type", ATU_lGenJnlLine."Applies-to Doc. Type");
                            ATU_lVLE.SetRange("Document No.", ATU_lGenJnlLine."Applies-to Doc. No.");
                            ATU_lVLE.SetRange("Vendor No.", ATU_lGenJnlLine."Account No.");
                            ATU_lVLE.SetAutoCalcFields("Amount (LCY)");
                            if ATU_lVLE.FindSet() then begin
                                repeat
                                    if ATU_lVLE."Document Type" = ATU_lVLE."Document Type"::Invoice then begin
                                        if ATU_lGenJnlLine."Currency Factor" <> 0 then
                                            ATU_lTotalAmount += Abs((1 / ATU_lGenJnlLine."Currency Factor") * ATU_lVLE."Amount to Apply")
                                        else
                                            ATU_lTotalAmount += Abs(ATU_lVLE."Amount to Apply");
                                    end else begin
                                        if ATU_lGenJnlLine."Currency Factor" <> 0 then
                                            ATU_lTotalAmount += (1 / ATU_lGenJnlLine."Currency Factor") * ATU_lVLE."Amount to Apply" * -1
                                        else
                                            ATU_lTotalAmount += ATU_lVLE."Amount to Apply" * -1;
                                    end;
                                until ATU_lVLE.Next() = 0;
                            end;
                        end else begin
                            ATU_lVLE.Reset();
                            ATU_lVLE.SetCurrentKey("Applies-to ID", "Vendor No.");
                            ATU_lVLE.SetRange("Applies-to ID", ATU_lGenJnlLine."Document No.");
                            ATU_lVLE.SetRange("Vendor No.", ATU_lGenJnlLine."Account No.");
                            ATU_lVLE.SetAutoCalcFields("Amount (LCY)");
                            if ATU_lVLE.FindSet() then begin
                                repeat
                                    if ATU_lVLE."Document Type" = ATU_lVLE."Document Type"::Invoice then begin
                                        if ATU_lGenJnlLine."Currency Factor" <> 0 then
                                            ATU_lTotalAmount += Abs((1 / ATU_lGenJnlLine."Currency Factor") * ATU_lVLE."Amount to Apply")
                                        else
                                            ATU_lTotalAmount += Abs(ATU_lVLE."Amount to Apply");
                                    end else begin
                                        if ATU_lGenJnlLine."Currency Factor" <> 0 then
                                            ATU_lTotalAmount += (1 / ATU_lGenJnlLine."Currency Factor") * ATU_lVLE."Amount to Apply" * -1
                                        else
                                            ATU_lTotalAmount += ATU_lVLE."Amount to Apply" * -1;
                                    end;
                                until ATU_lVLE.Next() = 0;
                            end
                        end;
                    end else
                        ATU_lTotalAmount += ATU_lGenJnlLine."Amount (LCY)";
                end else begin
                    ATU_lTotalAmount += ATU_lGenJnlLine."Amount (LCY)";
                end;
            until ATU_lGenJnlLine.Next() = 0;
        end;

        exit(ATU_lTotalAmount);
    end;

    procedure ATU_CalculateFCY(ATU_pCurrencyFactor: Decimal; ATU_pAmountToConvert: Decimal): Decimal
    begin
        if ATU_pCurrencyFactor <> 0 then
            exit(ATU_pAmountToConvert / ATU_pCurrencyFactor);

        exit(ATU_pAmountToConvert);
    end;

    procedure ATU_CalculateApplnAmountToApply(ATU_pAmountToApply: Decimal; ATU_pApplnDate: Date; ATU_pCurrencyCode: Code[10]; ATU_pPostingDate: Date): Decimal
    var
        ATU_lApplnAmountToApply: Decimal;
        ATU_lCurrExchRate: Record "Currency Exchange Rate";
        ATU_lApplnCurrencyCode: Code[10];
        ATU_lValidExchRate: Boolean;
    begin
        ATU_lValidExchRate := true;

        if ATU_lApplnCurrencyCode = ATU_pCurrencyCode then
            exit(ATU_pAmountToApply);

        if ATU_pApplnDate = 0D then
            ATU_pApplnDate := ATU_pPostingDate;

        ATU_lApplnAmountToApply := ATU_lCurrExchRate.ApplnExchangeAmtFCYToFCY(ATU_pApplnDate, ATU_pCurrencyCode, ATU_lApplnCurrencyCode, ATU_pAmountToApply, ATU_lValidExchRate);

        exit(ATU_lApplnAmountToApply);
    end;

    procedure ATU_GetPOApprovedBy(ATU_pPurchHdr: Record "Purchase Header"): Code[50]
    var
        ATU_lApprovalEntry: Record "Approval Entry";
    begin
        ATU_lApprovalEntry.Reset();
        ATU_lApprovalEntry.SetCurrentKey("Entry No.", "Record ID to Approve", "Table ID", "Document Type", "Document No.");
        ATU_lApprovalEntry.SetRange("Record ID to Approve", ATU_pPurchHdr.RecordId);
        ATU_lApprovalEntry.SetRange("Table ID", ATU_pPurchHdr.RecordId.TableNo);
        ATU_lApprovalEntry.SetRange("Document Type", ATU_pPurchHdr."Document Type");
        ATU_lApprovalEntry.SetRange("Document No.", ATU_pPurchHdr."No.");
        ATU_lApprovalEntry.SetRange(Status, ATU_lApprovalEntry.Status::Approved);
        if ATU_lApprovalEntry.FindLast() then
            exit(ATU_lApprovalEntry."Approver ID");

        exit('');
    end;
}
//HS.1-