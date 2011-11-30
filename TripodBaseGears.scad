//This will make the base for the tripod and the gears that go with it.

use <ParametricHerringboneGears.scad> //Import the gears library

//Stepper shaft 4.79mm
//Stepper MOTOR side, 41.9mm
//Stpper MOTOR height 32.8mm
//Stepper MOTOR shaft length 22.5mm

//TRipod Diameter 21.6mm

tripodDiameter = 23.5;
tripodRadius = tripodDiameter/2;

wallThickness = 20;

coverRadius = tripodRadius + wallThickness;
coverHeight = 50;

tripodScrewDiameter = 4;
tripodScrewRadius = tripodScrewDiameter/2;

stepperShaft = 4.79;
stepperSide = 41.9;
stepperShaftHeight = 32.8;

generate = 2;

//gear_h = 15; //height of the gear THIS LINE CURRENTLY DOES NOT WORK FIX ME PLZ!
//gear_shaft_h = 15;


gear2_teeth = 50; //2:1 ratio!
gear1_teeth = 25;


lazySusanSide = 102;
lazySusanHeight = 8;
lazySusanOffset = lazySusanHeight - 2;

lazySusanDiameter = sqrt(2 * lazySusanSide * lazySusanSide);
lazySusanRadius = (lazySusanDiameter)/2;


bigGearDiameter = lazySusanDiameter+5;

distance_between_axels = 180*(gear1_teeth + gear2_teeth)*(bigGearDiameter)/(gear2_teeth*360);



module interiorDifference() {
translate([0,0,50])
cylinder(r=tripodRadius,h=100,center = true);
}

module baseBottom() {
difference() { //difference the cover from the shaft
translate([0,0,coverHeight/2 + gear_h])
cylinder(r=coverRadius,h=coverHeight,center=true);

interiorDifference(); //Interior pipe

tripodCoverScrewsDifference(); //Knock out two holes in the cover for potentially screwing in screws. (4mm diameter) 
}
}

module tripodCoverScrewsDifference() {
//Difference out the screw holes.
translate([0,0,gear_h + coverHeight/5])
rotate([90,0,45])
cylinder(r=tripodScrewRadius,h=100,center=true,$fn=10);

translate([0,0,gear_h + coverHeight/5])
rotate([90,0,-45])
cylinder(r=tripodScrewRadius,h=100,center=true,$fn=10);

translate([0,0,gear_h + 4*coverHeight/5])
rotate([90,0,45])
cylinder(r=tripodScrewRadius,h=100,center=true,$fn=10);

translate([0,0,gear_h + 4*coverHeight/5])
rotate([90,0,-45])
cylinder(r=tripodScrewRadius,h=100,center=true,$fn=10);
}

module baseGear() {
difference() {
gearsbyteethanddistance(t1 = gear1_teeth, t2 = gear2_teeth, d=distance_between_axels, which=2);

//difference out the lazy susan
translate([0,0,lazySusanOffset/2])
cube([lazySusanSide,lazySusanSide,lazySusanOffset],center=true);
}

}

module smallGear() {
//makes the smaller stepper gear for the yaw control of the camera.
//
//// GEAR1 (SMALLER GEAR, STEPPER GEAR) OPTIONS:
//// It's helpful to choose prime numbers for the gear teeth.
//gear1_teeth = 13;
//gear1_shaft_d = 5.4;  			// diameter of motor shaft
//gear1_shaft_r  = gear1_shaft_d/2;	
//// gear1 shaft assumed to fill entire gear.
//// gear1 attaches by means of a captive nut and bolt (or actual setscrew)
//
//hub_wall_thickness = 14.5;
//
//gear1_hub_diameter = gear1_shaft_d + (2*hub_wall_thickness);
//gear1_hub_radius = gear1_hub_diameter/2;
//
//gear1_setscrew_offset = gear_shaft_h/2;			// Distance from motor on motor shaft. HALF
//
//gear1_setscrew_d         = 3.5;		
//gear1_setscrew_r          = gear1_setscrew_d/2;
//gear1_setscrew_head_d         = 6.2;	
//gear1_setscrew_head_r          = gear1_setscrew_head_d/2;
//gear1_captive_nut_d = 6.2;
//gear1_captive_nut_r  = gear1_captive_nut_d/2;
//gear1_captive_nut_h = 3;

gearsbyteethanddistance(t1 = gear1_teeth, t2 = gear2_teeth, d=distance_between_axels, which=1, gear_direction = 2);
}

module sideStepperGear() {
//This makes the stepper gear for the pitch angle of the camera.

hubThicknessTemp = 5;
setscrewOffset = hubThicknessTemp/2;

gearsbyteethanddistance(t1=20,t2=40, d=60, teethtwist=1, which=1, gearDirection = 1, gearThickness=12, hubWallThickness = 10.5, hubThickness = hubThicknessTemp, shaftDiameter = 5.4, setscrewShaftDiameter = 3.5, setscrewHeadDiameter = 6.2, setscrewOffset = setscrewOffset, captiveNutDiameter = 6.2, captiveNutHeight = 3);

}

module sideAxleGear() {
//This makes the axle gear for the pitch angle of the camera.

hubThicknessTemp = 5;
setscrewOffset = hubThicknessTemp/2;

gearsbyteethanddistance(t1=40,t2=20, d=60, teethtwist=1, which=1, gearDirection = 2, gearThickness=12, hubWallThickness = 11, hubThickness = hubThicknessTemp, shaftDiameter = 8.6, setscrewShaftDiameter = 3.5, setscrewHeadDiameter = 6.2, setscrewOffset = setscrewOffset, captiveNutDiameter = 6.2, captiveNutHeight = 3);

}

module telescopingBigGear() {
//This makes the Big gear that should telescope the tripod
hubThicknessTemp = 0;
setscrewOffset = hubThicknessTemp/2;

gearsbyteethanddistance(t1=40,t2=20, d=60, teethtwist=1, which=1, gearDirection = 2, gearThickness=12, hubWallThickness = 11, hubThickness = hubThicknessTemp, shaftDiameter = 8.6, setscrewShaftDiameter = 3.5, setscrewHeadDiameter = 6.2, setscrewOffset = setscrewOffset, captiveNutDiameter = 6.2, captiveNutHeight = 3);

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
sideAxleGear();

//chopInFour(4); //Make the gear! (Chopped into quarters!)
}