pageextension 80100 "ATU_VAT Entries" extends "VAT Entries"
{
    layout
    {
        addafter("VAT Prod. Posting Group")
        {
            field("VAT Identifier"; Rec."VAT Identifier")
            {
                ApplicationArea = All;
            }
        }
    }
}
