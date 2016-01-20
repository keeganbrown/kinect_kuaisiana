import java.nio.*;
import java.util.*;
import java.lang.*;

class Kinect {

  public Kinect (Object sketch) {
    System.out.println(sketch);
  }

  public int width = 320;
  public int height = 240;
  private int arrayDepth = this.width*this.height;
  private float[] floatArr = new float[this.arrayDepth];
  private FloatBuffer returnBuffer = FloatBuffer.wrap(floatArr);


  public void initDepth () {
    Random rand = new Random();
    for ( int i = 0; i < this.arrayDepth; i++ ) {
      floatArr[i] = (float)( (rand.nextFloat()*0.5)-0.25 );
    }
  }

  public void getDepthImage () {

  }

  private void incrementVertexArray () {
    Random rand = new Random();
    for ( int i = 0; i < this.floatArr.length; i++ ) {
      //.this.floatArr[i] += ( (rand.nextFloat()*0.02)-0.01 );
      if ( Math.abs(this.floatArr[i]) > 3.1 ) {
        this.floatArr[i] = (float)(this.floatArr[i] * -(0.0001*rand.nextFloat()));
      }
      this.floatArr[i] = (float)(this.floatArr[i]*(0.9+(rand.nextFloat()*0.3)));
    }
  }

  public FloatBuffer getDephToWorldPositions() {
    this.incrementVertexArray();
    return this.returnBuffer;
  }
}