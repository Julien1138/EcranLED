<?php
   $FichierMeteo = "config/Meteo.txt";
 

$url = "http://api.worldweatheronline.com/free/v1/weather.ashx?q=Gien&format=xml&extra=localObsTime&num_of_days=1&key=jcjx8e5r5h97khnps9m8mrsn";
$xml = simplexml_load_file($url);
$tempC = $xml->current_condition->temp_C;
$File = fopen($FichierMeteo,"w");

fputs($File, "[Météo]\n");
fputs($File, sprintf("Température=%u\n", $tempC));
fclose($File);
?>