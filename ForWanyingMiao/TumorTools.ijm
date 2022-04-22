//© 2022 Junqi Lu <jql2026@gmail.com>
//Specifically designed for Dr. Wanying Miao's needs

macro "TumorMeasure [t]"{	
	//Written for Wanying Miao, MD/PHD to increase her efficiency
	
	//Set the scale
	setTool("Line");

	waitForUser('Draw a line for seeting the scale', 'Draw a line for 1 cm');

	run("Set Scale...","known=1 unit=cm");

	//Select area to save 
	setTool("Rectangle");

	getPixelSize(unit, pixelWidth, pixelHeight);
	
	makeRectangle(0, 0, 6*(1/pixelWidth), 4*(1/pixelWidth)); //width & length are in pixels

	waitForUser("Move the rectangle", "Move the rectangle to the desired area to save");

	//Save the selected area
	save_directory="C:/Users/14127/Desktop/TumorImages/"

	file=split(getTitle(),".")
	file_name=file[0];
	run("Duplicate...","title=Selection");
	
	saveAs("Tiff", save_directory+file_name+"_Selection.tif");
	close("Selection");
	close();

	
}


