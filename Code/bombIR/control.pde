
//-----------------------------------------------------------------------------------------
// MENU + GUI CONTROL

int saveCount = 0;

 void CLEAR(boolean theFlag) {
  if(theFlag == true) {
    paintscreen.beginDraw();
    paintscreen.clear();
    paintscreen.endDraw();
    
    wallscreen.beginDraw();
    wallscreen.clear();
    wallscreen.endDraw();
  }
 }

 // SAVE
 void SAVE(boolean theFlag) {
  if(theFlag == true) {
     saveCount ++;
     // save image w/o gui
     wallscreen.save("exports/Save_" + saveCount + ".jpg");
  }
 } 
 
 // CLEAR
 void CLEAR() {
   // ?? 
 }

 //adjust brush size
 void WIDTH(int BrushSize) {
    weight = (BrushSize);
 } 
 
 // Crop Scale
 void cropScale(float cs) {
     float w = paintscreen.width;
     float h = paintscreen.height;
     corner.tlX = int( w / 2.0 * cs );
     corner.tlY = int( h / 2.0 * cs );
     corner.trX = int( w - ( w  / 2.0 * cs ) );
     corner.trY = int( h / 2.0 * cs );
     corner.brX = int( w - ( w  / 2.0 * cs ) );
     corner.brY = int( h - ( h  / 2.0 * cs ) );
     corner.blX = int( w / 2.0 * cs );
     corner.blY = int( h - ( h  / 2.0 * cs ) );
 }

 // Show Blob
 void showBlob() {
   if(calibrateCamera) {
     showBlob =! showBlob;
   }
   if(!calibrateCamera) {
     showBlob =! showBlob;
     background(0);
     paintbg.render(paintbackground);
   }   
 }
 
 // Show Cam
 void showCam() {
   if(calibrateCamera) {
     showCam =! showCam;
   }
   if(!calibrateCamera) {
     showCam =! showCam;
     background(0);
     paintbg.render(paintbackground);
   }   
 }
 
 // Save Calibration
 void saveCalib() {
   if(calibrateCamera) {
     background(0);
     calibrateCamera = false; 
     showCam = false;
     showBlob = false;
     paintbg.render(paintbackground);
     calibMenu.hide();
   }
 }
 
 void keyPressed() {
   switch(key) {
     case 'r': 
       sprayCan.reset(); // clear the screen
     break;
     case 'c':
       if(!calibrateCamera) { 
         // enter/leave calibration mode, where surfaces can be warped and moved
         ks.toggleCalibration();
         calibrateKeystone = !calibrateKeystone;       
         //redraw background once after calibration
         background(0);
         paintbg.render(paintbackground);
       }
     break;
     case 'm': 
       if(!calibrateCamera) {   
         toggleMenu();
         paintbg.render(paintbackground);
       }
     break;
     case 'b':
       toggleBlobControl();
       if(calibrateCamera) {   
         background(0);
       }
       else {
         paintbg.render(paintbackground);
       }
     break;     
   }
 }
   
 //show or hide the menu
 void toggleMenu(){
   if(menu.isVisible()){
     menu.hide();
     background(0);
   }
   else {
     menu.show();
   }
 }
 
 //show or hide blob control
 void toggleBlobControl(){
   if(calibMenu.isVisible()){
     calibMenu.hide();
     background(0);
   }
   else {
     calibMenu.show();
   }
 }
