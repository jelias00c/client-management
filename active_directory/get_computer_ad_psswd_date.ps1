$outputTxt = "C:\Users\user\Desktop\computer_list.csv" 
$OU = "OU=Computers,DC=ad,DC=company,DC=pri"
$todayDate = Get-Date -Format yyyy-MM-dd
$thirtyDaysAgo = Get-Date -Format yyyy-MM-dd ((Get-Date).AddDays(-30))

$computerList = Get-ADComputer -SearchScope OneLevel -SearchBase $OU -Filter * -Properties PasswordLastSet | Select-Object Name , PasswordLastSet | Sort-Object -Property Name

ForEach ($i in $computerList) {
    $objName = $i.Name
    if ($objName -match "prefix-") {
        $pwdSetDate = Get-Date ($i.PasswordLastSet); $pwdSetDateF = Get-Date ($i.PasswordLastSet) -Format yyyy-MM-dd
        $pwdCngDate = $pwdSetDate.AddDays(14); $pwdCngDateF = Get-Date ($pwdCngDate) -Format yyyy-MM-dd
        #Write-Host $i.Name`t$pwdSetDateF`t$pwdCngDateF
        if ($pwdCngDateF -lt $thirtyDaysAgo) {
            Write-Host $objName`t$pwdCngDateF -ForegroundColor Red
            #Write-Output $objName`t$pwdCngDateF | Out-File -FilePath $outputTxt -Append
        }
        elseif ($pwdCngDateF -lt $todayDate) {
            Write-Host $objName`t$pwdCngDateF -ForegroundColor Yellow
        }
        else {
            Continue
        }
    }
}