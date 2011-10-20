//This will make the base for the tripod and the gears that go with it.

use <ParametricHerringboneGears.scad> //Import the gears library

//Stepper shaft 4.79mm
//Stepper MOTOR side, 41.9mm
//Stpper MOTOR height 32.8mm
//Stepper MOTOR shaft length 22.5mm

//TRipod Diameter 21.6mm

TripodDiameter = 21.6;

stepperShaft = 4.79;
stepperSide = 41.9;
stepperShaftHeight = 32.8;

generate = 2;


gear_h = 15;
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

}

module baseBottom() {
cube([lazySusanSide,lazySusanSide,5],center=true);
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

}

baseGear();

