<#
.Synopsis
   This function takes a username (or a list of usernames) as an argument and sets that user (or users) to leave of absense status.
.DESCRIPTION
   This function takes a username (or a list of usernames) as an argument and sets that user (or users) to leave of absense status.The user's description will be set to "LOA", and their logon workstations will
   be set to "CASPOM3,CASPMW3,MAILBOXPOM1,MAILBOXPOM2,MAILBOXPOM3,MAILBOXPMW1,MAILBOXPMW2,MAILBOXPMW3". The user is also added to the "LOA Accounts" group. 
.EXAMPLE
   Set-LOAUser -users 47082

.EXAMPLE
   Set-LOAUser -users 12345, 47832, 2345
#>

function Set-LOAUser
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
		
		Set-ADUser -identity $user -Description "LOA" -LogonWorkstations "CASPOM3,CASPMW3,MAILBOXPOM1,MAILBOXPOM2,MAILBOXPOM3,MAILBOXPMW1,MAILBOXPMW2,MAILBOXPMW3"
		
		# Add user to LOA Accounts group
		
		Add-ADGroupMember -Identity "LOA Accounts" -Members $user
		
	}
}<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2021 v5.8.188
	 Created on:   	5/17/2021 6:46 PM
	 Created by:   	BW069340
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>



