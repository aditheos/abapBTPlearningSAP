CLASS zcl_btp_select DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_btp_select IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    out->write( '****************************************************************' ).
* Case
    SELECT FROM /dmo/customer
         FIELDS customer_id,
                title,
                CASE title
                  WHEN 'Mr.'  THEN 'Mister'
                  WHEN 'Mrs.' THEN 'Misses'
                  ELSE             ' '
               END AS title_long

        WHERE country_code = 'AT'
         INTO TABLE @DATA(result_simple).

    out->write(
      EXPORTING
        data   = result_simple
        name   = 'RESULT_SIMPLE_CASE'
    ).

**********************************************************************
    out->write( '****************************************************************' ).
    SELECT FROM /DMO/flight
         FIELDS flight_date,
                seats_max,
                seats_occupied,
                CASE
                  WHEN seats_occupied < seats_max THEN 'Seats Avaliable'
                  WHEN seats_occupied = seats_max THEN 'Fully Booked'
                  WHEN seats_occupied > seats_max THEN 'Overbooked!'
                  ELSE                                 'This is impossible'
                END AS Booking_State

          WHERE carrier_id    = 'LH'
            AND connection_id = '0400'
           INTO TABLE @DATA(result_complex).

    out->write(
      EXPORTING
        data   = result_complex
        name   = 'RESULT_COMPLEX_CASE'
    ).

* Cast
    out->write( '****************************************************************' ).
    SELECT FROM /dmo/carrier
         FIELDS '19891109'                           AS char_8,
                CAST( '19891109' AS CHAR( 4 ) )      AS char_4,
                CAST( '19891109' AS NUMC( 8  ) )     AS numc_8,

                CAST( '19891109' AS INT4 )          AS integer,
                CAST( '19891109' AS DEC( 10, 2 ) )  AS dec_10_2,
                CAST( '19891109' AS FLTP )          AS fltp,

                CAST( '19891109' AS DATS )          AS date

           INTO TABLE @DATA(result).

    out->write(
      EXPORTING
        data   = result
        name   = 'RESULT_CAST'
    ).

* Arithmetic
    out->write( '****************************************************************' ).
    SELECT
            FROM /dmo/flight
          FIELDS plane_type_id,
                 seats_max, seats_occupied,
                 seats_max - seats_occupied AS seats_free,
                 price, currency_code
           WHERE carrier_id    = 'SQ'
            INTO TABLE @DATA(result_sel_arth) .


    out->write(
      EXPORTING
        data   = result_sel_arth
        name   = 'RESULT_SELECT_ARITHMETIC'
    ).

* String Processing
    out->write( '****************************************************************' ).
    SELECT
         FROM /dmo/carrier
       FIELDS concat_with_space( carrier_id, name, 1 ) AS carrier_name, currency_code
        WHERE carrier_id = 'SQ'
        INTO TABLE @DATA(result_sel_concat).

    out->write(
      EXPORTING
        data   = result_sel_concat
        name   = 'RESULT_SELECT_CONCAT'
    ).

* Date Formatting
    out->write( '****************************************************************' ).
    SELECT FROM /dmo/travel
         FIELDS begin_date,
                end_date,
                is_valid( begin_date  )              AS valid,

                add_days( begin_date, 7 )            AS add_7_days,
                add_months(  begin_date, 3 )         AS add_3_months,
                days_between( begin_date, end_date ) AS duration,

                weekday(  begin_date  )              AS weekday,
                extract_month(  begin_date )         AS month,
                dayname(  begin_date )               AS day_name

          WHERE customer_id = '000001'
            AND days_between( begin_date, end_date ) > 10

           INTO TABLE @DATA(result_sel_date).

    out->write(
      EXPORTING
        data   = result_sel_date
        name   = 'RESULT_SELECT_DATE'
    ).

