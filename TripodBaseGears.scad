//This will make the base for the tripod and the gears that go with it.

use <ParametricHerringboneGears.scad> //Import the gears library

//********************
//*****SETTINGS******
//*********************

//Stepper shaft 4.79mm
//Stepper MOTOR side, 41.9mm
//Stpper MOTOR height 32.8mm
//Stepper MOTOR shaft length 22.5mm
//Tripod Diameter 21.6mm

tripodDiameter = 23.5; //Diameter of the tripod in question
tripodRadius = tripodDiameter/2; //Radius

stepperShaft = 4.79; //Diameter of the stepper shaft
stepperSide = 41.9; //Unused
stepperShaftHeight = 32.8; //unused

wallThickness = 20;

coverRadius = tripodRadius + wallThickness;
coverHeight = 50;

tripodScrewDiameter = 4;
tripodScrewRadius = tripodScrewDiameter/2;

baseGearHeight = 15;
baseGearTeeth = 50; //2:1 ratio!

smallGearTeeth = 25;

lazySusanSide = 102;
lazySusanHeight = 8;
lazySusanOffset = lazySusanHeight - 2;

lazySusanDiameter = sqrt(2 * lazySusanSide * lazySusanSide);
lazySusanRadius = (lazySusanDiameter)/2;

bigGearDiameter = lazySusanDiameter+5;

distance_between_axels = 180*(smallGearTeeth + baseGearTeeth)*(bigGearDiameter)/(baseGearTeeth*360);



module interiorDifference() {
    translate([0,0,50])
    cylinder(r=tripodRadius,h=100,center = true);
}

module baseBottom() {
    difference() { //difference the cover from the shaft
        translate([0,0,coverHeight/2 + baseGearHeight])
        cylinder(r=coverRadius,h=coverHeight,center=true);
        
        interiorDifference(); //Interior pipe
        
        tripodCoverScrewsDifference(); //Knock out two holes in the cover for potentially screwing in screws. (4mm diameter) 
    }
}

module tripodCoverScrewsDifference() {
    //Difference out the screw holes.
    translate([0,0,baseGearHeight + coverHeight/5])
    rotate([90,0,45])
    cylinder(r=tripodScrewRadius,h=100,center=true,$fn=10);
    
    translate([0,0,baseGearHeight + coverHeight/5])
    rotate([90,0,-45])
    cylinder(r=tripodScrewRadius,h=100,center=true,$fn=10);
    
    translate([0,0,baseGearHeight + 4*coverHeight/5])
    rotate([90,0,45])
    cylinder(r=tripodScrewRadius,h=100,center=true,$fn=10);
    
    translate([0,0,baseGearHeight + 4*coverHeight/5])
    rotate([90,0,-45])
    cylinder(r=tripodScrewRadius,h=100,center=true,$fn=10);
}

module baseGear() {
    difference() {
        
        gearsbyteethanddistance(
        t1 = baseGearTeeth,
        t2 = smallGearTeeth, 
        d = distance_between_axels, 
        teethtwist = 1, 
        which = 1, 
        gearDirection = 1, 
        gearThickness = baseGearHeight, 
        hubWallThickness = 0, 
        hubThickness = 5, 
        shaftDiameter = 0, 
        setscrewShaftDiameter = 0, 
        setscrewHeadDiameter = 0, 
        setscrewOffset = 0, 
        captiveNutDiameter = 0, 
        captiveNutHeight = 0);
        
        
        //difference out the lazy susan
        translate([0,0,lazySusanOffset/2])
        cube([lazySusanSide,lazySusanSide,lazySusanOffset],center=true);
    }
    
}

//makes the smaller stepper gear for the yaw control of the camera.
module smallGear() {
    smallGearTeeth = 13;
    smallGearShaftDiameter = 5.4;  			// diameter of motor shaft
    smallGearShaftRadius  = smallGearShaftDiameter/2;	
    
