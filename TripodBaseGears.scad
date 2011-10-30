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

gear_h = 15; //height of the gear THIS LINE CURRENTLY DOES NOT WORK FIX ME PLZ!
gear_shaft_h = 15;

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
gearsbyteethanddistance(t1 = gear1_teeth, t2 = gear2_teeth, d=distance_between_axels, which=1,gear_direction = 2);
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
smallGear();


//chopInFour(4); //Make the gear! (Chopped into quarters!)
}