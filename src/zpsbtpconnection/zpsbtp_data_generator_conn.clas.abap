CLASS zpsbtp_data_generator_conn DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zpsbtp_data_generator_conn IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA: lt_aconn TYPE STANDARD TABLE OF zpsbtpaconn.
    DATA: lv_secs TYPE i VALUE 3600.
    SELECT * FROM /dmo/connection INTO TABLE @DATA(lt_dmoconn).
    COMMIT WORK.
    GET TIME STAMP FIELD DATA(lv_tmstmp).
    LOOP AT lt_dmoconn INTO DATA(ls_dmoconn).
      SELECT SINGLE * FROM zpsbtpaconn
       WHERE carrier_id = @ls_dmoconn-carrier_id
         AND connection_id = @ls_dmoconn-connection_id
       INTO @DATA(ls_dmo).
      IF sy-subrc <> 0.
        APPEND INITIAL LINE TO lt_aconn ASSIGNING FIELD-SYMBOL(<lfs_aconn>).
        <lfs_aconn> = CORRESPONDING #( ls_dmoconn ).
        DATA(lo_sysuuid) = cl_uuid_factory=>create_system_uuid( ).
        TRY.
            <lfs_aconn>-uuid = lo_sysuuid->create_uuid_x16( ).
          CATCH cx_uuid_error.
            EXIT.
        ENDTRY.
        TRY.
            cl_abap_tstmp=>subtractsecs(
              EXPORTING
                tstmp   = lv_tmstmp
                secs    = lv_secs
              RECEIVING
                r_tstmp = lv_tmstmp
            ).
            <lfs_aconn>-createdat = <lfs_aconn>-lastchangedat = <lfs_aconn>-locallastchanged = lv_tmstmp.
          CATCH cx_parameter_invalid_range.
          CATCH cx_parameter_invalid_type.
        ENDTRY.
        <lfs_aconn>-createdby = <lfs_aconn>-lastchangedby = sy-uname.
      ENDIF.
    ENDLOOP.
    IF NOT lt_aconn IS INITIAL.
      INSERT zpsbtpaconn FROM TABLE @lt_aconn.
      DATA(lv_rows) = lines( lt_aconn ).
      out->write( |{ lv_rows } Records updated to the table| ).
    ELSE.
      out->write( 'No new records found for updation' ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
