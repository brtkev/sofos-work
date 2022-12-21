using { sap.petition as my } from '../db/schema';


service PetitionService 
@(path: '/service')
@(requires: 'authenticated-user')
{
    entity Petition 
        @(restrict: [
            {
                grant: ['READ'], to: 'Manager'
            },
            {
                grant: ['WRITE'], to: 'Employee'
            }
        ])
        as projection on my.Petitions;

    entity Departments 
        @(restrict: [
                {
                    grant: ['READ'], to: 'Employee'
                },
                {
                    grant: ['WRITE'], to: 'Manager'
                }
            ])
        as projection on my.Departments;

    entity Orders 
        @(restrict: [
            {
                grant: ['READ', 'WRITE'], to: 'Manager'
            }
        ])
        as Projection on my.Orders;
}

// service BasicService{
//     entity Petition as projection on my.Petitions;
//     entity Departments as projection on my.Departments;
//     entity Orders as Projection on my.Orders;
// }

// service EmployeeService @(requires: 'Employee'){
//     @insertonly entity Petition as projection on my.Petitions;
//     @readonly entity Departments as projection on my.Departments;
// }

// service ManagerService @(requires: 'Manager'){
//     entity Petition as projection on my.Petitions;
//     entity Departments as projection on my.Departments;
//     entity Orders as Projection on my.Orders;
// }
