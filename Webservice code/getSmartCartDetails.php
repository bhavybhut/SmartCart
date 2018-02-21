<?php
$cartid = 0;
$cartid= !empty($_GET['CartId']) ? $_GET['CartId'] : '100';
$host = "localhost"; // replace with your hostname
$username = "root"; // replace with your username
$password = ""; // replace with your password
$db_name = "cartdb"; // replace with your database
$con = mysql_connect ( "$host", "$username", "$password" ) or die ( "cannot connect" );
mysql_select_db ( "$db_name" ) or die ( "cannot select DB" );
$sql = "SELECT d.itemname as itemname, ROUND(u.price-((u.price * d.discount)/100)) as price, u.quantity as quantity FROM usercart u INNER JOIN discount d ON u.itemnumber = d.itemnumber where u.cartid=".$cartid; // replace with your table name
$result = mysql_query ( $sql );
$json = array ();
$count = 0;
if (mysql_num_rows ( $result )) {
	while ( $row = mysql_fetch_row ( $result ) ) {
		$count = $count + 1;
		$json ["item" . $count] = $row;
	}
}
mysql_close ( $con );
echo json_encode ( $json );
?>