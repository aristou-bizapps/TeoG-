/*
NO      DEV     DATE            DESCRIPTION
=========================================================================================================================
1       HS      2026-02-02      Create new "Aged Accounts Receivable" report extension
*/

//HS.1+
reportextension 50002 "ATU_Aged Accounts Receivable" extends "Aged Accounts Receivable"
{
    RDLCLayout = './src/report layout/REL_50002_ATU_Aged Accounts Receivable.rdl';

    dataset
    {
        add(CurrencyLoop)
        {
            column(ATU_PaymentTermCode; Customer."Payment Terms Code") { }
        }
    }

    labels
    {
        ATU_PaymentTermCaption = 'Payment Term';
    }
}
//HS.1-