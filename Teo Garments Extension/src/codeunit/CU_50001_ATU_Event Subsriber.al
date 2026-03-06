/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================
1       HS      2026-01-20      Create new "Event Subscriber" codeunit
2                               Ignore validate when key in VAT Registration No in Company Information page
3               2026-02-02      Add function to validate if the PO created from SO
4               2026-02-04      Add function to transfer "Shipment Buyer Order No." from Sales Line to Requisition Line
5                               Add function to transfer "Shipment Buyer Order No." from Requisition Line to Purchase Line
6                               Add function to transfer field from Sales Order and Purchase Order to General Ledger Entries
7                               Add function to transfer field from Sales Order/Purchase Order Lines to Item Ledger Entry
8               2026-02-13      Add function to validate "Sales Order No." can't be blank before posting PO
9               2026-03-02      Add validate for "Country of Origin" and "Country of Destination" must be mandatory before posting SO
10                              Add validate for "Payment Term Code" before posting for SI
11              2026-03-03      Add validate for "Currency Code" must be fill in before posting for Sales and Purchase
12                              Add function for validate "Shipment Buyer Order No." before convert SO to PO
13              2026-03-04      Make the "Expected Receipt Date" follow the "Factory Shipped Date" after PO created
14              2026-03-05      Add validation for "Purchaser Code", "Business Unit" must be mandatory before send approval for PO
15                              Transfer "Manual Invoice No." from Sales Header to Customer Ledger Entry
16                              Transfer "Sales Order No." and "Purchase Order No." to Item Ledger Entries
17              2026-03-06      Change the Details in Notification Email to format "Issued by [Purchaser Code]" for Purchase
*/

