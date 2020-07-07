<?php
include "common.php";
$dir = '..\\web\\data';

$filesInData = glob($dir . '\\*.json');
$ops = array();
foreach($filesInData as &$dataFileName){
	$string = file_get_contents($dataFileName);
	$fileData = json_decode($string, true);

	# Emulate old database structure as JSON
	$op_world_name = $fileData["worldName"] . ',';
	$op_mission_name = $fileData["missionName"] . ',';
	$op_mission_duration = $fileData["missionDuration"] . ',';
	$op_filename = $dataFileName . ',';
	$op_date = $fileData["missionDate"];
	$ops[] = $op_world_name . $op_mission_name . $op_mission_duration . $op_filename . $op_date;

}


?>
<!DOCTYPE html>
<html>
<head>
	<title><?php echo $appTitle; ?></title>
	<meta charset="utf-8"/>
	<meta name="viewport" content="initial-scale=1.0, user-scalable=no"/>
	<link rel="stylesheet" href="style/leaflet-1.0.0-rc1.css" />
	<link rel="stylesheet" href="style/common.css" />
	<link rel="stylesheet" href="style/index.css" />
	<link rel="icon" type="img/png" href="images/favicon.png">
	<script src="scripts/leaflet-1.0.0-rc1.js"></script>
	<script src="scripts/leaflet.rotatedMarker.js"></script>
	<script src="scripts/leaflet.svgIcon.js"></script>
	<script src="scripts/jquery.min.js"></script>
	<script src="scripts/ocap.js"></script>
</head>
<body>


<div id="container">
	<div id="map"></div>
	<div id="topPanel">
		<div id="ocapLogoButton"></div>
		<div id="loadOpButton" class="button"></div>
		<div id="aboutButton" class="bold button">i</div>
		<span id="toggleFirelines" class="button"></span>
		<span id="missionName" class="medium"></span>
	</div>
	<div id="leftPanel">
		<div class="title bold"><span>Units</span></div>
		<div class="filterBox"></div>
		<div class="panelContent">
			<ul id="listWest"><span class="blufor sideTitle">BLUFOR</span></ul>
			<ul id="listEast"><span class="opfor sideTitle">OPFOR</span></ul>
			<ul id="listGuer"><span class="ind sideTitle">INDEPENDENT</span></ul>
			<ul id="listCiv"><span class="civ sideTitle">CIVILIAN</span></ul>
		</div>
	</div>
	<div id="rightPanel">
		<div class="title bold">Events</div>
		<div class="filterBox">
			<div id="filterHitEventsButton" class="filterHit"></div>
			<input type="text" id="filterEventsInput" placeholder="Filter" />
		</div>
		<div class="panelContent">
			<ul id="eventList"></ul>
		</div>
	</div>
	<div class="extraInfoBox">
		<div class="extraInfoBoxContent">
			<span class="bold">Cursor target: </span><span id="cursorTargetBox">None</span>
		</div>
	</div>
	<div id="bottomPanel">
		<div class="panelContent">
			<div id="playPauseButton" onclick="playPause()">
			</div>
			<div id="timecodeContainer" class="medium">
				<span id="missionCurTime">0:00:00</span>
				<span>/</span>
				<span id="missionEndTime">0:00:00</span>
			</div>
			<div id="frameSliderContainer">
				<input type="range" id="frameSlider" min="0" value="0">
					<div id="eventTimeline"></div>
				</input>
			</div>
			<div id="playbackSpeedSliderContainer">
				<span id="playbackSpeedVal"></span>
				<input type="range" id="playbackSpeedSlider" />
			</div>
			<div class="fullscreenButton" onclick="goFullscreen()"></div>
		</div>
	</div>
</div>

<div id="modal" class="modal">
	<div class="modalContent">
		<div id="modalHeader" class="modalHeader medium">Header</div>
		<div id="modalBody" class="modalBody">Body</div>
		<div id="modalButtons" class="modalButtons"></div>
	</div>
</div>

<div id="hint" class="hint">Test popup</div>

<script>

let opList = <?php echo json_encode($ops); ?>;
let appVersion = <?php echo json_encode(VERSION); ?>;
let appTitle = <?php echo json_encode($appTitle); ?>;
let appDesc = <?php echo json_encode($appDesc); ?>;
let appAuthor = <?php echo json_encode($appAuthor); ?>;
let appUpdater = <?php echo json_encode($appUpdater); ?>;

initOCAP();
</script>
</body>
</html>
