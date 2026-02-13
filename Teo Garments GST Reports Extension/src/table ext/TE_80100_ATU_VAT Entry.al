tableextension 80100 "Aristou VAT Entry" extends "VAT Entry"
{
    fields
    {
        field(80100; "VAT Identifier"; Code[20])
        {
            Caption = 'VAT Identifier';
            FieldClass = FlowField;
            CalcFormula = lookup("VAT Posting Setup"."VAT Identifier" where("VAT Bus. Posting Group" = field("VAT Bus. Posting Group"), "VAT Prod. Posting Group" = field("VAT Prod. Posting Group")));
            Editable = false;
        }
    }
}
