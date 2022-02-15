#!/bin/bash

mkdir -p gh-pages

cd gh-pages
helm package ../charts/*
helm repo index .
