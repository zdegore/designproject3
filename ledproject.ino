//Junior Design Project #3 
//Led control based on bluetooth
//adapted and tuturials follow for FASTled and arduino bleuart
//headers for bluetooth and LED
#include <bluefruit.h>
#include <FastLED.h>

//define values for LEDS
#define NUMLEDS 150
#define DATAPIN 27
CRGB leds[NUMLEDS];
CRGBPalette16 currentPalette;
TBlendType    currentBlending;

//bluetooth defined values
#define MANUFACTURER_ID   0x004C
uint8_t beaconUuid[16] =
{
  0x01, 0x12, 0x23, 0x34, 0x45, 0x56, 0x67, 0x78,
  0x89, 0x9a, 0xab, 0xbc, 0xcd, 0xde, 0xef, 0xf0
};

//set the beacon based on the set values above
BLEBeacon beacon(beaconUuid, 0x0102, 0x0304, -54);
BLEUart bleuart;



void setup()
{
  //begin the serial and bluetooth connections
  Serial.begin(115200);
  Bluefruit.begin();

  //bluetooth connection setup commands
  Bluefruit.autoConnLed(false);
  Bluefruit.setTxPower(0);    
  beacon.setManufacturer(MANUFACTURER_ID);
  bleuart.begin();

  //begin advertising
  startAdv();
  Serial.println("Broadcasting beacon, open your beacon app to test");

  //LED setup 
  FastLED.addLeds<WS2812B, DATAPIN, GRB>(leds, NUMLEDS);
}

//bluetooth function for advertising availability
void startAdv(void)
{
  //set the beacon so that it can be picked up by other bluetooth capable devices
  Bluefruit.Advertising.setBeacon(beacon);
  Bluefruit.Advertising.addService(bleuart);
  Bluefruit.ScanResponse.addName();

  //if a device disconnects from the feather it will begin to transmit again for new connections
  //also set the broadcast intervals and timeout
  Bluefruit.Advertising.restartOnDisconnect(true);
  Bluefruit.Advertising.setInterval(320, 1600);    
  Bluefruit.Advertising.setFastTimeout(30);      
  Bluefruit.Advertising.start(0);                
}

//main code loop
void loop()
{
  
  // read in from bluetooth information
  //variables to hold info
  String inp;
  String temp;
  int count =0;
  int input[10]={0};

  //loop while info is being sent to the feather from bluetooth
  while ( bleuart.available() )
  {
    
    //gets the value sent through BT
    //intially in ASCII value shift by 48 to get the true value
    temp = (String) (bleuart.read()-48);

    //test code
    //Serial.println("test " + temp);
    
    //if the value is -16 or -38 it signifies that end of transmission or a space has been
    //encountered so append current number to current position
    if(temp == "-16" or temp == "-38")
    {
      //convert back from string to int 
      input[count] = inp.toInt();

      //Serial.println(input[count]);
      //reset variables for more info and increase count
      inp="";
      temp="";
      count ++;
    }

    //add number to the string 
    //digit by digit
    else
    {
      inp = inp + temp;
      //Serial.println(inp);
    }

    //reached end of transmission break out of loop
    if(temp == "-38")
    {
      break;
    }
    
  }

  //seperate values into variables from the input just read in 
  //this is the order the values would be sent from the swift app to ensure consistency
  int mode = input[0];
  int red = input[1];
  int green = input[2];
  int blue = input[3];
  int brightness = input[4];
  int speed = input[5];
  int smooth = input[6];
  int pattern = input[7];

  //testing
  Serial.println(mode);
  Serial.println(red);
  Serial.println(green);
  Serial.println(blue);
  Serial.println(brightness);
  FastLED.setBrightness(brightness);

  
  //loop while no new transmissions are detected to prevent from reading empty data 
  while(!bleuart.available())
  {
    //switch to a given mode based on the input
    switch(mode)
    {
      
      //solid color
      //uses mode, r,g,b, brightness
      case 0:
        //fill solid to set all leds to the given color and brightness
        fill_solid(leds, NUMLEDS, CRGB(red,green,blue));
        FastLED.setBrightness(brightness);
        //update the LEDS to show results
        FastLED.show();
        break;

      //color train
      //uses mode, brightness, speed, smooth, pattern
      case 1:
      {
        //used to shift the starting position so the lights "move" along the LED strip
        static uint8_t index = 0;
        index = index + 1; 

        //select the blending type based on input
        //linear appears smooth while noblend appears pixelated 
        if(smooth==1)
          currentBlending = LINEARBLEND;
        else
          currentBlending = NOBLEND;

        //select pattern based on input
        switch(pattern)
        {
          case 0:
          {
            currentPalette = RainbowColors_p;
            break;
          }
          case 1:
          {
            currentPalette = LavaColors_p;
            break;
          }
          case 2:
          {
            currentPalette = CloudColors_p;
            break;
          }
        }

        //fill leds based on selected values
        FillLEDS(index,brightness);
        //display changes
        FastLED.show();
        //delay for speed 
        FastLED.delay(200/speed);
        break;
      }
        
      

      //chase back and forth
      //uses mode, r,g,b if smooth 0, pattern, brightness, speed
      case 2:
        
        //hue is used to vary the color 
        static int hue = 0;

        //loop to set the values of LEDS
        for(int i=0; i<NUMLEDS; i++)
        {
          //check if user wants solid color or fade 
          if(pattern)
            leds[i] = CHSV(hue++, 255, 255);
          else
            leds[i] = CRGB(red, green, blue); 
          
          //update
          FastLED.show();

          //fade effect that dims the light after certain amount of time 
          //to create the chase effect 
          fade();

          //delay based on speed
          delay(200/speed);
        }

        //same as the first loop but in the opposite direction
        for(int i=NUMLEDS-1; i>=0; i--)
        {
          if(pattern)
            leds[i] = CHSV(hue++, 255, 255);
          else
            leds[i] = CRGB(red, green, blue);
          FastLED.show();
          fade();
          delay(200/speed);
        }
        break;

      //all fade color
      //uses mode, speed, brightness
      case 3:
        //fill all with the same color that transitions through all colors
        fill_solid(leds,NUMLEDS,CHSV(hue++,255,255));
        //update
        FastLED.show();
        //speed
        FastLED.delay(200/speed);
        break;
    }
  }
}

//fills leds with colors based on input and values
void FillLEDS(int index, int brightness)
{
  //set the color for each led 
  for(int i=0; i<NUMLEDS; i++)
  {
    //parameters for setting color values based on the palette/pattern
    leds[i] = ColorFromPalette(currentPalette, index, brightness, currentBlending);
    index+=3;
  }

}

//fade the color away as it moves on in time
void fade()
{
  for(int i=0; i<NUMLEDS; i++)
  {
    leds[i].nscale8(250);
  }
}

//bluetooth connection response functions
void connect_callback(void)
{
  Serial.println("Connected");
}
void disconnect_callback(uint8_t reason)
{
  (void) reason;

  Serial.println();
  Serial.println("Disconnected");
  Serial.println("Bluefruit will start advertising again");
}