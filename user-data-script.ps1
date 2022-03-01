<powershell>
# host_name_short_ad_friendly   =AD-friendly short (computer) name           e.g. AWS27164834
# host_name                     =long host name                              e.g. prpl-core-nexus
# host_fqdn                     =host FQDN                                   e.g. prpl-core-nexus.core.parkrunpointsleague.org
# domain_name                   =TLD                                         e.g. parkrunpointsleague.org
# domain_netbios_name           =NETBIOS name                                e.g. PRPL
echo "user-data-script.ps1 : Start"
Set-PSDebug -Trace 1

Set-ExecutionPolicy Unrestricted -Scope LocalMachine -Force -ErrorAction Ignore
# Don't set this before Set-ExecutionPolicy as it throws an error
$ErrorActionPreference = "stop"

# Configure Cloudwatch Agent config files with our more readable host_name.  Set Service to automatic startup and start now.
Get-ChildItem -Recurse -Depth 5 "C:\ProgramData\Amazon\AmazonCloudWatchAgent\" -Filter 'amazon-cloudwatch-agent*.json' |
Foreach-Object {
    (Get-Content -path $_.FullName -Raw) -replace '{local_hostname}','${host_name}' | Set-Content -Path $_.FullName
}
Set-Service -Name AmazonCloudWatchAgent -StartupType Automatic
Start-Service -Name AmazonCloudWatchAgent

echo "user-data-script.ps1 : Check our network settings before alteration"
cmd.exe /c ipconfig /all
echo ""

if("${domain_name}" -ne "") {
    echo "user-data-script.ps1 : Add DNS Suffixes for Machine"
    cmd.exe /c Reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" /v "SearchList" /t REG_SZ /d "${domain_name},eu-west-1.ec2-utilities.amazonaws.com,us-east-1.ec2-utilities.amazonaws.com"
}

if("${domain_name}" -ne "") {
    echo "user-data-script.ps1 : Setting Hostname and joining Domain..."
    $Password = convertto-securestring '${domain_join_user_password}' -AsPlainText -Force
    $Credential = new-object -typename System.Management.Automation.PSCredential -argumentlist "${domain_join_user_name}@${domain_name}", $Password

    echo "user-data-script.ps1 : Set Hostname"
    Rename-Computer -NewName ${host_name_short_ad_friendly}
    [Console]::Out.Flush()

    echo "user-data-script.ps1 : Join domain"
    sleep 5
    #  Add-Computer -Domain "${domain_name}" -Credential $Credential -NewName ${host_name_short_ad_friendly} -Options JoinWithNewName,AccountCreate -Force
    Add-Computer -Domain "${domain_name}" -Credential $Credential -Options JoinWithNewName,AccountCreate -Force
    [Console]::Out.Flush()

    # Below function "Set-ADComputer" is not available with Simple AD (Samba4) (Cause=No AD WebServices available)
    #echo "user-data-script.ps1 : Set the Description in AD for this newly joined Computer with DNS Name"
    #sleep 5
    #Import-Module ActiveDirectory
    #Set-ADComputer -Credential $Credential -Identity "${host_name_short_ad_friendly}" -Description "${host_name}"
    #[Console]::Out.Flush()

%{ for domain_login_allowed_user in domain_login_allowed_users ~}
    echo "user-data-script.ps1 : Configure RDP to just allow this user ${domain_login_allowed_user}"
    Add-LocalGroupMember -Group "Remote Desktop Users" -Member "${domain_netbios_name}\${domain_login_allowed_user}"
    [Console]::Out.Flush()
%{ endfor ~}

%{ for domain_login_allowed_group in domain_login_allowed_groups ~}
    echo "user-data-script.ps1 : Configure RDP login to allow domain group ${domain_login_allowed_group}"
    Add-LocalGroupMember -Group "Remote Desktop Users" -Member "${domain_netbios_name}\${domain_login_allowed_group}"
    [Console]::Out.Flush()
%{ endfor ~}

    echo "user-data-script.ps1 : Add our alternate/pretty hostname '${host_fqdn}'"
    netdom computername ${host_name_short_ad_friendly} /add:${host_fqdn}
    netdom computername ${host_name_short_ad_friendly} /add:${host_name}.${domain_name}
    [Console]::Out.Flush()

    echo "user-data-script.ps1 : Check our host names"
    netdom computername ${host_name_short_ad_friendly} /enumerate:ALLNAMES
    [Console]::Out.Flush()

    echo "user-data-script.ps1 : Verify our DNS and SPN names"
    netdom computername ${host_name_short_ad_friendly} /verify
    [Console]::Out.Flush()

    # Fix issue with "netdom computername localhost /add" not adding the SPNs for the added alternate name
    echo "user-data-script.ps1 : Add SPN names for WSMAN"
    setspn -s WSMAN/${host_name} ${host_name_short_ad_friendly}
    setspn -s WSMAN/${host_fqdn} ${host_name_short_ad_friendly}
    setspn -s WSMAN/${host_name}.${domain_name} ${host_name_short_ad_friendly}

    echo "user-data-script.ps1 : Add SPN names for TERMSRV"
    setspn -s TERMSRV/${host_name} ${host_name_short_ad_friendly}
    setspn -s TERMSRV/${host_fqdn} ${host_name_short_ad_friendly}
    setspn -s TERMSRV/${host_name}.${domain_name} ${host_name_short_ad_friendly}

    echo "user-data-script.ps1 : Add SPN names for HOST"
    setspn -s HOST/${host_name} ${host_name_short_ad_friendly}
    setspn -s HOST/${host_fqdn} ${host_name_short_ad_friendly}
    setspn -s HOST/${host_name}.${domain_name} ${host_name_short_ad_friendly}

    echo "user-data-script.ps1 : Add SPN names for RestrictedKrbHost"
    setspn -s RestrictedKrbHost/${host_name} ${host_name_short_ad_friendly}
    setspn -s RestrictedKrbHost/${host_fqdn} ${host_name_short_ad_friendly}
    setspn -s RestrictedKrbHost/${host_name}.${domain_name} ${host_name_short_ad_friendly}

    echo "user-data-script.ps1 : Verify our DNS and SPN names 2"
    netdom computername localhost /verify
    [Console]::Out.Flush()

    echo "user-data-script.ps1 : Reboot"
    [Console]::Out.Flush()
    # Give a few seconds for Cloudwatch agent to send this script output to Cloudwatch LogGroup "win-ec2launch-user-data" before reboot
    sleep 10
    Restart-Computer
}

echo "user-data-script.ps1 : Finish"
</powershell>
<runAsLocalSystem>true</runAsLocalSystem>
<powershellArguments></powershellArguments>
<script></script>