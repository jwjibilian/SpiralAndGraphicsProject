//**************************** user actions ****************************
void keyPressed()  // executed each time a key is pressed: sets the Boolean "keyPressed" till it is released   
  // sets  char "key" state variables till another key is pressed or released

{

  if (key=='~') recordingPDF=true; // to snap an image of the canvas and save as zoomable a PDF, compact and great quality, but does not always work
  if (key=='!') snapJPG=true; // make a .PDF picture of the canvas, compact, poor quality
  if (key=='@') snapTIF=true; // make a .TIF picture of the canvas, better quality, but large file
  if (key=='#') ;
  if (key=='$') ;
  if (key=='%') ; 
  if (key=='^') ;
  if (key=='&') ;
  if (key=='*') ;    
  if (key=='(') ;
  if (key==')') ;  
  if (key=='_') ;
  if (key=='+') ;

  if (key=='`') filming=!filming;  // filming on/off capture frames into folder IMAGES/MOVIE_FRAMES_TIF/
  if (key=='1') ;               // toggles what should be displayed at each fram
  if (key=='2') ;
  if (key=='3') ;
  if (key=='4') ;
  if (key=='5') ;
  if (key=='6') ;
  if (key=='7') ;
  if (key=='8') ;
  if (key=='9') ;
  if (key=='0') ; 
  if (key=='-') ;
  if (key=='=') ;

  if (key=='a') ; 
  if (key=='b') ; 
  if (key=='c') P.resetOnCircle(P.nv);
  if (key=='d') ; 
  if (key=='e') ;
  if (key=='f') ;
  if (key=='g') ; 
  if (key=='h') ;
  if (key=='i') ; 
  if (key=='j') {
    if (currentState == GameStates.CREATION) {
      for (Polygon thing : polygons) {
        ghosts.add(thing.copy());
      }
      stateStr = "Hold 'b' to rotate, 'n' to move and 'm' to scale, then click on the piece you want to manipulate.";
      currentState = GameStates.PUZZLE;
    } else if (currentState == GameStates.PUZZLE) {
      currentState = GameStates.PLAYER;
      stateStr = "To solve click on a pice then a place on the red polygon.";
    }
  }
  if (key=='k') ;   
  if (key=='l') ;
  if (key=='m') ;
  if (key=='n') ;
  if (key=='o') ;
  if (key=='p') ;
  if (key=='q') ; 
  if (key=='r') ; // used in mouseDrag to rotate the control points 
  if (key=='s') ;
  if (key=='t') ; // used in mouseDrag to translate the control points 
  if (key=='p') ;
  if (key=='v') ; 
  if (key=='w') ;  
  if (key=='x') ;
  if (key=='y') ;
  if (key=='z') ; // used in mouseDrag to scale the control points

  if (key=='A') ;
  if (key=='B') ; 
  if (key=='C') ; 
  if (key=='D') ;  
  if (key=='E') ;
  if (key=='F') ;
  if (key=='G') ; 
  if (key=='H') ; 
  if (key=='I') ; 
  if (key=='J') ;
  if (key=='K') ;
  if (key=='L') P.loadPts("data/pts");    // load current positions of control points from file
  if (key=='M') ;
  if (key=='N') ;
  if (key=='O') ;
  if (key=='P') ; 
  if (key=='Q') exit();  // quit application
  if (key=='R') ; 
  if (key=='S') P.savePts("data/pts");    // save current positions of control points on file
  if (key=='T') ;
  if (key=='U') ;
  if (key=='V') ;
  if (key=='W') ;  
  if (key=='X') ;  
  if (key=='Y') ;
  if (key=='Z') ;  

  if (key=='{') ;
  if (key=='}') ;
  if (key=='|') ; 

  if (key=='[') ; 
  if (key==']') P.fitToCanvas();  
  if (key=='\\') ;

  if (key==':') ; 
  if (key=='"') ; 

  if (key==';') ; 
  if (key=='\''); 

  if (key=='<') ;
  if (key=='>') ;
  if (key=='?') scribeText=!scribeText; // toggle display of help text and authors picture

  if (key==',') ;
  if (key=='.') ;  // used in mousePressed to tweak current frame f
  if (key=='/') ;

  if (key==' ') ;

  if (key == CODED) 
  {
    String pressed = "Pressed coded key ";
    if (keyCode == UP) {
      pressed="UP";
    }
    if (keyCode == DOWN) {
      pressed="DOWN";
    };
    if (keyCode == LEFT) {
      pressed="LEFT";
    };
    if (keyCode == RIGHT) {
      pressed="RIGHT";
    };
    if (keyCode == ALT) {
      pressed="ALT";
    };
    if (keyCode == CONTROL) {
      pressed="CONTROL";
    };
    if (keyCode == SHIFT) {
      pressed="SHIFT";
    };
    println("Pressed coded key = "+pressed);
  } 

  change=true; // to make sure that we save a movie frame each time something changes
  println("key pressed = "+key);
}

