<# ------------------------------------------------------------
# ITWorks - Operating System Information Script
# File: OS_Information_Daniel_Mchendrie.ps1
# Purpose: Collect and display computer and OS information.
# Author: Daniel McHendrie
# Date; 13/11/2026

# Version 1.3
-----------------------
### Helpfull commands ###
Run with 'CAll' > & "C:\Powershell\PS_Scripts\OS_Information_Daniel_Mchendrie.ps1"
RUN > .\OS_Information_Daniel_Mchendrie.ps1
------------------------------------------------------------#>

## START ##

<#-------------------------------------------------------------
DEFINE FUNCTIONS
All functions will be imported from a module they are stored in - OS_Information_Daniel_Mchendrie.psm1
-------------------------------------------------------------#> 

# To import, first chech to remove the module and then import again 
# Troubleshooting - Remove Comment to run with '-Verbose" to make this visible when troubleshooting
Remove-Module OS_Information_Daniel_Mchendrie.psm1 -ErrorAction SilentlyContinue
Import-Module C:\Powershell\PS_Modules\OS_Information_Daniel_Mchendrie.psm1 -Force #-Verbose 

# Collect computer information once for use by the other functions.
$ComputerInfo = Get-ComputerInformation
# Exit if computer information could not be collected.
if ($null -eq $ComputerInfo) {
    return
}

<# ------------------------------------------------------------
MAIN MENU
Display the menu options
This will continue/Loop until option 9 is selected (exit)
 ------------------------------------------------------------#>
# VARIABLES
# Menu contence Format - Option 1 - Operating System Information
$MainMenu = @"
------------- ITWorks OS Information Tool -------------`n
1 - Current Operating System Information
2 - Windows remote service status
3 - Computer manufacturer and Model
4 - Computer Name
5 - Computer domain name
6 - Computer's trusted hosts
7 - Operating system architecture
8 - Get All Computer Information
9 - Quit
`n-------------------------------------------------------
"@ 

# WHILE loop - While TRUE - keep the menu running until the user chooses to quit #
while ($true) {
    # Display available menu options
    Write-Host $MainMenu `
        -ForegroundColor Cyan

    # Keep asking for a valid selection
    # If the table is required to be re-displayed after a invalid input, comment this out or remove
    do {
        # Ask the user to enter a selection
        $selection = Read-Host "`nPlease select an option (1-9)"

        if ($selection -notmatch '^[1-9]$') {
            Write-Host "`nInvalid selection. Please enter a number from 1 to 9." `
                -ForegroundColor Red
        }
    } while ($selection -notmatch '^[1-9]$')
<#
    # If the main menu is required to be displayed for invalid, un-comment this and use to replace the above "read-host"
    # Read the user's selection #
    $selection = Read-Host "Enter a selection (1-9) " 
#>

    # Process the user's selection
    switch ($selection) {
        "1" {
            Get-OperatingSystemInfo -ComputerInfo $ComputerInfo
        }
        "2" {
            Get-RemoteServiceStatus
        }
        "3" {
            Get-ComputerManufacturerAndModel -ComputerInfo $ComputerInfo
        }
        "4" {
            Get-ComputerNameInfo -ComputerInfo $ComputerInfo
        }
        "5" {
            Get-ComputerDomain -ComputerInfo $ComputerInfo
        }
        "6" {
            Get-TrustedHosts
        }
        "7" {
            Get-OSArchitecture -ComputerInfo $ComputerInfo
        }
        "8" {
            Get-AllOSInformation -ComputerInfo $ComputerInfo
        }
        "9" {
            Write-Host "`n------------- Exiting ITWorks OS Information Tool ------------" `
                -ForegroundColor Green
            break
        }
        # the 'Default" is not needed as the above DO loop validates selections
        # keeping default to have as an additional safeguard and 
        default {
            Write-Host "`nInvalid selection. Please enter a number from 1 to 9." `
                -ForegroundColor Red
        }
    }

    # Exit the menu when option 9 is selected
    if ($selection -eq "9") {
        break
    }
    # Pause so the user can read the returned information
    Read-Host "`nPress Enter to return to the menu"
}

## END ##
