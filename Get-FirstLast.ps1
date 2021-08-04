<#
.Synopsis
   Run Get-ADUser by first and last name. 
.DESCRIPTION
   This function takes a user's first and last name and returns active directory properties for that user.  
.EXAMPLE
   Get-FirstLast Ben Wharton
#>

function Get-FirstLast
{
	[cmdletbinding()]
	Param (
		[Parameter(Mandatory = $true, position = 0)]
		[string]$firstname,
		[Parameter(Mandatory = $true, position = 1)]
		[string]$lastname)
	
	Process
	{
		$user = get-aduser -filter { surname -like $lastname -and givenname -like $firstname } -Properties * |
		select name, title, emailaddress, telephoneNumber, lockedout, samaccountname, userprincipalname
		return $user
	}
}