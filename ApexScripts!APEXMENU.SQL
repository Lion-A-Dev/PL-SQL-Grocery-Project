--APEX MENU
clear screen
prompt ***Menu principal***
prompt 1. SOUS-MENU INSERTION DES TABLES
prompt 2. AFFICHER LES DONNER DE CHAQUNE DES TABLES
prompt 3. AFFICHER LA FACTURE DE UNE CLIENT
prompt 4. RABAIS SUR UNE FACTURE
prompt 5. MISE A JOUR ET SUPPRESSIONS
prompt 6. QUITTER
accept selection prompt "Votre choix: "

set term off
column script NEW_VALUE v_script
select case '&selection'
when '1' then 'ApexScripts\SOUS-MENU_INSERTION.sql' 
when '2' then 'ApexScripts\APPEL_AFFICHAGE.sql' --CREE UN FICHIER APPEL POUR APPELLER LES TROIS PROCEDURE
when '3' then 'ApexScripts\FACTURE.SQL'			--GENERATION D'UNE FACTURE BASE SUR LE NUM CLIENT
when '4' then 'ApexScripts\RABAIS.SQL'
when '5' then 'ApexScripts\UPDATE_SUPPRESSION_MENU.sql' --CREE UN SOUS-MENU POUR LES UPDATES ET SUPPRESSIONS
when '6' then 'ApexScripts\APEX_QUITTER.sql'			--CREE UN FICHIER POUR QUITTER
else 'APEXMENU.SQL'
end as script
from dual;
set term on
@C:\&v_script