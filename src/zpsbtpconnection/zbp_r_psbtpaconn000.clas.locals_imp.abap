CLASS lhc_zr_psbtpaconn000 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR Connections
        RESULT result,
      CheckSemanticData FOR VALIDATE ON SAVE
        IMPORTING keys FOR Connections~CheckSemanticData,
      SetCities FOR DETERMINE ON SAVE
        IMPORTING keys FOR Connections~SetCities.
ENDCLASS.

CLASS lhc_zr_psbtpaconn000 IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD CheckSemanticData.
    DATA: lt_keys        TYPE TABLE FOR READ IMPORT zr_psbtpaconn000,
          lt_connections TYPE TABLE FOR READ RESULT zr_psbtpaconn000,
          ls_reported    LIKE LINE OF reported-connections.

    " Get Keys
    lt_keys = CORRESPONDING #(  keys ).

    " Read Entity
    READ ENTITIES OF zr_psbtpaconn000 IN LOCAL MODE
      ENTITY Connections
      FIELDS ( Uuid CarrierId ConnectionId AirportFromId AirportToId )
      WITH lt_keys
      RESULT lt_connections.

    LOOP AT lt_connections INTO DATA(ls_conn).
      " Check for Valid Airline ID
      SELECT SINGLE
        FROM /DMO/I_Carrier
      FIELDS @abap_true
       WHERE AirlineID = @ls_conn-CarrierId
        INTO @DATA(lv_exists).
      IF lv_exists <> abap_true.
        DATA(ls_message) = me->new_message(
                             id       = 'ZPSBTPMESGCONN'
                             number   = '002'
                             severity = ms-error
                             v1       = ls_conn-CarrierId
                           ).
        " Add Error Message
        CLEAR ls_reported.
        ls_reported-%tky = ls_conn-%tky.
        ls_reported-%state_area = 'Validate Semantic Key'.
        ls_reported-%msg = ls_message.
        ls_reported-%element-carrierid = if_abap_behv=>mk-on.
        ls_reported-%element-connectionid = if_abap_behv=>mk-on.
        APPEND ls_reported TO reported-connections.
        APPEND VALUE #( %tky                       = ls_conn-%tky ) TO failed-connections.
      ELSE.
        " Check Airports are not same
        IF ls_conn-AirportFromId = ls_conn-AirportToId.
          CLEAR ls_message.
          ls_message = me->new_message(
                               id       = 'ZPSBTPMESGCONN'
                               number   = '003'
                               severity = ms-error
                             ).
          " Add Error Message
          CLEAR ls_reported.
          ls_reported-%tky = ls_conn-%tky.
          ls_reported-%state_area = 'Validate Semantic Key'.
          ls_reported-%msg = ls_message.
          ls_reported-%element-airportfromid = if_abap_behv=>mk-on.
          ls_reported-%element-airporttoid = if_abap_behv=>mk-on.
          APPEND ls_reported TO reported-connections.
          APPEND VALUE #( %tky                       = ls_conn-%tky ) TO failed-connections.
        ELSE.
          " Check for Duplicate Entry
          SELECT FROM zpsbtpaconn
               FIELDS uuid
                WHERE carrier_id = @ls_conn-CarrierId
                  AND connection_id = @ls_conn-ConnectionId
                  AND uuid <> @ls_conn-Uuid
          UNION
          SELECT FROM zpsbtpaconn000_d
               FIELDS uuid
                WHERE carrierid = @ls_conn-CarrierId
                  AND connectionid = @ls_conn-ConnectionId
                  AND uuid <> @ls_conn-Uuid
          INTO TABLE @DATA(lt_conn_found).
          IF NOT lt_conn_found IS INITIAL.
            CLEAR ls_message.
            ls_message = me->new_message(
                                 id       = 'ZPSBTPMESGCONN'
                                 number   = '001'
                                 severity = ms-error
                                 v1       = ls_conn-CarrierId
                                 v2       = ls_conn-ConnectionId
                               ).
            " Add Error Message
            CLEAR ls_reported.
            ls_reported-%tky = ls_conn-%tky.
            ls_reported-%state_area = 'Validate Semantic Key'.
            ls_reported-%msg = ls_message.
            ls_reported-%element-carrierid = if_abap_behv=>mk-on.
            ls_reported-%element-connectionid = if_abap_behv=>mk-on.
            APPEND ls_reported TO reported-connections.
            APPEND VALUE #( %tky                       = ls_conn-%tky ) TO failed-connections.
          ENDIF.
        ENDIF.
      ENDIF.
      CLEAR: ls_message, ls_conn.
    ENDLOOP.

  ENDMETHOD.

  METHOD SetCities.
    DATA: lt_keys        TYPE TABLE FOR READ IMPORT zr_psbtpaconn000,
          lt_connections TYPE TABLE FOR READ RESULT zr_psbtpaconn000,
          lt_connupdate  TYPE TABLE FOR UPDATE zr_psbtpaconn000.

    " Get Keys
    lt_keys = CORRESPONDING #(  keys ).

    " Read Entity
    READ ENTITIES OF zr_psbtpaconn000 IN LOCAL MODE
      ENTITY Connections
      FIELDS ( Uuid CarrierId ConnectionId AirportFromId AirportToId )
      WITH lt_keys
      RESULT lt_connections.

    LOOP AT lt_connections ASSIGNING FIELD-SYMBOL(<lfs_conn>).
      SELECT SINGLE
        FROM /DMO/I_Airport
      FIELDS City, CountryCode
       WHERE AirportID = @<lfs_conn>-AirportFromId
       INTO ( @<lfs_conn>-CityFrom, @<lfs_conn>-CountryFrom ).

      SELECT SINGLE
        FROM /DMO/I_Airport
      FIELDS City, CountryCode
       WHERE AirportID = @<lfs_conn>-AirportToId
       INTO ( @<lfs_conn>-CityTo, @<lfs_conn>-CountryTo ).
    ENDLOOP.
    lt_connupdate = CORRESPONDING #( lt_connections ).

    " Modify Entity
    MODIFY ENTITIES OF zr_psbtpaconn000 IN LOCAL MODE
             ENTITY Connections
             UPDATE
             FIELDS ( CityFrom CountryFrom CityTo CountryTo )
               WITH lt_connupdate
           REPORTED DATA(ls_reported).

     reported-connections = CORRESPONDING #( ls_reported-connections ).

  ENDMETHOD.

ENDCLASS.
