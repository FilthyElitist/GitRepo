# Notes
# ISSUE: log file sucks
# ISSUE: maybe rewrite function?
# ISSUE: not WHERE-ing



# Push Pop
Push-Location
Import-Module "SQLPS" -DisableNameChecking
Pop-Location


## FUNCTIONS

# Source SQL
function RunSql-Source {
        param([string] $sqlCommand = $(throw "Please specify a query"))
    # NEW: $sqlCommand | Add-Content $logFile
    Add-Content $logFile -Value $sqlCommand
    $output = Invoke-Sqlcmd -query $sqlCommand -ServerInstance $sqlServerSource -Database $sqlDatabaseSource
    return $output
}

# Target SQL
function RunSql-Target {
        param([string] $sqlCommand = $(throw "Please specify a query"))
    Add-Content $logFile -Value $sqlCommand
    $outputB = Invoke-Sqlcmd -query $sqlCommand -ServerInstance $sqlServerTarget -Database $sqlDatabaseTarget
    return $outputB
}



## DECLARE DATABASES

# Declare Source & Target Databases    # Hardcoded for now

$srcCID            = Read-Host -Prompt 'Enter Source CID'
$sqlServerSource   = Read-Host -Prompt 'Enter Source Cluster Thing'
$sqlDatabaseSource = Read-Host -Prompt 'Enter SOURCE database name'

$tgtCID            = Read-Host -Prompt 'Enter Target CID' 
$sqlServerTarget   = Read-Host -Prompt 'Enter Target Cluster Thing'
$sqlDatabaseTarget = Read-Host -Prompt 'Enter TARGET database name'





## MAKE TABLE VARIABLES

# DateString
$dateVar = $((Get-Date).ToString("MMddyyyy"))


# Backup Tables
$srcClientsBak = "[_ConversionDatawork]..[$($srcCid)_CccBAK_Clients_$($dateVar)]"
$srcCcNumbersBAK = "[_ConversionDatawork]..[$($srcCid)_CccBAK_CcNumbers_$($dateVar)]"
# Target
$tgtClientsBak = "[_ConversionDatawork]..[$($tgtCID)_CccBAK_Clients_$($dateVar)]"
$tgtCcNumbersBAK = "[_ConversionDatawork]..[$($tgtCID)_CccBAK_CcNumbers_$($dateVar)]"

# Transfer Tables
$srcClientsTable = "[_ConversionDatawork].[PROD\keegan.johnson].[$($srcCid)_Ccc_SrcClients_$($dateVar)]"
$srcCcNumbersTable = "[_ConversionDatawork].[PROD\keegan.johnson].[$($srcCid)_Ccc_SRCtblCCNumbers_$($dateVar)]"



# Logfile
$logFile = "D:\SQL Conversions\_keegan Johnson\Investigate & Learning\CCC Powershell\Logfile\CccLog_$($srcCID) to $($tgtCID)_$($dateVar).log"



## Pause for a Clause
$clientsWhereClause = " "
$ccWhereClause = " "

$clientsWhereClause = Read-Host -Prompt "If applicable, enter the WHERE clause for dbo.CLIENTS"
$ccWhereClause = Read-Host -Prompt "If applicable, enter the WHERE clause for dbo.tblCcNumbers"



## CHECK SOURCE FOR ENCRYPTED DATA


# Check for Encrypted CCs

# Script
$checkSourceEncryptedCc = "select count(ID) from tblCCNumbers where (CreditCardno is not null or ACHAccountNum is not null)"
# Run Script and output as a number you can work with
$encryptedSrcCcCount = (RunSql-Source $checkSourceEncryptedCc).Column1

# QA: print results
write-host "there are " $encryptedSrcCcCount " encrypted CC or ACH numbers"

if ($encryptedSrcCcCount -ge 1)
    {$encryptedSrcCC = 'y'}
else {$encryptedSrcCC = 'n'}

# QA: print status
write-host "recognized encrypted CCs: " $encryptedSrcCC


# Check for Encrypted PWs
$checkSourceEncryptedPw = "select count(passwordenc) from clients where passwordenc is not null"
$encryptedSrcPwCount = (RunSql-Source $checkSourceEncryptedPw).Column1

# QA
write-host "there are " $encryptedSrcPwCount " encrypted PWs"

if ($encryptedSrcPwCount -ge 1)
    {$encryptedSrcPW = 'y'}
else {$encryptedSrcPW = 'n'}

