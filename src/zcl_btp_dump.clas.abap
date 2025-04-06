CLASS zcl_btp_dump DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_btp_dump IMPLEMENTATION.
METHOD if_oo_adt_classrun~main.

    DATA: lv_mths TYPE i VALUE 0, "No. of months remaining in year
          lv_hols TYPE i VALUE 20, "No. of days untaken vacation
          lv_avg_hols TYPE i.

    lv_avg_hols = lv_hols / lv_mths.
    out->write( |Average vacation days per month { lv_avg_hols }| ).

ENDMETHOD.
ENDCLASS.
