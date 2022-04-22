//© 2022 Junqi Lu <jql2026@gmail.com>





//All the images need to be of the same scale (by fixing your camera from a height from all the mice) for this to work
//Scale is determined from 10 random images

//Directory structure: you need to have the 4 folders named as below below in 1 folder (whatever name) to work 
//inputs for original images
//allOverlays for all the traces overlaid on the original image 
//individualOverlaysTraceShown for 1 trace overlaid on the wound 
//individualOverlaysTraceNotShown for a minimum rectangle that fits the 1 trace overlaid on the wound but this image shows no trace at all; just the original wound cropped by the minimum rectangle that fits the trace 

macro "AddOverlaySelection [z]"{ //Overlay the selection on the image but doesn't change the image itself 
	//The overlaid selection won't be pixelized 
	//If you don't have a selection before this function, you'll have an error
	run("Add Selection..."); //Add the selection to overlay 
	
	//Format the labels 
	run("Overlay Options...", "stroke=none width=0 fill=none set show"); //Show the labels (aka the indexes of all the selections you made). These labels will be maintained if you save the selection as another image
	run("Labels...", "color=white font=24 show draw bold"); //The default labels aren't bolded. The bolded ones look better 
	//After flattening the selections, the text font for the labels will become smaller. If it's too small for you to read, just increase the font size in the line above
}




macro "IterateAllOverlaySelection [c]"{ //The main function that allows the user to make selections, measure all, and save all as individual images
	run("Set Scale...", "distance=158.2044 known=1 unit=cm global"); //Set the scale. 158.1444 for 1 cm is determined by the average from 10 randomly picked images
	//Use "global" to ensure that the scale gets carried over when the current input image is closed and you opened the next one
	
	//Save a screenshot of the original image with all the overlays. If you keep running this section, new generated images will overwrite the old one with the same name
	//For this section to run successfully, you need to have 2 folders called allOverlays and individualOverlays in the parent directory of the input image's directory 
	
	//Get original file name
	file=split(getTitle(),".");
	file_name=file[0];

	//Get the current working directory 
	input_img_directory=getDirectory("image"); //This is the directory that the original input image is located in 
	parent_directory=input_img_directory+"\.."; //This is the parent folder of input_img_directory 





	


	//Measure and save all the selections individual 
	run("To ROI Manager"); //Save all the selections into the ROI manager
	ROI_count=roiManager("count"); //Get the number of ROI in the manager to prepare for the iteration
	for(i=0;i<ROI_count;i++){
		//All the ROIs' names are in the format of "count-4digit" so the original order of ROIs is correct  
		roiManager("Select",i); //Select each ROI by order
		roiManager("Rename",i+1); //Rename because the original name has a random 4-digit number as part of it. i+1 because the wound index should start from 1 from a biological perspective

		roiManager("Measure"); //Measure the area of that ROI. ROI's name will be part of the label in the measurement chart

		//Save the wound cropped by the minimum rectangle that fits the trace without the trace
		run("Duplicate...", "title=Selection");
		index=""+i+1; //This is the method of how you convert i+1 into a string 
		saveAs("Jpeg", parent_directory+"\\individualOverlaysTraceNotShown\\"+file_name+"_individualOverlaysTraceNotShown_woundIdx"+index+".jpg"); //This won't save the original overlay since it's a new image now. But it doesn't matter since you have saved a comprehensive view of all the overlays
		

		//Save the wound cropped by the minimum rectangle that fits the trace with the trace
		//run("Fit Rectangle"); //Fit a minimum rectangle around a selection -> Don't use this function. Otherwise the trace shown in the final saved image is the minimum-fit rectangle
		run("Flatten"); //This generates another window called in a name that I can't control but starts with Selection. You must have the flatten command. Otherwise the trace won't be shown on the saved image
		//The flatten only occurs on the Duplicated area so it doesn't influence the original image
		
		index=""+i+1; //This is the method of how you convert i+1 into a string 
		saveAs("Jpeg", parent_directory+"\\individualOverlaysTraceShown\\"+file_name+"_individualOverlaysTraceShown_woundIdx"+index+".jpg"); //This won't save the original overlay since it's a new image now. But it doesn't matter since you have saved a comprehensive view of all the overlays
		close(getTitle()); //Close that flatten window whose name is hard to control 
		close("Selection"); //Close the Selection window whose name is always Selection 
	}

	








	//Save the flatten image. I put this in the end because flatten command will slightly influence the image quality
	run("Flatten"); //Create a new of the original image with all the overlaid selections and their labels. Without this command, the trace won't be shown on the image
	saveAs("Jpeg", parent_directory+"\\allOverlays\\"+file_name+"_allOverlays.jpg"); //This also changes the window's title into flatten_img_name. To close this window, you need close(flatten_img_name); than close(file_name);
	close(getTitle());


	selectWindow("ROI Manager");
    run("Close"); //Close the ROI Manager window



	close(); //Force close the image since you've done with the image now. This won't influence the ROI Manager and the Results window 
}



