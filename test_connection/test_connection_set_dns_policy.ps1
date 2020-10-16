$srvrPath = "\\HOST\SHARE"
$srvrHost = "HOST"

Function Get-DnsPolicyStats () {
    $script:dnsPolicy = Get-DnsServerQueryResolutionPolicy -Name "POLICY_NAME" -Zone "ZONE"
    $script:policyName = $dnsPolicy.Name
    $script:policyZone = $dnsPolicy.ZoneName
    $script:policyStatus = $dnsPolicy.IsEnabled
}

Function Get-HostStatus () {
    If (Test-Connection $srvrHost) {
        $script:hostStatus = "reachable"
    }
    Else {
        $script:hostStatus = "not reachable"
    }
}

Function Send-EmailAlert () {
    $outlook = New-Object -ComObject Outlook.Application
    $message = $outlook.CreateItem(0)
    $message.To = "EMAIL@DOMAIN.COM"
    $message.Subject = "DNS Policy Status Change"
    $message.Body = "DNS Policy Status changed on $(Get-Date)`n`nPolicy: $policyName `nZone: $policyZone `nEnabled: $policyStatus `n`n$srvrHost is $hostStatus `nThis script will continue to monitor the service status."
    #$message.Save()
    $message.Send()
}

While ($True) {
    If (Test-Path $srvrPath) {
        Write-Host "SMB Share Active" -ForegroundColor Green
        Get-DnsPolicyStats
        If ($dnsPolicy.IsEnabled -eq $False) {
            Write-Host "Enabling DNS Policy" -ForegroundColor Green
            Enable-DnsServerPolicy -Level Zone -Name $dnsPolicy.Name -Zone $dnsPolicy.ZoneName -Force
            Get-HostStatus; Get-DnsPolicyStats; Send-EmailAlert
        }
    }
    Else {
        Write-Host "SMB Share Inactive" -ForegroundColor Red
        # test service availability up to 4 more times
        While ($isInactive -lt 4) {
            If (Test-Path $srvrPath) {
                Write-Host "Service Responding" -ForegroundColor Green
                Get-DnsPolicyStats
                If ($dnsPolicy.IsEnabled -eq $False) {
                    Write-Host "Enabling DNS Policy" -ForegroundColor Green
                    Enable-DnsServerPolicy -Level Zone -Name $dnsPolicy.Name -Zone $dnsPolicy.ZoneName -Force
                    Get-HostStatus; Get-DnsPolicyStats; Send-EmailAlert
                }
                $isInactive = 4
            }
            Else {
                Write-Host "Service Not Responding. Retrying" -ForegroundColor Red
                $isDown++
                If ($isDown -eq 4) {
                    Get-DnsPolicyStats
                    If ($dnsPolicy.IsEnabled -eq $True) {
                        # service is not responding
                        Write-Host "Service Down" -ForegroundColor Red
                        Write-Host "Disabling DNS Policy" -ForegroundColor Red
                        Disable-DnsServerPolicy -Level Zone -Name $dnsPolicy.Name -Zone $dnsPolicy.ZoneName -Force
                        Get-HostStatus; Get-DnsPolicyStats; Send-EmailAlert
                    }
                }
            }
            Start-Sleep -s 5
            $isInactive++
        }
    }
    $isDown = 0
    $isInactive = 0
    Start-Sleep -s 30
}
