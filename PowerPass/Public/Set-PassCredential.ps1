function New-PassCredential {
    [cmdletbinding()]
    param (

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String]$Password,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String]$GPGKeyName,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String]$Path = (Join-Path -Path ('c:{0}' -f $env:HOMEPATH) -ChildPath '.password-store'),
        
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String]$GPGPath = (Get-Command -Name gpg2|Select-Object -First 1).Source
    )

    $passwordFile = Join-Path -Path $Path -ChildPath ('{0}.gpg' -f $Name)
    
    if (Test-Path -Path $PasswordFile) {
        $EncryptedPassword = $Password | & gpg2 -e -r $GPGKeyName --armor
        Out-File -FilePath (Join-Path -Path $Path -ChildPath ('{0}.gpg' -f $Name)) -Encoding utf8 -InputObject $EncryptedPassword
        
    } else {
        Write-Error -Message ('{0} Not Found! Did you mean New-Credential?') -Exception ([System.Data.ObjectNotFoundException]::new())
    }
    Remove-Variable -Force -Name Password
}