void mousePressed()   // executed when the mouse is pressed
{
  if (!keyPressed || (key=='a') || (key=='i') || (key=='x'))  
    P.pickClosest(Mouse()); // pick vertex closest to mouse: sets pv ("picked vertex") in pts
  if (!keyPressed && currentState == GameStates.PLAYER) {
    if (moving == null) {
      for (Polygon thing : polygons) {
        if (thing.isMouseInside()) {
          moving = thing;
        }
      }
    } else {
      for (Polygon thing : ghosts) {
        if (thing.isMouseInside()) {
          moveToHere = thing;
        }
      }
    }
  }
  if (keyPressed) 
  {
    if (key=='a')  P.addPt(Mouse()); // appends vertex after the last one
    if (key=='i')  P.insertClosestProjection(Mouse()); // inserts vertex at closest projection of mouse
    if (key=='d')  P.deletePickedPt(); // deletes vertex closeset to mouse
    if (key=='b' || key == 'n' || key == 'm' && currentState == GameStates.PUZZLE) {
      for (Polygon thing : polygons) {
        if (thing.isMouseInside()) {
          selected = thing;
        }
      }
    } else  
    if (keyPressed && key=='s') {
      A=Mouse(); 
      B=Mouse();
    } 
    change=true;
  }
}

void mouseReleased()   // executed when the mouse is pressed
{
  if (keyPressed && key=='s' && currentState == GameStates.CREATION) { 
    B=Mouse();
    Polygon toAdd = null;

    for (int i = 0; i < polygons.size() && toAdd == null; i++) {
      toAdd = (polygons.get(i).cutt(A, B));
    }
    if (toAdd != null) {
      polygons.add(toAdd);
    }
  }
  selected = null;
  change=true;
  //pt one = stabP.pickClosest(A);
  //pick closest red dot to A
  stabP.pickClosest(A);
  pt one = stabP.getPicked();
  //add closest red to A on set of points P
  //P.addPt(one);

  //pick closest red dot to B
  stabP.pickClosest(B);
  pt two = stabP.getPicked();
  //add closest red to B on set of points P
  //P.addPt(two);
  //polygons.add(new Polygon(one, two));
}

void mouseDragged() // executed when the mouse is dragged (while mouse buttom pressed)
{
  if (!keyPressed || (key=='a')|| (key=='i')) P.dragPicked();   // drag selected point with mouse
  if (keyPressed) {
    if (key=='.') f+=2.*float(mouseX-pmouseX)/width;  // adjust current frame   
    if (key=='t') P.dragAll(); // move all vertices
    if (key=='r') P.rotateAllAroundCentroid(Mouse(), Pmouse()); // turn all vertices around their center of mass
    if (key=='z') P.scaleAllAroundCentroid(Mouse(), Pmouse()); // scale all vertices with respect to their center of mass
    if (currentState == GameStates.PUZZLE) {
      if (key=='n' && selected != null) {
        selected.drag();
      }
      if (key=='b'&& selected != null) {
        selected.rotateAllAroundCentroid(Mouse(), Pmouse());
      }
      if (key=='m'&& selected != null) {
        selected.scaleAllAroundCentroid(Mouse(), Pmouse());
      }
    }
  }
  if (keyPressed && key=='s') B=Mouse(); 
  change=true;
}  

void mouseWheel(MouseEvent event) { // reads mouse wheel and uses to zoom
  float s = event.getAmount();
  P.scaleAllAroundCentroid(s/100);
  change=true;
}

//**************************** text for name, title and help  ****************************
String title ="Split Polygon Puzzle", name ="Student: Gabriel Galarza and Josh Jibilian", 
  subtitle = "  base code for P2 for Jarek Rossignac's CS3451 class in the Fall 2016", 

  menu="?:(show/hide) help, ~/!/@:snap pdf/jpg/fif, `:(start/stop) recording, S/L:save/load, Q:quit", 
  guide="click&drag:edit, d&click:delete, i&click&drag:insrt, s&click&drag:split"; // help info