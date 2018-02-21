#include <SPI.h>
#include <WiFi.h>

char ssid[] = "Bhavy"; //  your network SSID (name)
char pass[] = "JackSparrow";    // your network password (use for WPA, or use as key for WEP)
int keyIndex = 0;            // your network key Index number (needed only for WEP)
int product[3] = {194, 213, 215};
int price[3] = {100, 120, 230};
int token[3] = {0, 0, 0};
int total;
int sum = 0;
int count = 0;
unsigned int sbuffer = 0;

int status = WL_IDLE_STATUS;
// if you don't want to use DNS (and reduce your sketch size)
// use the numeric IP instead of the name for the server:
IPAddress server(172,20,10,2); // numeric IP for Google (no DNS)
//char server[] = "www.google.com";    // name address for Google (using DNS)

// Initialize the Ethernet client library
// with the IP address and port of the server
// that you want to connect to (port 80 is default for HTTP):
WiFiClient client;

void setup() {
  //Initialize serial and wait for port to open:
  Serial.begin(9600);
  Serial1.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for Leonardo only
  }

  // check for the presence of the shield:
  if (WiFi.status() == WL_NO_SHIELD) {
    Serial.println("WiFi shield not present");
    // don't continue:
    while (true);
  }

  String fv = WiFi.firmwareVersion();
  if ( fv != "1.1.0" )
    Serial.println("Please upgrade the firmware");

  // attempt to connect to Wifi network:
  while (status != WL_CONNECTED) {
    Serial.print("Attempting to connect to SSID: ");
    Serial.println(ssid);
    // Connect to WPA/WPA2 network. Change this line if using open or WEP network:
    status = WiFi.begin(ssid, pass);

    // wait 10 seconds for connection:
    delay(10000);
  }
  Serial.println("Connected to wifi");
  printWifiStatus();
}

void loop() {
  readRfid();
}


void printWifiStatus() {
  // print the SSID of the network you're attached to:
  Serial.print("SSID: ");
  Serial.println(WiFi.SSID());

  // print your WiFi shield's IP address:
  IPAddress ip = WiFi.localIP();
  Serial.print("IP Address: ");
  Serial.println(ip);

  // print the received signal strength:
  long rssi = WiFi.RSSI();
  Serial.print("signal strength (RSSI):");
  Serial.print(rssi);
  Serial.println(" dBm");
}

void readRfid() {
  // if date is coming from software serial port ==> data is coming from SoftSerial shield
  if (Serial1.available())
  {
    while (Serial1.available())              // reading data into char array
    {
      delay(20);
      sbuffer = Serial1.read();      // writing data into array
      sum = sum + sbuffer;
      count++;
      if (count == 5) {
        serialFlush();
        clearBufferArray();
        break;
      }
    }
    for (int i = 0; i < 3; i++)
    {
      if (product[i] == sum)
      {
        if (token[i] == 0)
        {
          String output = "Item number ";
          output.concat(product[i]);
          output.concat(" with price ");
          output.concat(price[i]);
          output.concat(" is added to cart.");
          Serial.println(output);
          total = total + price[i];
          sendData(product[i], price[i]);
          getData();
          //token[i] = 1;      //Uncomment this to toggle add and remove
        }
        else
        {
          String output = "Item number ";
          output.concat(product[i]);
          output.concat(" with price ");
          output.concat(price[i]);
          output.concat(" is removed from cart.");
          Serial.println(output);
          total = total - price[i];
          token[i] = 0;
        }
        Serial.println("Cart total:");
        Serial.println(total);
        Serial.println("--------------------");
        break;
      }
    }
    sum = 0;
  }
}

void clearBufferArray()                 // function to clear buffer array
{
  sbuffer = 0;
  count = 0;
}

void serialFlush() {
  while (Serial1.available() > 0) {
    char t = Serial1.read();
  }
}

void sendData(int item, int price) {
  Serial.println("\nStarting connection to server...");
  // if you get a connection, report back via serial:
  if (client.connect(server, 80)) {
    Serial.println("connected to server");
    // Make a HTTP request:
    String request = "GET /smartcart?item=";
    request.concat(item);
    request.concat("&price=");
    request.concat(price);
    request.concat(" HTTP/1.1");
    //client.println("GET /search?q=arduino HTTP/1.1");
    client.println(request);
    Serial.println("Request->");
    Serial.println(request);
    //client.println("Host: www.google.com");
    //client.println("Connection: close");
    //client.println();
  }
  disconnectClient();
}

void getData() {
  // if there are incoming bytes available
  // from the server, read them and print them:
  Serial.println("client available?->");
  Serial.println(client.available());
  while (client.available()) {
    char c = client.read();
    Serial.write(c);
  }
}

void disconnectClient() {
  // if the server's disconnected, stop the client:
  //if (!client.connected()) {
    Serial.println();
    Serial.println("disconnecting from server.");
    client.stop();

    // do nothing forevermore:
    //while (true);
  //}
}

