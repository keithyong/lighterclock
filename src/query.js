var pg = require('pg');
var config = require('./config');

module.exports = (query, callback) => {
    var client = new pg.Client(config.postgres_url);
    client.connect((err) => {
        if (err) {
            return console.error('Could not connect to postgres', err);
        }

        client.query(query, (err, result) => {
            if (err) {
                return console.error('Error running time_sheet query', err);
            }

            callback(result.rows);
        });
    });
}
