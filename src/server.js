var express = require('express');
var config = require('./config')
var app = express();

var router = express.Router();

app.use('/timesheet', require('./routes/timesheet'));
router.get('/', (req, res, next) => {

});

router.post('/punch/in', (req, res, next) => {
    var body = req.body;
    console.log(body);
    // Add to DB.
});

app.listen(config.port);
