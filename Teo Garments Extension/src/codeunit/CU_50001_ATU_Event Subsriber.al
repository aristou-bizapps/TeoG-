/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================
1       HS      2026-01-20      Create new "Event Subscriber" codeunit
2                               Ignore validate when key in VAT Registration No in Company Information page
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
}
//HS.1-