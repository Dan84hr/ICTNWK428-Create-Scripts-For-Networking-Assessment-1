<# ------------------------------------------------------------
ITWorks - Operating System Information - Function Module
File: OS_Information_Daniel_Mchendrie.psm1
Purpose: Store the functions required for OS_Information_Daniel_Mchendrie Script
Author: Daniel McHendrie
Date: 14/11/2026

Version 1.3
-----------------------
### Helpfull commands ###
Run > .\OS_Information_Daniel_Mchendrie.psm1
Run with 'CAll' > & "C:\Powershell\PS_Modules\OS_Information_Daniel_Mchendrie.psm1"
------------------------------------------------------------#>

<# ------------------------------------------------------------
# Create the module manifest
cd C:\Powershell\PS_Modules
New-ModuleManifest `
    -Path 'C:\Powershell\PS_Modules\OS_Information_Daniel_Mchendrie.psd1' `
    -RootModule 'OS_Information_Daniel_Mchendrie.psm1' `
    -Author 'Daniel McHendrie' `
    -Description 'Operating System Information - Functions - Daniel Mchendrie' `
    -FunctionsToExport '*'
------------------------------------------------------------#>

<#-------------------------------------------------------------
DEFINE FUNCTIONS
All defined functions will use TRY and CATCH
All functions will TRY and have Error set to - STOP 

** The TRY step will be used in all functions **
** This Catch function step will be the same for all defined function**
NOTE: These functions will be exported and publicly acessible 
-------------------------------------------------------------#> 

# Function: Get computer information - store in variable 'ComputerInfo'
# The 'ComputerInfo' is then used to pass to other functions, if required
function Get-ComputerInformation {
    try {
        # Collect computer information.
        $ComputerInfo = Get-ComputerInfo -ErrorAction Stop
        # Check whether computer information was collected.
        if ($null -eq $ComputerInfo) {
            Write-Host "Unable to collect computer information. Exiting script." `
                -ForegroundColor Red
            # The main finction tests for '$null' and the quits - if this fails that is the required output
            return $null
        }
        #  Any partial returns or empty/whitespace will be tested later
        return $ComputerInfo
    }
    catch {
        Write-Host "Error collecting computer information: $($_.Exception.Message)" `
            -ForegroundColor Red
        # The main finction tests for '$null' and the quits - if this fails that is the required output
        return $null
    }
}

# Function 1: Retrieve the current Operating System information #
function Get-OperatingSystemInfo {
    param (
        [Parameter(Mandatory)]
        [PSObject]$ComputerInfo
    )
    try {
        # Check whether Operating System information is available.
        if ([string]::IsNullOrWhiteSpace($ComputerInfo.OsName) -or
            [string]::IsNullOrWhiteSpace($ComputerInfo.OsVersion)) {
            return "Operating System information is unavailable."
        }
        Write-Host "`nOperating System: " -NoNewline -ForegroundColor Cyan 
        return "$($ComputerInfo.OsName) - Version: $($ComputerInfo.OsVersion)"
    }
    catch {
        return "`nError retrieving Operating System information: $($_.Exception.Message)"
    }
}

# Function 2: Retrieve the Windows Remote Management service status #
function Get-RemoteServiceStatus {
    try {
        # Retrieve the WinRM service.
        $service = Get-Service -Name "WinRM" -ErrorAction Stop
        # Check whether the service status is available.
        if ([string]::IsNullOrWhiteSpace([string]$service.Status)) {
            return "WinRM service status is unavailable."
        }
        Write-Host "`nWinRM Service Status: " -NoNewline -ForegroundColor Cyan
        return "$($service.Status)"
    }
    catch {
        return "`nError retrieving remote service status: $($_.Exception.Message)"
    }
}

# Function 3: Retrieve the computer manufacturer and model #
function Get-ComputerManufacturerAndModel {
    param (
        [Parameter(Mandatory)]
        [PSObject]$ComputerInfo
    )
    try {
        # Check whether manufacturer and model information is available.
        if ([string]::IsNullOrWhiteSpace($ComputerInfo.CsManufacturer) -or
            [string]::IsNullOrWhiteSpace($ComputerInfo.CsModel)) {

            # Does have an option to have the blank fileds throw an error - chosing to return the result message instead
            # throw "Manufacturer and/or Model information is unavailable."
            return "Manufacturer and/or Model information is unavailable."
        }
        Write-Host "`nManufacturer And Model: " -NoNewline -ForegroundColor Cyan
        return "$($ComputerInfo.CsManufacturer) - $($ComputerInfo.CsModel)"
    }
    catch {
        return "`nError retrieving manufacturer and model: $($_.Exception.Message)"
    }
}

# Function 4: Retrieve the computer name #
function Get-ComputerNameInfo {
    param (
        [Parameter(Mandatory)]
        [PSObject]$ComputerInfo
    )
    try {
        # Check whether computer name information is available.
        if ([string]::IsNullOrWhiteSpace($ComputerInfo.CsName)) {
            return "Computer Name information is unavailable."
        }
        Write-Host "`nComputer Name: " -NoNewline -ForegroundColor Cyan
        return "$($ComputerInfo.CsName)"
    }
    catch {
        return "`nError retrieving computer name: $($_.Exception.Message)"
    }
}

