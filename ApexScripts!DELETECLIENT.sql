ACCEPT DEL PROMPT 'ENTRER LE NUMERO A SUPPRIMER : '	
	
BEGIN
    -- Delete the sales data from VENTECLIENTS
    DELETE FROM ENTREPOT.CLIENTS
    WHERE NUMCLIENT = '&DEL';
END;
/
pause appuyuer
@C:\ApexScripts\APEXMENU.SQL
