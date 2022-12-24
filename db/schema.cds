namespace sap.petition;
using { managed, cuid } from '@sap/cds/common';

type Set {
    name  : String(100) not null;
    count : Integer not null;
}

entity Petitions : managed, cuid  {
    title         : String(100) not null;
    description   : String not null;
    department    : Association to Departments not null;
    materials     : many Set not null;
}


entity Departments : cuid {
    name : String(100) not null;
}

entity Orders : managed, cuid {
    title       : String(100) not null;
    material    : Set not null;
}