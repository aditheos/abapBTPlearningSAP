CLASS zcl_btp_cond DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_btp_cond IMPLEMENTATION.
METHOD if_oo_adt_classrun~main.
    CONSTANTS: c_0 TYPE i VALUE 0,
               c_name TYPE char1 VALUE 'F'.

    DATA: lv_fullname TYPE string VALUE 'John Smith',
          lv_firstname TYPE string,
          lv_lastname TYPE string.

    SPLIT lv_fullname AT space INTO lv_firstname lv_lastname.

    out->write( '-----------------------------' ).
    out->write( 'Example 1: IF...ELSE...ENDIF' ).
    out->write( '-----------------------------' ).

    IF c_0 = 0.
        out->write( 'The value of c_0 equels zero' ).
    ELSE.
        out->write( 'The value of c_0 equels some numer other than zero' ).
    ENDIF.

    out->write( '-----------------------------' ).
    out->write( 'Example 2: CASE.......ENDCASE' ).
    out->write( '-----------------------------' ).

    CASE c_name.
    WHEN 'F'.
        out->write( |User's: First Name- { lv_firstname }| ).
    WHEN OTHERS.
        out->write( | User's: Last Name- { lv_lastname } | ).
    ENDCASE.

ENDMETHOD.
ENDCLASS.
