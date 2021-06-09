<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2021 v5.8.188
	 Created on:   	5/17/2021 6:47 PM
	 Created by:   	BW069340
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>
<#
.Synopsis
   This function takes a username (or a list of usernames) as an argument and restores that user (or users) from leave of absense status.
.DESCRIPTION
   This function takes a username (or a list of usernames) as an argument and restores that user (or users) from leave of absense status.The user's description will be set to $null, and their logon workstations will
   also be set to $null. The user is also removed from the "LOA Accounts" group. 
.EXAMPLE
   Restore-LOAUser -users 47082

.EXAMPLE
   Restore-LOAUser -users 12345, 47832, 2345
#>

function Restore-LOAUser
{
	[cmdletbinding()]
	param (
		[Parameter(
				   mandatory = $true,
				   valuefrompipelinebypropertyname = $true)]
		[string[]]$users
	)
	# Loop through each user and modify their AD description
	
	foreach ($user in $users)
	{
		
		# Set user description to LOA, set logon workstations
		
		Set-ADUser -identity $user -Description $null -LogonWorkstations $null
		
		# Add user to LOA Accounts group
		
		Remove-ADGroupMember -Identity "LOA Accounts" -Members $user -Confirm:$false
		
	}
}


