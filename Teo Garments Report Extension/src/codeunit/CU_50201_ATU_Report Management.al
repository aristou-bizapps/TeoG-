codeunit 50201 "ATU_Report Management"
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

    procedure ATU_GetSalesBillToAddress(ATU_pHeader: Variant; var ATU_pBillToAddress: array[5] of Text[150])
    var
        ATU_lBillToAddrList: List of [Text[150]];
        ATU_lRecRef: RecordRef;
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

    procedure ATU_GetTaxPercentage(ATU_pHeader: Variant): Decimal
    var
        ATU_lRecRef: RecordRef;
        ATU_lSalesCMLine: Record "Sales Cr.Memo Line";
        ATU_lSalesInvLine: Record "Sales Invoice Line";
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

    procedure ATU_IsPOPendingApproval(ATU_pPOReportType: Enum "ATU_PO Report Type"): Boolean
    begin
        if ATU_pPOReportType = ATU_pPOReportType::"Pending Approval" then
            exit(true);

        exit(false);
    end;
}