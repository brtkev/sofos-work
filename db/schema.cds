namespace sap.petition;
using { managed, cuid } from '@sap/cds/common';

type Set {
    name  : String(100);
    count : Integer
}

entity Petitions : managed, cuid {
    title         : String(100);
    description   : String;
    department    : Association to Departments;
    materials     : many Set
}

entity Departments : cuid {
    name : String(100);
}

entity Orders : managed, cuid {
    title       : String(100);
    material    : Set;
}