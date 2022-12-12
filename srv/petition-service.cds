using { sap.petition as my } from '../db/schema';

@path: 'service/petitions'
service PetitionService {
    entity Petitions as projection on my.Petitions;
    entity Departments as projection on my.Departments;
    entity Orders as projection on my.Orders;
}