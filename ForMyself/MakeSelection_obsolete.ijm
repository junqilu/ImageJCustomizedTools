//© 2022 Junqi Lu <jql2026@gmail.com>
//Obsolete because you can just use ROI manager to make multiple selections

end_count=6;
count = 0;
while (true){
	if (selectionType()<0){
		continue;
		wait(2000);
	}else{
		if (count < end_count){
		run("Measure");
		run("Select None"); //This deselects and makes selectionType() < 0 
	
		count += 1;
		}else{
			break;
		}
	}
	
}



