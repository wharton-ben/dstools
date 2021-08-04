<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2021 v5.8.188
	 Created on:   	7/1/2021 6:10 PM
	 Created by:   	BW069340
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>
function Check-LockoutStatus($username)
{
	while ($true)
	{
		$user = get-aduser $username -Properties lockedout
		if ($user.lockedout -eq "True")
		{
			Write-host "$($user.samaccountname) is locked!!!" -ForegroundColor Red
			Unlock-ADAccount $user
		}
		else
		{
			write-host "$($user.samaccountname) is not locked out." -ForegroundColor Green
		}
		start-sleep -Seconds 10
	}	
}