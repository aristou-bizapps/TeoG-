/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================
1       HS      2026-01-20      Create new "PO Report Type" enum
*/

//HS.1+
enum 50001 "ATU_PO Report Type"
{
    Extensible = true;
    AssignmentCompatibility = true;

    value(0; "Pending Approval") { Caption = 'Pending Approval'; }
    value(1; "Complete Approval") { Caption = 'Complete Approval'; }
}
//HS.1-