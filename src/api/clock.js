var express = require('express');
var router = express.Router();
var query = require('../query');
var db = require('../db');

const clock = (id, type, res) => {
    db.punch(id, type, (rows) => {
        if (rows) {
            res.status(200);
            res.send('Successful.');
        } else {
            res.status(401);
            res.send('Unsuccessful.');
        }
    });
};

router.post('/in/:timesheet_id', (req, res, next) => {
    clock(req.params.timesheet_id, 'in', res);
});

router.post('/out/:timesheet_id', (req, res, next) => {
    clock(req.params.timesheet_id, 'out', res);
});

module.exports = router;
