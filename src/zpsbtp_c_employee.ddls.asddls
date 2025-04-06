@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Employee (Entity) Projection'
@Metadata.ignorePropagatedAnnotations: false
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zpsbtp_c_employee as select from zpsbtp_r_employee
{
    key EmployeeId,
    FirstName,
    LastName,
    BrithDay,
    EntryDate,
    DepartmentId,
    AnnualSalary,
    CurrencyCode,
    ComponentToBeChanged,
    CreatedBy,
    CreatedAt,
    LocalLastChangedAt,
    LocalLastChangedBy,
    LastChangedAt
}
