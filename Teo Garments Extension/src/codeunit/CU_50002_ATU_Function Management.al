/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================
1       HS      2026-01-20      Create new "Function Management" codeunit
2                               Add function to check THL Company
3                               Add function to check TGC Company
4               2026-02-03      Add function to import data from Excel to Sales Order
*/

//HS.1+
codeunit 50002 "ATU_Function Management"
{
    //HS.2+
    procedure ATU_IsTHLCompany(): Boolean
    var
        ATU_lCompanyInfo: Record "Company Information";
    begin
        ATU_lCompanyInfo.Get();
        if ATU_lCompanyInfo."Custom System Indicator Text" = 'TH' then
            exit(true);

        exit(false);
    end;
    //HS.2-
    //HS.3+
    procedure ATU_IsTGCCompany(): Boolean
    var
        ATU_lCompanyInfo: Record "Company Information";
    begin
        ATU_lCompanyInfo.Get();
        if ATU_lCompanyInfo."Custom System Indicator Text" = 'TGC' then
            exit(true);

        exit(false);
    end;
    //HS.3-
    //HS.4+
    procedure ATU_CreateSalesOrder(var ATU_pExcelBuffer: Record "Excel Buffer" temporary; var ATU_pSalesOrderNo: Text; var ATU_pNoOfSalesOrderCreated: Integer)
    var
        ATU_lSalesHeader: Record "Sales Header";
        ATU_li, ATU_lj, ATU_lRowNo, ATU_lMaxRowNo : Integer;
        ATU_lCustomerNo, ATU_lVendorNo : Code[20];
        ATU_lListOfCustomerNo, ATU_lListOfVendorNo : List of [Code[20]];
        ATU_lIsItemCreated: Boolean;
    begin
        ATU_ValidateDataBeforeCreate(ATU_pExcelBuffer);

        ATU_pExcelBuffer.Reset();
        if ATU_pExcelBuffer.FindLast() then
            ATU_lMaxRowNo := ATU_pExcelBuffer."Row No.";

        for ATU_lRowNo := 2 to ATU_lMaxRowNo do begin
            Clear(ATU_lCustomerNo);
            ATU_lCustomerNo := ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_lRowNo, 2);
            if not ATU_lListOfCustomerNo.Contains(ATU_lCustomerNo) then
                ATU_lListOfCustomerNo.Add(ATU_lCustomerNo);
        end;

        if ATU_lListOfCustomerNo.Count > 0 then begin
            for ATU_li := 1 to ATU_lListOfCustomerNo.Count do begin
                Clear(ATU_lListOfVendorNo);

                for ATU_lRowNo := 2 to ATU_lMaxRowNo do begin
                    if ATU_lListOfCustomerNo.Get(ATU_li) = ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_lRowNo, 2) then begin
                        Clear(ATU_lVendorNo);
                        ATU_lVendorNo := ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_lRowNo, 4);
                        if not ATU_lListOfVendorNo.Contains(ATU_lVendorNo) then
                            ATU_lListOfVendorNo.Add(ATU_lVendorNo);
                    end;
                end;

                if ATU_lListOfVendorNo.Count > 0 then begin
                    for ATU_lj := 1 to ATU_lListOfVendorNo.Count do begin
                        ATU_lSalesHeader := ATU_CreateSOHeader(ATU_pExcelBuffer, ATU_lListOfCustomerNo.Get(ATU_li));
                        if not ATU_lIsItemCreated then
                            ATU_CreateItems(ATU_pExcelBuffer, ATU_lIsItemCreated);
                        ATU_CreateSOLines(ATU_pExcelBuffer, ATU_lSalesHeader, ATU_lListOfVendorNo.Get(ATU_lj));

                        if ATU_pSalesOrderNo = '' then
                            ATU_pSalesOrderNo := ATU_lSalesHeader."No."
                        else
                            ATU_pSalesOrderNo += '|' + ATU_lSalesHeader."No.";

                        ATU_pNoOfSalesOrderCreated += 1;
                    end;
                end;
            end;
        end;
    end;

    local procedure ATU_GetValueAtCell(var ATU_pExcelBuffer: Record "Excel Buffer" temporary; ATU_pRowNo: Integer; ATU_pColNo: Integer): Text
    begin
        ATU_pExcelBuffer.Reset();
        if ATU_pExcelBuffer.Get(ATU_pRowNo, ATU_pColNo) then
            exit(ATU_pExcelBuffer."Cell Value as Text");

        exit('');
    end;

    local procedure ATU_CreateSOHeader(var ATU_pExcelBuffer: Record "Excel Buffer" temporary; ATU_pCustomerNo: Code[20]): Record "Sales Header"
    var
        ATU_lCustomer: Record Customer;
        ATU_lCustNotExistError: Label 'The Customer No. %1 not existed.\\Please check again.';
        ATU_lSalesHeader: Record "Sales Header";
    begin
        ATU_lCustomer.Reset();
        if ATU_lCustomer.Get(ATU_pCustomerNo) then begin
            ATU_lSalesHeader.Reset();
            ATU_lSalesHeader.Init();
            ATU_lSalesHeader.Validate("Document Type", ATU_lSalesHeader."Document Type"::Order);
            ATU_lSalesHeader.Validate("Sell-to Customer No.", ATU_pCustomerNo);
            ATU_lSalesHeader.Insert(true);

            exit(ATU_lSalesHeader);
        end else
            Error(StrSubstNo(ATU_lCustNotExistError, ATU_pCustomerNo));
    end;

    local procedure ATU_CreateItems(var ATU_pExcelBuffer: Record "Excel Buffer" temporary; var ATU_pIsItemCreated: Boolean)
    var
        ATU_lInventorySetup: Record "Inventory Setup";
        ATU_lItem: Record Item;
        ATU_lRowNo, ATU_lMaxRowNo : Integer;
        ATU_lItemNo: Code[20];
    begin
        ATU_lInventorySetup.Get();
        ATU_lInventorySetup.TestField("ATU_Def Gen Prod Posting Group");

        ATU_pExcelBuffer.Reset();
        if ATU_pExcelBuffer.FindLast() then
            ATU_lMaxRowNo := ATU_pExcelBuffer."Row No.";

        for ATU_lRowNo := 2 to ATU_lMaxRowNo do begin
            Clear(ATU_lItemNo);
            ATU_lItemNo := ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_lRowNo, 7);

            ATU_lItem.Reset();
            if not ATU_lItem.Get(ATU_lItemNo) then begin
                ATU_lItem.Reset();
                ATU_lItem.Init();
                ATU_lItem.Validate("No.", ATU_lItemNo);
                ATU_lItem.Insert(true);

                ATU_lItem.Validate(Type, ATU_lItem.Type::"Non-Inventory");
                ATU_lItem.Validate(Description, ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_lRowNo, 8));
                ATU_lItem.Validate("Base Unit of Measure", ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_lRowNo, 18));
                ATU_lItem.Validate("Gen. Prod. Posting Group", ATU_lInventorySetup."ATU_Def Gen Prod Posting Group");
                ATU_lItem.Validate("Assembly Policy", ATU_lItem."Assembly Policy"::"Assemble-to-Stock");
                ATU_lItem.Validate("Replenishment System", ATU_lItem."Replenishment System"::Purchase);
                ATU_lItem.Validate("Vendor No.", ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_lRowNo, 4));
                ATU_lItem.Validate("Purch. Unit of Measure", ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_lRowNo, 18));
                ATU_lItem.Modify(true);
            end;
        end;

        ATU_pIsItemCreated := true;
    end;

    local procedure ATU_CreateSOLines(var ATU_pExcelBuffer: Record "Excel Buffer" temporary; ATU_pSalesHeader: Record "Sales Header"; ATU_pVendorNo: Code[20])
    var
        ATU_lSalesLine: Record "Sales Line";
        ATU_lRowNo, ATU_lMaxRowNo, ATU_lLineNo : Integer;
    begin
        ATU_pExcelBuffer.Reset();
        if ATU_pExcelBuffer.FindLast() then
            ATU_lMaxRowNo := ATU_pExcelBuffer."Row No.";

        for ATU_lRowNo := 2 to ATU_lMaxRowNo do begin
            if (ATU_pSalesHeader."Sell-to Customer No." = ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_lRowNo, 2)) and
                (ATU_pVendorNo = ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_lRowNo, 4)) then begin
                ATU_lLineNo += 10000;

                ATU_lSalesLine.Reset();
                ATU_lSalesLine.Init();
                ATU_lSalesLine."Document Type" := ATU_pSalesHeader."Document Type";
                ATU_lSalesLine."Document No." := ATU_pSalesHeader."No.";
                ATU_lSalesLine."Line No." := ATU_lLineNo;
                ATU_lSalesLine.Validate("Bill-to Customer No.", ATU_pSalesHeader."Bill-to Customer No.");
                ATU_lSalesLine.Validate("Sell-to Customer No.", ATU_pSalesHeader."Sell-to Customer No.");
                ATU_lSalesLine.Validate(Type, ATU_lSalesLine.Type::Item);
                ATU_lSalesLine.Validate("No.", ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_lRowNo, 7));
                Evaluate(ATU_lSalesLine.Quantity, ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_lRowNo, 17));
                ATU_lSalesLine.Validate(Quantity);
                ATU_lSalesLine.Validate("Unit of Measure Code", ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_lRowNo, 18));
                ATU_lSalesLine.Validate("Currency Code", ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_lRowNo, 19));
                Evaluate(ATU_lSalesLine."Unit Price", ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_lRowNo, 20));
                ATU_lSalesLine.Validate("Unit Price");
                ATU_lSalesLine.Insert(true);

                ATU_ValidateExcelData(ATU_pExcelBuffer, ATU_lSalesLine, ATU_lRowNo);
                ATU_lSalesLine.Modify(true);
            end;
        end;
    end;

    local procedure ATU_ValidateDataBeforeCreate(var ATU_pExcelBuffer: Record "Excel Buffer" temporary)
    var
        ATU_lGLSetup: Record "General Ledger Setup";
        ATU_lDimValue: Record "Dimension Value";
        ATU_lCustomer: Record Customer;
        ATU_lVendor: Record Vendor;
        ATU_lRowNo, ATU_lMaxRowNo : Integer;
        ATU_lData: Code[20];
        ATU_lDataMissingErr: Label 'The %1 is missing in line number %2 of Excel.\\Please check again.';
        ATU_lDataNotExist: Label 'The %1 %2 not existed.\\Please check again.';
    begin
        ATU_lGLSetup.Get();
        ATU_lGLSetup.TestField("Global Dimension 1 Code");

        ATU_pExcelBuffer.Reset();
        if ATU_pExcelBuffer.FindLast() then
            ATU_lMaxRowNo := ATU_pExcelBuffer."Row No.";

        for ATU_lRowNo := 2 to ATU_lMaxRowNo do begin
            //Business Unit
            Clear(ATU_lData);
            ATU_lData := ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_lRowNo, 1);

            if ATU_lData = '' then
                Error(StrSubstNo(ATU_lDataMissingErr, 'Business Unit', ATU_lRowNo));

            ATU_lDimValue.Reset();
            if not ATU_lDimValue.Get(ATU_lGLSetup."Global Dimension 1 Code", ATU_lData) then
                Error(StrSubstNo(ATU_lDataNotExist, 'Business Unit Code', ATU_lData));

            //Buyer No.
            Clear(ATU_lData);
            ATU_lData := ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_lRowNo, 2);

            if ATU_lData = '' then
                Error(StrSubstNo(ATU_lDataMissingErr, 'Buyer Code', ATU_lRowNo));

            ATU_lCustomer.Reset();
            if not ATU_lCustomer.Get(ATU_lData) then
                Error(StrSubstNo(ATU_lDataNotExist, 'Customer', ATU_lData));

            //Supplier No.
            Clear(ATU_lData);
            ATU_lData := ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_lRowNo, 4);

            if ATU_lData = '' then
                Error(StrSubstNo(ATU_lDataMissingErr, 'Supplier Code', ATU_lRowNo));

            ATU_lVendor.Reset();
            if not ATU_lVendor.Get(ATU_lData) then
                Error(StrSubstNo(ATU_lDataNotExist, 'Vendor', ATU_lData));
        end;
    end;

    local procedure ATU_ValidateExcelData(var ATU_pExcelBuffer: Record "Excel Buffer" temporary; var ATU_pSalesLine: Record "Sales Line"; ATU_pRowNo: Integer)
    var
        ATU_lCustomer: Record Customer;
        ATU_lVendor: Record Vendor;
        ATU_lGender: Record ATU_Gender;
        ATU_lDivision: Record ATU_Division;
        ATU_lFactoryName: Record "ATU_Factory Name";
        ATU_lCountryOfOrigin: Record "ATU_Country Of Origin";
        ATU_lCountryOfDestination: Record "ATU_Country Of Destination";
        ATU_lDataCode: Code[50];
        ATU_lDataText: Text[150];
        ATU_lNotFoundDataError: Label 'The value %1 not exist in the %2.\\Please check again.';
    begin
        //Business Unit
        Clear(ATU_lDataCode);
        ATU_lDataCode := ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_pRowNo, 1);
        ATU_pSalesLine.Validate("Shortcut Dimension 1 Code", ATU_lDataCode);

        //Buyer No.
        Clear(ATU_lDataCode);
        ATU_lDataCode := ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_pRowNo, 2);
        ATU_lCustomer.Reset();
        if not ATU_lCustomer.Get(ATU_lDataCode) then
            Error(StrSubstNo(ATU_lNotFoundDataError, ATU_lDataCode, ATU_lCustomer.TableCaption));

        ATU_pSalesLine."ATU_Buyer No." := ATU_lDataCode;

        //Buyer Name
        ATU_pSalesLine."ATU_Buyer Name" := ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_pRowNo, 3);

        //Supplier No.
        Clear(ATU_lDataCode);
        ATU_lDataCode := ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_pRowNo, 4);
        ATU_lVendor.Reset();
        if not ATU_lVendor.Get(ATU_lDataCode) then
            Error(StrSubstNo(ATU_lNotFoundDataError, ATU_lDataCode, ATU_lVendor.TableCaption));

        ATU_pSalesLine."ATU_Supplier No." := ATU_lDataCode;

        //Supplier Name
        ATU_pSalesLine."ATU_Supplier Name" := ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_pRowNo, 5);

        //Agent
        ATU_pSalesLine.ATU_Agent := ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_pRowNo, 6);

        //Gender
        Clear(ATU_lDataText);
        ATU_lDataText := ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_pRowNo, 9);
        ATU_lGender.Reset();
        ATU_lGender.SetFilter(ATU_Name, '@*' + ATU_lDataText + '*');
        if not ATU_lGender.FindFirst() then
            Error(StrSubstNo(ATU_lNotFoundDataError, ATU_lDataText, ATU_lGender.TableCaption));

        ATU_pSalesLine.ATU_Gender := ATU_lDataText;

        //Shipment Buyer Order No.
        ATU_pSalesLine."ATU_Shipment Buyer Order No." := ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_pRowNo, 10);

        //Fiber Content
        ATU_pSalesLine."ATU_Fiber Content" := ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_pRowNo, 11);

        //Colour
        ATU_pSalesLine.ATU_Colour := ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_pRowNo, 12);

        //Dim
        ATU_pSalesLine.ATU_Dim := ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_pRowNo, 13);

        //Division
        Clear(ATU_lDataText);
        ATU_lDataText := ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_pRowNo, 14);
        ATU_lDivision.Reset();
        ATU_lDivision.SetFilter(ATU_Name, '@*' + ATU_lDataText + '*');
        if not ATU_lDivision.FindFirst() then
            Error(StrSubstNo(ATU_lNotFoundDataError, ATU_lDataText, ATU_lDivision.TableCaption));

        ATU_pSalesLine.ATU_Division := ATU_lDataText;

        //Season
        ATU_pSalesLine.ATU_Season := ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_pRowNo, 15);

        //Knitted
        ATU_pSalesLine.ATU_Knitted := ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_pRowNo, 16);

        //Teo Commission
        Evaluate(ATU_pSalesLine."ATU_Teo Commission", ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_pRowNo, 21));

        //Agent Commission
        Evaluate(ATU_pSalesLine."ATU_Agent Commission", ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_pRowNo, 22));

        //Factory Unit Price
        Evaluate(ATU_pSalesLine."ATU_Factory Unit Price", ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_pRowNo, 23));

        //Shipping Method
        ATU_pSalesLine."ATU_Shipping Method" := ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_pRowNo, 24);

        //Request Ship Date
        Evaluate(ATU_pSalesLine."ATU_Request Ship Date", ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_pRowNo, 25));

        //Factory Shipped Date
        Evaluate(ATU_pSalesLine."ATU_Factory Shipped Date", ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_pRowNo, 26));

        //Factory Name
        Clear(ATU_lDataText);
        ATU_lDataText := ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_pRowNo, 27);
        ATU_lFactoryName.Reset();
        ATU_lFactoryName.SetFilter(ATU_Name, '@*' + ATU_lDataText + '*');
        if not ATU_lFactoryName.FindFirst() then
            Error(StrSubstNo(ATU_lNotFoundDataError, ATU_lDataText, ATU_lFactoryName.TableCaption));

        ATU_pSalesLine."ATU_Factory Name" := ATU_lDataText;

        //Country of Origin
        Clear(ATU_lDataCode);
        ATU_lDataCode := ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_pRowNo, 28);
        ATU_lCountryOfOrigin.Reset();
        if not ATU_lCountryOfOrigin.Get(ATU_lDataCode) then
            Error(StrSubstNo(ATU_lNotFoundDataError, ATU_lDataCode, ATU_lCountryOfOrigin.TableCaption));

        ATU_pSalesLine."ATU_Country of Origin" := ATU_lDataCode;

        //Port of Loading
        ATU_pSalesLine."ATU_Port of Loading" := ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_pRowNo, 29);

        //Port of Discharge
        ATU_pSalesLine."ATU_Port of Discharge" := ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_pRowNo, 30);

        //Country of Destination
        Clear(ATU_lDataCode);
        ATU_lDataCode := ATU_GetValueAtCell(ATU_pExcelBuffer, ATU_pRowNo, 31);
        ATU_lCountryOfDestination.Reset();
        if not ATU_lCountryOfDestination.Get(ATU_lDataCode) then
            Error(StrSubstNo(ATU_lNotFoundDataError, ATU_lDataCode, ATU_lCountryOfDestination.TableCaption));

        ATU_pSalesLine."ATU_Country of Destination" := ATU_lDataCode;
    end;
    //HS.4-
}
//HS.1-