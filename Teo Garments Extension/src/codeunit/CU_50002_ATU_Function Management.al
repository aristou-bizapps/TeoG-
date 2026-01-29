/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================
1       HS      2026-01-20      Create new "Function Management" codeunit
2                               Add function to check THL Company
3                               Add function to check TGC Company
*/

//HS.1+
codeunit 50002 "ATU_Function Management"
{
    //HS.2+
    procedure ATU_IsTHLCompany(): Boolean
    var
        ATU_lCompanyInfo: Record "Company Information";
    begin
        ATU_lCompanyInfo.Get();
        if ATU_lCompanyInfo."Custom System Indicator Text" = 'TH' then
            exit(true);

        exit(false);
    end;
    //HS.2-
    //HS.3+
    procedure ATU_IsTGCCompany(): Boolean
    var
        ATU_lCompanyInfo: Record "Company Information";
    begin
        ATU_lCompanyInfo.Get();
        if ATU_lCompanyInfo."Custom System Indicator Text" = 'TGC' then
            exit(true);

        exit(false);
    end;
    //HS.3-
}
//HS.1-