/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================
1       HS      2026-01-20      Create new "Convert Amount In Word" codeunit
*/

//HS.1+
codeunit 50004 "ATU_Convert Amount In Word"
{
    var
        ATU_gOnesText: array[20] of Text[90];
        ATU_gTensText: array[10] of Text[90];
        ATU_gThousText: array[5] of Text[30];

    procedure ATU_FormatNoText(ATU_pAmount: Decimal; ATU_pCurrencyText: Text; ATU_pDecimalText: Text): Text
    begin
        ATU_InitTextVariable();
        exit(ATU_NumberInWords(ATU_pAmount, ATU_pCurrencyText, ATU_pDecimalText));
    end;

    local procedure ATU_InitTextVariable()
    begin
        ATU_gOnesText[1] := 'ONE';
        ATU_gOnesText[2] := 'TWO';
        ATU_gOnesText[3] := 'THREE';
        ATU_gOnesText[4] := 'FOUR';
        ATU_gOnesText[5] := 'FIVE';
        ATU_gOnesText[6] := 'SIX';
        ATU_gOnesText[7] := 'SEVEN';
        ATU_gOnesText[8] := 'EIGHT';
        ATU_gOnesText[9] := 'NINE';
        ATU_gOnesText[10] := 'TEN';
        ATU_gOnesText[11] := 'ELEVEN';
        ATU_gOnesText[12] := 'TWELVE';
        ATU_gOnesText[13] := 'THIRTEEN';
        ATU_gOnesText[14] := 'FOURTEEN';
        ATU_gOnesText[15] := 'FIFTEEN';
        ATU_gOnesText[16] := 'SIXTEEN';
        ATU_gOnesText[17] := 'SEVENTEEN';
        ATU_gOnesText[18] := 'EIGHTEEN';
        ATU_gOnesText[19] := 'NINETEEN';

        ATU_gTensText[1] := '';
        ATU_gTensText[2] := 'TWENTY';
        ATU_gTensText[3] := 'THIRTY';
        ATU_gTensText[4] := 'FORTY';
        ATU_gTensText[5] := 'FIFTY';
        ATU_gTensText[6] := 'SIXTY';
        ATU_gTensText[7] := 'SEVENTY';
        ATU_gTensText[8] := 'EIGHTY';
        ATU_gTensText[9] := 'NINETY';

        ATU_gThousText[1] := 'HUNDRED';
        ATU_gThousText[2] := 'THOUSAND';
        ATU_gThousText[3] := 'MILLION';
        ATU_gThousText[4] := 'BILLION';
        ATU_gThousText[5] := 'TRILLION';
    end;

    local procedure ATU_NumberInWords(ATU_pNumber: Decimal; ATU_pCurrencyName: Text[30]; ATU_pDenomName: Text[30]): Text[300]
    var
        ATU_lAmountInWords, ATU_lWholeInWords, ATU_lDecimalInWords : Text[300];
        ATU_lWholePart, ATU_lDecimalPart : Integer;
    begin
        ATU_lWholePart := Round(Abs(ATU_pNumber), 1, '<');
        ATU_lDecimalPart := Abs((Abs(ATU_pNumber) - ATU_lWholePart) * 100);

        ATU_lWholeInWords := ATU_NumberToWords(ATU_lWholePart, '');
        ATU_lWholeInWords := ATU_lWholeInWords.Trim();

        if ATU_lDecimalPart <> 0 then begin
            ATU_lDecimalInWords := ATU_NumberToWords(ATU_lDecimalPart, ATU_pDenomName);
            ATU_lWholeInWords := ATU_lWholeInWords + ' AND ' + ATU_lDecimalInWords;
        end;

        ATU_lAmountInWords := '**** ' + ATU_lWholeInWords + ' ONLY ' + ATU_pCurrencyName;
        exit(ATU_lAmountInWords);
    end;

    local procedure ATU_NumberToWords(ATU_pNumber: Decimal; ATU_pAppendScale: Text[30]): Text[300]
    var
        ATU_lNumString: Text[300];
        ATU_lPow, ATU_lLog : Integer;
        ATU_lPowStr: Text[50];
    begin
        ATU_lNumString := '';
        if ATU_pNumber < 100 then begin
            if ATU_pNumber < 20 then begin
                if ATU_pNumber <> 0 then
                    ATU_lNumString := ATU_gOnesText[ATU_pNumber];
            end else begin
                ATU_lNumString := ATU_gTensText[ATU_pNumber div 10];
                if (ATU_pNumber mod 10) > 0 then
                    ATU_lNumString := ATU_lNumString + ' ' + ATU_gOnesText[ATU_pNumber mod 10];
            end;
        end else begin
            ATU_lPow := 0;
            ATU_lPowStr := '';
            if ATU_pNumber < 1000 then begin // number is between 100 and 1000
                ATU_lPow := 100;
                ATU_lPowStr := ATU_gThousText[1];
            end else begin // find the scale of the number
                ATU_lLog := Round(StrLen(Format(ATU_pNumber div 1000)) / 3, 1, '>');
                ATU_lPow := Power(1000, ATU_lLog);
                ATU_lPowStr := ATU_gThousText[ATU_lLog + 1];
            end;

            ATU_lNumString := ATU_NumberToWords(ATU_pNumber div ATU_lPow, ATU_lPowStr) + ' ' + ATU_NumberToWords(ATU_pNumber mod ATU_lPow, '');
        end;

        exit(DelChr(ATU_lNumString, '<>', ' ') + ' ' + ATU_pAppendScale);
    end;
}
//HS.1-