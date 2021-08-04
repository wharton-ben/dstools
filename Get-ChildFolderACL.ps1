<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Get-ChildFolderACL
{
    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]$Path,
        [Parameter(Mandatory=$false)]
        [string]$match
    )

    Begin
    {
        set-location $path
    }
    Process
    {
        foreach($x in Get-ChildItem)
        {  
            $child_item = $x.Name

            foreach($acl in get-acl -path $child_item | select-object -ExpandProperty access)
            {
                if($acl.identityreference -like "$match")
                {
                    $acl.identityreference
                }
            }

        }
    }
    End
    {
        Write-host "Complete." -ForegroundColor Green
    }
}