var express = require("express");
var app = express();
var request = require('request');
const apiMetrics = require('prometheus-api-metrics');
app.use(apiMetrics());

/* Home page */
app.get('/', function(req, res, next) {
    res.status(200).send("Home page. 200 OK")
});

/* GET health. */
app.get('/health', function(req, res, next) {
    res.status(200).json({"message": "Application is running OK"});
});

/* GET metics. */
app.get('/metrics', function (req, res) {
    res.set('Content-Type', prom.register.contentType);
    res.end(prom.register.metrics());
});

app.get('/favicon.ico', function (req, res) {
   res.status(204);
});

/* To support test json parse error */
app.get('/jsonerror', function(req, res, next) {
  res.status(200).send('{"data":{"base":"BTC","currency":"EUR","amount":"37530.49",}}');
});

app.get('/:currency', async function (req, res) {
    reqCurrency = req.params.currency.toUpperCase();

    // Add BAD for test scenario 
    var currencyList = ["EUR","GBP","USD","JPY", "BAD"];

    if (currencyList.includes(reqCurrency)) {
      currencyApiUrl = 'https://api.coinbase.com/v2/prices/spot?currency=' + reqCurrency;
      console.log(currencyApiUrl);
      request.get(
        currencyApiUrl,
        function (error, response, body) {
          if(!error) {
              console.log(response.statusCode);
              console.log(body);
              res.setHeader('Content-Type', 'application/json');
              res.status(response.statusCode);
              res.send(body);
          } else {
              res.json(error);
          }
        });
    } else {
        res.status(400).json({"error": "Currently, only support EUR, GBP, USD, JPY currencies"});
    }
});


app.listen(3000, () => {
 console.log("Server running on port 3000");
});
