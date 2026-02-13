/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-01-20      Create new "Purchase Order" page extension
2                               Add new action to print the "Purchase Order" report
3               2026-02-03      Pull out "Sales Order No.", "Remarks" field
*/

//HS.1+
pageextension 50008 "ATU_Purchase Order" extends "Purchase Order"
{
    layout
    {
        addlast(General)
        {
            //HS.3+
            field("ATU_Sales Order No."; Rec."ATU_Sales Order No.")
            {
                ApplicationArea = All;
            }
            field(ATU_Remarks; Rec.ATU_Remarks)
            {
                ApplicationArea = All;
                MultiLine = true;
            }
            //HS.3-
        }
    }

    actions
    {
        //HS.2+
        addafter("&Print")
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

        addafter("&Print_Promoted")
        {
            actionref(ATU_POMaterial_Promoted; "ATU_Purchase Order") { }
        }
        //HS.2-
    }
}
//HS.1-