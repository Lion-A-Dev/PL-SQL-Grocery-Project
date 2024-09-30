-- Clear the screen and display the insertion menu
CLEAR SCREEN
PROMPT ***MENU INSERTION***
PROMPT 1. INSERTION DE CLIENT
PROMPT 2. INSERTION DE PRODUIT
PROMPT 3. INSERTION DE VENTE
PROMPT 4. RETOUR AU MENU PRINCIPALE  

-- Prompt the user for their selection
ACCEPT selection PROMPT "Votre choix: "

SET TERM OFF

-- Define a column for script selection
COLUMN script NEW_VALUE MI_script
SELECT CASE '&selection'
    WHEN '1' THEN 'Clients.sql' 
    WHEN '2' THEN 'Produits.sql'
    WHEN '3' THEN 'VENTECLIENTS.SQL'
    WHEN '4' THEN 'APEXMENU.SQL'
    ELSE 'APEXMENU.SQL'
END AS script
FROM dual;

-- Set terminal output on to display the selected script output
SET TERM ON

-- Execute the selected script
@C:\ApexScripts\&MI_script

-- Return to the main menu
@C:\ApexScripts\APEXMENU.SQL
