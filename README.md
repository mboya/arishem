### _Caching_
We can enable caching so the next request will not require the system to process all 20K records again.
We first need to turn on caching for the rails portion of the application with the following:
```
rails dev:cache
```

### _User_
When a user registers/create an account, a wallet is created for them and a bonus kes 50 is credited into the account

### _Wallet_
Wallet will contain 3 elements
```
 - Credit : finances coming into the account.
 - Debit : finances leaving the account.
 - Overdraft : Excess based on credit, this will be tracked separatly.
```
> _We do have a DB constaint that will always make sure the above are never going to be negatives._ 

### *Finance Workflow*
Registered User should be able to top-up his account via m-pesa
```
 1. using lipa na mpesa api to send to a till/business number and this loads credit into the account
 2. using C2B, loads credit into the account
```

Registered Users should be able to send each other funds, so long as they are registered
```
 - This will defintly be a B2C, since technically the funds will be on the business since rather than the client
```

### *Loading Account*