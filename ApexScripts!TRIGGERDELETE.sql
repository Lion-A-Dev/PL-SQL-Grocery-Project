--TRIGGERDELETE
CREATE OR REPLACE TRIGGER delete_client_cascade
BEFORE DELETE ON ENTREPOT.CLIENTS
FOR EACH ROW
BEGIN
    -- Store the sales data in VENTESUPPRIMEES before deletion
    insert into ENTREPOT.VENTESUPPRIMEES(CODEVENTE, NUMCLIENT, NUMPROD, DATEVENTE, QUANTITEVENDUE, PRIXVENTE)
	SELECT CODEVENTE, :OLD:NUMCLIENT, NUMPROD, DATEVENTE, QUANTITEVENDUE, PRIXVENTE
	FROM ENTREPOT.VENTECLIENTS
	WHERE NUMCLIENT = :OLD:NUMCLIENT;
	
	DELETE FROM ENTREPOT.VENTECLIENTS
	WHERE NUMCLIENT = :OLD:NUMCLIENTS;
END;
/
pause appuyer sur une touche
@C:\ApexScripts\APEXMENU.SQL
