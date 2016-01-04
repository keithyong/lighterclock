require('babel-register');
var express = require('express');
var config = require('./config')
var React = require('react');
// var ReactApp = React.createFactory(require('./components/App.jsx'));
// var ReactDOMServer = require('react-dom/server');
var db = require('./db');

var app = express();
app.set('view engine', 'jade');
app.set('views', __dirname + '/views');

app.use('/api/timesheet', require('./api/timesheet'));
app.use('/api/clock', require('./api/clock'));

// Server Side render
// app.get('/', function(req, res) {
//     db.grabTimeSheetList('keithy', (rows) => {
//         var reactHtml = ReactDOMServer.renderToString(ReactApp({timesheets: rows}));
//         res.render('index.jade', {reactOutput: reactHtml});
//     })
// });

app.get('/', function(req, res) {
    res.render('index.jade');
});



app.listen(config.port);
console.log('Server started at port ' + config.port);
