function Test-FindMbStudio
{
        Param
        ([Parameter(Position=0, Mandatory=$true)] [string] $StudioID)

        $global:result =  "SELECT TOP 1 StudioShort, dbPath FROM dbo.Studios WHERE StudioID=$StudioID"
        
}


<#
.SYNOPSIS
Look up the StudioShort & Server for a given StudioID.

.DESCRIPTION
This function queries wsMaster  to return the Studio Short 
and Server Name for a given Studio ID.

If an error occurs looking up the studio ID, $null is returned.

.PARAMETER StudioID
The studio ID to look up.
#>

function Find-MBStudio
{
    Param
    ([Parameter(Position=0, Mandatory=$true)] [int] $StudioID)

    $rs = Invoke-Sqlcmd -ServerInstance 'WAT' `
                        -Database "wsMaster" `
                        -Query "SELECT TOP 1 StudioShort, dbPath FROM dbo.Studios WHERE StudioID=$StudioID"
    # Write-Verbose "Find-MBStudio: Studio Short for CID $StudioID is $($rs.StudioShort) on server $($rs.dbPath)"
    return $rs.StudioShort, $rs.dbPath
}


<#
.SYNOPSIS
Run given SQL statement against specified source site

.DESCRIPTION
This function takes in the source server and database
name and executes the result.

Writes output to log in a hideous way. 
It has no meaningful error handling :)

.PARAMETER sqlCommand
The SQL statement to be run
#>

function Run-SqlSource {
    param(
        [string] $sqlCommand = $(throw "Please specify a query"),
        [switch] $test
        )
    if($test) {Write-Host "Invoke-Sqlcmd -query $($sqlCommand) -ServerInstance $sqlServer -Database $sqlDatabase"}
    else { 
    Add-Content $logFile -Value $sqlCommand
    $output = Invoke-Sqlcmd -query $sqlCommand -ServerInstance $sqlServer -Database $sqlDatabase
    return $output }
}