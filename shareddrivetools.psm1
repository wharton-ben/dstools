<#
.Synopsis
   This function will allow an administrator to find all of the ACLs applied to a network share's child folders.
.DESCRIPTION
   If a user needs access to all subfolders within a parent folder, this command will allow you to get a list of all of the security groups that have access to the folder. 
.PARAMETER Path
   Specifies the path to the parent folder.
.PARAMETER Match
   Specifies a string to match a security group name to.
.EXAMPLE
   PS> Get-ChildFolderACL -path \\server\root\parent_folder
.EXAMPLE
   PS> Get-ChildFolderACL -path \\server\root\parent_folder -match group_name
#>
function Get-ChildFolderACL
{
	[CmdletBinding()]
	[OutputType([string])]
	Param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   Position = 0)]
		[string]$path,
		[Parameter(Mandatory = $false)]
		[string]$match = "*"
	)
	
	Begin
	{
		# To begin, the function will grab the user's current directory and save it to $current_location
		$current_location = get-location
		# The function will then set the user's location to the path specified in the $path parameter
		try
		{
			set-location $path
		}
		catch
		{
			Write-Error "This path does not exist. Please verify the specified path is correct and try again."
		}
	}
	Process
	{
		# Once the user is in the correct location, iterate over all child items within the parent.
		foreach ($child in Get-ChildItem )
		{
			# Grab the name of the child folder from the object returned.
			$child_item = $child.Name
			# Iterate over all items in the returned access list.
			foreach ($acl in get-acl -path $child_item | select-object -ExpandProperty access)
			{
				# Check to see if any of the users/groups match the user's $match parameter input. If no input, the default is a wildcard.
				if ($acl.identityreference -like "*$Match*")
				{
					# Each item will be run through the Get-ADGroup cmdlet to check who is listed as the manager for the file.
					try
					{
						$owner = Get-ADGroup ([string]$acl.identityreference).Split("\")[1] -Properties managedby
					}
					# If the group does not have a manager listed, a message will be returned to the user stating so.
					catch
					{
						Write-Warning "This group/member does not have a manager listed."
					}
					# The manager and the name of the group will be written to the terminal for the user.
					Write-Host "$($owner.managedby) $(([string]$acl.identityreference).Split("\")[1])"
				}

			}
			
		}
	}
	End
	{
		# Set the user's location back to their original location.
		Set-Location $current_location
	}
}




