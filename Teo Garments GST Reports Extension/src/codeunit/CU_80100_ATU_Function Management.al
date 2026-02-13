codeunit 80100 "ATU_Function Management"
{
    procedure ATU_ConvertToSGD(ATU_pAmountToConvert: Decimal): Decimal
    var
        ATU_lGLSetup: Record "General Ledger Setup";
        ATU_lCurrency: Record Currency;
        ATU_lCurrExchRate: Record "Currency Exchange Rate";
        ATU_lExchangeRateDate: Date;
        ATU_lExchangeRateAmt: Decimal;
    begin
        if ATU_pAmountToConvert <> 0 then begin
            ATU_lGLSetup.Get();
            ATU_lGLSetup.TestField("LCY Code");
            if ATU_lGLSetup."LCY Code" = 'SGD' then
                exit(ATU_pAmountToConvert)
            else begin
                ATU_lCurrency.Reset();
                ATU_lCurrency.Get('SGD');
                ATU_lCurrExchRate.GetLastestExchangeRate(ATU_lCurrency.Code, ATU_lExchangeRateDate, ATU_lExchangeRateAmt);
                if ATU_lExchangeRateAmt <> 0 then
                    exit(ATU_pAmountToConvert / ATU_lExchangeRateAmt);
            end;
        end;

        exit(0);
    end;
}