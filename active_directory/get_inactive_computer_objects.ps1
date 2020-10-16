$timeStamp = Get-Date -UFormat "%Y-%m-%d-%H-%M-%S"
$fortyFiveDaysAgo = Get-Date -Format G ((Get-Date).AddDays(-45))

#$path1 = "C:\Users\user\Desktop\AD_Active_Check\ARD\ard_computer_list.csv"
$path2 = "C:\Users\user\Desktop\AD_Active_Check\Scratch\ad_computer_list_$timeStamp.csv"
$path3 = "C:\Users\user\Desktop\AD_Active_Check\Scratch\comparison_results_$timeStamp.csv"
$path4 = "C:\Users\user\Desktop\AD_Active_Check\Scratch\macs_to_test_$timeStamp.csv"
$path5 = "C:\Users\user\Desktop\AD_Active_Check\Scratch\failed_ping_macs_$timeStamp.txt"
$path6 = "C:\Users\user\Desktop\AD_Active_Check\old_macs_to_remove_$timeStamp.txt"

# check for ard export
#if (!(Test-Path $path1)) {
#    Throw "Missing exported ARD list!"
#}

# get AD list
Get-ADComputer -SearchScope OneLevel -SearchBase "OU=Computers,DC=ad,DC=company,DC=pri" -Filter * -Properties CN | Select-Object CN | Sort-Object -Property CN | Export-CSV -Path $path2 -NoTypeInformation

#$ardComputerList = Import-CSV -Path $path1
$adComputerList = Import-CSV -Path $path2

Write-Host `n"Generating Client Lists" -ForegroundColor Yellow

# compare ARD to AD
#Compare-Object -ReferenceObject $ardComputerList -DifferenceObject $adComputerList -Property CN | ?{$_.sideIndicator -eq "=>"} | Select-Object CN | Export-CSV -Path $path3 -NoTypeInformation
#Compare-Object -ReferenceObject $adComputerList -DifferenceObject $ardComputerList -Property CN | Select-Object CN | Export-CSV -Path $path3 -NoTypeInformation

#$checkList = Import-CSV -Path $path3
$checkList = Import-CSV -Path $path2

# exclude clients that are not macs
ForEach ($i in $checkList) {
    $filterList = Get-ADComputer -Identity $i.CN -Property CN , OperatingSystem | Select-Object CN , OperatingSystem
    ForEach ($i in $filterList) {
        if ($i.OperatingSystem -eq "Mac OS X") {
            Write-Output $i | Export-CSV -Path $path4 -NoTypeInformation -Append
            Write-Host $i.CN" Mac" -ForegroundColor Green
        }
        elseif ($i.OperatingSystem -Like "Windows*") {
            Write-Host $i.CN" Windows" -ForegroundColor Yellow
        }
        elseif ($i.OperatingSystem -Like "Hyper*") {
            Write-Host $i.CN" Hyper-V" -ForegroundColor Yellow
        }
        else {
            Write-Host $i.CN" Unknown" -ForegroundColor Red
        }
    }
}

$macList = Import-CSV -Path $path4 | Select -ExpandProperty CN

Write-Host `n"Begin Ping Test" -ForegroundColor Yellow

# ping test mac clients
ForEach ($i in $macList) {
    if (Test-Connection -ComputerName $i -Count 1 -ErrorAction SilentlyContinue) {
        Write-Host $i`t"Active" -ForegroundColor Green
    }
    else {
        Write-Host $i`t"Inactive" -ForegroundColor Red
        Write-Output $i | Out-File -FilePath $path5 -Append
    }
}

$failedPings = Get-Content -Path $path5

Write-Host `n"Checking Client LastLogonDate Attribute" -ForegroundColor Yellow

# check lastlogondate for clients that failed ping
ForEach ($i in $failedPings) {
    $checkLastLogon = Get-ADComputer -Identity $i -Property CN , LastLogonDate | Select-Object CN , LastLogonDate
    ForEach ($i in $checkLastLogon) {
        if ($i.LastLogonDate -le $fortyFiveDaysAgo) {
            Write-Output $i.CN | Out-File -FilePath $path6 -Append
            Write-Host $i.CN`t"LastLogonDate is over 30 days" -ForegroundColor Red
        }
        else {
            Write-Host $i.CN`t"LastLogonDate is under 30 days" -ForegroundColor Green
        }
    }
}

#$removeList = Get-Content -Path $path6

#Write-Host `n"Removing Inactive AD Clients" -ForegroundColor Yellow

# remove ad clients
#ForEach ($i in $removeList) {
#    Remove-ADComputer -Identity $i
#}