CLASS zcl_btp_stringout DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_btp_stringout IMPLEMENTATION.
METHOD if_oo_adt_classrun~main.
    DATA: lv_fullname TYPE string VALUE 'John Smith',
          lv_firstname TYPE string,
          lv_lastname TYPE string.

    SPLIT lv_fullname AT space INTO lv_firstname lv_lastname.

    out->write( |User's: First Name- { lv_firstname } Last Name- { lv_lastname } | ).

ENDMETHOD.
ENDCLASS.
