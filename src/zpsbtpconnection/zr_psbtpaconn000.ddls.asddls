@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_PSBTPACONN000
  as select from zpsbtpaconn as Connections
{
  key uuid as Uuid,
  carrier_id as CarrierId,
  connection_id as ConnectionId,
  @Consumption.valueHelpDefinition: [{  
    entity.name: '/DMO/I_Airport',
    entity.element: 'AirportID',
    useForValidation: true
  }]
  airport_from_id as AirportFromId,
  city_from as CityFrom,
  country_from as CountryFrom,
    @Consumption.valueHelpDefinition: [{  
    entity.name: '/DMO/I_Airport',
    entity.element: 'AirportID',
    useForValidation: true
  }]
  airport_to_id as AirportToId,
  city_to as CityTo,
  country_to as CountryTo,
  departure_time as DepartureTime,
  arrival_time as ArrivalTime,
  distance as Distance,
  @Consumption.valueHelpDefinition: [ {
    entity.name: 'I_UnitOfMeasureStdVH', 
    entity.element: 'UnitOfMeasure', 
    useForValidation: true
  } ]
  distance_unit as DistanceUnit,
  @Semantics.user.createdBy: true
  createdby as Createdby,
  createdat as Createdat,
  @Semantics.user.lastChangedBy: true
  lastchangedby as Lastchangedby,
  @Semantics.systemDateTime.lastChangedAt: true
  lastchangedat as Lastchangedat,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  locallastchanged as Locallastchanged
  
}
