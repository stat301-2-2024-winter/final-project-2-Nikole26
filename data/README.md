## Datasets
`SBAnational.csv`: It's the original data set. 
`sba.rds`: It's the clean and tidy dataset. 

## Codebook
| Variable Name       | Description                                                 |
|---------------------|-------------------------------------------------------------|
| LoanNr_ChkDgt       | Identifier Primary key                                     |
| Name                | Borrower name                                               |
| City                | Borrower city                                               |
| State               | Borrower state                                              |
| Zip                 | Borrower zip code                                           |
| Bank                | Bank name                                                   |
| BankState           | Bank state                                                  |
| NAICS               | North American industry classification system code         |
| ApprovalDate        | Date SBA commitment issued                                  |
| ApprovalFY          | Fiscal year of commitment                                   |
| Term                | Loan term in months                                         |
| NoEmp               | Number of business employees                                |
| NewExist            | 1 = Existing business, 2 = New business                     |
| CreateJob           | Number of jobs created                                      |
| RetainedJob         | Number of jobs retained                                     |
| FranchiseCode       | Franchise code, (00000 or 00001) = No franchise             |
| UrbanRural          | 1 = Urban, 2 = rural, 0 = undefined                         |
| RevLineCr           | Revolving line of credit: Y = Yes, N = No                    |
| LowDoc              | LowDoc Loan Program: Y = Yes, N = No                         |
| ChgOffDate          | The date when a loan is declared to be in default            |
| DisbursementDate    | Disbursement date                                           |
| DisbursementGross   | Amount disbursed                                            |
| BalanceGross        | Gross amount outstanding                                    |
| MIS_Status          | Loan status charged off = CHGOFF, Paid in full = PIF        |
| ChgOffPrinGr        | Charged-off amount                                          |
| GrAppv              | Gross amount of loan approved by bank                        |
| SBA_Appv            | SBA’s guaranteed amount of approved loan                    |
