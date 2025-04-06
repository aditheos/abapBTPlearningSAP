*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_flights DEFINITION.
  PUBLIC SECTION.
    METHODS constructor.
    METHODS access_standard.
    METHODS access_sorted.
    METHODS access_hashed.
  PRIVATE SECTION.


    DATA standard_table TYPE STANDARD TABLE OF zs4d401_flights WITH NON-UNIQUE KEY carrier_id connection_id flight_date.
    DATA sorted_table TYPE SORTED TABLE OF zs4d401_flights WITH NON-UNIQUE KEY carrier_id connection_id flight_date.
    DATA hashed_table TYPE HASHED TABLE OF zs4d401_flights WITH UNIQUE KEY carrier_id connection_id flight_date.


    DATA key_carrier_id TYPE /dmo/carrier_id.
    DATA key_connection_id TYPE /dmo/connection_id.
    DATA key_date TYPE /dmo/flight_date.
    METHODS set_line_to_read.


ENDCLASS.


CLASS lcl_flights IMPLEMENTATION.

  METHOD constructor.
    SELECT FROM zs4d401_flights FIELDS * INTO TABLE @standard_table.
    SELECT FROM zs4d401_flights FIELDS * INTO TABLE @sorted_table.
    SELECT FROM zs4d401_flights FIELDS * INTO TABLE @hashed_table.


    set_line_to_read( ).
  ENDMETHOD.

  METHOD access_standard.
    DATA(result) = standard_table[ carrier_Id = me->key_carrier_id connection_Id = me->key_connection_id flight_date = me->key_date ].
  ENDMETHOD.

  METHOD access_hashed.
    DATA(result) = hashed_table[ carrier_Id = me->key_carrier_id connection_Id = me->key_connection_id flight_date = me->key_date ].
  ENDMETHOD.


  METHOD access_sorted.
    DATA(result) = sorted_table[ carrier_Id = me->key_carrier_id connection_Id = me->key_connection_id flight_date = me->key_date ].
  ENDMETHOD.

  METHOD set_line_to_read.
    DATA(line) = standard_table[ CONV i( lines( standard_table ) * '0.65' ) ].
    me->key_carrier_id = line-carrier_Id.
    me->key_connection_Id = line-connection_id.
    me->key_date = line-flight_date.
  ENDMETHOD.


ENDCLASS.

CLASS lcl_flights_seckey DEFINITION.
  PUBLIC SECTION.
    METHODS constructor.
    METHODS read_primary.
    METHODS read_non_key.
    METHODS read_secondary_1.
    METHODS read_secondary_2.
    METHODS read_secondary_3.


  PRIVATE SECTION.
    DATA connections TYPE SORTED TABLE OF Zs4d401_flights WITH NON-UNIQUE KEY carrier_id connection_Id flight_date.
    DATA connections_sk TYPE SORTED TABLE OF Zs4d401_flights WITH NON-UNIQUE KEY carrier_id connection_id flight_date
    WITH NON-UNIQUE SORTED KEY k_plane COMPONENTS plane_type_id.


ENDCLASS.


CLASS lcl_flights_seckey IMPLEMENTATION.


  METHOD constructor.
    SELECT FROM Zs4d401_flights FIELDS * INTO TABLE @connections.
    SELECT FROM Zs4d401_flights FIELDS * INTO TABLE @connections_sk.
  ENDMETHOD.


  METHOD read_non_key.
    LOOP AT connections INTO DATA(connection) WHERE plane_type_id = '737-800'.
    ENDLOOP.
  ENDMETHOD.


  METHOD read_primary.
    DATA count TYPE i VALUE 1.
    LOOP AT connections INTO DATA(connection) WHERE carrier_id = 'LH' AND connection_id = '0405' .
      count += 1.
    ENDLOOP.
  ENDMETHOD.


  METHOD read_secondary_1.
    LOOP AT connections_sk INTO DATA(connection) USING KEY k_plane WHERE plane_type_id = '737-800'.
    ENDLOOP.
  ENDMETHOD.


  METHOD read_secondary_2.
    LOOP AT connections_sk INTO DATA(connection) USING KEY k_plane WHERE plane_type_id = '737-800'.
    ENDLOOP.
  ENDMETHOD.
  METHOD read_secondary_3.
    LOOP AT connections_sk INTO DATA(connection) USING KEY k_plane WHERE plane_type_id = '737-800'.
    ENDLOOP.


  ENDMETHOD.


ENDCLASS.
