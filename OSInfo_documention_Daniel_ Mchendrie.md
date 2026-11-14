# Modifications 1: Version control 
# Modifications 2: File path variables, possibly this is passed in from another script
# Create a file path variable (Example - $FilePath = $env:TEMP)
# Modifications 3: Store the menu and related function in variables 
# 	The menu can be edited and added to without large modifications to code
# Modifications 4: Can the exit command be the 'Esc" Key?


# <# ------------------------------------------------------------
# ITWorks - Operating System Information Pseudocode
# File: Pseudocode-OSInfo_documentation_Daniel_Mchendrie.md(docx)
# Purpose: Pseudocode for scriprt - Assessment 1 
# Author: Daniel Mchendrie
# Student # 000267035
# Date: 07/11/2026
# ------------------------------------------------------------#>

# Modifications: Version control 

# Modifications: File path variables, possibly this is passed in from another script
# Create a file path variable (Example - $FilePath = $env:TEMP)

# where to store Functions? (modules are a good practice)

# Functions that are not required 
   # DEFINE function to retrieve and display all information ##

START

# The functions will be stored in a separate module and then imported
# All Functions that require the computer Info will accept this as a variable that is passed to it
# All functions will display (RETURN) the output, in the function 
    DEFINE function to retrieve operating system information
    DEFINE function to retrieve remote service status
    DEFINE function to retrieve manufacturer and model
    DEFINE function to retrieve computer name
    DEFINE function to retrieve domain information
    DEFINE function to retrieve TrustedHosts configuration
    DEFINE function to retrieve OS architecture
    EXPORT all functions to be exported
# Import the above module
    IMPORT OS Info functions module

# Collect the computer information as a variable
    DEFINE the variable for Computer information 
    GET - the Computer Information and store in this variable
    Test - Test if this is 'null' - quit if null

# Modifications: Store the menu and related function in variables 
# Modifications cont.: - the menu can be edited and added to without large modifications to code

# The display Menu may need to be placed inside the loop below - variable possibly
    WHILE LOOP

        DISPLAY menu options 1 to 9
1.  Operating system currently been used.
2.  Windows remote service status.
3.  Computer manufacturer and Model.
4.  Computer name.
5.  Computer domain name.
6.  Computer’s trusted hosts.
7.  Operating system architecture (32 bit or 64 bit)
8.  Get all the above information
9.  Quit
# Modifications: Can the exit command be the 'Esc" Key?

# DO WHILE - This does not display the menu again 
        PROMPT user for menu selection
        TEST - if valid, prompt again if not valid

## Can this Loop use nested IF statements or ELSE IF (Possible a SWITCH)?
# “Display Outputs” - will be completed in each function

        SWITCH Function 
            Selection is "1"
                CALL function - Operating system information
                DISPLAY - output
            Selection is "2"
                CALL function - Remote service status
                DISPLAY - output
            Selection is "3"
                CALL function - Manufacturer and model
                DISPLAY - output
            Selection is "4"
                CALL function - Computer name
                DISPLAY - output
            Selection is "5"
                CALL function - Computer domain name
                DISPLAY - output
            Selection is "6"
                CALL function - Trusted hosts
                DISPLAY - output
            Selection is "7"
                CALL function - OS architecture
                DISPLAY – output
            Selection is "8"
                CALL function - Get all information
                DISPLAY – output 
            Selection is "9"
                DISPLAY Message - Exit message
            NO selection or Error
# IF not the defined selections, all others are errors - Ask for input again
                Default
                DISPLAY Message – Error message - Invalid selection message
        END Switch

    OUTPUTS
        If 9 - Exit 
        Functions - will display the requested outputs
        Pause - Press Enter to continue
        Display menu again

  END LOOP - UNTIL selection is "9"

END Script
