CREATE OR REPLACE PROCEDURE PROCRABAIS (
    p_numclient IN ENTREPOT.VENTECLIENTS.NUMCLIENT%TYPE,
    p_datevente IN DATE
) IS
    CURSOR c_transactions IS
        SELECT numprod, prixvente, quantitevendue, (prixvente * quantitevendue) AS total
        FROM ENTREPOT.VENTECLIENTS
        WHERE numclient = p_numclient AND datevente = p_datevente;

    v_numprod ENTREPOT.VENTECLIENTS.NUMPROD%TYPE;
    v_prixvente ENTREPOT.VENTECLIENTS.PRIXVENTE%TYPE;
    v_quantitevendue ENTREPOT.VENTECLIENTS.QUANTITEVENDUE%TYPE;
    v_total NUMBER;
    v_new_prixvente ENTREPOT.VENTECLIENTS.PRIXVENTE%TYPE;
    v_discount NUMBER;
BEGIN
    FOR rec IN c_transactions LOOP
        v_numprod := rec.numprod;
        v_prixvente := rec.prixvente;
        v_quantitevendue := rec.quantitevendue;
        v_total := rec.total;

        IF v_total <= 100 THEN
            v_new_prixvente := v_prixvente * 0.95; -- 5% discount
            v_discount := 0.05;
        ELSIF v_total > 100 AND v_total <= 500 THEN
            v_new_prixvente := v_prixvente * 0.90; -- 10% discount
            v_discount := 0.10;
        ELSIF v_total > 500 THEN
            v_new_prixvente := v_prixvente * 0.85; -- 15% discount
            v_discount := 0.15;
        END IF;

        UPDATE ENTREPOT.VENTECLIENTS
        SET prixvente = v_new_prixvente
        WHERE numclient = p_numclient AND numprod = v_numprod AND datevente = p_datevente;
        
        COMMIT; -- Commit the transaction after each update

        -- Print the discount information
        DBMS_OUTPUT.PUT_LINE('Discount for product ' || v_numprod || ': ' || (v_discount * 100) || '%');
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Rabais appliqué pour le client ' || p_numclient || ' pour la date ' || TO_CHAR(p_datevente, 'YYYY-MM-DD'));
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Aucune transaction trouvée pour le client ' || p_numclient || ' à la date ' || TO_CHAR(p_datevente, 'YYYY-MM-DD'));
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erreur: ' || SQLERRM);
END PROCRABAIS;
/
@C:\ApexScripts\APEXMENU.SQL