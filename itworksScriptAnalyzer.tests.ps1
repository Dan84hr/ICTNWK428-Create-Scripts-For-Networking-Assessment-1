
<# ------------------------------------------------------------
 ITWorks - Operating System Information - Function Module
 File: itworksScriptPester.tests.ps1
 Purpose: Tests for OS_Information_Daniel_Mchendrie Script
 Author: Daniel McHendrie
 Date; 13/11/2026

 Version 1.1
------------------------------------------------------------
Invoke-ScriptAnalyzer -Path "C:\Powershell\PS_Scripts\itworksScriptAnalyzer.tests.ps1"
Invoke-ScriptAnalyzer -Path "C:\Powershell\PS_Scripts\itworksScriptAnalyzer.tests.ps1" |
    Format-List Severity, RuleName, Message, Extent, SuggestedCorrections
------------------------------------------------------------#>

# Import the module containing the functions.
Import-Module C:\Powershell\PS_Modules\OS_Information_Daniel_Mchendrie.psm1 -Force

BeforeAll {
    # Create sample computer information for testing.
    $ComputerInfo = [PSCustomObject]@{
            OsName         = "Microsoft Windows Server 2022 Standard"
            OsVersion      = "10.0.20348"
            OsArchitecture = "64-bit"
            CsName         = "SERVER1"
            CsManufacturer = "VMware, Inc."
            CsModel        = "VMware7,1"
            CsPartOfDomain = $true
            CsDomain       = "W2K22AD.local"
            CsWorkgroup    = "WORKGROUP"
    }
}

# Function: Get-ComputerInformation
Describe "Get-ComputerInformation Tests" {
    Context "When computer information is successfully collected" {
        It "Should return computer information" {
            Mock Get-ComputerInfo {
                [PSCustomObject]@{
                    CsName         = "SERVER1"
                    CsManufacturer = "VMware, Inc."
                    CsModel        = "VMware7,1"
                }
            } -ModuleName OS_Information_Daniel_Mchendrie
            $result = Get-ComputerInformation
            $result.CsName | Should -Be "SERVER1"
            $result.CsManufacturer | Should -Be "VMware, Inc."
            $result.CsModel | Should -Be "VMware7,1"
        }
    }
    Context "When computer information cannot be collected" {
        It "Should return null when Get-ComputerInfo fails" {
            Mock Get-ComputerInfo {
                throw "Unable to collect computer information."
            } -ModuleName OS_Information_Daniel_Mchendrie
            $result = Get-ComputerInformation
            $result | Should -Be $null
        }
    }
    Context "When Get-ComputerInfo returns null" {
        It "Should return null when computer information is null" {
            Mock Get-ComputerInfo {
                return $null
            } -ModuleName OS_Information_Daniel_Mchendrie
            $result = Get-ComputerInformation
            $result | Should -Be $null
        }
    }
}

# Function 1: Get-OperatingSystemInfo
Describe "Get-OperatingSystemInfo Tests" {
    Context "When valid computer information is supplied" {
        It "Should return the operating system name and version" {
            $result = Get-OperatingSystemInfo -ComputerInfo $ComputerInfo
            $result | Should -Be "Microsoft Windows Server 2022 Standard - Version: 10.0.20348"
        }
    }
    Context "When operating system name information is missing" {
        It "Should return an unavailable message when the name is null" {
            $ComputerInfo.OsName = $null
            $result = Get-OperatingSystemInfo -ComputerInfo $ComputerInfo
            $result | Should -Be "Operating System information is unavailable."
        }
        It "Should return an unavailable message when the name is empty" {
            $ComputerInfo.OsName = ""
            $result = Get-OperatingSystemInfo -ComputerInfo $ComputerInfo
            $result | Should -Be "Operating System information is unavailable."
        }
        It "Should return an unavailable message when the name contains whitespace" {
            $ComputerInfo.OsName = "   "
            $result = Get-OperatingSystemInfo -ComputerInfo $ComputerInfo
            $result | Should -Be "Operating System information is unavailable."
        }
    }
    Context "When operating system version information is missing" {
        It "Should return an unavailable message when the version is null" {
            $ComputerInfo.OsVersion = $null
            $result = Get-OperatingSystemInfo -ComputerInfo $ComputerInfo
            $result | Should -Be "Operating System information is unavailable."
        }
        It "Should return an unavailable message when the version is empty" {
            $ComputerInfo.OsVersion = ""
            $result = Get-OperatingSystemInfo -ComputerInfo $ComputerInfo
            $result | Should -Be "Operating System information is unavailable."
        }
        It "Should return an unavailable message when the version contains whitespace" {
            $ComputerInfo.OsVersion = "   "
            $result = Get-OperatingSystemInfo -ComputerInfo $ComputerInfo
            $result | Should -Be "Operating System information is unavailable."
        }
    }
}

