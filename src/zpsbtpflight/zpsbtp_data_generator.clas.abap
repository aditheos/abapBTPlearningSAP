class ZPSBTP_DATA_GENERATOR definition
  public
  final
  create public .

public section.

  interfaces IF_OO_ADT_CLASSRUN .
protected section.
private section.
ENDCLASS.



CLASS ZPSBTP_DATA_GENERATOR IMPLEMENTATION.


METHOD IF_OO_ADT_CLASSRUN~MAIN.
    INSERT ('zpsbtptrav') FROM (
        SELECT
          FROM /dmo/travel
          FIELDS
            uuid(  )      AS travel_uuid           ,
            travel_id     AS travel_id             ,
            agency_id     AS agency_id             ,
            customer_id   AS customer_id           ,
            begin_date    AS begin_date            ,
            end_date      AS end_date              ,
            booking_fee   AS booking_fee           ,
            total_price   AS total_price           ,
            currency_code AS currency_code         ,
            description   AS description           ,
            CASE status
              WHEN 'B' THEN 'A'   " accepted
              WHEN 'X' THEN 'X'   " cancelled
              ELSE 'O'            " open
            END           AS overall_status        ,
            createdby     AS created_by            ,
            createdat     AS created_at            ,
            lastchangedby AS last_changed_by       ,
            lastchangedat AS last_changed_at       ,
            lastchangedat AS local_last_changed_at
            ORDER BY travel_id
      ).
    COMMIT WORK.

    " define FROM clause dynamically
    DATA: dyn_table_name TYPE string.
    dyn_table_name = | /dmo/booking    AS booking  |
                 && | JOIN  { 'zpsbtptrav' } AS z |
                 && | ON   booking~travel_id = z~travel_id |.

    " insert booking demo data
    INSERT ('zpsbtpbook') FROM (
        SELECT
          FROM (dyn_table_name)
          FIELDS
            uuid( )                 AS booking_uuid          ,
            z~travel_uuid           AS travel_uuid           ,
            booking~booking_id      AS booking_id            ,
            booking~booking_date    AS booking_date          ,
            booking~customer_id     AS customer_id           ,
            booking~carrier_id      AS carrier_id            ,
            booking~connection_id   AS connection_id         ,
            booking~flight_date     AS flight_date           ,
            booking~flight_price    AS flight_price          ,
            booking~currency_code   AS currency_code         ,
            z~created_by            AS created_by            ,
            z~last_changed_by       AS last_changed_by       ,
            z~last_changed_at       AS local_last_changed_by
      ).
    COMMIT WORK.

*   We overwrite the existing airlines with ours
    UPDATE ('zpsbtpbook') SET carrier_id = 'SW' WHERE carrier_id NOT IN ( 'AA', 'AZ', 'LH', 'JL' ).
    UPDATE ('zpsbtpbook') SET carrier_id = 'GA' WHERE carrier_id = 'AA'.
    UPDATE ('zpsbtpbook') SET carrier_id = 'FA' WHERE carrier_id = 'AZ'.
    UPDATE ('zpsbtpbook') SET carrier_id = 'EA' WHERE carrier_id = 'LH'.
    UPDATE ('zpsbtpbook') SET carrier_id = 'OC' WHERE carrier_id = 'JL'.
    COMMIT WORK.

    " Travel Status Texts
    TYPES: BEGIN OF t_status_fields,
             client             TYPE mandt,
             travel_status_id   TYPE /dmo/overall_status,
             travel_status_text TYPE /dmo/description,
           END OF t_status_fields.
    TYPES: tt_status TYPE STANDARD TABLE OF t_status_fields WITH KEY travel_status_id.

    DATA status_itab TYPE tt_status.

    status_itab = VALUE tt_status(
      ( travel_status_id = 'O' travel_status_text = 'Open' )
      ( travel_status_id = 'A' travel_status_text = 'Accepted' )
      ( travel_status_id = 'X' travel_status_text = 'Rejected' )
    ).
*   insert the new table entries
    INSERT ('zpsbtpstat') FROM TABLE @status_itab.
    COMMIT WORK.


    " Carrier
    TYPES: BEGIN OF t_carrier_fields,
             client          TYPE mandt,
             carrier_id      TYPE /dmo/carrier_id,
             name            TYPE /dmo/carrier_name,
             carrier_pic_url TYPE c length 255,
             currency_code   TYPE /dmo/currency_code,
           END OF t_carrier_fields.
    TYPES: tt_carrier TYPE STANDARD TABLE OF t_carrier_fields WITH KEY carrier_id.

    DATA carrier_itab TYPE tt_carrier.

