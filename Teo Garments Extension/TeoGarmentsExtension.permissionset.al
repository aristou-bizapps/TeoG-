permissionset 50001 TeoGarmentsExtension
{
    Assignable = true;
    Permissions = report "ATU_Credit Note" = X,
        report "ATU_Debit Note" = X,
        report "ATU_Purchase Order Material" = X,
        report "ATU_Purchase Order Standard" = X,
        report "ATU_Tax Invoice" = X,
        report "ATU_THL Unposted Tax Invoice" = X,
        codeunit "ATU_Convert Amount In Word" = X,
        codeunit "ATU_Event Subscriber" = X,
        codeunit "ATU_Function Management" = X,
        codeunit "ATU_Report Management" = X,
        report "ATU_Payment Voucher" = X,
        report "ATU_THL Posted Tax Invoice" = X,
        report "ATU_Cash Receipt Voucher" = X,
        report "ATU_Customer Statement (Email)" = X;
}