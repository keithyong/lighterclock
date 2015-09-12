var express = require("express");
var app = express();

var router = express.Router();

router.post('/punch/in', (req, res, next) => {
    var body = req.body;
    // Add to DB.
};
