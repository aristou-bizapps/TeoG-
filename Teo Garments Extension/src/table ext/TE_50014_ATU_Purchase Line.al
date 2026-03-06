/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-02-03      Create new "Purchase Line" table extension
2                               Add new "Customer PO No.", "Colour", "Code No.", "Factory Shipped Date" field
3               2026-03-03      Add new "Salvage Value" field
4                               Add function to update "Salvage Value" if user key in FA
*/

//HS.1+
tableextension 50014 "ATU_Purchase Line" extends "Purchase Line"
{
    fields
    {
        //HS.2+
        field(50001; "ATU_Customer PO No."; Code[20])
        {
            Caption = 'Customer PO No.';
        }
        field(50002; ATU_Colour; Text[50])
        {
            Caption = 'Colour';
        }
        field(50003; "ATU_Code No."; Code[20])
        {
            Caption = 'Style No.';
        }
        field(50004; "ATU_Factory Shipped Date"; Date)
        {
            Caption = 'Factory Shipped Date';
        }
        //HS.2-
        //HS.3+
        field(50005; "ATU_Salvage Value"; Decimal)
        {
            Caption = 'Salvage Value';
            Editable = false;
        }
        //HS.3-
        //HS.4+
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                ATU_UpdateSalvageValue();
            end;
        }
        //HS.4-
    }

    //HS.4+
    local procedure ATU_UpdateSalvageValue()
    var
        ATU_lFADepreciationBook: Record "FA Depreciation Book";
    begin
        if (Rec.Type = Rec.Type::"Fixed Asset") and (Rec."No." <> '') then begin
            ATU_lFADepreciationBook.Reset();
            ATU_lFADepreciationBook.SetRange("FA No.", Rec."No.");
            ATU_lFADepreciationBook.SetAutoCalcFields("Salvage Value");
            if ATU_lFADepreciationBook.FindFirst() then
                Rec."ATU_Salvage Value" := ATU_lFADepreciationBook."Salvage Value";
        end;
    end;
    //HS.4-
}
//HS.1-