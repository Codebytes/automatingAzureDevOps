# region Include required files
#
$ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
try {
    . ("$ScriptDirectory\DevOpsFunctions.ps1")
}
catch {
    Write-Host "Error while loading supporting PowerShell Scripts" 
}
#endregion

$org = "https://dev.azure.com/chrisNewSig"
$username = "chris.ayers@newsignature.com"
$PAT = ""

$headers = Get-Headers $username $PAT
$existingAgentPools = GetAgentPools $Org $headers

$path = "$ScriptDirectory\agentpools.csv";
$csv = Import-Csv -path $path
foreach ($line in $csv) { 
    $poolName = $line.PoolName;
    $poolId = $line.PoolId;
    if($existingAgentPools  | Where-Object { $_.name -eq $poolName } ){
        Write-Host $poolName "Exists"
    } else {
        Write-Host "Creating" $poolName
        Create-AgentPool $Org $headers $poolName
    }
}

