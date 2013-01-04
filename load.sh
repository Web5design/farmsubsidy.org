#!/bin/bash

WD=`pwd`
DB="farmsubsidy_etl"
SQL="psql $DB"

$SQL -f schema.sql
$SQL -c "COPY country FROM '$WD/countries.csv' WITH CSV DELIMITER ',' QUOTE '\"' HEADER ENCODING 'Utf-8';"

for COUNTRY in "AT" "BE" "BG" "CY" "CZ" "DE" "DK" "EE" "ES" "FI" "GR" "HU" "IE" "IT" "LT" "LU" "LV" "MT" "NL" "PL" "PT" "RO" "SE" "SK" "SL"; do
  unzip -n -j -d $WD/$COUNTRY $COUNTRY.zip
  for FN in "payment.txt" "payment1.txt" "payment2.txt"; do
    if [ -f $COUNTRY/$FN ]; then
      $SQL -c "COPY payment FROM '$WD/$COUNTRY/$FN' WITH CSV DELIMITER ';' QUOTE '\"' HEADER ENCODING 'Utf-8';"
    fi
  done
  $SQL -c "COPY recipient FROM '$WD/$COUNTRY/recipient.txt' WITH CSV DELIMITER ';' QUOTE '\"' HEADER ENCODING 'Utf-8';"
  for FN in "scheme.txt" "schemes.txt"; do
    if [ -f $COUNTRY/$FN ]; then
      $SQL -c "COPY scheme FROM '$WD/$COUNTRY/$FN' WITH CSV DELIMITER ';' QUOTE '\"' HEADER ENCODING 'Utf-8';"
    fi
  done
done


unzip -n -d $WD FR.zip
unzip -n -d $WD GB.zip
$SQL -c "COPY payment FROM '$WD/FR/payment.csv' WITH CSV DELIMITER ';' QUOTE '\"' ENCODING 'Utf-8';"
$SQL -c "COPY recipient FROM '$WD/FR/recipient.csv' WITH CSV DELIMITER ';' QUOTE '\"' ENCODING 'Utf-8';"
$SQL -c "COPY scheme FROM '$WD/FR/scheme.csv' WITH CSV DELIMITER ';' QUOTE '\"' ENCODING 'Utf-8';"
$SQL -c "COPY payment FROM '$WD/GB/payment.csv' WITH CSV DELIMITER ';' QUOTE '\"' ENCODING 'Utf-8';"
$SQL -c "COPY recipient FROM '$WD/GB/recipient.csv' WITH CSV DELIMITER ';' QUOTE '\"' ENCODING 'Utf-8';"
$SQL -c "COPY scheme FROM '$WD/GB/scheme.csv' WITH CSV DELIMITER ';' QUOTE '\"' ENCODING 'Utf-8';"


# TODO: fix recupient.name
# TODO: fix scheme.GlobalSchemeId
# TODO: fix scheme.nameEnglish
# TODO: fix scheme.countryPayment
# TODO: fix recipient.countryRecipient
# TODO: fix payment.amountEuro
# TODO: fix payment.globalPaymentId