    smallGearHubWallThickness = 14.5; //This is how thick the hub of the gear will be from the outside of the stepper shaft.
    //You want to have this value be barely smaller than the length of your screw
    smallGearHubThickness = 5;
    
    smallGearHubDiameter = smallGearShaftDiameter + (2*smallGearHubWallThickness);
    smallGearHubRadius = smallGearHubDiameter/2;
    
    
    smallGear_setscrew_offset = smallGearHubThickness/2;			//Distance from motor on motor shaft. (Halfway up the shaft)

    
    smallGearSetscrewDiameter         = 3.5;		
    smallGearSetscrewRadius          = smallGearSetscrewDiameter/2;
    smallGearSetscrewHeadDiameter         = 6.2;	
    smallGearSetscrewHeadRadius          = smallGearSetscrewHeadDiameter/2;
    smallGearCaptiveNutDiameter = 6.2;
    smallGearCaptiveNutRadius  = smallGearCaptiveNutDiameter/2;
    smallGearCaptiveNutHeight = 3;
    
    gearsbyteethanddistance(
    t1 = smallGearTeeth,
    t2 = baseGearTeeth, 
    d = distance_between_axels, 
    teethtwist = 1, 
    which = 1, 
    gearDirection = 1, 
    gearThickness = baseGearHeight, 
    hubWallThickness = smallGearHubWallThickness, 
    hubThickness = smallGearHubThickness, 
    shaftDiameter = smallGearShaftDiameter, 
    setscrewShaftDiameter = smallGearSetscrewDiameter, 
    setscrewHeadDiameter = smallGearSetscrewHeadDiameter, 
    setscrewOffset = smallGear_setscrew_offset, 
    captiveNutDiameter = smallGearCaptiveNutDiameter, 
    captiveNutHeight = smallGearCaptiveNutHeight);
    
}

module sideStepperGear() {
    //This makes the stepper gear for the pitch angle of the camera.
    
    smallGearHubThickness = 5;
    setscrewOffset = smallGearHubThickness/2;
    
    gearsbyteethanddistance(
    t1=20,
    t2=40, 
    d=60, 
    teethtwist=1, 
    which=1, 
    gearDirection = 1, 
    gearThickness=12, 
    hubWallThickness = 10.5, 
    hubThickness = smallGearHubThickness, 
    shaftDiameter = 5.4, 
    setscrewShaftDiameter = 3.5, 
    setscrewHeadDiameter = 6.2, 
    setscrewOffset = setscrewOffset, 
    captiveNutDiameter = 6.2, 
    captiveNutHeight = 3
    );
    
}

module sideAxleGear() {
    //This makes the axle gear for the pitch angle of the camera.
    
    sideAxelGearHubThickness = 5;
    setscrewOffset = sideAxelGearHubThickness/2;
    
    gearsbyteethanddistance(
    t1=40,
    t2=20, 
    d=60, 
    teethtwist=1, 
    which=2, 
    gearDirection = 1, 
    gearThickness=12, 
    hubWallThickness = 11, 
    hubThickness = sideAxelGearHubThickness, 
    shaftDiameter = 8.6, 
    setscrewShaftDiameter = 3.5, 
    setscrewHeadDiameter = 6.2, 
    setscrewOffset = setscrewOffset, 
    captiveNutDiameter = 6.2, 
    captiveNutHeight = 3
    );
    
}

module chopInFour(chop=1) {
    intersection() {
        
        union() {
            baseGear();
            baseBottom();
        }
        
        if (chop==1){
            cube(200,200,200);
        } else if (chop==2){
            translate([0,-200,0])
            cube(200,200,200);
        } else if (chop==3){
            translate([-200,-200,0])
            cube(200,200,200);
        } else if (chop==4){
            translate([-200,0,0])
            cube(200,200,200);
        }
        
    }
    
}

union(){
    //smallGear();
    //sideStepperGear();
    //sideAxleGear();
    
    chopInFour(1); //Make the gear! (Chopped into quarters!)
}