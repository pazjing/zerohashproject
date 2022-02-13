#!/bin/bash
echo "Hello World"

response=$(curl -s http://localhost:3000/EUR)
echo "$response"

echo "$response" | python -m json.tool
RET=$?

if [ $RET -gt 0 ]; then
  echo "Error in response son object parsed"
  exit 1
fi

returncode=$(curl http://localhost:3000/BAD -o /dev/null -s -w '%{http_code}\n')
echo "$returncode"

if [ "$returncode" != "200" ]; then
  echo "Error $returncode, currency does not exist"
  exit 1
fi




