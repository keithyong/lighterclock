var express = require('express');
var router = express.Router();
var query = require('../query');

router.get('/:username', (req, res, next) => {
    query('SELECT * FROM time_sheet WHERE username=\'' + req.params.username + '\'', (rows) => {
        res.send(rows);
    });
});

module.exports = router;
