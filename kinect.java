import java.nio.*;
import java.util.*;
import java.lang.*;

class FauxKinect {

  public FauxKinect (Object sketch) {
    System.out.println(sketch);
  }

  public int width = 320;
  public int height = 240;
  private int arrayDepth = this.width*this.height;
  private int[] depthArray = new int[this.arrayDepth];


  public void initDepth () {
    Random rand = new Random();
    for ( int i = 0; i < this.arrayDepth; i++ ) {
      depthArray[i] = rand.nextInt(2047);
    }
  }

  public void getDepthImage () {

  }

  private void incrementVertexArray () {
    Random rand = new Random();
    for ( int i = 0; i < this.depthArray.length; i++ ) {
      if ( i % 3 == 0 ) {
        this.depthArray[i] = (int)(Math.floor( i / this.width ));
      } else if ( i % 3 == 1 ) {
        this.depthArray[i] = i % this.width;
      } else if ( i % 3 == 2 ) {
        this.depthArray[i] = (int)(this.depthArray[i] + (rand.nextInt(5) - rand.nextInt(5)) );
      }
      if ( this.depthArray[i] < 0 ) {
        this.depthArray[i] = 0;
      } else if ( this.depthArray[i] > 2047 ) {
        this.depthArray[i] = 2047;
      }
    }
  }

  public int[] getRawDepth() {
    this.incrementVertexArray();
    return this.depthArray;
  }
}