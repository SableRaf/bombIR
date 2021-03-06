
//-----------------------------------------------------------------------------------------
/*
 * bombIR
 * ---------------------------------------------------------------------------
 * Graffiti Research Lab Germany
 * http://www.graffitiresearchlab.de
 * ----------------------------------------------------------------------------
 * License:
 * Licensed according to the 
 * Attribution-Non-Commercial-Repurcussions 3.0 Unported (CC BY-NC 3.0)
 * as per http://www.graffitiresearchlab.fr/?portfolio=attribution-noncommercial-repercussions-3-0-unported-cc-by-nc-3-0
 * 
 * ----------------------------------------------------------------------------
 * Credits
 * _______
 * 
 * Programming:  
 *   Jesse Scott
 *   Hauke Altmann
 *   Raphael de Courville
 * 
 * Libraries:
 *  keystone
 * ----------------------------------------------------------------------------
 */
//-----------------------------------------------------------------------------------------

/*
TO DO 
- saving of keystone configurations not working (yet)
- IRCam calibration
- Menu positioning and sizing
  
*/

// IMPORTS
//-----------------------------------------------------------------------------------------
import deadpixel.keystone.*;
import controlP5.*;
import io.thp.psmove.*;
import java.util.Properties;
import codeanticode.gsvideo.*;
//import monclubelec.javacvPro.*; 
import blobDetection.*;


  
// DECLARATIONS
//-----------------------------------------------------------------------------------------  
Keystone ks;
CornerPinSurface surface, paintbg;
PGraphics wallscreen, paintscreen, paintbackground;
GSCapture cam;
BlobDetection bd;


// GLOBAL VARIABLES
//-----------------------------------------------------------------------------------------
boolean clicked = false;
boolean calibrateKeystone = false;

//-----------------------------------------------------------------------------------------

public void init() {
  // remove the window frame
  frame.removeNotify(); 
  frame.setUndecorated(true);
  frame.addNotify();
  super.init();
}

//-----------------------------------------------------------------------------------------
  
  void setup() {
        
        //read the values from the configuration file
        readConfiguration();
        
        //P3D or OPENGL seems to only work with one window (https://forum.processing.org/topic/opengl-rendering-multiple-windows-frames), 
        //so we make it big enough to span over all three output devices (Laptop, rp screen projector, wall projector)
  	size(windowWidth, windowHeight, P3D);
        
        //create painting screen
        paintscreen = createGraphics(windowWidth/2, windowHeight, P3D);
        paintscreen.background(255,255,255,0);
        
        //setup opencv & video capture
        setupCamera();
        
        //setup wall screen
	setupKeystone(); 
                
        //setup the spraypaint shader
        setupSpraypaint();
        
        //setup the control menu (colorpicker, clear screen, save, etc.)
        setupMenu();
        
        // setup the menu for the calibration screen
        setupCalibrationMenu();
        
        //Init the PSMove controller
        psmoveInit();
		
        //put the upper left corner of the frame to the upper left corner of the screen
        //needs to be the last call on setup to work
	frame.setLocation(0,0);

  } // end SETUP
  
  //-----------------------------------------------------------------------------------------
  
  void draw() {
    
    // Calibration Stage
    if(calibrateCamera) {
      runCameraCalibration();
    }
    
    // Main Draw Loop
    else {
      
      PVector surfaceMouse = paintbg.getTransformedMouse();
      
      //draw background for painting screen on first frame
      if(frameCount == 1 ) {
        paintbg.render(paintbackground);
      }
     	
      //draw painting screen
      paintscreen.beginDraw();
        if(!menu.isVisible() && !calibMenu.isVisible() && calibrateKeystone == false) {
          spray();
        }
      paintscreen.endDraw();
      
      //draw wall screen
      wallscreen.beginDraw();
        //redraw the background of the wallscreen during calibration  
        //for the calibration view to work
        if(ks.isCalibrating()){
          wallscreen.background(0);
        }
        wallscreen.image(paintscreen,0,0); 
      wallscreen.endDraw();
      
      //redraw the main backgound for calibration and make sure
      //that the imagebackground is drawn as well
      if(ks.isCalibrating()){
        background(0);
        paintbg.render(paintbackground);
      }
    
      //draw painting area
      image(paintscreen,0,0);
          
      //render the wall screen
  	surface.render(wallscreen);
  
      // GUI
      if(menu.isVisible()){
        cp.render();
        pickColor();
      }
    
    } 
    
    // Playstation Move udptate
    psmoveUpdate();
    
    if(debug){
       println("Framerate: " + int(frameRate));
    }
    
  } // end DRAW

  
  

  
  
//-----------------------------------------------------------------------------------------