# QA: print status
write-host "recognized encrypted PWs: " $encryptedSrcPW
Read-Host -Prompt "Press enter to continue "


## ASK IF WE'RE BRINGING IT OVER

IF($encryptedSrcPW -eq 'y')
    {$includeSrcPW = Read-Host -Prompt "Are we bringing over the passwords? y/n: "
        while("y", "n" -notcontains $includeSrcPW)
            {$includeSrcPW = Read-Host -Prompt "Are we bringing over the passwords? y/n: "}}
ELSE {$includeSrcPW='n'}

IF($encryptedSrcCC -eq 'y')
    {$includeSrcCC = Read-Host -Prompt "Are we bringing over the CCs? y/n: "
        while("y", "n" -notcontains $includeSrcCC)
            {$includeSrcCC = Read-Host -Prompt "Are we bringing over the CCs? y/n: "}}
ELSE {$includeSrcCC='n'}



### Source Backups

echo "`n   ***************Create Backup tables`n"

$srcClientsBackup = "
USE $($sqlDatabaseSource)
go
select * into $($srcClientsBak) from clients
"

$srcBillingBackup = "
USE $($sqlDatabaseSource)
go
select * into $($srcCcNumbersBak) from tblCCNumbers
"

if ($includeSrcCC -eq 'y')
{
    $srcBackup = $srcClientsBackup + $srcBillingBackup }
else {
    $srcBackup =  $srcClientsBackup  }


RunSql-Source $srcBackup


Read-Host -Prompt "Backups created. Verify with: `n select * from $($srcClientsBak) `n select * from $($srcCcNumbersBak) `n Press enter to continue "


### Source Decryption

if($includeSrcPW -eq 'y' -or $includeSrcCC -eq 'y')    {
    $seniorScript = "Can you please DEcrypt source site $($srcCID) $($sqlDatabaseSource)?" 
    if($includeSrcPW -eq 'y' -and $includeSrcCC -eq 'y')   {
        $seniorScript += " CCs and passwords."}
    elseif($includeSrcPW -eq 'y') {
        $seniorScript += " Just passwords."}
    elseif($includeSrcCC -eq 'y') {
        $seniorScript += " Just CCs."}
    $seniorScript += " I have backups."
    echo "`n   Ask Senior for DEcryption of Source`n"
    Write-Output $seniorScript | clip
    Read-Host -Prompt "(Script placed in clipboard). Ask Senior for Decryption. Press enter when done."}
   

### Check Decryption Results

$decryptionCheckPW = "
select top 10 passwordenc from clients
where passwordenc is not null order by PasswordEnc desc
go"
$decryptionCheckCC = "
select clientid, right(creditcardno,4) from tblccnumbers 
where isnumeric(creditcardno)=0 and creditcardno is not null"

if($includeSrcPW -eq 'y' -or $includeSrcCC -eq 'y') {
    if($includeSrcCC-eq'y' -and $includeSrcPW -eq 'y') {
        $decryptionCheckScript = $decryptionCheckPW + $decryptionCheckCC }
    elseif($includeSrcCC -eq 'y' -and $includeSrcPW -eq 'n') {
        $decryptionCheckScript=$decryptionCheckCC }
    elseif($includeSrcCC -eq 'n' -and $includeSrcPW -eq 'y') {
        $decryptionCheckScript=$decryptionCheckPW }
    
RunSql-Source $decryptionCheckPW 
RunSql-Source $decryptionCheckCC
echo "`n   Check Decryption Success"
Read-Host -Prompt "(Script run). Press enter when done if everything looks okay"}



### Source Transfer Tables

echo "`n **********  Create Transfer Tables   **********   `n"

$srcTransferScript = "
USE $($sqlDatabaseSource)
go
select * into $srcClientsTable from Clients $($clientsWhereClause)
go
alter table $srcClientsTable drop column staffalertmsgshort
go
alter table $srcClientsTable drop column medicAlertshort
go
delete from $srcClientsTable
where clientId in (-2,0,1,98765)
go"


$srcTransferCC = "
USE $($sqlDatabaseSource)
go
Select * into $srcCcNumbersTable from tblccnumbers $($ccWhereClause)
go
alter table $srcCcNumbersTable drop column id
go"

if ($includeSrcCC -eq 'y') {
    $srcTransferScript = $srcTransferScript + $srcTransferCC}

RunSql-Source $srcTransferScript

