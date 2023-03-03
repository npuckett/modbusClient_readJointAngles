

//import ModbusRTU.*;
import de.re.easymodbus.exceptions.*;
import de.re.easymodbus.modbusclient.*;
//import de.re.easymodbus.modbusclient.gui.*;
//import de.re.easymodbus.server.*;
//import de.re.easymodbus.server.gui.*;

int totalJoints = 6;
int jointAngleRads[] = new int[totalJoints];
float jointAngleDeg[] = new float[totalJoints];
int tcpPos[] = new int[3];
int mousePos[] = new int[3];


ModbusClient modbusClient;
String robotIP = "192.168.1.100";

void setup()
{
size(400,400);

  modbusClient = new ModbusClient(robotIP,502);
  connectClient();
}

void draw()
{
background(0);
  if(modbusClient.isConnected())
  {
    //readJoints();
    //readTCP();
    sendMouse();
  }
  else
  {
    println("not connected");
    connectClient();
  }

//stroke(255);
//fill(255);
//line(width/2,0,width/2,height);

//textAlign(CENTER,CENTER);
//textSize(32);
//text("Waypoint1",width/4,height/2);
//text("Waypoint2",((width/4)*3),height/2);

// readRegister();
}
void readTCP()
{
  try
  {
 tcpPos = modbusClient.ReadInputRegisters(400, 3);
  printArray(tcpPos);

  }
  catch (Exception e)
  {
    println("NOPE!!");  
  }

}
void readJoints()
{
  try 
  {
  jointAngleRads = modbusClient.ReadInputRegisters(270, totalJoints);
     for(int i=0;i<jointAngleRads.length;i++)
     {
      jointAngleDeg[i]=degrees(jointAngleRads[i])/1000f; 
     }
     //printArray(jointAngleRads);
     //printArray(jointAngleDeg);  
  } catch (Exception e) 
  {
  println("NOPE!!");  
  }    
}
void sendMouse()
{
  mousePos[0] = round(map(mouseX,0,width,0,100));  //128
  mousePos[1] = round(mouseY);  //129
  mousePos[2] = round(width/2); //130
  println(mousePos[0]);
  try
  {
    modbusClient.WriteMultipleRegisters(135, mousePos);
    
  }
  catch (Exception e)
  {
    println("NOPE!!");  
  }
}
void connectClient()
{
  try
  {
    modbusClient.Connect();
    println("connected");
  }
  catch (Exception e)
  {
    println("NOPE!!");  
  }
}
