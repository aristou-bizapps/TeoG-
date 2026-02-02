/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================
1       HS      2026-01-20      Create new "Event Subscriber" codeunit
2                               Ignore validate when key in VAT Registration No in Company Information page
3               2026-02-02      Add function to validate if the PO created from SO
*/

//HS.1+
codeunit 50001 "ATU_Event Subscriber"
{
    //HS.2+
    [EventSubscriber(ObjectType::Table, Database::"VAT Registration No. Format", 'OnBeforeTest', '', false, false)]
    local procedure ACPL_VATRegNoFormat_OnBeforeTest(VATRegNo: Text[20]; CountryCode: Code[10]; Number: Code[20]; TableID: Option; Check: Boolean; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;
    //HS.2-
    //HS.3+
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Doc. From Sales Doc.", 'OnCreatePurchaseOrderOnAfterPurchaseHeaderSetFilters', '', false, false)]
    local procedure ATU_PurchDocFromSalesDoc_OnCreatePurchaseOrderOnAfterPurchaseHeaderSetFilters(var PurchaseHeader: Record "Purchase Header"; SalesHeader: Record "Sales Header")
    begin
        if (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order) and (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) then begin
            PurchaseHeader."ATU_Is PO Created From SO" := true;
            PurchaseHeader.Modify();
        end;
    end;
    //HS.3-
}
//HS.1-