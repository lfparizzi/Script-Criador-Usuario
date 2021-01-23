$Username = "your_username"
$Password = "your_passwd"

$group = "Administradores"

$adsi = [ADSI]"WinNT://$env:COMPUTERNAME"
$existing = $adsi.Children | where {$_.SchemaClassName -eq 'user' -and $_.Name -eq $Username }

if ($existing -eq $null) {

   Write-Host "Criando novo usuário local $Username."
   & NET USER $Username $Password /add /y /expires:never
   
   Write-Host "Adicionando o usuário $Username em $group."
   & NET LOCALGROUP $group $env:computername\$Username /add

}
else {
   Write-Host "Definindo a senha para $Username."
   $existing.SetPassword($Password)
}

Write-Host "Comprovando que a senha de $Username nunca expire."
& WMIC USERACCOUNT WHERE "Name='$Username'" SET PasswordExpires=FALSE