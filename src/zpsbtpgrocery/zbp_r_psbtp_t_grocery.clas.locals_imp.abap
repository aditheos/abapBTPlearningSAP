CLASS LHC_ZR_PSBTP_T_GROCERY DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR Grocery
        RESULT result,
      checkDateExpiration FOR MODIFY
            IMPORTING keys FOR ACTION Grocery~checkDateExpiration RESULT result.
ENDCLASS.

CLASS LHC_ZR_PSBTP_T_GROCERY IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.
  METHOD checkDateExpiration.

    DATA: lt_groceries TYPE TABLE FOR READ RESULT zr_psbtp_t_grocery,
          ls_grocery TYPE STRUCTURE FOR READ RESULT zr_psbtp_t_grocery,
          lv_expiration TYPE d,
          lv_current_date TYPE d,
          lv_expired TYPE abap_boolean,
          lt_update_groceries TYPE TABLE FOR UPDATE zr_psbtp_t_grocery.

    READ ENTITIES OF zr_psbtp_t_grocery
      IN LOCAL MODE ENTITY Grocery
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT lt_groceries.

    LOOP AT lt_groceries INTO ls_grocery.
      lv_expiration = ls_grocery-Expirationdate.
      lv_current_date = cl_abap_context_info=>get_system_date( ).
      IF lv_expiration < lv_current_date.
        lv_expired = abap_true.
      ELSE.
        lv_expired = abap_false.
      ENDIF.

    APPEND VALUE #( id = ls_grocery-Id expired = lv_expired )
      TO lt_update_groceries.
    MODIFY ENTITIES OF zr_psbtp_t_grocery IN LOCAL MODE
      ENTITY Grocery
      UPDATE FIELDS ( expired )
      WITH lt_update_groceries.
    ENDLOOP.

    result = VALUE #( FOR groceries IN lt_groceries
      ( id = groceries-id %param = groceries ) ).
  ENDMETHOD.

ENDCLASS.