# Function 2: Get-RemoteServiceStatus
Describe "Get-RemoteServiceStatus Tests" {
    Context "When the WinRM service is running" {
        It "Should return Running when the WinRM service is running" {
            Mock Get-Service {
                [PSCustomObject]@{
                    Status = "Running"
                }
            } -ModuleName OS_Information_Daniel_Mchendrie
            $result = Get-RemoteServiceStatus
            $result | Should -Be "Running"
        }
    }
    Context "When the WinRM service is stopped" {
        It "Should return Stopped when the WinRM service is stopped" {
            Mock Get-Service {
                [PSCustomObject]@{
                    Status = "Stopped"
                }
            } -ModuleName OS_Information_Daniel_Mchendrie
            $result = Get-RemoteServiceStatus
            $result | Should -Be "Stopped"
        }
    }
    Context "When the WinRM service status is unavailable" {
        It "Should return an unavailable message when the status is null" {
            Mock Get-Service {
                [PSCustomObject]@{
                    Status = $null
                }
            } -ModuleName OS_Information_Daniel_Mchendrie
            $result = Get-RemoteServiceStatus
            $result | Should -Be "WinRM service status is unavailable."
        }
    }
    Context "When the WinRM service cannot be found" {
        It "Should return an error message when the service cannot be found" {
            Mock Get-Service {
                throw "Service not found"
            } -ModuleName OS_Information_Daniel_Mchendrie
            $result = Get-RemoteServiceStatus
            $result | Should -Match "Error retrieving remote service status"
        }
    }
}

# Function 3: Get-ComputerManufacturerAndModel
Describe "Get-ComputerManufacturerAndModel Tests" {
    Context "When valid manufacturer and model information is supplied" {
        It "Should return the manufacturer and model" {
            $result = Get-ComputerManufacturerAndModel -ComputerInfo $ComputerInfo
            $result | Should -Be "VMware, Inc. - VMware7,1"
        }
    }
    Context "When manufacturer or model information is unavailable" {
        It "Should return an unavailable message when both values are empty" {
            $ComputerInfo.CsManufacturer = ""
            $ComputerInfo.CsModel = ""
            $result = Get-ComputerManufacturerAndModel -ComputerInfo $ComputerInfo
            $result | Should -Be "Manufacturer and/or Model information is unavailable."
        }
        It "Should return an unavailable message when manufacturer is empty" {
            $ComputerInfo.CsManufacturer = ""
            $ComputerInfo.CsModel = "VMware7,1"
            $result = Get-ComputerManufacturerAndModel -ComputerInfo $ComputerInfo
            $result | Should -Be "Manufacturer and/or Model information is unavailable."
        }
        It "Should return an unavailable message when model is empty" {
            $ComputerInfo.CsManufacturer = "VMware, Inc."
            $ComputerInfo.CsModel = ""
            $result = Get-ComputerManufacturerAndModel -ComputerInfo $ComputerInfo
            $result | Should -Be "Manufacturer and/or Model information is unavailable."
        }
    }
    Context "When manufacturer or model information is null" {
        It "Should return an unavailable message when both values are null" {
            $ComputerInfo.CsManufacturer = $null
            $ComputerInfo.CsModel = $null
            $result = Get-ComputerManufacturerAndModel -ComputerInfo $ComputerInfo
            $result | Should -Be "Manufacturer and/or Model information is unavailable."
        }
        It "Should return an unavailable message when manufacturer is null" {
            $ComputerInfo.CsManufacturer = $null
            $ComputerInfo.CsModel = "VMware7,1"
            $result = Get-ComputerManufacturerAndModel -ComputerInfo $ComputerInfo
            $result | Should -Be "Manufacturer and/or Model information is unavailable."
        }
        It "Should return an unavailable message when model is null" {
            $ComputerInfo.CsManufacturer = "VMware, Inc."
            $ComputerInfo.CsModel = $null
            $result = Get-ComputerManufacturerAndModel -ComputerInfo $ComputerInfo
            $result | Should -Be "Manufacturer and/or Model information is unavailable."
        }
    }
    <#
    # This can be true > -ComputerInfo $null - Is already tested in "Get-ComputerInformation"
    # > Script quits before it gets to this function
    Context "When computer information is null" {
        It "Should return an unavailable message" {
            $result = Get-ComputerManufacturerAndModel -ComputerInfo $null
            $result | Should -Be "Computer information is unavailable."
        }
    }
    #>
}

