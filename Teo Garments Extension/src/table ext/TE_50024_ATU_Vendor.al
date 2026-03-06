/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-03-03      Create new "Vendor" table extension
2                               Add new "Ship-to Address" field
*/

//HS.1+
tableextension 50024 ATU_Vendor extends Vendor
{
    fields
    {
        //HS.2+
        field(50001; "ATU_Ship-to Address"; Text[150])
        {
            Caption = 'Ship-to Address';

            trigger OnLookup()
            var
                ATU_lShipToAddress: Record "ATU_Ship-to Address";
                ATU_lShipToAddressPage: Page "ATU_Ship-to Address";
                ATU_lRecRef: RecordRef;
                ATU_lSelectionFilterMgmt: Codeunit SelectionFilterManagement;
            begin
                ATU_lShipToAddress.Reset();
                ATU_lShipToAddress.SetRange("ATU_Vendor No.", Rec."No.");
                if ATU_lShipToAddress.FindSet() then begin
                    ATU_lShipToAddressPage.SetTableView(ATU_lShipToAddress);
                    ATU_lShipToAddressPage.LookupMode(true);
                    if ATU_lShipToAddressPage.RunModal() = Action::LookupOK then begin
                        ATU_lShipToAddressPage.SetSelectionFilter(ATU_lShipToAddress);
                        ATU_lRecRef.GetTable(ATU_lShipToAddress);
                        Rec."ATU_Ship-to Address" := DelChr(ATU_lSelectionFilterMgmt.GetSelectionFilter(ATU_lRecRef, ATU_lShipToAddress.FieldNo("ATU_Ship-to Address")), '=', '''');
                    end;
                end;
            end;
        }
        //HS.2-
    }
}
//HS.1-