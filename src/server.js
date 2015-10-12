require('babel/register');
var express = require('express');
var config = require('./config')
var React = require('react');
var ReactApp = React.createFactory(require('./components/App.jsx'));
var ReactDOMServer = require('react-dom/server');
var db = require('./db');

var app = express();
app.set('view engine', 'jade');
app.set('views', __dirname + '/views');

app.use('/api/timesheet', require('./api/timesheet'));


app.get('/', function(req, res) {
    db.grabTimeSheetList('keithy', (rows) => {
        var reactHtml = ReactDOMServer.renderToString(ReactApp({timesheets: rows}));
        res.render('index.jade', {reactOutput: reactHtml});
    })
});


app.post('/punch/in', (req, res, next) => {
    var body = req.body;
    console.log(body);
    // Add to DB.
});

app.listen(config.port);
console.log('Server started at port ' + config.port);
