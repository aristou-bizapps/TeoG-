pageextension 50206 "ATU_Purchase Order" extends "Purchase Order"
{
    actions
    {
        addafter("&Print")
        {
            action("ATU_Purchase Order Material")
            {
                ApplicationArea = All;
                Caption = 'Purchase Order Material';
                Image = Print;

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
                Image = Print;

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
    }
}