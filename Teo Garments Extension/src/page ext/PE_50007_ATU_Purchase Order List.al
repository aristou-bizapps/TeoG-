/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-01-20      Create new "Purchase Order List" page extension
2                               Add new action to print the "Purchase Order" report
*/

//HS.1+
pageextension 50007 "ATU_Purchase Order List" extends "Purchase Order List"
{
    actions
    {
        //HS.2+
        addafter(Print)
        {
            action("ATU_Purchase Order")
            {
                ApplicationArea = All;
                Caption = 'Purchase Order';
                Image = Report;

                trigger OnAction()
                var
                    ATU_lPurchHeader: Record "Purchase Header";
                begin
                    CurrPage.SetSelectionFilter(ATU_lPurchHeader);

                    if Rec."ATU_Is PO Created From SO" then
                        Report.RunModal(Report::"ATU_Purchase Order Standard", true, false, ATU_lPurchHeader)
                    else
                        Report.RunModal(Report::"ATU_Purchase Order Material", true, false, ATU_lPurchHeader);
                end;
            }
        }

        addafter(Print_Promoted)
        {
            actionref(ATU_PurchaseOrder_Promoted; "ATU_Purchase Order") { }
        }
        //HS.2-
    }
}
//HS.1-