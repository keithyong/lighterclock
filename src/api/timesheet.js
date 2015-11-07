var express = require('express');
var router = express.Router();
var query = require('../query');
var db = require('../db');

router.get('/:username', (req, res, next) => {
    db.grabTimeSheetList(req.params.username, (rows) => {
        res.send(rows);
    });
});

router.get('/id/:timesheet_id', (req, res, next) => {
    db.grabTimeSheetInfo(req.params.timesheet_id, (rows) => {
        res.send(rows);
    });
});

module.exports = router;
