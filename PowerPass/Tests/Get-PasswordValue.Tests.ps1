$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace '\\Tests'
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\Public\$sut"

Describe 'Get-PasswordValue' {
    It -name "Decrypts bob.gpg and puts it in the clipboard" {
        Get-PasswordValue -path "$here\Tests\Artifacts\password-store" -name bob
        Get-Clipboard | Should Be 'Success'
    }
    $result = Get-PasswordValue -path "$here\Tests\Artifacts\password-store" -name bob -AsPSCredential
    It -name 'Creates a PSCredential Object' {
        $result.GetType().Name | Should Be 'PSCredential'
    }
    It -name 'Should have a username of the credential file (bob.gpg should be bob)' {
        $result.username | Should Be 'bob'
    }
    It -name 'Should have the password value of Success' {
        $result.GetNetworkCredential().Password | Should Be 'Success'
    }
}