--SOUS-MENU UPDATE ET SUPPRESSION
-- Clear the screen and display the sub-menu for updates and deletions
CLEAR SCREEN
PROMPT ***SOUS-MENU UPDATES ET SUPPRESSIONS***
PROMPT 1. CHANGER LE NUMERO D''UN CLIENT
PROMPT 2. SUPPRIMER UN CLIENT
PROMPT 3. RETOUR AU MENU PRINCIPALE

-- Prompt the user for their selection
ACCEPT selection PROMPT "Votre choix: "

-- Set terminal output off to control display of commands
SET TERM OFF

-- Define a column for script selection
COLUMN script NEW_VALUE UD_script
SELECT CASE '&selection'
    WHEN '1' THEN 'TRIGGERUPDATECLIENT.sql' -- Updates client number
    WHEN '2' THEN 'DELETECLIENT.sql' -- Deletes a client
    WHEN '3' THEN 'APEXMENU.SQL' -- Returns to main menu
    ELSE 'APEXMENU.SQL'
END AS script
FROM dual;

-- Set terminal output on to display the selected script output
SET TERM ON

-- Execute the selected script
@C:\ApexScripts\&UD_script

-- Return to the main menu after the selected operation is completed
pause appuyer sur une touche
@C:\ApexScripts\APEXMENU.SQL
