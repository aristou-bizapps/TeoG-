/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-02-10      Create new "Notification Email" report extension
*/

//HS.1+
reportextension 50003 "ATU_Notification Email" extends "Notification Email"
{
    WordLayout = './src/report layout/REL_50003_ATU_Notification Email.docx';

    dataset
    {
        add("Notification Entry")
        {
            column(ATU_BusinessUnit; ATU_gBusinessUnit) { }
        }

        modify("Notification Entry")
        {
            trigger OnAfterAfterGetRecord()
            var
                ATU_lRecRef: RecordRef;
            begin
                ATU_gDataTypeManagement.GetRecordRef("Triggered By Record", ATU_lRecRef);
                ATU_GetBusinessUnit(ATU_lRecRef);
            end;
        }
    }

    labels
    {
        ATU_BusinessUnitCaption = 'Business Unit';
    }

    var
        ATU_gDataTypeManagement: Codeunit "Data Type Management";
        ATU_gBusinessUnit: Code[20];

    local procedure ATU_GetBusinessUnit(ATU_pSourceRecRef: RecordRef)
    var
        ATU_lTargetRecRef: RecordRef;
    begin
        Clear(ATU_gBusinessUnit);

        ATU_GetTargetRecRef(ATU_pSourceRecRef, ATU_lTargetRecRef);

        case ATU_lTargetRecRef.Number of
            Database::"Sales Header", Database::"Sales Invoice Header", Database::"Sales Cr.Memo Header",
            Database::"Purchase Header", Database::"Purch. Inv. Header", Database::"Purch. Cr. Memo Hdr.":
                ATU_gBusinessUnit := ATU_lTargetRecRef.Field(29).Value;
            Database::"Gen. Journal Line":
                ATU_gBusinessUnit := ATU_lTargetRecRef.Field(24).Value;
            Database::Customer, Database::Vendor:
                ATU_gBusinessUnit := ATU_lTargetRecRef.Field(16).Value;
        end;
    end;

    local procedure ATU_GetTargetRecRef(ATU_pSourceRecRef: RecordRef; var ATU_pTargetRecRef: RecordRef)
    var
        ATU_lApprovalEntry: Record "Approval Entry";
        ATU_lOverdueApprovalEntry: Record "Overdue Approval Entry";
    begin
        case "Notification Entry".Type of
            "Notification Entry".Type::"New Record":
                ATU_pTargetRecRef := ATU_pSourceRecRef;
            "Notification Entry".Type::Approval:
                begin
                    ATU_pSourceRecRef.SetTable(ATU_lApprovalEntry);
                    ATU_pTargetRecRef.Get(ATU_lApprovalEntry."Record ID to Approve");
                end;
            "Notification Entry".Type::Overdue:
                begin
                    ATU_pSourceRecRef.SetTable(ATU_lOverdueApprovalEntry);
                    ATU_pTargetRecRef.Get(ATU_lOverdueApprovalEntry."Record ID to Approve");
                end;
        end;
    end;
}
//HS.1-