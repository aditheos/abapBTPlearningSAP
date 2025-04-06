CLASS zcl_btp_internal_table DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_btp_internal_table IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    TYPES: BEGIN OF t_connection,
             carrier_id             TYPE /dmo/carrier_id,
             connection_id          TYPE /dmo/connection_id,
             departure_airport      TYPE /dmo/airport_from_id,
             departure_airport_Name TYPE /dmo/airport_Name,
           END OF t_connection.


    TYPES t_connections TYPE STANDARD TABLE OF t_connection WITH NON-UNIQUE KEY carrier_id connection_id.


    DATA connections TYPE TABLE OF /dmo/connection.
    DATA airports TYPE TABLE OF /dmo/airport.
    DATA result_table TYPE t_connections.


* Aim of the method:
* Read a list of connections from the database and use them to fill an internal table result_table.
* This contains some data from the table connections and adds the name of the departure airport.


    SELECT FROM /dmo/airport FIELDS * INTO TABLE @airports.
    SELECT FROM /dmo/connection FIELDS * INTO TABLE @connections.




    out->write( 'Connection Table' ).
    out->write( '________________' ).
    out->write( connections ).
    out->write( ` ` ).




* The VALUE expression iterates over the table connections. In each iteration, the variable line
* accesses the current line. Inside the parentheses, we build the next line of result_table by
* copying the values of line-carrier_Id, line-connection_Id and line-airport_from_id, then
* loooking up the airport name in the internal table airports using a table expression


    result_table = VALUE #( FOR line IN connections ( carrier_Id = line-carrier_id
                                        connection_id = line-connection_id
                                        departure_airport = line-airport_from_id
                                        departure_airport_name = airports[ airport_id = line-airport_from_id ]-name )
                                        ).


    out->write( 'Results' ).
    out->write( '_______' ).
    out->write( result_table ).


    TYPES: BEGIN OF t_results,
             occupied TYPE /dmo/plane_seats_occupied,
             maximum  TYPE /dmo/plane_seats_max,
           END OF t_results.


    TYPES: BEGIN OF t_results_with_Avg,
             occupied TYPE /dmo/plane_seats_occupied,
             maximum  TYPE /dmo/plane_seats_max,
             average  TYPE p LENGTH 16 DECIMALS 2,
           END OF t_results_with_avg.


    DATA flights TYPE TABLE OF /dmo/flight.
    SELECT FROM /dmo/flight FIELDS * INTO TABLE @flights.


* Result is a scalar data type
    DATA(sum) = REDUCE i( INIT total = 0 FOR line1 IN flights NEXT total += line1-seats_occupied ).
    out->write( 'Result is a scalar data type' ).
    out->write( '_____________ ______________' ).
    out->write( sum ).
    out->write( ' ' ).


* Result is a structured data type
    DATA(results) = REDUCE t_results( INIT totals TYPE t_results
                                      FOR line2 IN flights NEXT
                                          totals-occupied += line2-seats_occupied
                                          totals-maximum += line2-seats_max ).
    out->write( 'Result is a structure' ).
    out->write( '_____________________' ).


    out->write( results ).
    out->write( ' ' ).


* Result is a structured data type
* Reduction uses a local helper variable
* Result of the reduction is always the *first* variable declared after init
    out->write( 'Result is a structure. The average is calculated using a local helper variable' ).
    out->write( '______________________________________________________________________________' ).


    DATA(result_with_Average) = REDUCE t_results_with_avg( INIT totals_avg TYPE t_results_with_avg count = 1
                                                            FOR line3 IN flights NEXT totals_Avg-occupied += line3-seats_occupied
                                                            totals_avg-maximum += line3-seats_max
                                                            totals_avg-average = totals_avg-occupied / count
                                                            count += 1 ).
    out->write( result_with_average ).

**********************************************************************
* SORTED/HASHED
**********************************************************************

* Run this class using the ABAP Profiler to measure relative access times for standard, sorted, and hashed tables


    DATA(lo_flights) = NEW lcl_flights( ).
    lo_flights->access_standard( ).
    lo_flights->access_sorted( ).
    lo_flights->access_hashed( ).


    out->write( |Done| ).


    DATA(object) = NEW lcl_flights_seckey( ).


* object->read_primary( ).
    object->read_non_key( ).
    object->read_secondary_1( ).
    object->read_secondary_2( ).
    object->read_secondary_3( ).


    out->write( 'Done' ).


  ENDMETHOD.
ENDCLASS.

