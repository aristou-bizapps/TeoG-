/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-02-02      Create new "Aged Accounts Payable" report extension
*/

//HS.1+
reportextension 50001 "ATU_Aged Accounts Payable" extends "Aged Accounts Payable"
{
    RDLCLayout = './src/report layout/REL_50001_ATU_Aged Accounts Payable.rdl';

    dataset
    {
        add(CurrencyLoop)
        {
            column(ATU_PaymentTermCode; Vendor."Payment Terms Code") { }
        }
    }

    labels
    {
        ATU_PaymentTermCaption = 'Payment Term';
    }
}
//HS.1-