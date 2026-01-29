/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-01-20      Create new "Purchase Order" page extension
2                               Add new action to print the "Purchase Order Material" and "Purchase Order Standard" reports
*/

//HS.1+
pageextension 50008 "ATU_Purchase Order" extends "Purchase Order"
{
    actions
    {
        //HS.2+
        addafter("&Print")
        {
            action("ATU_Purchase Order Material")
            {
                ApplicationArea = All;
                Caption = 'Purchase Order Material';
                Image = Report;

                trigger OnAction()
                var
                    ATU_lPurchHeader: Record "Purchase Header";
                begin
                    CurrPage.SetSelectionFilter(ATU_lPurchHeader);
                    Report.RunModal(Report::"ATU_Purchase Order Material", true, false, ATU_lPurchHeader);
                end;
            }
            action("ATU_Purchase Order Standard")
            {
                ApplicationArea = All;
                Caption = 'Purchase Order Standard';
                Image = Report;

                trigger OnAction()
                var
                    ATU_lPurchHeader: Record "Purchase Header";
                begin
                    CurrPage.SetSelectionFilter(ATU_lPurchHeader);
                    Report.RunModal(Report::"ATU_Purchase Order Standard", true, false, ATU_lPurchHeader);
                end;
            }
        }

        addafter("&Print_Promoted")
        {
            actionref(ATU_POMaterial_Promoted; "ATU_Purchase Order Material") { }
            actionref(ATU_POStandard_Promoted; "ATU_Purchase Order Standard") { }
        }
        //HS.2-
    }
}
//HS.1-