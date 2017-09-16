function Show-PassList {
    <#
    .DESCRIPTION
    List all of the credentials in the vault

    .PARAMETER Path
    Location of the vault by default it is ~/.password-store

    .EXAMPLE
    Show-CredentialList
    #>

    param (
        $Path = (Join-Path -Path $env:HOMEPATH -ChildPath '.password-store')
    )

    Push-Location -Path $Path
    (Get-ChildItem -Path $Path).Name.GetEnumerator().trim('.gpg')
    Pop-Location
}