# Function 5: Retrieve the computer domain name #
function Get-ComputerDomain {
    param (
        [Parameter(Mandatory)]
        [PSObject]$ComputerInfo
    )
    try {
        
        # The computer may or may not be domain joined.
        # There are two possible outcomes: Workgroup or Domain.

        if ($ComputerInfo.CsPartOfDomain) {
            # Check whether domain name information is available.
            if ([string]::IsNullOrWhiteSpace($ComputerInfo.CsDomain)) {
                return "Domain name information is unavailable."
            }
            Write-Host "`nDomain Name: " -NoNewline -ForegroundColor Cyan
            return "$($ComputerInfo.CsDomain)"
        }
        else {
            # Check whether workgroup name information is available.
            if ([string]::IsNullOrWhiteSpace($ComputerInfo.CsWorkgroup)) {
                return "Workgroup name information is unavailable."
            }
            Write-Host "`nWorkgroup Name: " -NoNewline -ForegroundColor Cyan
            return "$($ComputerInfo.CsWorkgroup)"
        }
    }
    catch {
        return "`nError retrieving domain information: $($_.Exception.Message)"
    }
}

# Function 6: Retrieve the computer's Trusted Hosts configuration #
function Get-TrustedHosts {
    try {
        $trustedHosts = Get-Item -Path "WSMan:\localhost\Client\TrustedHosts" `
            -ErrorAction Stop
            Write-Host "`nTrustedHosts: " -NoNewline -ForegroundColor Cyan
        if ([string]::IsNullOrWhiteSpace($trustedHosts.Value)) {
            return "No hosts configured"
        }
        return "$($trustedHosts.Value)"
    }
    catch {
        return "`nError retrieving TrustedHosts: $($_.Exception.Message)"
    }
}

# Function 7: Retrieve the Operating System architecture #
function Get-OSArchitecture {
    param (
        [Parameter(Mandatory)]
        [PSObject]$ComputerInfo
    )
    try {
        # Check whether Operating System architecture information is available.
        if ([string]::IsNullOrWhiteSpace($ComputerInfo.OsArchitecture)) {
            return "Operating System architecture information is unavailable."
        }
        Write-Host "`nOS Architecture: " -NoNewline -ForegroundColor Cyan
        return "$($ComputerInfo.OsArchitecture)"
    }
    catch {
        return "`nError retrieving OS architecture: $($_.Exception.Message)"
    }
}

# Function 8: Retrieve and display all computer information #
function Get-AllOSInformation {
    param (
        [Parameter(Mandatory)]
        [PSObject]$ComputerInfo
    )
    try {
        # Collect information by calling the individual functions.
        # Functions have some write-host elements, these are removed with - "6>$null"
        # Functions have new lines installed in output, removed with - "Trim()"
        $information = [ordered]@{
            "Operating System"       = (Get-OperatingSystemInfo -ComputerInfo $ComputerInfo 6>$null).Trim()
            "Remote Service Status"   = (Get-RemoteServiceStatus 6>$null).Trim()
            "Manufacturer and Model" = (Get-ComputerManufacturerAndModel -ComputerInfo $ComputerInfo 6>$null).Trim()
            "Computer Name"          = (Get-ComputerNameInfo -ComputerInfo $ComputerInfo 6>$null).Trim()
            "Domain Information"     = (Get-ComputerDomain -ComputerInfo $ComputerInfo 6>$null).Trim()
            "Trusted Hosts"           = (Get-TrustedHosts 6>$null).Trim()
            "OS Architecture"        = (Get-OSArchitecture -ComputerInfo $ComputerInfo 6>$null).Trim()
        }
        # Display all collected information in a list format #
        Write-Host "`n-------- Complete Computer Information --------" `
            -ForegroundColor Cyan
<#
# Old more simple table format output - Removed - Using the easier to read table format
        $information.GetEnumerator() | ForEach-Object {
            Write-Host "$($_.Key): $($_.Value)"
        }
#>
        $information.GetEnumerator() | ForEach-Object {
            [PSCustomObject]@{
                Information = $_.Key
                Details     = $_.Value
            }
        } | Format-Table -Property Information, Details -AutoSize -Wrap 
#        | Out-String | Write-Host -ForegroundColor Green # - possible colour formatting
    }
    catch {
        Write-Host "`nError retrieving computer information: $($_.Exception.Message)" `
            -ForegroundColor Red
    }
}


# *** EXPORT ALL FUNCTION - by not defining this, this will make all public by default
<#
# EXPORT ALL FUNCTION 
# Export-ModuleMember -Function '*'

# Optional: Match the manifest, or simply omit this line altogether
Export-ModuleMember -Function @(
    'Get-ComputerInformation', 
    'Get-OperatingSystemInfo',
    'Get-RemoteServiceStatus',
    'Get-ComputerManufacturerAndModel',
    'Get-ComputerNameInfo',
    'Get-ComputerDomain',
    'Get-TrustedHosts',
    'Get-OSArchitecture',
    'Get-AllOSInformation'
)
#>
