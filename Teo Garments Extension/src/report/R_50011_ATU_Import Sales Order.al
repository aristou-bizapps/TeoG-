/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-02-03      Create new "Import Sales Order" report
*/

//HS.1+
report 50011 "ATU_Import Sales Order"
{
    ApplicationArea = All;
    Caption = 'ATU Import Sales Order';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;

    trigger OnPreReport()
    var
        ATU_lFunctionMgmt: Codeunit "ATU_Function Management";
    begin
        ATU_ReadExcelSheet();
        ATU_lFunctionMgmt.ATU_CreateSalesOrder(ATU_gExcelBuffer, ATU_gSalesOrderNo, ATU_gNoOfSOCreated);
    end;

    trigger OnPostReport()
    var
        ATU_lSalesHeader: Record "Sales Header";
        ATU_lSalesOrderCreatedMsg: Label '%1 Sales Orders created.\\Do you want to open?';
        ATU_lNoSalesOrderCreatedMsg: Label 'No Sales Orders created.';
    begin
        if ATU_gNoOfSOCreated <> 0 then begin
            if Dialog.Confirm(StrSubstNo(ATU_lSalesOrderCreatedMsg, ATU_gNoOfSOCreated)) then begin
                if ATU_gNoOfSOCreated = 1 then begin
                    ATU_lSalesHeader.Reset();
                    if ATU_lSalesHeader.Get(ATU_lSalesHeader."Document Type"::Order, ATU_gSalesOrderNo) then
                        Page.Run(Page::"Sales Order", ATU_lSalesHeader);
                end else begin
                    ATU_lSalesHeader.Reset();
                    ATU_lSalesHeader.SetFilter("No.", ATU_gSalesOrderNo);
                    if ATU_lSalesHeader.FindSet() then
                        Page.Run(Page::"Sales Order List", ATU_lSalesHeader);
                end;
            end;
        end else
            Message(ATU_lNoSalesOrderCreatedMsg);
    end;

    var
        ATU_gSalesOrderNo: Text;
        ATU_gNoOfSOCreated: Integer;
        ATU_gExcelBuffer: Record "Excel Buffer" temporary;

    local procedure ATU_ReadExcelSheet()
    var
        ATU_lFileMgmt: Codeunit "File Management";
        ATU_lInStream: InStream;
        ATU_lFileName, ATU_lSheetName, ATU_lFromFile : Text[100];
        ATU_lUploadExcelMsg: Label 'Please Choose the Excel file';
        ATU_lNoFileFoundErr: Label 'No Excel file found!';
    begin
        UploadIntoStream(ATU_lUploadExcelMsg, '', '', ATU_lFromFile, ATU_lInStream);
        if ATU_lFromFile <> '' then begin
            ATU_lFileName := ATU_lFileMgmt.GetFileName(ATU_lFromFile);
            ATU_lSheetName := ATU_gExcelBuffer.SelectSheetsNameStream(ATU_lInStream);
        end else
            Error(ATU_lNoFileFoundErr);

        ATU_gExcelBuffer.Reset();
        ATU_gExcelBuffer.DeleteAll();
        ATU_gExcelBuffer.OpenBookStream(ATU_lInStream, ATU_lSheetName);
        ATU_gExcelBuffer.ReadSheet();
    end;
}
//HS.1-