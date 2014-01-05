#!/usr/bin/php
<?php
   $FichierMeteo = "/home/pi/EcranLed/data/meteo.txt";
 

$url = "http://api.worldweatheronline.com/free/v1/weather.ashx?q=Gien&format=xml&extra=localObsTime&num_of_days=1&key=jcjx8e5r5h97khnps9m8mrsn";
$xml = simplexml_load_file($url);
$temp_C = $xml->current_condition->temp_C;
$humidity = $xml->current_condition->humidity;
$windspeedKmph = $xml->current_condition->windspeedKmph;
$url_icon = $xml->current_condition->weatherIconUrl;

$File = fopen($FichierMeteo,"w");
fputs($File, sprintf("Temperature=%u\n", $temp_C));
fputs($File, sprintf("Humidite=%u\n", $humidity));
fputs($File, sprintf("VitesseVent=%u\n", $windspeedKmph));
fclose($File);

file_put_contents("/home/pi/EcranLed/data/meteo_icon.png", fopen($url_icon, 'r'))
?>
