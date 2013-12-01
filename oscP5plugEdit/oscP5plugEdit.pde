/**
 * oscP5plug by andreas schlegel
 * example shows how to use the plug service with oscP5.
 * the concept of the plug service is, that you can
 * register methods in your sketch to which incoming 
 * osc messages will be forwareded automatically without 
 * having to parse them in the oscEvent method.
 * that a look at the example below to get an understanding
 * of how plug works.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import oscP5.*;
import netP5.*;
float pos = 0;
boolean switcher = true;
OscP5 oscP5;
NetAddress myRemoteLocation;
color col;

void setup() {
  size(1280,400);
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);
  
  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress("127.0.0.1",12000);
  
  /* osc plug service
   * osc messages with a specific address pattern can be automatically
   * forwarded to a specific method of an object. in this example 
   * a message with address pattern /test will be forwarded to a method
   * test(). below the method test takes 2 arguments - 2 ints. therefore each
   * message with address pattern /test and typetag ii will be forwarded to
   * the method test(int theA, int theB)
   */
  oscP5.plug(this,"recieve_curves","/curves");
  oscP5.plug(this,"recieve_bang","/bangs");
  oscP5.plug(this,"recieve_colors","/colors");

}

public void recieve_colors(int R, int G, int B) {
  println("### plug event method. received a message /curves.");
//  println(" 2 ints received: "+theA);  
    col = color(R,G,B);
}

public void recieve_curves(float theA) {
  println("### plug event method. received a message /curves.");
//  println(" 2 ints received: "+theA);  
    pos= theA;
}

public void recieve_bang() {
  println("### plug event method. received a message /bangs.");
//  println(" 2 ints received: "+theA);  
    switcher = !switcher;
}

void display(){
     if(switcher){
      ellipse(width/2, (height/2) + pos, 100,100);
    }else{
      rectMode(CENTER);
      rect(width/2, (height/2) + pos, 100,100);
    }
    

}

void draw() {
  noStroke();
  fill(255,20);
  rectMode(CORNER);
  rect(0,0,width,height);
  fill(col);
 
  display();

}


//void mousePressed() {
//  /* createan osc message with address pattern /test */
//  OscMessage myMessage = new OscMessage("/test");
//  
//  myMessage.add(123); /* add an int to the osc message */
//  myMessage.add(456); /* add a second int to the osc message */
//
//  /* send the message */
//  oscP5.send(myMessage, myRemoteLocation); 
//}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* with theOscMessage.isPlugged() you check if the osc message has already been
   * forwarded to a plugged method. if theOscMessage.isPlugged()==true, it has already 
   * been forwared to another method in your sketch. theOscMessage.isPlugged() can 
   * be used for double posting but is not required.
  */  
  if(theOscMessage.isPlugged()==false) {
  /* print the address pattern and the typetag of the received OscMessage */
  println("### received an osc message.");
  println("### addrpattern\t"+theOscMessage.addrPattern());
  println("### typetag\t"+theOscMessage.typetag());
  }
}
