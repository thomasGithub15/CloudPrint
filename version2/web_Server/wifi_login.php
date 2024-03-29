<!DOCTYPE html>
<!--
FILE_DETAILS
    Description: This page connects the Pi to wifi and runs a script to set 
    up the Google CUPS connector. Return to AP mode if falied.
FILE_DETAILS
-->
<html>
<head>
	<title>Plugable Cloud Print</title>
	<link rel="stylesheet" type="text/css" href="style.css" />
</head>
<body>
        <div id="header">
                <h1>Plugable Cloud Print Device</h1>
        </div>

        <div id="nav">
        	<p><a href="verified.html">Home</a></p>
            <p><a href="testPrinter.html">Step 1: Add and Test Printer</a></p>
			<p><a href="formPage.html">Step 2: Device Setup</a></p>
        </div>
        <div id="section">
            <h2>Configuring device and printing confirmation page shortly...</h2>
			<p></p>
			<h4>Helpful links:</h4>
			<p><a href="http:\/\/www.google.com/device">Website</a> for entering eight-letter code.</p>
			<p><a href="http:\/\/www.google.com/cloudprint">Website</a> to see your list of Google cloud printers.</p>
<?php
	# extract all the parameters
	$name = $_POST["name"];
	$password = $_POST["password"];
	$email = $_POST["email"];
	$proxy = $_POST["proxy"];

	# excute the bash file to connect to wireless network
	$output = shell_exec("sudo /home/pi/Pi_Setup/client_Setup/wifi_login.sh $name $password");
	$client = shell_exec("sudo /home/pi/Pi_Setup/client_Setup/switchToWlanClient.sh");
	sleep(5);

	# check wifi connection
	$connection = shell_exec("sudo /home/pi/Pi_Setup/client_Setup/checkWifi.sh $name");
	# if the connection is failed, switch to Access Point
	if($connection && $connection == 0) {
		$ap = shell_exec("sudo /home/pi/Pi_Setup/AP_Setup/toRouter.sh");
		$print = shell_exec("sudo /home/pi/Pi_Setup/cloudprint_Setup/printFail.sh");
	} else {
		$code = shell_exec("sudo /home/pi/Pi_Setup/cloudprint_Setup/connector.sh $email $proxy");
	}
?>
        </div>

        <div id="footer">
                Designed By EE498 Plugable Team
        </div>

</body>
</html>
