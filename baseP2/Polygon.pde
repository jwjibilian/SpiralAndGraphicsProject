


public class Polygon {
  /**points that define polygon**/
  private pts p; 

  public Polygon(pts points) {
    p = points;
  }

  /*returns pt array ifn this format
   [pt of line1 that cutting on, pt1 to cut on, pt line2 is starting on, pt2 to cut on]
   */
  public pt[] stabedPts(pt A, pt B) {
    //println("mouse: " + A + " " + B);
    pt[] points = p.get();
    int before=0, after=0, on=0;//will have how many points are after, before or on vector
    pt[] toReturn = new pt[4]; 
    pt lineStart;
    pt lineEnd;
    pt x = null;
    for (int i =0; i<p.size(); i++) { //goes through all points of a polygon
      lineStart = points[i];
      lineEnd = points[(i+1)%p.size()];
      float test1 = det(V(A, B), V(A, lineStart));
      float test2 = det(V(A, B), V(A, lineEnd));
      if ( (test1 < 0 && test2 >= 0) || (test1 >= 0 && test2 < 0) ) { //tests if we are stabbing a line

        //X=P+tV with t = -AB:AP / AB:V
        float time =  RayEdgeCrossParameter(A, B, lineStart, lineEnd); //time param
        if (time > 1) {
          after ++;
        } else if (time < 0) {
          before ++;
        } else {
          on++;
        }
        //println(time);
        x = P(A, time, V(A, B));
        //pen(red,6);
        //show(x);
        // println("x is: " + x);
        //println("to return 1" + toReturn[1]);
        //println(time);
        if ((toReturn[1] == null || (d(A, x) < d(toReturn[1], A))) && time < 0) { //points closest to A
          toReturn[0] = lineStart;
          toReturn[1] = x;
        }
        if ((toReturn[3] == null || (d(x, B) < d(B, toReturn[3]))) && time > 1) { //point closest to B
          toReturn[2] = lineStart;
          toReturn[3] = x;
        }
      }
    }
    //println("close too a " + toReturn[1]);
    //println(x);

    if (on > 0 || toReturn[1]==null || toReturn[3] == null || before%2 ==0 || after%2 == 0) { //if there is was no valid cut to make return null
      // defines line style wiht (5) and color (green) and draws starting arrow from A to B

      toReturn = null;
    } else { //if there was a valid cut shows the points and allows something other than null to be returned

      //println("close too a " + toReturn[1]); 
      //println("close too B " + toReturn[3]); 
      //println("on is" + on);
      pen(green, 5);
      show(toReturn[1], 5);
      show(toReturn[3], 5);
    }
    return toReturn;
  }
  public void draw() {
    p.drawCurve();
  }
  public void showIds() {
    p.IDs();
  }

  public float RayEdgeCrossParameter(pt A, pt B, pt lineStart, pt lineEnd) {
    float time = (-det(V(lineStart, lineEnd), V(lineStart, A)))/(det(V(lineStart, lineEnd), V(A, B)));
    return time;
  }

  public boolean isMouseInside() {
    int i;
    double angle = 0;
    double px1, px2, py1, py2;
    int n = p.size();
    pt mouse = Mouse();
    pt[] points = p.get();
    for (i = 0; i < n; i++)
    {
      px1 = points[i].getX() - mouse.getX();
      py1 = points[i].getY() - mouse.getY();
      px2 = points[(i+1)%n].getX() - mouse.getX(); 
      py2 = points[(i+1)%n].getY() - mouse.getY();
      //p1.X = polygon._vertexes[i].X - point.X;
      //p1.Y = polygon._vertexes[i].Y - point.Y;
      //p2.X = polygon._vertexes[(i + 1) % n].X - point.X;
      //p2.Y = polygon._vertexes[(i + 1) % n].Y - point.Y;
      angle += getAngle(px1, py1, px2, py2);
    }

    if (Math.abs(angle) < Math.PI)
      return false;
    else
      return true;
  }

