// OpenSCAD Herringbone Wade's Gears Script
// (c) 2011, Christopher "ScribbleJ" Jansen
//
// Thanks to Greg Frost for his great "Involute Gears" script.
//
// Licensed under the BSD license.

include <MCAD/involute_gears.scad> 

//Edited by XtremD

// Tolerances for geometry connections.
AT=0.02;
ST=AT*2;
TT=AT/2;


module gearsbyteethanddistance(t1=13,t2=51, d=60, teethtwist=1, which=1, gearDirection = 1, gearThickness=15, hubWallThickness = 10, hubThickness=10, shaftDiameter = 3, setscrewShaftDiameter = 6, setscrewHeadDiameter = 6.2, setscrewOffset = 2, captiveNutDiameter = 6, captiveNutHeight = 6)
{
	cp = 360*d/(t1+t2);
    
	gear1Twist = 360 * teethtwist / t1;
	gear2Twist = 360 * teethtwist / t2;
    
	gear1Diameter  =  t1 * cp / 180;
	gear2Diameter  =  t2 * cp / 180;
	gear1Radius   = gear1Diameter/2;
	gear2Radius   = gear2Diameter/2;
    
    shaftRadius = shaftDiameter/2;
    hubDiameter = shaftDiameter + (2*hubWallThickness);
    hubRadius = hubDiameter/2;
    setscrewShaftRadius = setscrewShaftDiameter/2;
    setscrewHeadRadius = setscrewHeadDiameter/2;
    captiveNutRadius = captiveNutDiameter/2;
    
	echo(str("Your small ", t1, "-toothed gear will be ", gear1Diameter, "mm across (plus 1 gear tooth size) (PR=", gear1Radius,")"));
	echo(str("Your large ", t2, "-toothed gear will be ", gear2Diameter, "mm across (plus 1 gear tooth size) (PR=", gear2Radius,")"));
	echo(str("Your gear mount axles should be ", d,"mm (", gear1Radius+gear2Radius,"mm calculated) from each other."));
    
	
    if(which == 1) //Is this the first or second gear?
    {
        
        if (gearDirection == 1) {//This is the regular direction. The hub will end up on top.
            difference() {
                
                gearWithRegularTwist(_teeth = t1, _gearTwist = gear1Twist, _circularPitch = cp, _gearThickness = gearThickness, _gearRadius = gear1Radius, _hubDiameter = hubDiameter, _hubThickness = hubThickness);
                
                differenceOutSetscrew(_shaftRadius = shaftRadius, _gearThickness = gearThickness, _gearRadius = gear1Radius, _hubThickness = hubThickness, _hubRadius = hubRadius, _setscrewOffset = setscrewOffset, _setscrewShaftRadius = setscrewShaftRadius, _setscrewHeadRadius = setscrewHeadRadius, _captiveNutRadius = captiveNutRadius, _captiveNutHeight = captiveNutHeight, _captiveNutDiameter = captiveNutDiameter);
            }
        } else { //The hub will be on the bottom, lets construct the gear with revered twist, add the hub and then flip it
            rotate([180,0,0])
            difference() {
                
                gearWithInverseTwist(_teeth = t1, _gearTwist = gear1Twist, _circularPitch = cp, _gearThickness = gearThickness, _gearRadius = gear1Radius, _hubDiameter = hubDiameter, _hubThickness = hubThickness);
                
                differenceOutSetscrew(_shaftRadius = shaftRadius, _gearThickness = gearThickness, _gearRadius = gear1Radius, _hubThickness = hubThickness, _hubRadius = hubRadius, _setscrewOffset = setscrewOffset, _setscrewShaftRadius = setscrewShaftRadius, _setscrewHeadRadius = setscrewHeadRadius, _captiveNutRadius = captiveNutRadius, _captiveNutHeight = captiveNutHeight, _captiveNutDiameter = captiveNutDiameter);
            }
        }
        
    } else if (which == 2) { //This is the second gear
        
        if(gearDirection == 1) //This is the regular direction for the second gear. The hub will be on top but the twist must be reversed for meshing. 
        difference() {
            
            gearWithInverseTwist(_teeth = t1, _gearTwist = gear1Twist, _circularPitch = cp, _gearThickness = gearThickness, _gearRadius = gear1Radius, _hubDiameter = hubDiameter, _hubThickness = hubThickness);
            
            differenceOutSetscrew(_shaftRadius = shaftRadius, _gearThickness = gearThickness, _gearRadius = gear1Radius, _hubThickness = hubThickness, _hubRadius = hubRadius, _setscrewOffset = setscrewOffset, _setscrewShaftRadius = setscrewShaftRadius, _setscrewHeadRadius = setscrewHeadRadius, _captiveNutRadius = captiveNutRadius, _captiveNutHeight = captiveNutHeight, _captiveNutDiameter = captiveNutDiameter);
        }
    } else { //This is the inverse direction for the second gear. The hub will end up on the bottom
        rotate([180,0,0])
        difference() {
            
            gearWithRegularTwist(_teeth = t1, _gearTwist = gear1Twist, _circularPitch = cp, _gearThickness = gearThickness, _gearRadius = gear1Radius, _hubDiameter = hubDiameter, _hubThickness = hubThickness);
            
            differenceOutSetscrew(_shaftRadius = shaftRadius, _gearThickness = gearThickness, _gearRadius = gear1Radius, _hubThickness = hubThickness, _hubRadius = hubRadius, _setscrewOffset = setscrewOffset, _setscrewShaftRadius = setscrewShaftRadius, _setscrewHeadRadius = setscrewHeadRadius, _captiveNutRadius = captiveNutRadius, _captiveNutHeight = captiveNutHeight, _captiveNutDiameter = captiveNutDiameter);
        }
    }
}

