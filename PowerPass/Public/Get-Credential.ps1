function Get-Credential {
    <#
    .DESCRIPTION
    Get the plain text password values from a pass credential

    .PARAMETER clearTime
    The time in seconds to clear the function

    .PARAMETER name
    Name of the credential to decrypt

    .PARAMETER AsPSCredential
    Emit the password as a PSCredential Object

    .PARAMETER Path
    Location of the vault by default it is ~/.password-store

    .PARAMETER GPGPath
    Location of the GPG executable, defaults to whatever Get-Command finds

    .EXAMPLE
    Get-PasswordValue -Name bill -clearTime 10
    will get a credential from a credential named bill and clear the clipboard after 10 seconds

    #>
    param (

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [int]$ClearTime = 10,
        
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter()]
        [switch]$AsPSCredential,
        
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        $Path = (Join-Path -Path ('c:{0}' -f $env:HOMEPATH) -ChildPath '.password-store'),
        
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        $GPGPath = (Get-Command -Name gpg2|Select-Object -First 1).Source
    )
    $passwordFile = Join-Path -Path $Path -ChildPath ('{0}.gpg' -f $Name)

    if (Test-Path -Path $PasswordFile) {
        if ($AsPSCredential) {
            Write-Output ([pscredential]::new($name,
                    (ConvertTo-SecureString -AsPlainText -Force -String (& $gpgpath -d $PasswordFile))
                ))
        } else {
            (& $gpgpath -d $PasswordFile) | Select-Object -First 1 | Set-Clipboard
            Write-Host ("{0} copied to clipboard! Clearing in {1} seconds" -f $name, $clearTime)
            $null = $fork = [System.Management.Automation.PowerShell]::Create()
            $null = $fork.AddScript(( {
                        param ($clearTime)
                        Start-Sleep -Seconds $clearTime
                        $null|clip
                    }))
            $null = $fork.AddParameter('clearTime', $clearTime)
            $null = $fork.BeginInvoke()
        }
    } else {
        Write-Error -Message ("{0} doesn't exist!" -f $passwordFile) -Exception ([System.Data.ObjectNotFoundException]::new())
    }
}