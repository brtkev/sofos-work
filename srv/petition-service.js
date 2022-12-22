
module.exports = srv => {

    

    srv.on('userInfo', req => {
        let results = {};
        results.user = req.user.id;

        results.roles = {};
        results.roles.identified = req.user.is('identified-user')
        results.roles.authenticated = req.user.is('authenticated-user')
        results.roles.Employee = req.user.is('Employee');
        results.roles.Manager = req.user.is('Manager');

        return results
    })
}