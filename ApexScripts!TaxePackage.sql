CREATE OR REPLACE PACKAGE ENTREPOT.TAXEPACKAGE AS 
    FUNCTION COUTVENTE(p_numclient NUMBER) RETURN NUMBER;
    FUNCTION TAXE(coutvente NUMBER) RETURN NUMBER;
END TAXEPACKAGE;
/

CREATE OR REPLACE PACKAGE BODY ENTREPOT.TAXEPACKAGE AS

    FUNCTION COUTVENTE(p_numclient NUMBER) RETURN NUMBER IS
        v_coutvente NUMBER := 0;
    BEGIN
        BEGIN
            SELECT SUM(v.prixvente * v.quantitevendue)
            INTO v_coutvente
            FROM ENTREPOT.VENTECLIENTS v
            WHERE v.numclient = p_numclient;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_coutvente := 0;
        END;
        
        RETURN NVL(v_coutvente, 0); -- Return 0 if no sales are found
    END COUTVENTE;

    FUNCTION TAXE(coutvente NUMBER) RETURN NUMBER IS
        v_taxe NUMBER;
    BEGIN
        v_taxe := coutvente * 0.15;
        
        RETURN v_taxe;
    END TAXE;

END TAXEPACKAGE;
/
@C:\ApexScripts\APEXMENU.SQL
