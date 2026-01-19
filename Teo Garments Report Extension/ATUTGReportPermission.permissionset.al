permissionset 50200 "ATUReportPermission"
{
    Assignable = true;
    Permissions = report "ATU_Credit Note" = X,
        report "ATU_Debit Note" = X,
        report "ATU_Purchase Order Material" = X,
        report "ATU_Purchase Order Standard" = X,
        report "ATU_Tax Invoice" = X,
        codeunit "ATU_Report Management" = X;
}