Read-Host -Prompt "(Script run in SOURCE site) Transfer tables have been created. Press enter to continue "


### Source Encryption

if($includeSrcPW -eq 'y' -or $includeSrcCC -eq 'y')    {
    $seniorScript = "Can you please ENcrypt source site $($srcCID) $($sqlDatabaseSource)?" 
    if($includeSrcPW -eq 'y' -and $includeSrcCC -eq 'y')   {
        $seniorScript += " CCs and passwords."}
    elseif($includeSrcPW -eq 'y') {
        $seniorScript += " Just passwords."}
    elseif($includeSrcCC -eq 'y') {
        $seniorScript += " Just CCs."}
 
    Write-Output $seniorScript | clip
    Read-Host -Prompt "Ask Senior for ENcrypt of Source      (Script placed in clipboard)  `n  Press enter when done"
    Write-Host "SOURCE is now encrypted. Moving to TARGET site now. `n ******** MOVE THE TRANSFER TABLES TO THE NEW SERVER ****** `n From $($sqlServerSource) INTO  $($sqlServerTarget) `n `n `nPress enter when done... "}
    Read-Host -Prompt "Have you moved the freakin' table(s) over????"


###############################################################
###############################################################
########### SWITCH TO TARGET  #################################
###############################################################
###############################################################


## Check for ID Overlap

[int]$overlapUpdateNum = 0
$overlapQuery = "select count(clientid) from $($srcClientsTable) where clientID + $overlapUpdateNum in (select clientid from Clients)"

$overlapCount =(Runsql-Target $overlapQuery).Column1
write-host "overlap: " $overlapCount

while ($overlapCount -gt 0)
{
    $overlapUpdateNum = [int]$overlapUpdateNum + 50000
    $overlapQuery = "select count(clientid) from $($srcClientsTable) where clientID + $overlapUpdateNum in (select clientid from Clients)"
    # echo $overlapQuery
    $overlapCount =(Runsql-Target $overlapQuery).Column1
    write-host "overlap: " $overlapCount
}

Read-Host -Prompt "Updated overlapping ID value if applicable. Press enter to continue "


# Update ClientIDs

$updateSourceClientsString ="
USE $($sqlDatabaseTarget)
go
Update $($srcClientsTable)
set clientId=clientid+ $($overlapUpdateNum)
go
update $($srcClientsTable)
set rssid=clientID
go
"

$updateSourceCCstring ="
USE $($sqlDatabaseTarget)
go
update $($srcCcNumbersTable) set clientId=clientid+ $($overlapUpdateNum)
go
"

if ($includeSrcCC -eq 'n')
    {echo "`n Alter IDs `n"
     $alterIDs = $updateSourceClientsString}
else
    {echo "`n Alter IDs `n"
    $alterIDs = $updateSourceClientsString + $updateSourceCCstring}


RunSql-Target $alterIDs

Read-Host -Prompt "IDs altered if necessary. Press enter to continue "







# Check for Encrypted CCs

# Script
$checkTargetEncryptedCc = "select count(ID) from tblCCNumbers where (CreditCardno is not null or ACHAccountNum is not null)"
# Run Script and output as a number you can work with
$encryptedTargetCcCount = (RunSql-Target $checkTargetEncryptedCc).Column1

# QA: print results
write-host "there are " $encryptedTargetCcCount " encrypted CC or ACH numbers in TARGET site"

if ($encryptedTargetCcCount -ge 1)
    {$encryptedTargetCC = 'y'}
else {$encryptedTargetCC = 'n'}

# QA: print status
write-host "recognized encrypted CCs: " $encryptedTargetCC


# Check for Encrypted PWs
$checkTargetEncryptedPw = "select count(passwordenc) from clients where passwordenc is not null"
$encryptedTargetPwCount = (RunSql-Target $checkTargetEncryptedPw).Column1

# QA
write-host "there are " $encryptedTargetPwCount " encrypted PWs in TARGET site"

if ($encryptedTargetPwCount -ge 1)
    {$encryptedTargetPW = 'y'}
else {$encryptedTargetPW = 'n'}

# QA: print status
write-host "recognized encrypted PWs: " $encryptedTargetPW
Read-Host -Prompt "Press enter to continue "

### Destination Backups

echo "`n   ***************Create Backup tables`n"

$TGTclientsBackup = "
USE $($sqlDatabaseTarget)
go
select * into $($tgtClientsBak) from clients
"

