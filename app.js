var express = require("express");
var app = express();
var request = require('request');

/* GET home page. */
app.get('/', function(req, res, next) {
    res.status(200).json({"message": "Home page response with 200 OK"});
  });

app.get('/health', function(req, res, next) {
    res.status(200).json({"message": "Application is running OK"});
  });

app.get('/:currency', async function (req, res) {
    reqCurrency = req.params.currency.toUpperCase();
    var currencyList = ["EUR","GBP","USD","JPY"];
    //res.setTimeout(600);

    if (currencyList.includes(reqCurrency)) {
      currencyApiUrl = 'https://api.coinbase.com/v2/prices/spot?currency=' + reqCurrency;
      console.log(currencyApiUrl);
      request.get(
        currencyApiUrl,
        function (error, response, body) {
            if (!error && response.statusCode == 200) {
                console.log(body);
                const response = body;
                res.status(200).json(response);
                //res.send(response);
            }
        }
      );
    } 
    else {
        res.status(400).json({"error": "Currently, only support EUR, GBP, USD, JPY currencies"});
    }
})

app.listen(3000, () => {
 console.log("Server running on port 3000");
});