require('babel/register');
var express = require('express');
var config = require('./config')
var React = require('react');
var ReactApp = React.createFactory(require('./components/App.jsx'));
var ReactDOMServer = require('react-dom/server');

var app = express();
app.set('view engine', 'jade');
app.set('views', __dirname + '/views');

app.use('/api/timesheet', require('./api/timesheet'));

app.get('/', function(req, res) {
    var reactHtml = ReactDOMServer.renderToString(ReactApp({}));
    res.render('index.jade', {reactOutput: reactHtml});
});


app.post('/punch/in', (req, res, next) => {
    var body = req.body;
    console.log(body);
    // Add to DB.
});

app.listen(config.port);
