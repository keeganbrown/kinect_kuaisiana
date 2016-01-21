// Daniel Shiffman
// Kinect Point Cloud example

// https://github.com/shiffman/OpenKinect-for-Processing
// http://shiffman.net/p5/kinect/

import org.openkinect.freenect.*;
import org.openkinect.processing.*;

// Kinect Library object
Kinect kinect;

// Angle Vars
float a = 0.0f;
float ad = 0.005f;
float adr = 0.005f;
float add = 1;

//Tracers


// We'll use a lookup table so that we don't have to repeat the math over and over
float[] depthLookUp = new float[2048];

void setup() {
  // Rendering in P3D
  size(1280, 720, P3D);
  kinect = new Kinect(this);
  background(0);
  kinect.initDepth();
  kinect.setTilt(5);

  // Lookup table for all possible depth values (0 - 2047)
  for (int i = 0; i < depthLookUp.length; i++) {
    depthLookUp[i] = rawDepthToMeters(i);
  }
}

void mouseClicked() {
  if ( ad == 0.0f ) {
    add *= -1;
    ad = adr*add;
  } else {
    ad = 0.0f;
  }
}

void draw() {

  //background(0, 0, 0, 5);
  fill(0, 0, 0, 9);
  noStroke();
  rect(0, 0, width, height);
  rect(0, 0, width, height);

  // Get the raw depth as array of integers
  int[] depth = kinect.getRawDepth();

  int skip = 4;
  int hardLimit = 80000;
  int boxCount = 0;
  float factor = 100;

  // Translate and rotate
  translate( width/2, height/2, (300*sin(a))+300 );
  rotateY(a/10);
  rotateZ(a);

  for (int x = 0; x < kinect.width; x += skip) {
    for (int y = 0; y < kinect.height; y += skip) {
      int offset = x + y*kinect.width;

      // Convert kinect data to world xyz coordinate
      int rawDepth = depth[offset];
      PVector v = depthToWorld(x, y, rawDepth);

      stroke(255);
      pushMatrix();
      // Scale up by 200
      translate(v.x*factor, v.y*factor, factor-v.z*factor);
      // Draw a point
      //println(factor-v.z*factor);
      if ( x > 2 & y > 2 && boxCount < hardLimit && v.z*100 < 250 ) {
        //box(4);
        point(0, 0);
        boxCount++;
      }
      popMatrix();
    }
  }

  // Rotate
  a += ad;
}

// These functions come from: http://graphics.stanford.edu/~mdfisher/Kinect.html
float rawDepthToMeters(int depthValue) {
  if (depthValue < 2047) {
    return (float)(1.0 / ((double)(depthValue) * -0.0030711016 + 3.3309495161));
  }
  return 0.0f;
}

PVector depthToWorld(int x, int y, int depthValue) {

  final double fx_d = 1.0 / 5.9421434211923247e+02;
  final double fy_d = 1.0 / 5.9104053696870778e+02;
  final double cx_d = 3.3930780975300314e+02;
  final double cy_d = 2.4273913761751615e+02;

  PVector result = new PVector();
  double depth =  depthLookUp[depthValue];//rawDepthToMeters(depthValue);
  result.x = (float)((x - cx_d) * depth * fx_d);
  result.y = (float)((y - cy_d) * depth * fy_d);
  result.z = (float)(depth);
  return result;
}