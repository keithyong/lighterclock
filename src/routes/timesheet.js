var express = require('express');
var router = express.Router();

router.get('/', (req, res, next) => {
    res.send('welcome to timesheet')
});

module.exports = router;
