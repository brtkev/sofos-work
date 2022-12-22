const cors  = require('cors');
const cds = require ('@sap/cds')

cds.on('bootstrap', async app => {
    app.use(cors())
})


module.exports = cds.server;