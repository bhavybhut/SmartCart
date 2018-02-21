import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DataStore {

	public final String ITEM_KEY = "item";
	public final String PRICE_KEY = "price";
	public final Integer CARTID = 12345;
	
	int item = 0;
	int price = 0;
	
	public void processResponse(String response){
		int i = response.indexOf("?");
		int j = response.lastIndexOf(" ");
		String query = response.substring(i+1, j);
		if(query.contains("&")){
			for (String value : query.split("&")) {
				if(value.contains("=")){
					String pairs[] = value.split("=");
					if(pairs.length == 2){
						setValues(pairs[0],pairs[1]);
					}
				}
			}
		}
		
		insertValues(item, price);
	}
	
	public void setValues(String key, String value){
		if(ITEM_KEY.equals(key)){
			item = Integer.parseInt(value);
		}
		if(PRICE_KEY.equals(key)){
			price = Integer.parseInt(value);
		}
	}
	
	public void insertValues(int itemNumber, int itemPrice){
		//Connection con = getAWSTestConnection();
		Connection con = getLocalConnection();
		try {
			boolean isExist = checkItemExist(con, itemNumber);
			if(isExist){
				increaseQuantity(con, itemNumber);
			}else{
				insertNewItem(con, itemNumber, itemPrice);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	private void insertNewItem(Connection con, int itemNumber, int itemPrice) throws SQLException {
		String query = "insert into usercart (cartid, itemnumber, price, quantity) values (?, ?, ?, ?)";
		PreparedStatement preparedStmt = con.prepareStatement(query);
		preparedStmt.setInt(1, CARTID);
		preparedStmt.setInt(2, itemNumber);
		preparedStmt.setInt(3, itemPrice);
		preparedStmt.setInt(4, 1);
		preparedStmt.execute();
	}

	private void increaseQuantity(Connection con, int itemNumber) throws SQLException {
		Statement stmt = con.createStatement();
		String query = "UPDATE usercart SET quantity = quantity + 1 WHERE itemnumber = " + itemNumber + " and cartid = " + CARTID ;
		stmt.executeUpdate(query);
	}

	public boolean checkItemExist(Connection con, int itemNumber) throws SQLException{
		Statement stmt = con.createStatement();
		String query = "select count(*) from usercart where itemnumber = " + itemNumber + " and cartid = " + CARTID;
		ResultSet rs= stmt.executeQuery(query);
		while(rs.next()){
			int count= rs.getInt(1);
			if(count > 0){
				return true;
			}else{
				return false;
			}
		}
		return false;
	}
	
	public Connection getLocalConnection() {
		String url = "jdbc:mysql://127.0.0.1:3306/";
		String userName = "root";
		String password = "";
		String dbName = "cartdb";
		String driver = "com.mysql.jdbc.Driver";
		try {
			Connection connection = DriverManager.getConnection(url + dbName, userName, password);
			return connection;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
	}
	
	public Connection getAWSConnection() {
		String url = "jdbc:mysql://cartinstance.cfhnezpm5mzp.us-east-2.rds.amazonaws.com:3306/";
		String userName = "cartuser";
		String password = "cartpassword";
		String dbName = "cartdb";
		String driver = "com.mysql.jdbc.Driver";
		try {
			Connection connection = DriverManager.getConnection(url + dbName, userName, password);
			return connection;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
	}
	
	public Connection getAWSTestConnection() {
		String url = "jdbc:mysql://testinstance.cfhnezpm5mzp.us-east-2.rds.amazonaws.com:3306/";
		String userName = "testuser";
		String password = "testpassword";
		String dbName = "testdb";
		String driver = "com.mysql.jdbc.Driver";
		try {
			Connection connection = DriverManager.getConnection(url + dbName, userName, password);
			return connection;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
	}
}
