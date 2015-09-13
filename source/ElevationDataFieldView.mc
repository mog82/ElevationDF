using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class ElevationDataFieldView extends Ui.DataField {

    hidden var xa;
    hidden var xb;
	hidden var h;
    hidden var w;
    hidden var font0 = Gfx.FONT_NUMBER_MILD;
    hidden var font1 = Gfx.FONT_NUMBER_MEDIUM;
    hidden var iconSize;
     
    hidden var elevationManager;
    
    //! Constructeur
	//
	//  Realeases :
	//   12/07/2015 - mog82 - v1.0

    function initialize() {      
        elevationManager = new ElevationManager();
	}  


    
    //! For datafields, if the size changed since the last onUpdate(), onLayout() will be called prior to onUpdate(). 
	//
	//  Realeases :
	//   12/07/2015 - mog82 - v1.0

    function onLayout(dc){
    	h = dc.getHeight();
     	w = dc.getWidth();
     	
    	if (h < 55) {
    		xa = w/3 - 1;
    		xb = (w*2)/3 - 1;
    		font1 = Gfx.FONT_NUMBER_MEDIUM;
    		iconSize = 6;
    	} else {
    		xa = w/2;
    		xb = w;
    		font1 = Gfx.FONT_NUMBER_HOT;
    		iconSize = 10;
    	}
    }


    
    //! The system will call the onUpdate() method inherited from View when the field is displayed by the system.
	//
	//  Realeases :
	//   12/07/2015 - mog82 - v1.0

    function onUpdate(dc) {
    	
    	// set the view background to white
   		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
		dc.clear();
		
		// set the color for the separation
   		dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_WHITE);
   		dc.setPenWidth(3);
   		dc.drawLine(xa, 0, xa, h);
   		
        // 3 DataFieds
   		if (h < 55) {
   			dc.drawLine(xb, 0, xb, h);
   			
   			// denivelé negatif
   			elevationManager.drawDescentIcon (dc, xb, 0, w-xb, h, iconSize);  			
			elevationManager.drawValue       (dc, xb, 0, w-xb, h, font0, font1, elevationManager.descent);   			
   		}
   		
   		// denivelé positif
		elevationManager.drawAscentIcon (dc, 0, 0, xa, h, iconSize);
        elevationManager.drawValue      (dc, 0, 0, xa, h, font0, font1, elevationManager.ascent);
   				
		// altitude		
        elevationManager.drawValue (dc, xa, 0, xb-xa, h, font0, font1, elevationManager.altitude);
         		    	
    }



    //! Appelée toutes les secondes avec Activity.Info
	//
	//  Realeases :
	//   12/07/2015 - mog82 - v1.0

    function compute(info) {    
    	elevationManager.compute(info.altitude, info.startTime);
    }

}