*   Carrier tab entries
    carrier_itab = VALUE tt_carrier(
      ( carrier_id = 'GA' name = 'Green Albatros' carrier_pic_url = 'https://raw.githubusercontent.com/SAP-samples/fiori-elements-opensap/main/week1/images/airlines/Green-Albatross-logo.png' currency_code = 'EUR')
      ( carrier_id = 'FA' name = 'Fly Africa' carrier_pic_url = 'https://raw.githubusercontent.com/SAP-samples/fiori-elements-opensap/main/week1/images/airlines/Fly-Africa-logo.png' currency_code = 'EUR')
      ( carrier_id = 'EA' name = 'European Airlines' carrier_pic_url = 'https://raw.githubusercontent.com/SAP-samples/fiori-elements-opensap/main/week1/images/airlines/European-Airlines-logo.png' currency_code = 'EUR')
      ( carrier_id = 'OC' name = 'Oceania' carrier_pic_url = 'https://raw.githubusercontent.com/SAP-samples/fiori-elements-opensap/main/week1/images/airlines/Oceania-logo.png' currency_code = 'EUR')
      ( carrier_id = 'SW' name = 'Sunset Wings' carrier_pic_url = 'https://raw.githubusercontent.com/SAP-samples/fiori-elements-opensap/main/week1/images/airlines/Sunset-Wings-logo.png' currency_code = 'EUR')
    ).

*   insert the new table entries
    INSERT ('zpsbtpcarr') FROM TABLE @carrier_itab.
    COMMIT WORK.

    " insert connection demo data
    INSERT ('zpsbtpconn') FROM (
        SELECT
          FROM /dmo/connection
          FIELDS
            carrier_id,
            connection_id,
            airport_from_id,
            airport_to_id,
            departure_time,
            arrival_time,
            CAST( distance AS dec( 12, 2 ) ),
            distance_unit
    ).
    COMMIT WORK.

*   We overwrite the existing airlines with ours
    UPDATE ('zpsbtpconn') SET carrier_id = 'SW' WHERE carrier_id NOT IN ( 'AA', 'AZ', 'LH', 'JL' ).
    UPDATE ('zpsbtpconn') SET carrier_id = 'GA' WHERE carrier_id = 'AA'.
    UPDATE ('zpsbtpconn') SET carrier_id = 'FA' WHERE carrier_id = 'AZ'.
    UPDATE ('zpsbtpconn') SET carrier_id = 'EA' WHERE carrier_id = 'LH'.
    UPDATE ('zpsbtpconn') SET carrier_id = 'OC' WHERE carrier_id = 'JL'.
    COMMIT WORK.

    " insert flight demo data
    INSERT ('zpsbtpflight') FROM (
      SELECT FROM /dmo/flight FIELDS
        " client
        carrier_id,
        connection_id,
        flight_date,
        price,
        currency_code,
        plane_type_id,
        seats_max,
        seats_occupied
    ).
    COMMIT WORK.

*   We overwrite the existing airlines with ours
    UPDATE ('zpsbtpflight') SET carrier_id = 'SW' WHERE carrier_id NOT IN ( 'AA', 'AZ', 'LH', 'JL' ).
    UPDATE ('zpsbtpflight') SET carrier_id = 'GA' WHERE carrier_id = 'AA'.
    UPDATE ('zpsbtpflight') SET carrier_id = 'FA' WHERE carrier_id = 'AZ'.
    UPDATE ('zpsbtpflight') SET carrier_id = 'EA' WHERE carrier_id = 'LH'.
    UPDATE ('zpsbtpflight') SET carrier_id = 'OC' WHERE carrier_id = 'JL'.
    COMMIT WORK.

*   For simplicity reasons we only use one currency (EUR)
    UPDATE ('zpsbtpbook') SET flight_price = division( flight_price, 130, 2 )  where currency_code = 'JPY'.
    UPDATE ('zpsbtptrav') SET booking_fee = division( booking_fee, 130, 2 )  where currency_code = 'JPY'.
    UPDATE ('zpsbtptrav') SET total_price = division( total_price, 130, 2 )  where currency_code = 'JPY'.
    UPDATE ('zpsbtpbook') SET flight_price = division( flight_price, 2, 2 )  where currency_code = 'SGD'.
    UPDATE ('zpsbtptrav') SET booking_fee = division( booking_fee, 2, 2 )  where currency_code = 'SGD'.
    UPDATE ('zpsbtptrav') SET total_price = division( total_price, 2, 2 )  where currency_code = 'SGD'.
    UPDATE ('zpsbtptrav') SET currency_code = 'EUR'.
    UPDATE ('zpsbtpbook') SET currency_code = 'EUR'.
ENDMETHOD.
ENDCLASS.
