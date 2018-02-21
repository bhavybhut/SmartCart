<?php
$ProductId= 0;
$ProductId= !empty($_GET['ProductId']) ? $_GET['ProductId'] : '100';
$host = "localhost"; // replace with your hostname
$username = "root"; // replace with your username
$password = ""; // replace with your password
$db_name = "cartdb"; // replace with your database
$con = mysql_connect ( "$host", "$username", "$password" ) or die ( "cannot connect" );
mysql_select_db ( "$db_name" ) or die ( "cannot select DB" );
$sql = "SELECT u.itemnumber as productId, d.itemname as productName, u.price as MRP, d.discount as discount, ROUND(u.price-((u.price * d.discount)/100)) as discountedPrice FROM usercart u INNER JOIN discount d ON u.itemnumber = d.itemnumber where u.itemnumber = ".$ProductId; // replace with your table name
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