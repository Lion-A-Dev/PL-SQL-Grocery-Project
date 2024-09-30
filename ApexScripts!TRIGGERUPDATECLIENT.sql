SET SERVEROUTPUT ON;
SET VERIFY OFF;

-- Prompt the user for the old and new client numbers
ACCEPT p_old_numclient NUMBER PROMPT 'Enter the current client number: '
ACCEPT p_new_numclient NUMBER PROMPT 'Enter the new client number: '

DECLARE
    v_old_numclient ENTREPOT.CLIENTS.NUMCLIENT%TYPE := &p_old_numclient;
    v_new_numclient ENTREPOT.CLIENTS.NUMCLIENT%TYPE := &p_new_numclient;
    v_count INTEGER;

BEGIN
    -- Check if the old client number exists
    SELECT COUNT(*)
    INTO v_count
    FROM ENTREPOT.CLIENTS
    WHERE numclient = v_old_numclient;

    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('ERREUR: Le numéro de client ' || v_old_numclient || ' n''existe pas.');
        RETURN;
    END IF;

    -- Update the client number
    UPDATE ENTREPOT.CLIENTS
    SET numclient = v_new_numclient
    WHERE numclient = v_old_numclient;

    IF SQL%ROWCOUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Le numéro de client a été mis à jour avec succès.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('ERREUR: Mise à jour échouée.');
    END IF;

    -- Display the data after the update
    DBMS_OUTPUT.PUT_LINE('Données après la mise à jour:');
    FOR rec IN (SELECT * FROM ENTREPOT.CLIENTS WHERE numclient = v_new_numclient) LOOP
        DBMS_OUTPUT.PUT_LINE('NumClient: ' || rec.numclient || ', NomClient: ' || rec.nomclient || ', PrenomClient: ' || rec.prenomclient || ', Telephone: ' || rec.telephone || ', Adresse: ' || rec.norue || ' ' || rec.nomrue || ', ' || rec.ville || ', ' || rec.province || ', ' || rec.codepostal || ', ' || rec.pays);
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erreur: ' || SQLERRM);
END;
/
pause appuyer sur une touche
@C:\ApexScripts\APEXMENU.SQL