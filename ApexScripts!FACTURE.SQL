SET SERVEROUTPUT ON;
SET VERIFY OFF;

-- Prompt the user for the client number
ACCEPT p_numclient NUMBER PROMPT 'Enter the client number: '

DECLARE
    v_numclient ENTREPOT.CLIENTS.NUMCLIENT%TYPE := &p_numclient;
    v_nom ENTREPOT.CLIENTS.NOMCLIENT%TYPE;
    v_prenom ENTREPOT.CLIENTS.PRENOMCLIENT%TYPE;
    v_adresse VARCHAR2(100);
    v_total NUMBER := 0;
    v_taxe NUMBER := 0;
    v_grand_total NUMBER := 0;
    v_count INTEGER;
    v_sous_total NUMBER;
    v_has_transactions BOOLEAN := FALSE;

    CURSOR c_ventes IS
        SELECT v.numprod, p.nom AS nomprod, v.prixvente, v.quantitevendue, (v.prixvente * v.quantitevendue) AS sous_total
        FROM ENTREPOT.VENTECLIENTS v
        JOIN ENTREPOT.PRODUITS p ON v.numprod = p.numprod
        WHERE v.numclient = v_numclient;

BEGIN
    -- Check if the client exists
    SELECT COUNT(*)
    INTO v_count
    FROM ENTREPOT.CLIENTS
    WHERE numclient = v_numclient;

    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('ERREUR: Le numéro de client ' || v_numclient || ' n''existe pas.');
        RETURN;
    END IF;

    -- Fetch client details
    SELECT nomclient, prenomclient, norue || ' ' || nomrue || ', ' || ville || ', ' || province || ' ' || codepostal || ', ' || pays
    INTO v_nom, v_prenom, v_adresse
    FROM ENTREPOT.CLIENTS
    WHERE numclient = v_numclient;

    DBMS_OUTPUT.PUT_LINE('FACTURE DU CLIENT: ' || v_numclient);
    DBMS_OUTPUT.PUT_LINE('NOM: ' || v_nom || ' ' || v_prenom);
    DBMS_OUTPUT.PUT_LINE('ADRESSE: ' || v_adresse);
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    DBMS_OUTPUT.PUT_LINE(RPAD('Noprod', 10) || RPAD('Nomprod', 20) || RPAD('Prixvente', 10) || RPAD('Quantitevendue', 15) || 'Sous-total');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');

    -- Fetch and display sales details
    FOR rec IN c_ventes LOOP
        v_has_transactions := TRUE;
        v_sous_total := rec.prixvente * rec.quantitevendue;
        DBMS_OUTPUT.PUT_LINE(RPAD(rec.numprod, 10) || RPAD(rec.nomprod, 20) || RPAD(TO_CHAR(rec.prixvente, '999.99'), 10) || RPAD(rec.quantitevendue, 15) || TO_CHAR(v_sous_total, '9999.99'));
        v_total := v_total + v_sous_total;
    END LOOP;

    IF NOT v_has_transactions THEN
        DBMS_OUTPUT.PUT_LINE('Aucune transaction trouvée pour ce client.');
        RETURN;
    END IF;

    -- Calculate and display totals using package functions
    v_taxe := v_total * 0.15;
    v_grand_total := v_total + v_taxe;

    DBMS_OUTPUT.PUT_LINE('Total: ' 		 || LPAD(v_total, 56));
    DBMS_OUTPUT.PUT_LINE('Taxes (15%): ' || LPAD(v_taxe,50));
    DBMS_OUTPUT.PUT_LINE('Grand Total: ' || LPAD(v_grand_total,50));

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
pause appuyer sur une touche
@C:\ApexScripts\APEXMENU.SQL