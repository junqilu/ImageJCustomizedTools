//© 2022 Junqi Lu <jql2026@gmail.com>
//This one works if you need to set the scale for each image individually

macro "SetScale [q]"{ //Press Q key will call on this macro
	//You put a straight line first and this macro will set that straightline as 1 

	run("Set Scale...", "known=1 unit=unit");
	setTool("freehand"); //Automatically change to the freehand tool so you can start tracing the wounds
}

macro "ToggleTools [n]"{ //Toggle between line and freehand
	if (IJ.getToolName()=="line"){
	setTool("freehand");
	}else if (IJ.getToolName()=="freehand"){
		setTool("line");
	}else{
	}
}

function GetCurrentTime(){
	getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
	
	TimeString ="";
	
	if (hour<10) {TimeString = TimeString+"0";}
	TimeString = TimeString+hour+"-";
	if (minute<10) {TimeString = TimeString+"0";}
	TimeString = TimeString+minute+"-";
	if (second<10) {TimeString = TimeString+"0";}
	TimeString = TimeString+second+"-"+msec;
	
	return TimeString;
}

function SaveSelectedArea(){ // Save the current selected area
	save_directory="C:/Users/jl922/Desktop/Output/"

	//Get original file name
	file=split(getTitle(),".");
	file_name=file[0];
	file_extension=file[1];

	time_label=GetCurrentTime(); //Generate a time label so files can be told from each other
	
	run("Duplicate...", "title=Selection");
	saveAs("Jpeg", save_directory+file_name+"_Selection_"+time_label+".jpg");
	close("Selection");
}

function GetScaleInfo(){
	getPixelSize(unit, pixelWidth, pixelHeight);
	return 1/pixelWidth; //This is the number of pixels/unit, like pixels/cm if you use cm
	
//	print("Scale: "+1/pixelWidth+" pixels/"+unit);
}

macro "SaveSelectedAreaWithScale [c]"{
	number_unit_wanted=0.5; //By default my unit is cm 
	scale=GetScaleInfo(); //Obtain the factor to convert the number_unit_wanted to pixels on the image 

	setTool("rectangle");
	getCursorLoc(x, y, z, modifiers);
	makeRectangle(x, y, scale*number_unit_wanted, scale*number_unit_wanted);
	//After you set the scale using cm, if you want to get a 1 cm by 1 cm square, you should use makeRectangle(x, y, scale*1, scale*1); where 1 is for "1 cm". So if you want a 0.5 cm by 0.5 cm square, just replace the 1 by 0.5 

	waitForUser("Click inside the selected area to move it. Click OK once you get the ideal selection");
	
	SaveSelectedArea();
}


macro "ForceClose [w]"{ //Force to close without saving any changes on the image. This speeds up the closing process
	close();
}







