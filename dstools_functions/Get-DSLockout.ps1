<#
.Synopsis
   This function will check to see if a user account is locked out in Active Directory.
.DESCRIPTION
   This function will check to see if a user account is locked out in Active Directory
   and give the user the ability to unlock the user. This tool can be used to unlock a 
   user who mistyped their password, or it can be used while investigating the cause of
   frequent lockouts.
.EXAMPLE
   Get-DSLockout -user billy.madison
#>

function Get-DSLockout
{
	[cmdletbinding()]
	param (
		[Parameter(
				   Mandatory = $true,
				   ValueFromPipeline = $true)]
		[Microsoft.ActiveDirectory.Management.ADUser]$user
	)
	process
	{
		$query = Get-ADUser $user -Properties lockedout | select lockedout, surname, givenname
		if ($query.lockedout -eq $false)
		{
			Write-Host "$($query.givenname) $($query.surname) is not locked out." -ForegroundColor black -BackgroundColor Green
		}
		else
		{
			Write-Host "$($query.givenname) $($query.surname) is locked out." -ForegroundColor black -BackgroundColor red
			$action = Read-Host -Prompt "Would you like to unlock this user? (enter 'yes' or 'no')"
			while ($action -ne "yes" -or "no")
			{
				$action = Read-Host "You did not select a valid option. Would you like to unlock this user? (enter 'yes' or 'no')"
			}
			if ($action -eq 'yes')
			{
				Unlock-ADAccount $user
			}
			else
			{
				Read-Host -Prompt "Press any key to exit."
			}
		}
	}
}



