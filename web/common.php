<?php

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$debug = false;
$appTitle = "OCAP";
$appDesc = "Operation Capture And Playback - Revived";
$appAuthor = "MisterGoodson (aka Goodson [3CB]), Development K.I.A. on Dec 16th, 2017";
$appUpdater = "Revived by TelluriumCrystal and Axodah on July 5th, 2020";
const VERSION = "0.5.0.1-beta";


function print_debug($var) {
	global $debug;
	if ($debug) {
		echo "<b>DEBUG: </b>";
		print_r($var);
		echo "<br/>";
	}
}
?>