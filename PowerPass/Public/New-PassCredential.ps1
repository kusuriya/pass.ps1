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
        Write-Error -Message ('{0} Already exists! Did you mean Set-CredentialValue?')
    } else {
        $EncryptedPassword = $Password | & gpg2 -e -r $GPGKeyName --armor
        $CredentialPath = (Join-Path -Path $Path -ChildPath ('{0}.gpg' -f $Name))
        New-Item -Force -Type File -Path $CredentialPath 
        Out-File -FilePath $CredentialPath -Encoding utf8 -InputObject $EncryptedPassword
    }
    Remove-Variable -Force -Name Password
}