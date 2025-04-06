@Metadata.allowExtensions: true
@Search.searchable: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_PSBTP_T_GROCERY
  provider contract transactional_query
  as projection on ZR_PSBTP_T_GROCERY
{
  key Id,
  @Search.defaultSearchElement: true
  Product,
  @Search.defaultSearchElement: true
  Category,
  @Search.defaultSearchElement: true
  Brand,
  Price,
  @Semantics.currencyCode: true
  Currency,
  Quantity,
  Purchasedate,
  @Search.defaultSearchElement: true
  Expirationdate,
  @Search.defaultSearchElement: true
  Expired,
  @Search.defaultSearchElement: true
  Rating,
  Note,
  Createdby,
  Createdat,
  Lastchangedby,
  Lastchangedat,
  Locallastchanged
  
}
