
//-----------------------------------------------------------------------------------------
// BLOB DETECTION

float blobX, blobY;
float blobSize;

void drawBlobsAndEdges(boolean drawEdges, boolean drawRects) {  
  Blob b;
  EdgeVertex eA,eB;


  for (int n = 0 ; n < ct.getBlobDetection().getBlobNb() ; n++) {
    b = ct.getBlobDetection().getBlob(n);
    //println("There Are " + ct.getBlobDetection().getBlobNb() + " Blobs Detected...");
    if (b!= null) {
        
      // Edges
      if (drawEdges) {
         // If Blobs Are Within Crop Area
        if(b.xMin * firstWindowWidth > LeftBorder && b.xMin * firstWindowWidth < RightBorder && b.yMin * windowHeight > TopBorder && b.yMin * windowHeight < BottomBorder) {    
          // If The Blob Is Over A Certain Size
          if(b.w > blobMin && b.w < blobMax) {
            
            noFill();
            strokeWeight(2);
            stroke(0, 0, 255);
            beginShape();
              for (int m = 0; m < b.getEdgeNb(); m++) {
                eA = b.getEdgeVertexA(m);
                eB = b.getEdgeVertexB(m);
                  if (eA != null && eB != null) {
                    vertex(eA.x * captureWidth, eA.y * captureHeight - captureOffsetY); // keep the 4:3 ratio and positionning of the capture image
                  }
              }
            endShape(CLOSE); 
            
            // Return Valid Blobs
            //blobX = (b.xMin * firstWindowWidth);
            
            //blobX = map(blobX, 0, firstWindowWidth, LeftBorder, RightBorder - LeftBorder);
            
            //float mult = firstWindowWidth / ct.getWidth(); // vertical stretch
            //blobY = (b.yMin * windowHeight * mult );
            
            //blobY = map(blobY, 0, windowHeight, TopBorder, BottomBorder - TopBorder);

            //println("BX: " + blobX + "  BY: " + blobY); 
            
          }
        }   
      }     
      
      // Blobs
      if (drawRects) {
        strokeWeight(1);
        noFill();
        stroke(255,0,0);
        rectMode(CORNER);
        // If Blobs Are Within Crop Area
        if(b.xMin * firstWindowWidth > LeftBorder && b.xMin * firstWindowWidth < RightBorder && b.yMin * windowHeight > TopBorder && b.yMin * windowHeight < BottomBorder) {
          // If The Blob Is Over A Certain Size
          if(b.w > blobMin && b.w < blobMax) {
            rect(b.xMin * firstWindowWidth, b.yMin * windowHeight, b.w * firstWindowWidth, b.h * windowHeight);
          }
        }    
      }
        
    } // null
  } // for
} 

//set the mapped x/y coordinates to blobX and blobY
void updateCurrentBlob() {
  //we have at least one blob  
  if(ct.getBlobDetection().getBlobNb() >= 1){
    
      //float xBlobUnit = ct.getBlobDetection().getBlob(0).xMin;
      //float yBlobUnit = ct.getBlobDetection().getBlob(0).yMin;
      
      float xBlobUnit = ct.getBlobDetection().getBlob(0).x;
      float yBlobUnit = ct.getBlobDetection().getBlob(0).y;
      
      /*
      println("");
      println("ct.getBlobDetection().getBlob(0).xMin = " + ct.getBlobDetection().getBlob(0).xMin);
      println("ct.getBlobDetection().getBlob(0).yMin = " + ct.getBlobDetection().getBlob(0).yMin);
      */
      
      // Flip the X axis (when not using the rear projection screen)
      if( mirrorX == true ) xBlobUnit = 1.0 - xBlobUnit;
      
      // 16:9 Y axis correction
      if( ratio == 1) {
        yBlobUnit = ( yBlobUnit * 1.33333 ) - 0.166666;
      }

      // Map the blob coordinates from unit square to the cropping area
      blobX = map( xBlobUnit, 0.0, 1.0, RightBorder - LeftBorder, LeftBorder);
      blobY = map( yBlobUnit, 0.0, 1.0, TopBorder, BottomBorder - TopBorder);
      
      // Adjust tracking
      blobX = blobX - trackingOffsetX;
      blobY = blobY - trackingOffsetY;
      
      // Let's just average the two dimensions of the blob (we just need an order of magnitude).
      blobSize = ( ct.getBlobDetection().getBlob(0).w + ct.getBlobDetection().getBlob(0).h ) / 2.0;
      //System.out.println( "blobSize = "+ blobSize );

      
      //println("blobX:" + blobX);
      //println("blobY:" + blobY);
      
  //we dont have a blob  
  } else {
      //println("No Blobs detected");
  }
}

// Not yet used
boolean isInsideCropZone( PVector coord, float left, float right, float top, float bottom ) {
  
   if ( coord.x * firstWindowWidth < left   ) return false; 
   if ( coord.x * firstWindowWidth > rigth  ) return false;
   if ( coord.y * windowHeight     < top    ) return false; 
   if ( coord.y * windowHeight     > bottom ) return false; 
   
   return true;
}

// -------------------------------- //
