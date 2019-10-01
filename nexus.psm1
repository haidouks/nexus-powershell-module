# Implement your module commands in this script.

#region Module Parameters
$Script:nexusBaseURI = $null
$Script:nexusCredential = $null
#endregion

function Set-NexusCredential {
    [CmdletBinding()]
    param (
        # Nexus Base URI
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $nexusBaseURI,
        # Nexus Pass
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [pscredential]
        $nexusCredential
    )

    begin {

    }

    process {
        $Script:nexusBaseURI = $nexusBaseURI
        $Script:nexusCredential = $nexusCredential
    }

    end {

    }
}
function Get-NexusRepositories {
    [CmdletBinding()]
    param (

    )

    begin {

    }

    process {
        try {
            $nexusUrl = $Script:nexusBaseURI + "v1/repositories"
            $repositories = Invoke-RestMethod -Uri $nexusUrl -Credential $Script:nexusCredential -Method Get -AllowUnencryptedAuthentication
            return $repositories
        }
        catch {
            $exception = $($PSItem | select-object * |Format-Custom -Property * -Depth 1 | Out-String)
            Write-Error -Message $exception -ErrorAction Stop
        }
    }

    end {

    }
}

# Export only the functions using PowerShell standard verb-noun naming.
# Be sure to list each exported functions in the FunctionsToExport field of the module manifest file.
# This improves performance of command discovery in PowerShell.
Export-ModuleMember -Function *-*
