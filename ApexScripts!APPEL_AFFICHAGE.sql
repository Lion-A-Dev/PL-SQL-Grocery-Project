--FICHIER APPEL QUI APPEL LES PRECEDURES D'AFFICHAGE
SET SERVEROUTPUT ON;

-- Call the procedures from the AFFICHAGEAPEX package
BEGIN
    ENTREPOT.AFFICHAGEAPEX.LISTECLIENTS;
    ENTREPOT.AFFICHAGEAPEX.LISTEPRODUIT;
    ENTREPOT.AFFICHAGEAPEX.LISTEVENTES;
END;
/
pause appuyer sur une touche
-- Return to the main menu after displaying the data
@C:\ApexScripts\APEXMENU.SQL