  double getAngle(double x1, double y1, double x2, double y2)
  {
    double twoPI = 6.283185307179586476925287; // PI*2
    double dtheta, theta1, theta2;

    theta1 = Math.atan2(y1, x1);
    theta2 = Math.atan2(y2, x2);
    dtheta = theta2 - theta1;
    while (dtheta > Math.PI)
      dtheta -= twoPI;
    while (dtheta < -Math.PI)
      dtheta += twoPI;

    return (dtheta);
  }

  public Polygon cutt(pt A, pt B) {
    println("go");
    pt[] cuttOn = stabedPts(A, B);
    if (cuttOn == null) {
      return null;
    }
    pts newHere = new pts();
    pts newPoly = new pts();
    newHere.declare();
    newPoly.declare();
    pts addingTo = newHere; //used to keep track of what we are adding to
    pt[] currentPts = p.get();
    for (int i = 0; i<p.size(); i++) {

      if (currentPts[i] == cuttOn[0]) { //if the next point is the line with a point to cut on
        addingTo.addPt(currentPts[i]);//add begenning of line to current pts.
        addingTo.addPt(cuttOn[1].copy());//add copy to current pts
        if (addingTo == newHere) { //change pts
          addingTo = newPoly;
          addingTo.addPt(cuttOn[1].copy()); //add another copy of point to cutt on.
        } else {
          addingTo = newHere;
          addingTo.addPt(cuttOn[1].copy());
        }
      } else if (currentPts[i] == cuttOn[2]) {
        addingTo.addPt(currentPts[i]);
        addingTo.addPt(cuttOn[3].copy());
        if (addingTo == newHere) {
          addingTo = newPoly;
          addingTo.addPt(cuttOn[3].copy());
        } else {
          addingTo = newHere;
          addingTo.addPt(cuttOn[3].copy());
        }
      } else {
        addingTo.addPt(currentPts[i]);
      }

      //if (addingTo == newHere) {//determines what polygon to add to
      //  if (cuttOn[0] == currentPts[i]) {  //if the the first point to cut on is by the tail of vector
      //    addingTo.addPt(currentPts[i]);
      //    addingTo.addPt(cuttOn[1].copy());
      //    newPoly.addPt(cuttOn[1]);
      //    addingTo = newPoly;
      //  } else if (cuttOn[2] == currentPts[i]) {  //if the the first point to cut on is by the head of vector
      //    addingTo.addPt(currentPts[i]);
      //    addingTo.addPt(cuttOn[3].copy());
      //    newPoly.addPt(cuttOn[3]);
      //    addingTo = newPoly;
      //  } else {
      //    addingTo.addPt(currentPts[i]);
      //  }
      //} else {
      //  if (cuttOn[0] == currentPts[i]) {
      //    addingTo.addPt(currentPts[i]);
      //    addingTo.addPt(cuttOn[1].copy());
      //    newHere.addPt(cuttOn[1]);
      //    addingTo = newHere;
      //  } else if (cuttOn[2] == currentPts[i]) {  //if the the first point to cut on is by the head of vector
      //    addingTo.addPt(currentPts[i]);
      //    addingTo.addPt(cuttOn[3].copy());
      //    newHere.addPt(cuttOn[3]);
      //    addingTo = newHere;
      //  } else {
      //    addingTo.addPt(currentPts[i]);
      //  }
      //}
    }

    p = newHere; //change polygon called on points

    return new Polygon(newPoly); //returns the new polygon
  }

  public pt getCentroid() {
    return p.Centroid();
  }

  public void drag() {
    
    p.dragAll();
  }
  
  public void rotateAllAroundCentroid(pt P, pt Q){
    p.rotateAllAroundCentroid(P, Q);
  }

  public void scaleAllAroundCentroid(pt M, pt P){
    p.scaleAllAroundCentroid(M, P);
  }

  //int sizeA = 0;
  //int sizeB = 0;
}