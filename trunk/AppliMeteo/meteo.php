#!/usr/bin/php
<?php
   $FichierMeteo = "/home/pi/EcranLed/data/meteo.txt";
 

$url = "http://api.openweathermap.org/data/2.5/weather?q=Gien&mode=xml&units=metric";
$xml = simplexml_load_file($url);
$temp_C = $xml->temperature['value'];
$humidity = $xml->humidity['value'];
$windspeedKmph = $xml->wind->speed['value'] * 3.6;
echo $windspeedKmph;
//$url_icon = $xml->current_condition->weatherIconUrl;

// $File = fopen($FichierMeteo,"w");
// fputs($File, sprintf("Temperature=%u\n", $temp_C));
// fputs($File, sprintf("Humidite=%u\n", $humidity));
// fputs($File, sprintf("VitesseVent=%u\n", $windspeedKmph));
// fclose($File);

//file_put_contents("/home/pi/EcranLed/data/meteo_icon.png", fopen($url_icon, 'r'))
?>
