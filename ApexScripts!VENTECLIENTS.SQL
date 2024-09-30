--INSERTION DE VENTECLIENTS
SET SERVEROUTPUT ON;
SET VERIFY OFF;

-- Prompt the user for input values
ACCEPT p_numclient NUMBER PROMPT 'Enter the client number: '
ACCEPT p_numprod NUMBER PROMPT 'Enter the product number: '
ACCEPT p_quantitevendue NUMBER PROMPT 'Enter the quantity sold: '
ACCEPT p_prixvente NUMBER PROMPT 'Enter the sale price: '

DECLARE
	ERREUR_INTEGRITE EXCEPTION;
	PRAGMA EXCEPTION_INIT(ERREUR_INTEGRITE, -2291);

    v_numclient ENTREPOT.CLIENTS.NUMCLIENT%TYPE := &p_numclient;
    v_numprod ENTREPOT.PRODUITS.NUMPROD%TYPE := &p_numprod;
    v_quantitevendue ENTREPOT.VENTECLIENTS.QUANTITEVENDUE%TYPE := &p_quantitevendue;
    v_prixvente ENTREPOT.VENTECLIENTS.PRIXVENTE%TYPE := &p_prixvente;
    v_quantitestock ENTREPOT.PRODUITS.QUANTITESTOCK%TYPE;
    v_prixprod ENTREPOT.PRODUITS.PRIX%TYPE;
    v_new_codevente ENTREPOT.VENTECLIENTS.CODEVENTE%TYPE;

BEGIN
    -- Retrieve the quantity in stock and the product price
    SELECT quantitestock, prix
    INTO v_quantitestock, v_prixprod
    FROM ENTREPOT.PRODUITS
    WHERE numprod = v_numprod;
    
    -- Check if the product can be sold
    IF v_quantitestock IS NULL OR v_quantitestock = 0 THEN
        DBMS_OUTPUT.PUT_LINE('ERREUR: Le produit ' || v_numprod || ' est en rupture de stock et ne peut etre vendu.');
        RETURN;
    ELSIF v_quantitevendue > v_quantitestock THEN
        DBMS_OUTPUT.PUT_LINE('ERREUR: La quantitee vendue (' || v_quantitevendue || ') ne peut etre superieure à la quantite en stock (' || v_quantitestock || ').');
        RETURN;
    ELSIF v_prixvente <= v_prixprod THEN
        DBMS_OUTPUT.PUT_LINE('ERREUR: Le prix de vente (' || v_prixvente || ') doit être superieur au prix du produit (' || v_prixprod || ').');
        RETURN;
    END IF;
    
    -- Perform the sale
    INSERT INTO ENTREPOT.VENTECLIENTS (CODEVENTE, NUMCLIENT, NUMPROD, DATEVENTE, QUANTITEVENDUE, PRIXVENTE)
    VALUES (ENTREPOT.CODEVENTES_SEQ.NEXTVAL, v_numclient, v_numprod, SYSDATE, v_quantitevendue, v_prixvente);

    -- Update the product quantity in stock
    UPDATE ENTREPOT.PRODUITS
    SET quantitestock = quantitestock - v_quantitevendue
    WHERE numprod = v_numprod;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('La vente a été effectuée avec succès et la quantité en stock a été mise à jour.');
    
EXCEPTION
	WHEN ERREUR_INTEGRITE THEN
		DBMS_OUTPUT.PUT_LINE('ERREUR: VIOLATION DE CONTRAINTE  D''INTEGRITE.');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('ERREUR: Le produit ou le client n''existe pas.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERREUR: ' || SQLERRM);
        ROLLBACK;
END;
/
@C:\ApexScripts\APEXMENU.SQL