# Function 4: Get-ComputerNameInfo
Describe "Get-ComputerNameInfo Tests" {
    BeforeEach {
        # Get the sample computer information before each test.
        $ComputerNameInfo = $ComputerInfo.PSObject.Copy()
    }
    Context "When valid computer name information is supplied" {
        It "Should return the computer name" {
            $result = Get-ComputerNameInfo -ComputerInfo $ComputerNameInfo
            $result | Should -Be "SERVER1"
        }
    }
    Context "When computer name information is missing" {
        It "Should return an empty value when the computer name is empty" {
            $ComputerNameInfo.CsName = ""
            $result = Get-ComputerNameInfo -ComputerInfo $ComputerNameInfo
            $result | Should -Be "Computer Name information is unavailable."
        }
        It "Should return an whitespace value when the computer name is 'whitespace'" {
            $ComputerNameInfo.CsName = "    "
            $result = Get-ComputerNameInfo -ComputerInfo $ComputerNameInfo
            $result | Should -Be "Computer Name information is unavailable."
        }
        It "Should return an empty value when the computer name is 'null'" {
            $ComputerNameInfo.CsName = $null
            $result = Get-ComputerNameInfo -ComputerInfo $ComputerNameInfo
            $result | Should -Be "Computer Name information is unavailable."
        }
    }
}

# Function 5: Get-ComputerDomain
Describe "Get-ComputerDomain Tests" {
    BeforeEach {
        # Reset computer information before each test.
        $ComputerInfo.CsPartOfDomain = $true
        $ComputerInfo.CsDomain = "W2K22AD.local"
        $ComputerInfo.CsWorkgroup = "WORKGROUP"
    }
    Context "When the computer is domain joined" {
        It "Should return the domain name" {
            $result = Get-ComputerDomain -ComputerInfo $ComputerInfo
            $result | Should -Be "W2K22AD.local"
        }
        It "Should return an unavailable message when domain name is null" {
            $ComputerInfo.CsDomain = $null
            $result = Get-ComputerDomain -ComputerInfo $ComputerInfo
            $result | Should -Be "Domain name information is unavailable."
        }
        It "Should return an unavailable message when domain name is empty" {
            $ComputerInfo.CsDomain = ""
            $result = Get-ComputerDomain -ComputerInfo $ComputerInfo
            $result | Should -Be "Domain name information is unavailable."
        }
        It "Should return an unavailable message when domain name contains whitespace" {
            $ComputerInfo.CsDomain = "   "
            $result = Get-ComputerDomain -ComputerInfo $ComputerInfo
            $result | Should -Be "Domain name information is unavailable."
        }
    }
    Context "When the computer is part of a workgroup" {
        It "Should return the workgroup name" {
            $ComputerInfo.CsPartOfDomain = $false
            $result = Get-ComputerDomain -ComputerInfo $ComputerInfo
            $result | Should -Be "WORKGROUP"
        }
        It "Should return an unavailable message when workgroup name is null" {
            $ComputerInfo.CsPartOfDomain = $false
            $ComputerInfo.CsWorkgroup = $null
            $result = Get-ComputerDomain -ComputerInfo $ComputerInfo
            $result | Should -Be "Workgroup name information is unavailable."
        }
        It "Should return an unavailable message when workgroup name is empty" {
            $ComputerInfo.CsPartOfDomain = $false
            $ComputerInfo.CsWorkgroup = ""
            $result = Get-ComputerDomain -ComputerInfo $ComputerInfo
            $result | Should -Be "Workgroup name information is unavailable."
        }
        It "Should return an unavailable message when workgroup name contains whitespace" {
            $ComputerInfo.CsPartOfDomain = $false
            $ComputerInfo.CsWorkgroup = "   "
            $result = Get-ComputerDomain -ComputerInfo $ComputerInfo
            $result | Should -Be "Workgroup name information is unavailable."
        }
    }
}

