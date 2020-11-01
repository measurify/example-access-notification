using std::vector;
using std::string;
#include <time.h>
#include <EdgeEngine_library.h>

 


clock_t pirCounter;
clock_t cycleCounter; // count execution cycle time
clock_t sleepTime;

 


//setting pir
uint8_t pirPin = 2;
sample* motion=NULL;
void detectedMotion();
bool state = false;
float tOn = 0;

 


//connection
const char* ssidWifi = "Infostrada-E7D04F_EXT";
const char* passWifi = "3CJRHNQMPG";

 

edgine* Edge;
connection* Connection; //Wrapper for the wifi connection
vector<sample*> samples;

 


/**
 * setup
 */
void setup() {
  Serial.begin(115200);
  //setup connection
  Connection = connection::getInstance();
  Connection->setupConnection(ssidWifi, passWifi);
  options opts;
  //login
  opts.username = "presence-username";
  opts.password =  "presence-password";
  //route
  opts.url = "http://students.atmosphere.tools";
  opts.ver = "v1";
  opts.login = "login";
  opts.devs = "devices";
  opts.scps = "scripts";
  opts.measurements = "measurements";
  opts.info= "info";
  opts.issues="issues";
  //Edgine identifiers
  opts.thing = "my-room";
  opts.device = "presence-detector";
  opts.id = "presence-detector";
  //initialize Edge engine
  Edge=edgine::getInstance();
  Edge->init(opts);
  //Interrupt sensor setup
  pinMode(pirPin, INPUT);
  

 

  
}

 

void loop() {
  cycleCounter=clock();

 detectMotion();

  if(motion != NULL){
    Edge->evaluate(samples);
    samples.clear();
    delete motion;
    motion=NULL;
    Serial.println("presenza avvistata");
  }
      


 

  cycleCounter=clock()-cycleCounter;// duration of the execution of the cycle
  Serial.println(digitalRead(pirPin));
  
  // subtract te execution time to the Sleep period if result is not negative
  ((float)cycleCounter/CLOCKS_PER_SEC) < Edge->getPeriod() ? sleepTime=(Edge->getPeriod()-(float)cycleCounter/CLOCKS_PER_SEC)*1000 : sleepTime=0;//delay in milliseconds
  

 

  delay(sleepTime);
}

 

void detectMotion(){
  
  if (digitalRead(pirPin) == HIGH) {
    if(!state){
      Serial.println("sensore attivato");
      state = true;
      tOn = millis();
      motion = new sample("presence");
      motion->startDate=Edge->Api->getActualDate();
      motion->endDate=motion->startDate;
      motion->value=1;
      samples.push_back(motion);
    }
  }
  else{
    if(state){
      state = false;
      tOn = (millis()- tOn)/1000;
      Serial.print("Durata sensore acceso: ");      //output
      Serial.print(tOn);
      Serial.println(" sec");
    }   
  }







  
  //detachInterrupt(digitalPinToInterrupt(pirPin)); //PIR sensor needs 2 seconds to take an image to compare to
 // pirCounter=clock();
  
  //Serial.print("presenza in data: ");
  //Serial.println(pirCounter);
}
