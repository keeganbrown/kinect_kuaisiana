import java.nio.*;
import java.util.*;
import java.lang.*;
//import org.openkinect.freenect.*;
//import org.openkinect.processing.*;

// Kinect Library object
Kinect kinect;


class Kinect {

  public Kinect (Object sketch) {
    print(sketch);
  }

  public int width = 320;
  public int height = 240;
  private int arrayDepth = this.width*this.height;
  private float[] floatArr = new float[this.arrayDepth];
  private FloatBuffer returnBuffer = FloatBuffer.wrap(floatArr);


  public void initDepth () {
    Random rand = new Random();
    for ( int i = 0; i < this.arrayDepth; i++ ) {
      floatArr[i] = ( (rand.nextFloat()*0.5)-0.25 );
    }
  }

  public void getDepthImage () {

  }

  private void incrementVertexArray () {
    Random rand = new Random();
    for ( int i = 0; i < this.floatArr.length; i++ ) {
      //.this.floatArr[i] += ( (rand.nextFloat()*0.02)-0.01 );
      if ( Math.abs(this.floatArr[i]) > 3.1 ) {
        this.floatArr[i] = this.floatArr[i] * -(0.0001*rand.nextFloat());
      }
      this.floatArr[i] = this.floatArr[i]*(0.9+(rand.nextFloat()*0.3));
    }
  }

  public FloatBuffer getDephToWorldPositions() {
    this.incrementVertexArray();
    return this.returnBuffer;
  }
}

// Angle for rotation
float a = 0;

//openGL object and shader
PGL     pgl;
PShader sh;

//VBO buffer location in the GPU
int vertexVboId;

void setup() {
  // Rendering in P3D

  print(this);

  size(1280, 720, P3D);
  kinect = new Kinect(this);
  kinect.initDepth();

  //load shaders
  sh = loadShader("frag.glsl", "vert.glsl");

  PGL pgl = beginPGL();

  IntBuffer intBuffer = IntBuffer.allocate(1);
  pgl.genBuffers(1, intBuffer);

  //memory location of the VBO
  vertexVboId = intBuffer.get(0);

  endPGL();
}

void draw() {

  background(0);

  //image(kinect.getDepthImage(), 0, 0, 320, 240);

  pushMatrix();
  translate(width/2, height/2, 50);
  scale(150);
  rotateY(a);

  
  //data size times 3 for each XYZ coordinate
  int vertData = kinect.width * kinect.height;

  //begin openGL calls and bind the shader
  pgl = beginPGL();
  sh.bind();
  
  FloatBuffer depthPositions =  kinect.getDephToWorldPositions();


  //obtain the vertex location in the shaders.
  //useful to know what shader to use when drawing the vertex positions
  vertexVboId = pgl.getAttribLocation(sh.glProgram, "vertex");

  pgl.enableVertexAttribArray(vertexVboId);

  //bind vertex positions to the VBO
  {
    pgl.bindBuffer(PGL.ARRAY_BUFFER, vertexVboId);
    // fill VBO with data
    pgl.bufferData(PGL.ARRAY_BUFFER, Float.BYTES * vertData *3, depthPositions, PGL.DYNAMIC_DRAW);
    // associate currently bound VBO with shader attribute
    pgl.vertexAttribPointer(vertexVboId, 3, PGL.FLOAT, false, Float.BYTES * 3, 0 );
  }

  // unbind VBOs
  pgl.bindBuffer(PGL.ARRAY_BUFFER, 0);

  //draw the point buffer as a set of POINTS
  pgl.drawArrays(PGL.POINTS, 0, vertData);

  //disable the vertex positions
  pgl.disableVertexAttribArray(vertexVboId);

  //finish drawing
  sh.unbind();
  endPGL();

  popMatrix();

  fill(255, 0, 0);
  text(frameRate, 50, 50);

  // Rotate
  a += 0.015f;
}