# Function 6: Get-TrustedHosts
Describe "Get-TrustedHosts Tests" {
    Context "When trusted hosts are configured" {
        It "Should return the trusted hosts" {
            Mock Get-Item {
                [PSCustomObject]@{
                    Value = "host1,host2"
                }
            } -ModuleName OS_Information_Daniel_Mchendrie
            $result = Get-TrustedHosts
            $result | Should -Be "host1,host2"
        }
    }
    Context "When no trusted hosts are configured" {
        It "Should return No hosts configured when the value is empty" {
            Mock Get-Item {
                [PSCustomObject]@{
                    Value = ""
                }
            } -ModuleName OS_Information_Daniel_Mchendrie
            $result = Get-TrustedHosts
            $result | Should -Be "No hosts configured"
        }
    }
    Context "When trusted hosts contain whitespace" {
        It "Should return No hosts configured when the value contains whitespace" {
            Mock Get-Item {
                [PSCustomObject]@{
                    Value = "   "
                }
            } -ModuleName OS_Information_Daniel_Mchendrie
            $result = Get-TrustedHosts
            $result | Should -Be "No hosts configured"
        }
    }
    Context "When trusted hosts cannot be retrieved" {
        It "Should return an error message when trusted hosts cannot be retrieved" {
            Mock Get-Item {
                throw "WSMan unavailable"
            } -ModuleName OS_Information_Daniel_Mchendrie
            $result = Get-TrustedHosts
            $result | Should -Match "Error retrieving TrustedHosts"
        }
    }
}

# Function 7: Get-OSArchitecture
Describe "Get-OSArchitecture Tests" {
    BeforeEach {
        # Reset computer information before each test.
        $ComputerInfo.OsArchitecture = "64-bit"
    }
    Context "When the computer uses 64-bit architecture" {
        It "Should return 64-bit architecture" {
            $result = Get-OSArchitecture -ComputerInfo $ComputerInfo
            $result | Should -Be "64-bit"
        }
    }
    Context "When the computer uses 32-bit architecture" {
        It "Should return 32-bit architecture" {
            $ComputerInfo.OsArchitecture = "32-bit"
            $result = Get-OSArchitecture -ComputerInfo $ComputerInfo
            $result | Should -Be "32-bit"
        }
    }
    Context "When OS architecture information is unavailable" {
        It "Should return an unavailable message when architecture is null" {
            $ComputerInfo.OsArchitecture = $null
            $result = Get-OSArchitecture -ComputerInfo $ComputerInfo
            $result | Should -Be "Operating System architecture information is unavailable."
        }
        It "Should return an unavailable message when architecture is empty" {
            $ComputerInfo.OsArchitecture = ""
            $result = Get-OSArchitecture -ComputerInfo $ComputerInfo
            $result | Should -Be "Operating System architecture information is unavailable."
        }
        It "Should return an unavailable message when architecture contains whitespace" {
            $ComputerInfo.OsArchitecture = "   "
            $result = Get-OSArchitecture -ComputerInfo $ComputerInfo
            $result | Should -Be "Operating System architecture information is unavailable."
        }
    }
}

# Function 8: Get-AllOSInformation
Describe "Get-AllOSInformation Tests" {
    Context "When all information is successfully retrieved" {
        BeforeEach {
            Mock Get-OperatingSystemInfo {
                "Windows Server 2016"
            } -ModuleName OS_Information_Daniel_Mchendrie
            Mock Get-RemoteServiceStatus {
                "Running"
            } -ModuleName OS_Information_Daniel_Mchendrie
            Mock Get-ComputerManufacturerAndModel {
                "VMware - Virtual Platform"
            } -ModuleName OS_Information_Daniel_Mchendrie
            Mock Get-ComputerNameInfo {
                "SERVER1"
            } -ModuleName OS_Information_Daniel_Mchendrie
            Mock Get-ComputerDomain {
                "W2K16AD.local"
            } -ModuleName OS_Information_Daniel_Mchendrie
            Mock Get-TrustedHosts {
                "No hosts configured"
            } -ModuleName OS_Information_Daniel_Mchendrie
            Mock Get-OSArchitecture {
                "64-bit"
            } -ModuleName OS_Information_Daniel_Mchendrie
        }
        It "Should display all seven information categories" {
            $result = Get-AllOSInformation -ComputerInfo $ComputerInfo | Out-String
            $result | Should -Match "Operating System"
            $result | Should -Match "Remote Service Status"
            $result | Should -Match "Manufacturer and Model"
            $result | Should -Match "Computer Name"
            $result | Should -Match "Domain Information"
            $result | Should -Match "Trusted Hosts"
            $result | Should -Match "OS Architecture"
        }
        It "Should display the collected computer information" {
            $result = Get-AllOSInformation -ComputerInfo $ComputerInfo | Out-String
            $result | Should -Match "Windows Server 2016"
            $result | Should -Match "Running"
            $result | Should -Match "SERVER1"
            $result | Should -Match "W2K16AD.local"
            $result | Should -Match "64-bit"
        }
    }
}
