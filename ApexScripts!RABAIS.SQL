SET SERVEROUTPUT ON;
SET VERIFY OFF;

-- Prompt the user for the client number and sale date
ACCEPT p_numclient NUMBER PROMPT 'Enter the client number: '
ACCEPT p_datevente CHAR PROMPT 'Enter the sale date (YYYY-MM-DD): '

DECLARE
    v_numclient ENTREPOT.CLIENTS.NUMCLIENT%TYPE := &p_numclient;
    v_datevente DATE;
    v_nomclient ENTREPOT.CLIENTS.NOMCLIENT%TYPE;
    v_prenomclient ENTREPOT.CLIENTS.PRENOMCLIENT%TYPE;
    v_total NUMBER := 0;
    v_taxe NUMBER := 0;
    v_grand_total NUMBER := 0;
    v_subtotal NUMBER := 0;
    v_new_prixvente NUMBER;
    v_quantitevendue NUMBER;
    v_sous_total NUMBER;
    v_discount_amount NUMBER;

    CURSOR c_updated_sales IS
        SELECT v.numprod, p.nom AS nomprod, v.prixvente, v.quantitevendue, 
               (v.prixvente * v.quantitevendue) AS sous_total,
               (rec.prixvente * rec.quantitevendue) - (v.prixvente * v.quantitevendue) AS discount_amount
        FROM ENTREPOT.VENTECLIENTS v
        JOIN ENTREPOT.PRODUITS p ON v.numprod = p.numprod
        JOIN ENTREPOT.VENTECLIENTS rec ON v.numclient = rec.numclient AND v.numprod = rec.numprod AND v.datevente = rec.datevente
        WHERE v.numclient = v_numclient AND v.datevente = v_datevente;
BEGIN
    -- Validate and convert the date input
    BEGIN
        v_datevente := TO_DATE('&p_datevente', 'YYYY-MM-DD');
        DBMS_OUTPUT.PUT_LINE('Date entered: ' || TO_CHAR(v_datevente, 'YYYY-MM-DD'));
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Invalid date format. Please enter the date in YYYY-MM-DD format.');
            RETURN;
    END;

    -- Call the RABAIS procedure
    PROCRABAIS(v_numclient, v_datevente);

    -- Fetch and display the updated sales details
    DBMS_OUTPUT.PUT_LINE('Updated Sales Details:');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    DBMS_OUTPUT.PUT_LINE(RPAD('Noprod', 10) || RPAD('Nomprod', 20) || RPAD('Prixvente', 15) || RPAD('Quantitevendue', 15) || RPAD('Sous-total', 15) || 'Discount Amount');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');

    OPEN c_updated_sales;
    LOOP
        FETCH c_updated_sales INTO v_numclient, v_nomclient, v_new_prixvente, v_quantitevendue, v_sous_total, v_discount_amount;
        EXIT WHEN c_updated_sales%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(RPAD(v_numclient, 10) || RPAD(v_nomclient, 20) || RPAD(TO_CHAR(v_new_prixvente, '999.99'), 15) || RPAD(v_quantitevendue, 15) || RPAD(TO_CHAR(v_sous_total, '9999.99'), 15) || TO_CHAR(v_discount_amount, '999.99'));

        v_total := v_total + v_sous_total;
    END LOOP;
    CLOSE c_updated_sales;

    v_taxe := v_total * 0.15;
    v_grand_total := v_total + v_taxe;

    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Total: ' || TO_CHAR(v_total, '9999.99'));
    DBMS_OUTPUT.PUT_LINE('Taxes (15%): ' || TO_CHAR(v_taxe, '999.99'));
    DBMS_OUTPUT.PUT_LINE('Grand Total: ' || TO_CHAR(v_grand_total, '9999.99'));

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
