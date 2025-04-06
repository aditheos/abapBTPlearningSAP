@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Employee (Entity)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zpsbtp_r_employee
  as select from zpsbtp_employee
{
  key employee_id             as EmployeeId,
      first_name              as FirstName,
      last_name               as LastName,
      brith_day               as BrithDay,
      entry_date              as EntryDate,
      department_id           as DepartmentId,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      annual_salary           as AnnualSalary,
      @EndUserText.label: 'Currency Key'
      currency_code           as CurrencyCode,
      component_to_be_changed as ComponentToBeChanged,
      created_by              as CreatedBy,
      created_at              as CreatedAt,
      local_last_changed_at   as LocalLastChangedAt,
      local_last_changed_by   as LocalLastChangedBy,
      last_changed_at         as LastChangedAt
}
