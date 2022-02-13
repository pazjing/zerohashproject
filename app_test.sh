#!/bin/bash

if [ -n "$1" ]; then
  PORT=$1
  echo "Port number is supplied, use $PORT"
else
  PORT="3000"
  echo "Port number is not supplied, use $PORT as default"
fi

URL="http://localhost:$PORT"

export IFS=";"
CURRENCIES="EUR;GBP;USD;JPY"

for CURRENCY in $CURRENCIES; do
  echo "####### Test on $CURRENCY"

  RESPONSE=$(curl $URL/$CURRENCY -s -w '\n%{http_code}\n')
  BODY=$(echo "$RESPONSE" | head -n 1)
  STATUS_CODE=$(echo "$RESPONSE" | tail -n 1)

  # Test if the currency is successfuly return
  if [ "$STATUS_CODE" != "200" ]; then
    echo "Error code $STATUS_CODE, currency does not exist"
    exit 1
  else
    echo "Return code $STATUS_CODE, currency exists"
  fi

  # Test if the return body is json format
  echo "$BODY" | python -m json.tool
  RET=$?
  if [ $RET -gt 0 ]; then
    echo "Error in parsing response json object."
    exit 1
  else
    echo "Retrun body is $BODY"
  fi
done

