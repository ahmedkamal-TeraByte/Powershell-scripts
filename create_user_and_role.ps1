param ($filePath,$user_name,$password,$user_principal_name)

# az login 

Write-Output ======================================
Write-Output "Creating Azure User"
Write-Output ======================================

az ad user create --display-name $user_name --password $password --user-principal-name $user_principal_name

if(!$?)
{
   return 0;
}
else{}
Write-Output ======================================
Write-Output "Azure User with principal name '$user_principal_name' created"
Write-Output ======================================

Write-Output ======================================
Write-Output "Creating Azure Role Definition"
Write-Output ======================================

az role definition create --role-definition $filePath

if(!$?)
{
   Write-Output ==================
   Write-Output "Rolling back"
   Write-Output ==================
   az ad user delete --id $user_principal_name

   Write-Output ==================
   Write-Output "User deleted."
   Write-Output ==================
   return ;
}
else{}

Write-Output ======================================
Write-Output "Azure Role Definition created"
Write-Output ======================================

Write-Output ======================================
Write-Output "Creating Role Assignment to User"
Write-Output ======================================

az role assignment create --assignee $user_principal_name --role "NCache SaaS Permissions"

if(!$?)
{
   Write-Output ==================
   Write-Output "Rolling back"
   Write-Output ==================
   az ad user delete --id $user_principal_name

   Write-Output ==================
   Write-Output "User deleted."
   Write-Output ==================

   az role definition delete --name "NCache SaaS Permissions"

   Write-Output ==================
   Write-Output "Role definition deleted."
   Write-Output ==================
   return;
}
else{}

Write-Output ======================================
Write-Output "Role assigned to user $user_name. You can use '$user_name' as deployment user in NCache Cloud Portal."
Write-Output ======================================

