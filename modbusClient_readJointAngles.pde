

import ModbusRTU.*;
import de.re.easymodbus.exceptions.*;
import de.re.easymodbus.modbusclient.*;
import de.re.easymodbus.modbusclient.gui.*;
import de.re.easymodbus.server.*;
import de.re.easymodbus.server.gui.*;

int totalJoints = 6;
int jointAngleRads[] = new int[totalJoints];
float jointAngleDeg[] = new float[totalJoints];
int tcpPos[] = new int[3];
int mousePos[] = new int[2];


ModbusClient modbusClient;
String robotIP = "192.168.1.100";

void setup()
{
size(800,800);

  modbusClient = new ModbusClient(robotIP,502);
  connectClient();
}

void draw()
{

  if(modbusClient.isConnected())
  {
    readJoints();
    readTCP();
    sendMouse();
  }
  else
  {
    println("not connected");
    connectClient();
  }
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
  mousePos[0] = round(mouseX);
  mousePos[1] = round(mouseY);
  try
  {
    modbusClient.WriteMultipleRegisters(128, mousePos);
    
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

