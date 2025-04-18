@Metadata.allowExtensions: true
@EndUserText.label: 'Travel App (PSBTP)'
@AccessControl.authorizationCheck: #CHECK
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: false
define root view entity ZC_PSBTP_ATRAV
  provider contract transactional_query
  as projection on ZR_PSBTP_ATRAV
{
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.90 
  key TravelId,
  @Search.defaultSearchElement: true
  @ObjectModel.text.element: ['AgencyName']
  @Consumption.valueHelpDefinition: [{ entity : {name: '/DMO/I_Agency', element: 'AgencyID' }, useForValidation: true }]
  AgencyId,
  _Agency.Name              as AgencyName,
  
  @Search.defaultSearchElement: true
  @ObjectModel.text.element: ['CustomerName']
  @Consumption.valueHelpDefinition: [{ entity : {name: '/DMO/I_Customer', element: 'CustomerID'  }, useForValidation: true }]
  CustomerId,
  _Customer.LastName        as CustomerName,
  BeginDate,
  EndDate,
  BookingFee,
  TotalPrice,
  
  @Semantics.currencyCode: true
  @Consumption.valueHelpDefinition: [{ entity: {name: 'I_Currency', element: 'Currency' }, useForValidation: true }]
  CurrencyCode,
  Description,
  
  @Search.defaultSearchElement: true
  @ObjectModel.text.element: [ 'OverallStatusText' ]
  @Consumption.valueHelpDefinition: [{ entity:{ name: '/DMO/I_Overall_Status_VH', element: 'OverallStatus' }, useForValidation: true }]
  OverallStatus,
  _OverallStatus._Text.Text as OverallStatusText : localized,   
  Attachment,
  MimeType,
  FileName,
  CreatedBy,
  CreatedAt,
  LocalLastChangedBy,
  LocalLastChangedAt,
  LastChangedAt
  
}