* Select Conversion
    out->write( '****************************************************************' ).
    SELECT FROM /dmo/travel
           FIELDS lastchangedat,
                  CAST( lastchangedat AS DEC( 15,0 ) ) AS latstchangedat_short,

                  tstmp_to_dats( tstmp = CAST( lastchangedat AS DEC( 15,0 ) ),
                                 tzone = CAST( 'EST' AS CHAR( 6 ) )
                               ) AS date_est,
                  tstmp_to_tims( tstmp = CAST( lastchangedat AS DEC( 15,0 ) ),
                                 tzone = CAST( 'EST' AS CHAR( 6 ) )
                               ) AS time_est

            WHERE customer_id = '000001'
             INTO TABLE @DATA(result_date_time).

    out->write(
      EXPORTING
        data   = result_date_time
        name   = 'RESULT_DATE_TIME'
    ).


*********************************************************************

*    DATA(today) = cl_abap_context_info=>get_system_date(  ).
*    out->write( '****************************************************************' ).
*    SELECT FROM /dmo/travel
*         FIELDS total_price,
*                currency_code,
*
*                currency_conversion( amount             = total_price,
*                                     source_currency    = currency_code,
*                                     target_currency    = 'EUR',
*                                     exchange_rate_date = @today
*                                   ) AS total_price_EUR
*
*          WHERE customer_id = '000001' AND currency_code <> 'EUR'
*           INTO TABLE @DATA(result_currency).
*
*    out->write(
*      EXPORTING
*        data   = result_currency
*        name   = 'RESULT__CURRENCY'
*    ).


**********************************************************************
    out->write( '****************************************************************' ).
    SELECT FROM /dmo/connection
         FIELDS distance,
                distance_unit,
                unit_conversion( quantity = CAST( distance AS QUAN ),
                                 source_unit = distance_unit,
                                 target_unit = CAST( 'MI' AS UNIT ) )  AS distance_MI

          WHERE airport_from_id = 'FRA'
           INTO TABLE @DATA(result_unit).

    out->write(
      EXPORTING
        data   = result_unit
        name   = 'RESULT_UNIT'
    ).

* Select Order By
    out->write( '****************************************************************' ).
    SELECT FROM /dmo/flight
         FIELDS carrier_id,
                connection_id,
                flight_date,
                seats_max - seats_occupied AS seats
          WHERE carrier_id     = 'AA'
            AND plane_type_id  = 'A320-200'
       ORDER BY seats_max - seats_occupied DESCENDING,
                flight_date                ASCENDING
           INTO TABLE @DATA(result_orderby).

    out->write(
      EXPORTING
        data   = result_orderby
        name   = 'RESULT_SELECT_ORDERBY'
    ).

* Select Distinct
    out->write( '****************************************************************' ).
    SELECT FROM /dmo/connection
       FIELDS
              DISTINCT
              airport_from_id,
              distance_unit

     ORDER BY airport_from_id
         INTO TABLE @DATA(result_distinct).

    out->write(
      EXPORTING
        data   = result_distinct
        name   = 'RESULT_SELECT_DISTINCT'
    ).

* Select Aggregate
    out->write( '****************************************************************' ).
    SELECT FROM /dmo/connection
         FIELDS carrier_id,
                connection_id,
                airport_from_id,
                distance
          WHERE carrier_id = 'LH'
           INTO TABLE @DATA(result_raw).


    out->write(
      EXPORTING
        data   = result_raw
        name   = 'RESULT_RAW'
    ).

*********************************************************************
    out->write( '****************************************************************' ).
    SELECT FROM /dmo/connection
         FIELDS
                carrier_id,connection_id,
                MAX( distance ) AS max,
                MIN( distance ) AS min,
                SUM( distance ) AS sum,
                AVG( distance ) AS average,
                COUNT( * ) AS count,
                COUNT( DISTINCT airport_from_id ) AS count_dist

          WHERE carrier_id = 'LH'
          GROUP BY carrier_id, connection_id
          ORDER BY carrier_id, connection_id ASCENDING
           INTO TABLE @DATA(result_aggregate).

    out->write(
      EXPORTING
        data   = result_aggregate
        name   = 'RESULT_AGGREGATED'
    ).

  ENDMETHOD.
ENDCLASS.
