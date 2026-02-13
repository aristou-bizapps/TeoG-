report 80101 "ATU_GST Form 5"
{
    ApplicationArea = All;
    Caption = 'ATU GST Form 5';
    UsageCategory = Administration;
    DefaultRenderingLayout = "ATU_GST Form 5 Layout";

    dataset
    {
        dataitem(Header; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = filter('1'));

            column(CompanyName; COMPANYNAME)
            {
            }
            column(CompanyTaxRefNo; CompanyInfo."VAT Registration No.")
            {
            }
            column(CompanyGSTRegNo; CompanyInfo."VAT Registration No.")
            {
            }
            column(AccountingPeriod; Format(StartDate) + '..' + Format(EndDate))
            {
            }
            dataitem(Line; Integer)
            {
                DataItemTableView = sorting(Number) where(Number = filter('1..15'));

                column(Number; Number)
                {
                }
                column(Form5HeaderText; Form5Header[Number])
                {
                }
                column(Form5Value; ATU_gFunctionMgmt.ATU_ConvertToSGD(Form5Value[Number]))
                {
                }
                column(NAText; NAText)
                {
                }
                column(Toggle; Toggle)
                {
                }
                trigger OnPreDataItem()
                begin
                    InitHeaders();
                end;

                trigger OnAfterGetRecord()
                begin
                    Toggle := CalculateGST(Number);
                end;
            }
            trigger OnPreDataItem()
            begin
                CompanyInfo.Get();
                if (StandardRated = '') or (ZeroRated = '') or (Exempt = '') or (TaxablePurchases = '') then Error('One or more VAT Identifier filter is left blank.');
                if (StartDate = 0D) or (EndDate = 0D) or (EndDate < StartDate) then Error('Date values are wrong.');
            end;
        }
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(Date)
                {
                    field(StartDate; StartDate)
                    {
                        Caption = 'Start Date';
                        ApplicationArea = All;
                    }
                    field(EndDate; EndDate)
                    {
                        Caption = 'End Date';
                        ApplicationArea = All;
                    }
                }
                group(Filters)
                {
                    field(StandardRated; StandardRated)
                    {
                        Caption = 'Standard Rated';
                        ApplicationArea = All;
                    }
                    field(ZeroRated; ZeroRated)
                    {
                        Caption = 'Zero Rated';
                        ApplicationArea = All;
                    }
                    field(Exempt; Exempt)
                    {
                        Caption = 'Exempt';
                        ApplicationArea = All;
                    }
                    field(TaxablePurchases; TaxablePurchases)
                    {
                        Caption = 'Taxable Purchases';
                        ApplicationArea = All;
                    }
                    field(RevenueGLAcct; RevenueGLAcct)
                    {
                        Caption = 'Revenue G/L Account';
                        TableRelation = "G/L Account";
                        ApplicationArea = All;
                    }
                }
                group("Filters (Special)")
                {
                    field(ReverseCharge; ReverseCharge)
                    {
                        Caption = 'Reverse Charge';
                        ApplicationArea = All;
                    }
                    field(DigitalServices; DigitalServices)
                    {
                        Caption = 'Digital Services';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    rendering
    {
        layout("ATU_GST Form 5 Layout")
        {
            Type = RDLC;
            LayoutFile = './src/report layout/RL_80101_ATU_GST Form 5.rdlc';
        }
    }
    var
        StartDate: Date;
        EndDate: Date;
        StandardRated: Code[50];
        ZeroRated: Code[50];
        Exempt: Code[50];
        RevenueGLAcct: Code[50];
        TaxablePurchases: Code[50];
        ReverseCharge: Code[50];
        DigitalServices: Code[50];
        Form5Header: array[15] of Text;
        Form5Value: array[15] of Decimal;
        Toggle: Boolean;
        NAText: TextConst ENU = 'N/A';
        CompanyInfo: Record "Company Information";
        VATEntry: Record "VAT Entry";
        GLAccount: Record "G/L Account";
        ATU_gFunctionMgmt: Codeunit "ATU_Function Management";

    local procedure InitHeaders();
    begin
        Form5Header[1] := 'Total value of standard-rated supplies';
        Form5Header[2] := 'Total value of zero-rated supplies';
        Form5Header[3] := 'Total value of exempt supplies';
        Form5Header[4] := 'Total value of (1) + (2) + (3)';
        Form5Header[5] := 'Total value of taxable purchases (exclude expenses where input tax is disallowed)';
        Form5Header[6] := 'Output tax due';
        Form5Header[7] := 'Input tax and refunds claimed (exclude disallowed input tax)';
        Form5Header[8] := 'Net GST to be paid to IRAS';
        Form5Header[9] := 'Total value of goods imported under import GST suspension schemes\(e.g. Major Exporter Scheme, Approved 3rd Party Logistics Company)';
        Form5Header[10] := 'Total value of tourist refund claimed';
        Form5Header[11] := 'Total value of bad debts relief claims and/ or refund for reverse charge transactions';
        Form5Header[12] := 'Pre-registration input tax claims';
        Form5Header[13] := 'Revenue';
        Form5Header[14] := 'Value of imported services subject to reverse charge';
        Form5Header[15] := 'Value of digital services supplied by electronic marketplace';
    end;

    local procedure CalculateGST(inNumber: Integer): Boolean
    begin
        VATEntry.Reset();
        VATEntry.SetRange("Posting Date", StartDate, EndDate);
        case inNumber of
            1:
                begin
                    VATEntry.SetRange(Type, VATEntry.Type::Sale);
                    VATEntry.SetFilter("VAT Identifier", StandardRated);
                    VATEntry.CalcSums(Base);
                    Form5Value[1] := VATEntry.Base * -1;
                end;
            2:
                begin
                    VATEntry.SetRange(Type, VATEntry.Type::Sale);
                    VATEntry.SetFilter("VAT Identifier", ZeroRated);
                    VATEntry.CalcSums(Base);
                    Form5Value[2] := VATEntry.Base * -1;
                end;
            3:
                begin
                    VATEntry.SetRange(Type, VATEntry.Type::Sale);
                    VATEntry.SetFilter("VAT Identifier", Exempt);
                    VATEntry.CalcSums(Base);
                    Form5Value[3] := VATEntry.Base * -1;
                end;
            4:
                begin
                    Form5Value[4] := Abs(Form5Value[1] + Form5Value[2] + Form5Value[3]);
                end;
            5:
                begin
                    VATEntry.SetRange(Type, VATEntry.Type::Purchase);
                    VATEntry.SetFilter("VAT Identifier", TaxablePurchases);
                    VATEntry.CalcSums(Base);
                    Form5Value[5] := Abs(VATEntry.Base);
                end;
            6:
                begin
                    VATEntry.SetRange(Type, VATEntry.Type::Sale);
                    VATEntry.CalcSums(Amount);
                    // Form5Value[6] := Abs(VATEntry.Amount);
                    Form5Value[6] := VATEntry.Amount * -1;
                end;
            7:
                begin
                    VATEntry.SetRange(Type, VATEntry.Type::Purchase);
                    VATEntry.CalcSums(Amount);
                    Form5Value[7] := Abs(VATEntry.Amount);
                end;
            8:
                begin
                    Form5Value[8] := Form5Value[6] - Form5Value[7];
                end;
            9:
                begin
                    //NA
                    //exit(false);
                end;
            10:
                begin
                    //NA
                    //exit(false);
                end;
            11:
                begin
                    //NA
                    //exit(false);
                end;
            12:
                begin
                    //NA
                    //exit(false);
                end;
            13:
                begin
                    GLAccount.Reset();
                    GLAccount.SetFilter("Date Filter", '%1..%2', StartDate, EndDate);
                    GLAccount.SetRange("No.", RevenueGLAcct);
                    if GLAccount.FindFirst() then GLAccount.CalcFields("Net Change");
                    Form5Value[13] := Abs(GLAccount."Net Change");
                end;
            14:
                begin
                    //if ReverseCharge = '' then
                    //exit(false);
                    VATEntry.SetRange(Type, VATEntry.Type::Purchase);
                    VATEntry.SetRange("VAT Identifier", ReverseCharge);
                    VATEntry.CalcSums(Base);
                    Form5Value[14] := Abs(VATEntry.Base);
                end;
            15:
                begin
                    //if DigitalServices = '' then
                    //exit(false);
                    VATEntry.SetRange(Type, VATEntry.Type::Purchase);
                    VATEntry.SetRange("VAT Identifier", DigitalServices);
                    VATEntry.CalcSums(Base);
                    Form5Value[15] := Abs(VATEntry.Base);
                end;
        end;
        exit(true);
    end;
}