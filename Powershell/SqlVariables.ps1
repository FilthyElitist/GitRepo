
# Used so backups are named correctly
$dateVar = $((Get-Date).ToString("MMddyyyy"))
[int]$overlapUpdateNum = 0

# Create backup of clients table
$clientsBak = @"
SELECT *
INTO [_ConversionDatawork]..[@xxyyxx_ClientsBAK_CCC_$($dateVar)]
FROM dbo.CLIENTS
"@

# Create backup of tblCcnumbers
$tblCcNumbersBak = @"
SELECT *
INTO [_ConversionDatawork]..[@xxyyxx_tblCcNumbersBAK_CCC_$($dateVar)]
FROM dbo.tblCcNumbers
"@

# Create SOURCE tables
# Later, declare column names specifically
# $whereClause needs to start with AND; otherwise will be ""
$srcClientsTable = @"
SELECT *
INTO [_ConversionDatawork].[PROD\keegan.johnson].[@xxyyxx_SrcClients_$($dateVar)]
FROM CLIENTS
WHERE clientId NOT IN (-2,0,1,98765)
$($whereClause)
"@

$srcCcNumbersTable = @"
SELECT tblCcNumbers.*
INTO [_ConversionDatawork].[PROD\keegan.johnson].[@xxyyxx_SRCtblCCNumbers_$($dateVar)]
FROM tblCcNumbers
INNER JOIN [_ConversionDatawork].[PROD\keegan.johnson].[@xxyyxx_SrcClients_$($dateVar)] s
    on tblCcNumbers.ClientID = s.ClientID
"@

$findEncryptedPw = @"
select count(passwordenc) as Count from clients 
where passwordenc is not null
"@

$findEncryptedCc = @"
select count(ID) as Count from tblCCNumbers 
where (CreditCardno is not null or ACHAccountNum is not null)
"@

$checkDecryptedPW = @"
select top 10 passwordenc from clients
where passwordenc is not null order by PasswordEnc desc
go
"@

$checkDecryptedCC = @"
select top 10 right(creditcardno,4) from tblccnumbers 
where isnumeric(creditcardno)=0 and creditcardno is not null
"@

$overlapQuery = @"
select count(clientid) from [_ConversionDatawork].[PROD\keegan.johnson].[@xxyyxx_SrcClients_$($dateVar)]
where clientID + @xykk in (select clientid from Clients)
"@

$updateSourceClientsString = @"
Update $($srcClientsTable)
set OldClientId = ClientId
go
Update $($srcClientsTable)
set clientId=clientid+ $($overlapUpdateNum)
go
update $($srcClientsTable)
set rssid=clientID
where RSSID = cast(OldclientID as nvarchar)
go
"@

$updateSourceCCstring =@"
update $($srcCcNumbersTable) set clientId=clientid+ $($overlapUpdateNum)
"@

$insertClients = @"
INSERT INTO dbo.CLIENTS
SELECT     $($srcClientsTable).*
FROM         $($srcClientsTable)
go
"@

$insertTblCC = @"
INSERT INTO dbo.tblCCNumbers
SELECT    $($srcCcNumbersTable).*
FROM         $($srcCcNumbersTable)
go
"@


$rawr = @"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~               __       --------   ~~~~~
~~~~~              / _) --- |'rawr' |   ~~~~~
~~~~~     _.----._/ /        -------    ~~~~~
~~~~~    /         /                    ~~~~~
~~~~~ __/ (  | (  |                     ~~~~~ 
~~~~~/__.-'|_|--|_|                     ~~~~~
~~~~~                                   ~~~~~
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~yOu'vE bEen FLIM FLAMMED ~~~~~~~~~
~~~by jon & keegan ~~~~~~~~~~~~~~~~~~~~~~~
  ~~~~~~~~da flim flam krew~~~~~~~~
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"@
 