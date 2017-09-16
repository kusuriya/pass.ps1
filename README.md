# PowerPass

This is a powershell adaptation of zx2c4's [password-store](https://www.passwordstore.org/).

## Tests
In the artifacts directory there is a completely known pgp key and a test store. the key will need to be imported into the key ring of the system running the test past that there are no other requirements to run the tests.

## Get-PassCredential
This will retrieve and decryp credentials in the password vault. It only has one mandatory paramater which is `-name`

### Name
This is the name of the credential you want to decrypt. As an example if you have a cred in the vault that is in bob.gpg you would select bob here and it would decrypt bob.gpg and load it into the clipboard or create a PSCredential object out of it.

### ClearTime
By default we copy the password to the clipboard and really it is not a great idea to have a password chilling in your clipboard. So to kill the password we fork a background process and attempt to clear the clipboard after the time specified here. This is an interger in seconds.

Default is: 10

### AsPSCredential
This is a switch that tells Get-PasswordValue to emit a PSCredential object instead of to the clipboard

### GPGPath
This is where gpg2 is installed on your machine.

Default is: (Get-Command -Name gpg2|Select -first 1).Source

### Path
This is where your password store sits.

Default is: ~/.password-store

### Show-PassList
This gives you a list of all the credentials in your password store

### Path
This is where your password store sits.

Default is: ~/.password-store