var express = require("express");
var app = express();
var request = require('request');

app.get("/url", (req, res, next) => {
    res.json(["Tony","Lisa","Michael","Ginger","Food"]);
   });

/* GET home page. */
app.get('/', function(req, res, next) {
    res.send("Home page. 200 OK");
    res.status(200);
  });

app.get('/health', function(req, res, next) {
    res.send("Running fine. 200 OK");
    res.status(200);
  });

app.get('/:currency', async function (req, res) {
    reqCurrency = req.params.currency.toUpperCase();
    var currencyList = ["EUR","GBP","USD","JPY"];
  
    if (currencyList.includes(reqCurrency)) {
      currencyApiUrl = 'https://api.coinbase.com/v2/prices/spot?currency=' + reqCurrency
      request.get(
        currencyApiUrl,
        function (error, response, body) {
            if (!error && response.statusCode == 200) {
                console.log(body);
                const response = body;
                res.send(response);
            }
        }
      );
    } 
    else {
      var errorResponse = "Please only use EUR, GBP, USD, JPY for the current valid currency request.";
      res.status(404);
      res.send(errorResponse);
    }
})

app.listen(3000, () => {
 console.log("Server running on port 3000");
});