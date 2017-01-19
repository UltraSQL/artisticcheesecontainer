$ContainerAdmin = $env:ContainerAdmin
$ContainerPassword = $env:ContainerPassword
if ((Get-LocalUser -Name $ContainerAdmin) -ne $true) {
    Write-Verbose "Admin container user already exists, updating password"
    Set-localuser -Name $ContainerAdmin -Password (ConvertTo-SecureString  $ContainerPassword -AsPlainText -Force) -ErrorAction SilentlyContinue
}
else
{
    Write-Verbose "Admin container does not exist, creating user"
    new-LocalUser -Name $ContainerAdmin -Password  (ConvertTo-SecureString  $ContainerPassword -AsPlainText -Force) -ErrorAction SilentlyContinue
}
if (((Get-LocalGroupMember administrators) -match  "contadmin").Count -eq 0) {Add-LocalGroupMember -Group Administrators -Member $ContainerAdmin }


   
   <# Configuration Startup
    {
        param
        (
                [pscredential] $cred
        )
        Import-DscResource -ModuleName  'PSDSCResources'
        node localhost{
                User LocalAdmin   {
                UserName =  $cred.UserName
                Description =  "Customized admin for container"
                Ensure = "Present"
                Password = $cred
        }
    }
    }
    $cd = @{
        AllNodes = @(
            @{
                NodeName = 'localhost'
                PSDscAllowPlainTextPassword = $true
            }
        )
    }
    $cred = [pscredential]::new($ContainerAdmin, (ConvertTo-SecureString  $ContainerPassword -AsPlainText -Force)) 
    Startup -cred $cred -ConfigurationData $cd 
    Start-DscConfiguration -Wait -Verbose -Path .\Startup -Force#>
