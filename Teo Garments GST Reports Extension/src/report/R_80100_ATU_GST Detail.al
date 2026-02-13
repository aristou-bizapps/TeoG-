report 80100 "ATU_GST Detail"
{
    ApplicationArea = All;
    Caption = 'ATU GST Detail';
    UsageCategory = Administration;
    DefaultRenderingLayout = "ATU_GST Detail Layout";

    dataset
    {
        dataitem("GST Entry"; "VAT Entry")
        {
            RequestFilterFields = Type, "VAT Prod. Posting Group", "Document No.", "Posting Date";

            column(CompanyName; COMPANYNAME)
            {
            }
            column(Today; Format(Today))
            {
            }
            column(Type; Type)
            {
            }
            column(VAT_Prod__Posting_Group; "VAT Prod. Posting Group")
            {
            }
            column(Entry_No_; "Entry No.")
            {
            }
            column(Document_No_; "Document No.")
            {
            }
            column(External_Document_No_; "External Document No.")
            {
            }
            column(Bill_to_Pay_to_No_; "Bill-to/Pay-to No.")
            {
            }
            column(SourceName; SourceName)
            {
            }
            column(Posting_Date; Format("Posting Date"))
            {
            }
            column(Document_Date; Format("Document Date"))
            {
            }
            column(Base; ATU_gFunctionMgmt.ATU_ConvertToSGD(Base))
            {
            }
            column(Amount; ATU_gFunctionMgmt.ATU_ConvertToSGD(Amount))
            {
            }
            column(TotalAmount; ATU_gFunctionMgmt.ATU_ConvertToSGD(Base + Amount))
            {
            }
            trigger OnPreDataItem()
            begin
                // SetFilter("Document Type", '%1|%2|%3', "GST Entry"."Document Type"::"Credit Memo", "GST Entry"."Document Type"::Invoice, "GST Entry"."Document Type"::"Finance Charge Memo");
            end;

            trigger OnAfterGetRecord()
            begin
                GetSourceName("GST Entry");
            end;
        }
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
        }
    }

    rendering
    {
        layout("ATU_GST Detail Layout")
        {
            Type = RDLC;
            LayoutFile = './src/report layout/RL_80100_ATU_GST Detail.rdlc';
        }
    }

    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        SourceName: Text[100];
        ATU_gFunctionMgmt: Codeunit "ATU_Function Management";

    local procedure GetSourceName(VATEntry: Record "VAT Entry");
    begin
        Clear(SourceName);
        case VATEntry.Type of
            VATEntry.Type::Sale:
                begin
                    if Customer.Get(VATEntry."Bill-to/Pay-to No.") then SourceName := Customer.Name;
                end;
            VATEntry.Type::Purchase:
                begin
                    if Vendor.Get(VATEntry."Bill-to/Pay-to No.") then SourceName := Vendor.Name;
                end;
        end;
    end;
}