module differenceOutSetscrew(_shaftRadius, _gearThickness, _gearRadius, _hubThickness, _hubRadius, _setscrewOffset, _setscrewShaftRadius, _setscrewHeadRadius, _captiveNutRadius, _captiveNutHeight, _captiveNutDiameter) {
    
    union() {
        
        //shafthole
        translate([0,0,-TT]) 
        cylinder(r=_shaftRadius, h=_gearThickness+_hubThickness+ST,$fn=10);
        
        //setscrew shaft
        translate([0,0,_gearThickness+_hubThickness-_setscrewOffset])
        rotate([0,90,0])
        cylinder(r=_setscrewShaftRadius, h=_hubRadius,$fn=20);
        
        //setscrew shaft head clearance
        translate([_hubRadius,0,_gearThickness+_hubThickness-_setscrewOffset])
        rotate([0,90,0])
        cylinder(r=_setscrewHeadRadius, h=2*_gearRadius,$fn=20); //FIX THIS!! THIS SHOULD NOT BE 2X gear1Radius. Should be the actual size of the gear w/teath!
        
        //setscrew captive nut
        translate([_hubRadius/2, 0, _gearThickness+_hubThickness-_captiveNutRadius-_setscrewOffset]) 
        translate([0,0,(_captiveNutRadius+_setscrewOffset)/2])
        #cube([_captiveNutHeight, _captiveNutDiameter, _captiveNutRadius+_setscrewOffset+ST],center=true);
    }
}

module gearWithRegularTwist(_teeth, _gearTwist, _circularPitch, _gearThickness, _gearRadius, _hubDiameter, _hubThickness) {
    
    union() {
        
        translate([0,0,(_gearThickness/2) - TT])
        gear(
        twist = _gearTwist, 
        number_of_teeth=_teeth, 
        circular_pitch=_circularPitch, 
        gear_thickness = (_gearThickness/2)+AT, 
        rim_thickness = (_gearThickness/2)+AT, 
        rim_width = _gearRadius,
        hub_diameter = _hubDiameter,
        hub_thickness = _hubThickness + (_gearThickness/2)+AT, 
        bore_diameter = 0); 
        
        translate([0,0,(_gearThickness/2) + AT])
        rotate([180,0,0]) 
        gear(
        twist = -_gearTwist, 
        number_of_teeth=_teeth, 
        circular_pitch=_circularPitch, 
        gear_thickness = (_gearThickness/2)+AT, 
        rim_thickness = (_gearThickness/2)+AT,
        rim_width = _gearRadius,
        hub_diameter = _hubDiameter, 
        hub_thickness = 0, 
        bore_diameter = 0); 
    }
}

module gearWithInverseTwist(_teeth, _gearTwist, _circularPitch, _gearThickness, _gearRadius, _hubDiameter, _hubThickness) {
    
    union() {
        
        translate([0,0,(_gearThickness/2) - TT])
        gear(
        twist = -_gearTwist, 
        number_of_teeth=_teeth, 
        circular_pitch=_circularPitch, 
        gear_thickness = (_gearThickness/2)+AT, 
        rim_thickness = (_gearThickness/2)+AT, 
        rim_width = _gearRadius,
        hub_diameter = _hubDiameter,
        hub_thickness = _hubThickness + (_gearThickness/2)+AT, 
        bore_diameter = 0); 
        
        translate([0,0,(_gearThickness/2) + AT])
        rotate([180,0,0]) 
        gear(
        twist = _gearTwist, 
        number_of_teeth=_teeth, 
        circular_pitch=_circularPitch, 
        gear_thickness = (_gearThickness/2)+AT, 
        rim_thickness = (_gearThickness/2)+AT,
        rim_width = _gearRadius,
        hub_diameter = _hubDiameter, 
        hub_thickness = 0, 
        bore_diameter = 0); 
    }
}