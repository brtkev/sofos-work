const cors  = require('cors');

const cds = require ('@sap/cds')
cds.on('bootstrap', app => app.use(cors()))