//HS.1+
codeunit 50001 "ATU_Event Subscriber"
{
    Permissions = tabledata Item = rimd;

    //HS.2+
    [EventSubscriber(ObjectType::Table, Database::"VAT Registration No. Format", 'OnBeforeTest', '', false, false)]
    local procedure ATU_VATRegNoFormat_OnBeforeTest(VATRegNo: Text[20]; CountryCode: Code[10]; Number: Code[20]; TableID: Option; Check: Boolean; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;
    //HS.2-
    //HS.3+
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Doc. From Sales Doc.", 'OnCreatePurchaseOrderOnAfterPurchaseHeaderSetFilters', '', false, false)]
    local procedure ATU_PurchDocFromSalesDoc_OnCreatePurchaseOrderOnAfterPurchaseHeaderSetFilters(var PurchaseHeader: Record "Purchase Header"; SalesHeader: Record "Sales Header")
    var
        ATU_lSalesHeader: Record "Sales Header";
    begin
        if (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order) and (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) then begin
            PurchaseHeader."ATU_Is PO Created From SO" := true;
            PurchaseHeader."ATU_Sales Order No." := SalesHeader."No.";
            PurchaseHeader.Modify();

            ATU_lSalesHeader.Reset();
            if ATU_lSalesHeader.Get(SalesHeader."Document Type", SalesHeader."No.") then begin
                ATU_lSalesHeader."ATU_Purchase Order No." := PurchaseHeader."No.";
                ATU_lSalesHeader.Modify();
            end;
        end;
    end;
    //HS.3-
    //HS.4+
    [EventSubscriber(ObjectType::Table, Database::"Requisition Line", 'OnAfterTransferFromUnplannedDemand', '', false, false)]
    local procedure ATU_RequisitionLine_OnAfterTransferFromUnplannedDemand(var RequisitionLine: Record "Requisition Line"; UnplannedDemand: Record "Unplanned Demand")
    var
        ATU_lSalesLine: Record "Sales Line";
    begin
        ATU_lSalesLine.Reset();
        if ATU_lSalesLine.Get(ATU_lSalesLine."Document Type"::Order, UnplannedDemand."Demand Order No.", UnplannedDemand."Demand Line No.") then begin
            RequisitionLine."ATU_Shipment Buyer Order No." := ATU_lSalesLine."ATU_Shipment Buyer Order No.";
            RequisitionLine.ATU_Colour := ATU_lSalesLine.ATU_Colour;
            RequisitionLine."ATU_Factory Unit Price" := ATU_lSalesLine."ATU_Factory Unit Price";
            RequisitionLine."ATU_Unit of Measure Code" := ATU_lSalesLine."Unit of Measure Code";
            RequisitionLine."ATU_Factory Shipped Date" := ATU_lSalesLine."ATU_Factory Shipped Date";
        end;
    end;
    //HS.4-
    //HS.5+
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", 'OnAfterInitPurchOrderLine', '', false, false)]
    local procedure ATU_ReqWkshMakeOrder_OnAfterInitPurchOrderLine(var PurchaseLine: Record "Purchase Line"; RequisitionLine: Record "Requisition Line")
    var
        ATU_lItem: Record Item;
    begin
        PurchaseLine.Validate("Direct Unit Cost", RequisitionLine."ATU_Factory Unit Price");
        PurchaseLine.Validate("Unit of Measure Code", RequisitionLine."ATU_Unit of Measure Code");
        PurchaseLine."ATU_Customer PO No." := RequisitionLine."ATU_Shipment Buyer Order No.";
        PurchaseLine.ATU_Colour := RequisitionLine.ATU_Colour;
        PurchaseLine."ATU_Factory Shipped Date" := RequisitionLine."ATU_Factory Shipped Date";

        ATU_lItem.Reset();
        if ATU_lItem.Get(PurchaseLine."No.") then begin
            ATU_lItem.Validate("Unit Cost", PurchaseLine."Direct Unit Cost");
            ATU_lItem.Modify(true);
        end;
    end;
    //HS.5-
    //HS.13+
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", 'OnAfterInsertPurchOrderLine', '', false, false)]
    local procedure ATU_ReqWkshMakeOrder_OnAfterInsertPurchOrderLine(var PurchOrderLine: Record "Purchase Line"; var NextLineNo: Integer; var RequisitionLine: Record "Requisition Line"; var PurchOrderHeader: Record "Purchase Header")
    begin
        PurchOrderHeader.Validate("Expected Receipt Date", PurchOrderLine."ATU_Factory Shipped Date");
        PurchOrderHeader.Modify();
    end;
    //HS.13-
    //HS.6+
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromSalesHeader', '', false, false)]
    local procedure ATU_GenJnlLine_OnAfterCopyGenJnlLineFromSalesHeader(SalesHeader: Record "Sales Header"; var GenJournalLine: Record "Gen. Journal Line");
    begin
        GenJournalLine."ATU_Purchase Order No." := SalesHeader."ATU_Purchase Order No.";
        GenJournalLine."ATU_Manual Invoice No." := SalesHeader."ATU_Manual Invoice No."; //HS.15
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromPurchHeader', '', false, false)]
    local procedure ATU_GenJnlLine_OnAfterCopyGenJnlLineFromPurchHeader(PurchaseHeader: Record "Purchase Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."ATU_Sales Order No." := PurchaseHeader."ATU_Sales Order No.";
    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]
    local procedure ATU_GLEntry_OnAfterCopyGLEntryFromGenJnlLine(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line");
    begin
        GLEntry."ATU_Purchase Order No." := GenJournalLine."ATU_Purchase Order No.";
        GLEntry."ATU_Sales Order No." := GenJournalLine."ATU_Sales Order No.";
    end;
    //HS.6-
    //HS.7+
    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromSalesLine', '', false, false)]
    local procedure ATU_ItemJnlLine_OnAfterCopyItemJnlLineFromSalesLine(var ItemJnlLine: Record "Item Journal Line"; SalesLine: Record "Sales Line")
    var
        ATU_SalesHdr: Record "Sales Header"; //HS.16
    begin
        ItemJnlLine."ATU_Buyer No." := SalesLine."ATU_Buyer No.";
        ItemJnlLine."ATU_Buyer Name" := SalesLine."ATU_Buyer Name";
        ItemJnlLine."ATU_Supplier No." := SalesLine."ATU_Supplier No.";
        ItemJnlLine."ATU_Supplier Name" := SalesLine."ATU_Supplier Name";
        ItemJnlLine.ATU_Agent := SalesLine.ATU_Agent;
        ItemJnlLine.ATU_Gender := SalesLine.ATU_Gender;
        ItemJnlLine."ATU_Shipment Buyer Order No." := SalesLine."ATU_Shipment Buyer Order No.";
        ItemJnlLine."ATU_Fiber Content" := SalesLine."ATU_Fiber Content";
        ItemJnlLine.ATU_Colour := SalesLine.ATU_Colour;
        ItemJnlLine.ATU_Dim := SalesLine.ATU_Dim;
        ItemJnlLine.ATU_Division := SalesLine.ATU_Division;
        ItemJnlLine.ATU_Season := SalesLine.ATU_Season;
        ItemJnlLine.ATU_Knitted := SalesLine.ATU_Knitted;
        ItemJnlLine."ATU_Teo Commission" := SalesLine."ATU_Teo Commission";
        ItemJnlLine."ATU_Agent Commission" := SalesLine."ATU_Agent Commission";
        ItemJnlLine."ATU_Factory Unit Price" := SalesLine."ATU_Factory Unit Price";
        ItemJnlLine."ATU_Shipping Method" := SalesLine."ATU_Shipping Method";
        ItemJnlLine."ATU_Request Ship Date" := SalesLine."ATU_Request Ship Date";
        ItemJnlLine."ATU_Factory Shipped Date" := SalesLine."ATU_Factory Shipped Date";
        ItemJnlLine."ATU_Factory Name" := SalesLine."ATU_Factory Name";
        ItemJnlLine."ATU_Country of Origin" := SalesLine."ATU_Country of Origin";
        ItemJnlLine."ATU_Country of Destination" := SalesLine."ATU_Country of Destination";
        ItemJnlLine."ATU_Port of Loading" := SalesLine."ATU_Port of Loading";
        ItemJnlLine."ATU_Port of Discharge" := SalesLine."ATU_Port of Discharge";

        //HS.16+
        ATU_SalesHdr.Reset();
        if ATU_SalesHdr.Get(SalesLine."Document Type", SalesLine."Document No.") then
            ItemJnlLine."ATU_Purchase Order No." := ATU_SalesHdr."ATU_Purchase Order No.";
        //HS.16-
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromPurchLine', '', false, false)]
    local procedure ATU_ItemJnlLine_OnAfterCopyItemJnlLineFromPurchLine(var ItemJnlLine: Record "Item Journal Line"; PurchLine: Record "Purchase Line")
    var
        ATU_lPurchHdr: Record "Purchase Header"; //HS.16
    begin
        ItemJnlLine."ATU_Shipment Buyer Order No." := PurchLine."ATU_Customer PO No.";
        ItemJnlLine.ATU_Colour := PurchLine.ATU_Colour;
        ItemJnlLine."ATU_Code No." := PurchLine."ATU_Code No.";
        ItemJnlLine."ATU_Factory Shipped Date" := PurchLine."ATU_Factory Shipped Date";

        //HS.16+
        ATU_lPurchHdr.Reset();
        if ATU_lPurchHdr.Get(PurchLine."Document Type", PurchLine."Document No.") then
            ItemJnlLine."ATU_Sales Order No." := ATU_lPurchHdr."ATU_Sales Order No.";
        //HS.16-
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure ATU_ItemJnlPostLine_OnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; var ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer)
    begin
        NewItemLedgEntry."ATU_Buyer No." := ItemJournalLine."ATU_Buyer No.";
        NewItemLedgEntry."ATU_Buyer Name" := ItemJournalLine."ATU_Buyer Name";
        NewItemLedgEntry."ATU_Supplier No." := ItemJournalLine."ATU_Supplier No.";
        NewItemLedgEntry."ATU_Supplier Name" := ItemJournalLine."ATU_Supplier Name";
        NewItemLedgEntry.ATU_Agent := ItemJournalLine.ATU_Agent;
        NewItemLedgEntry.ATU_Gender := ItemJournalLine.ATU_Gender;
        NewItemLedgEntry."ATU_Shipment Buyer Order No." := ItemJournalLine."ATU_Shipment Buyer Order No.";
        NewItemLedgEntry."ATU_Fiber Content" := ItemJournalLine."ATU_Fiber Content";
        NewItemLedgEntry.ATU_Colour := ItemJournalLine.ATU_Colour;
        NewItemLedgEntry.ATU_Dim := ItemJournalLine.ATU_Dim;
        NewItemLedgEntry.ATU_Division := ItemJournalLine.ATU_Division;
        NewItemLedgEntry.ATU_Season := ItemJournalLine.ATU_Season;
        NewItemLedgEntry.ATU_Knitted := ItemJournalLine.ATU_Knitted;
        NewItemLedgEntry."ATU_Teo Commission" := ItemJournalLine."ATU_Teo Commission";
        NewItemLedgEntry."ATU_Agent Commission" := ItemJournalLine."ATU_Agent Commission";
        NewItemLedgEntry."ATU_Factory Unit Price" := ItemJournalLine."ATU_Factory Unit Price";
        NewItemLedgEntry."ATU_Shipping Method" := ItemJournalLine."ATU_Shipping Method";
        NewItemLedgEntry."ATU_Request Ship Date" := ItemJournalLine."ATU_Request Ship Date";
        NewItemLedgEntry."ATU_Factory Shipped Date" := ItemJournalLine."ATU_Factory Shipped Date";
        NewItemLedgEntry."ATU_Factory Name" := ItemJournalLine."ATU_Factory Name";
        NewItemLedgEntry."ATU_Country of Origin" := ItemJournalLine."ATU_Country of Origin";
        NewItemLedgEntry."ATU_Country of Destination" := ItemJournalLine."ATU_Country of Destination";
        NewItemLedgEntry."ATU_Port of Loading" := ItemJournalLine."ATU_Port of Loading";
        NewItemLedgEntry."ATU_Port of Discharge" := ItemJournalLine."ATU_Port of Discharge";
        NewItemLedgEntry."ATU_Code No." := ItemJournalLine."ATU_Code No.";
        //HS.16+
        NewItemLedgEntry."ATU_Sales Order No." := ItemJournalLine."ATU_Sales Order No.";
        NewItemLedgEntry."ATU_Purchase Order No." := ItemJournalLine."ATU_Purchase Order No.";
        //HS.16-
    end;
    //HS.7-
    //HS.9+
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", 'OnBeforeOnRun', '', false, false)]
    local procedure ATU_SalesPostYesNo_OnBeforeOnRun(var SalesHeader: Record "Sales Header")
    var
        ATU_lSalesLine: Record "Sales Line";
    begin
        SalesHeader.TestField("Currency Code"); //HS.11

        case SalesHeader."Document Type" of
            SalesHeader."Document Type"::Order:
                begin
                    ATU_lSalesLine.Reset();
                    ATU_lSalesLine.SetRange("Document Type", SalesHeader."Document Type");
                    ATU_lSalesLine.SetRange("Document No.", SalesHeader."No.");
                    ATU_lSalesLine.SetRange(Type, ATU_lSalesLine.Type::Item);
                    ATU_lSalesLine.SetFilter("No.", '<>%1', '');
                    if ATU_lSalesLine.FindSet() then begin
                        repeat
                            ATU_lSalesLine.TestField("ATU_Country Of Origin");
                            ATU_lSalesLine.TestField("ATU_Country Of Destination");
                        until ATU_lSalesLine.Next() = 0;
                    end;
                end;
            SalesHeader."Document Type"::Invoice:
                begin
                    SalesHeader.TestField("Payment Terms Code"); //HS.10
                end;
        end;
    end;
    //HS.9-
    //HS.8+
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnBeforeOnRun', '', false, false)]
    local procedure ATU_PurchPostYesNo_OnBeforeOnRun(var PurchaseHeader: Record "Purchase Header")
    begin
        PurchaseHeader.TestField("Currency Code"); //HS.11

        if PurchaseHeader."Document Type" in [PurchaseHeader."Document Type"::Order] then
            PurchaseHeader.TestField("ATU_Sales Order No.");
    end;
    //HS.8-
    //HS.12+
    [EventSubscriber(ObjectType::Page, Page::"Sales Order", 'OnBeforeActionEvent', 'CreatePurchaseOrder', false, false)]
    local procedure ATU_SalesOrder_OnBeforeActionEvent_CreatePurchaseOrder(var Rec: Record "Sales Header")
    var
        ATU_lSalesLine: Record "Sales Line";
    begin
        ATU_lSalesLine.Reset();
        ATU_lSalesLine.SetRange("Document Type", Rec."Document Type");
        ATU_lSalesLine.SetRange("Document No.", Rec."No.");
        ATU_lSalesLine.SetRange(Type, ATU_lSalesLine.Type::Item);
        ATU_lSalesLine.SetFilter("No.", '<>%1', '');
        if ATU_lSalesLine.FindSet() then begin
            repeat
                ATU_lSalesLine.TestField("ATU_Shipment Buyer Order No.");
            until ATU_lSalesLine.Next() = 0;
        end;
    end;
    //HS.12-
    //HS.14+
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnBeforeCheckPurchaseApprovalPossible', '', false, false)]
    local procedure ATU_ApprovalsMgmt_OnBeforeCheckPurchaseApprovalPossible(var PurchaseHeader: Record "Purchase Header"; var Result: Boolean; var IsHandled: Boolean)
    begin
        case PurchaseHeader."Document Type" of
            PurchaseHeader."Document Type"::Order:
                begin
                    PurchaseHeader.TestField("Purchaser Code");
                    PurchaseHeader.TestField("Shortcut Dimension 1 Code");
                end;
        end;
    end;
    //HS.14-
    //HS.15+
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitCustLedgEntry', '', false, false)]
    local procedure ATU_GenJnlPostLine_OnAfterInitCustLedgEntry(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line"; var GLRegister: Record "G/L Register")
    begin
        CustLedgerEntry."ATU_Manual Invoice No." := GenJournalLine."ATU_Manual Invoice No.";
    end;
    //HS.15-
    //HS.17+
    [EventSubscriber(ObjectType::Report, Report::"Notification Email", 'OnSetReportFieldPlaceholdersOnBeforeGetWebUrl', '', false, false)]
    local procedure ATU_NotificationEmail_OnSetReportFieldPlaceholdersOnBeforeGetWebUrl(RecRef: RecordRef; var Field1Label: Text; var Field1Value: Text; var Field2Label: Text; var Field2Value: Text; var Field3Label: Text; var Field3Value: Text; var SourceRecRef: RecordRef; var DetailsLabel: Text; var DetailsValue: Text; NotificationEntry: Record "Notification Entry")
    var
        ATU_lPurchHdr: Record "Purchase Header";
        ATU_lPurchInvHdr: Record "Purch. Inv. Header";
        ATU_lPurchCMHdr: Record "Purch. Cr. Memo Hdr.";
    begin
        case RecRef.Number of
            Database::"Purchase Header":
                begin
                    RecRef.SetTable(ATU_lPurchHdr);
                    DetailsValue := 'Issued by ' + ATU_lPurchHdr."Purchaser Code";
                end;
            Database::"Purch. Inv. Header":
                begin
                    RecRef.SetTable(ATU_lPurchInvHdr);
                    DetailsValue := 'Issued by ' + ATU_lPurchInvHdr."Purchaser Code";
                end;
            Database::"Purch. Cr. Memo Hdr.":
                begin
                    RecRef.SetTable(ATU_lPurchCMHdr);
                    DetailsValue := 'Issued by ' + ATU_lPurchCMHdr."Purchaser Code";
                end;
        end;
    end;
    //HS.17-
}
//HS.1-