$TGTbillingBackup = "
USE $($sqlDatabaseTarget)
go
select * into $($tgtCcNumbersBak) from tblCCNumbers
"

if ($encryptedTargetCC -eq 'y' -and $includeSrcCC -eq 'y')
{
    $targetBackup = $TGTclientsBackup + $TGTbillingBackup }
else {
    $targetBackup =  $TGTclientsBackup  }

# echo $targetBackup


RunSql-Target $targetBackup


Read-Host -Prompt "Backups created. Verify with: `n select * from $($tgtClientsBak) `n select * from $($tgtCcNumbersBak) `n Press enter to continue "


# Assess need for decrypto
if(
    ($encryptedTargetPW -eq 'y' -and $includeSrcPW -eq 'y') -or ($encryptedTargetCC -eq 'y' -and $includeSrcCC -eq 'y')  )
    {$seniorScript = "Can you please DEcrypt destination site $($tgtCID) $($sqlDatabaseTarget) ?" 
    if(  ($encryptedTargetPW -eq 'y' -and $includeSrcPW -eq 'y' -and $encryptedTargetCC -eq 'y' -and $includeSrcCC -eq 'y'))
        {$seniorScript += " CCs and passwords."}
    elseif($encryptedTargetPW -eq 'y' -and $includeSrcPW -eq 'y')
        {$seniorScript += " Just passwords"}
    elseif($encryptedTargetCC -eq 'y')
        {$seniorScript += " Just CCs."}
    $seniorScript += " I have backups"
    $seniorScript | clip
    Read-Host -Prompt "(Script placed in clipboard). `n Press enter when done. Next step in INSERT... "}




# ### Insert


echo "`n Insert Source Data into Destination`n"

$insertClients = "
USE $($sqlDatabaseTarget)
go
INSERT INTO dbo.CLIENTS
SELECT     $($srcClientsTable).*
FROM         $($srcClientsTable)
go"

$insertTblCC = "
USE $($sqlDatabaseTarget)
go
INSERT INTO dbo.tblCCNumbers
SELECT    $($srcCcNumbersTable).*
FROM         $($srcCcNumbersTable)
go"

if($includeSrcCC-eq'y') {
    $insertStatement = $insertClients + $insertTblCC }
else {
    $insertStatement = $insertClients }


RunSql-Target $insertStatement

Read-Host -Prompt "Script ran. Press enter when done... "


# ### Destination Re-Encryption



# Destination Reencryption (note it checks if the SOURCE had encrypted data)


if($includeSrcPW -eq 'y' -or $includeSrcCC -eq'y') 
    {$seniorScript = "Can you please ENcrypt destination site $($tgtCID) $($sqlDatabaseTarget)." 
    if($includeSrcPW -eq 'y' -and $includeSrcCC -eq 'y') {
        $seniorScript = $seniorScript + " CCs and passwords."}
    elseif($includeSrcPW -eq 'y') {
        $seniorScript += " Just passwords."}
    elseif($includeSrcCC -eq 'y'){
        $seniorScript += " Just CCs."}
    echo "`n   Ask Senior for REencryption of Destination`n"
    $seniorScript | clip
    echo "(Script placed in clipboard)."
    Read-Host -Prompt "Press enter when done... "}


# ### Drop Tables If Needed

$dropTableMain = "
"
$dropTablePW = "drop table $($srcClientsTable)"
$dropTableCC = "`n drop table $($srcCcNumbersTable)"

if($includeSrcPW -eq 'y' -or $includeSrcCC -eq 'y') 
    {if($includeSrcPW -eq'y' -and $includeSrcCC -eq 'y')
        {$dropTableMain = $dropTableMain + $dropTablePW + $dropTableCC}
    elseif($includeSrcPW -eq 'y' -and $includeSrcCC -eq 'n')
        {$dropTableMain = $dropTableMain + $dropTablePW}
    elseif($includeSrcPW -eq 'n' -and $includeSrcCC -eq 'y')
        {$dropTableMain = $dropTableMain+ $dropTableCC}
    RunSql-Target "USE $($sqlDatabaseTarget)
        go
        $($dropTableMain)"
    RunSql-Source "USE $($sqlDatabaseSource)
        go
        $($dropTableMain)"
    echo "`n Drop decrypted tables. Script run"
    Read-Host -Prompt "Press enter when done... "
    }


# ### Grand Finale and only truly important part of this



#$dOnE = input

echo ("
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
")
