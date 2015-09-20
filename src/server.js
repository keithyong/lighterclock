var express = require("express");
var app = express();

var router = express.Router();

router.get('/', (req, res, next) => {

});
router.post('/punch/in', (req, res, next) => {
    var body = req.body;
    console.log(body);
    // Add to DB.
};
