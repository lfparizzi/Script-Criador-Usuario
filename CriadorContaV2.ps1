$Username = "eloila"
$Password = "eloila"

$group = "Administradores"

$adsi = [ADSI]"WinNT://$env:COMPUTERNAME"
$existing = $adsi.Children | where {$_.SchemaClassName -eq 'user' -and $_.Name -eq $Username }

if ($existing -eq $null) {

   Write-Host "Criando novo usuário local $Username."
   & NET USER $Username $Password /add /y /expires:never
   
   Write-Host "Adicionando usuário $Username em $group."
   & NET LOCALGROUP $group $env:COMPUTERNAME\$Username /add

}
else {
   Write-Host "Definindo senha para usuário $Username."
   $existing.SetPassword($Password)
}

Write-Host "Certificando que a senha nunca expire."
& WMIC USERACCOUNT WHERE "Name='$Username'" SET PasswordExpires=FALSE