@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_PSBTPACONN000
  provider contract transactional_query
  as projection on ZR_PSBTPACONN000
{
  key Uuid,
  CarrierId,
  ConnectionId,
  AirportFromId,
  CityFrom,
  CountryFrom,
  AirportToId,
  CityTo,
  CountryTo,
  DepartureTime,
  ArrivalTime,
  Distance,
  @Semantics.unitOfMeasure: true
  DistanceUnit,
  Createdby,
  Createdat,
  Lastchangedby,
  Lastchangedat,
  Locallastchanged
  
}
