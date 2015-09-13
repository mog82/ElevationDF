using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Time as Time;

// TODO
// - Fait : Vérifier pieds/metre

class ElevationManager {

 	// Attributs
    var ascent = null;
    var descent = null;
    var altitude = null;

	// Paramétrage pour calcul dénivelé
    hidden var offset = 2.75;

	// Paramétrage du dessin des icones
	hidden var nbBars = 4;		
	hidden var hBar   = 3;
	hidden var eBar   = 1;
	hidden var off    = nbBars*(hBar+eBar);
	
	// Préférences utilisateur
	hidden var conversion; // pour convertir metres en pieds

    // Pour mémorisation    
    hidden var lastAltitude = null;
	hidden var isStarted 	 = false;
	hidden var noBarAscent  = nbBars-1;
	hidden var noBarDescent = 0;


    // Initialise les variables
	//
	//  Realeases :
	//   12/07/2015 - mog82 - v1.0

    function initialize() {
		conversion = (System.getDeviceSettings().elevationUnits == Sys.UNIT_METRIC) ? 1.0 : 3.2808399;
	}
	
	// Calcul le denivelé positif et négatif en fonction des nouvelles données
	//
	//  Realeases :
	//   12/07/2015 - mog82 - v1.0

	function compute (elevation, startTime) {
	
		// Altitude valide
		if (elevation != null  && elevation.abs() < 5000.0) {
			if (!isStarted) {
			
			    // Traitement du 1er point
				if (startTime != null) {
					isStarted = true;					
					lastAltitude = elevation;
					altitude = elevation;
     				ascent = 0.0;
     				descent = 0.0;
					
				// En attente de démarrage
				} else {
					altitude = elevation;			
				}
				
			// Traitement du Nième point
			} else {			
    			var delta = elevation - lastAltitude;
    				
    			// Incrément dénivelé positif à faire
    			if (delta > offset ) {
    				ascent = ascent + delta;
    				lastAltitude = elevation;
    					
    			// Incément dénivelé négatif à faire
    			} else if (-delta > offset) {
    				descent = descent - delta;
    				lastAltitude = elevation;
    			}  			
				altitude = elevation;			
			}
			
		// Altitude invalide
		// } else {
			// Ne rien faire
		}
	
 	}  // End function compute


	
	// Dessine la valeur en formattant les milliers en petit et en haut avec les paramètres suivants :
	//  x, y : abscisse et ordonnée du coin en haut et à gauche de la zone d'affichage
    //  w, h : largeur et hauteur de la zone d'affichage
	//  font0 : police des centaines, dizaines et unités
    //  font1 : police des milliers
	//  value : valeur à afficher
	//
	//  Realeases :
	//   12/07/2015 - mog82 - v1.0

	function drawValue (dc, x, y, w, h, font0, font1, value) {       
    	var text;
    	var text1; // Texte des milliers
    	var text2; // Texte des centaines, dizaines et unités
    	
    	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
    	
		text = (value == null) ? "__" : ((value == null) ? null : value*conversion).format("%d");
    	
    	// La valeur est supérieure à 999    	    	
    	if (text.length() > 3) {
    		text1 = text.substring(text.length()-3, text.length());
    		text2 = text.substring(0, text.length()-3);
    		dc.drawText(x+w-2-dc.getTextWidthInPixels(text1, font1), y+h/2-2-dc.getFontHeight(font1)/2, font0, text2, Gfx.TEXT_JUSTIFY_RIGHT);   	

		// La valeur est inférieure ou égale à 99
    	} else {
    		text1 = text;
    	}
    	
    	dc.drawText(x+w-2, y+h/2-2, font1, text1, Gfx.TEXT_JUSTIFY_RIGHT | Gfx.TEXT_JUSTIFY_VCENTER);
    }
    


    // Dessine le logo du dénivelé positif avec les paramètres suivants :
	//  x, y : abscisse et ordonnée du coin en haut et à gauche de la zone d'affichage
    //  w, h : largeur et hauteur de la zone d'affichage
	//  l    : largeur de la fleche = 2*l+1
	//
	//  Realeases :
	//   12/07/2015 - mog82 - v1.0

    function drawAscentIcon (dc, x, y, w, h, l) {

    	dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_DK_RED);
		dc.fillPolygon([[x+2, y+h-2-off], [x+2+2*l+1, y+h-2-off], [x+2+l, y+h-2-2*l-1-off]]);
 		 
		noBarAscent = (noBarAscent > 0) ? noBarAscent-1 : nbBars-1;
    	for (var i=0; i<nbBars; i += 1) {
    		if (i != noBarAscent) {
    			dc.fillRectangle(x+2+1, y+h-2-i*(hBar+eBar)-hBar, 2*l+1-2, hBar);
    		}
    	}
    	
	} // end function drawAscentIcon



    // Dessine le logo du dénivelé négatif
	//  x, y : abscisse et ordonnée du coin en haut et à gauche de la zone d'affichage
    //  w, h : largeur et hauteur de la zone d'affichage
	//  l    : largeur de la fleche = 2*l+1
	//
	//  Realeases :
	//   12/07/2015 - mog82 - v1.0

    function drawDescentIcon (dc, x, y, w, h, l) {
		dc.setColor(Gfx.COLOR_DK_GREEN, Gfx.COLOR_DK_GREEN);
		dc.fillPolygon([[x+2, y+h-2-2*l-1], [x+2+2*l+1, y+h-2-2*l-1], [x+2+l, y+h-2]]);
		
		noBarDescent = (noBarDescent < nbBars-1) ? noBarDescent+1 : 0;
    	for (var i=0; i<nbBars; i += 1) {
    		if (i != noBarDescent) {
    			dc.fillRectangle(x+3, y+h-2-i*(hBar+eBar)-eBar-off, 2*l+1-2, hBar);
    		}
    	} // end for

    } // end function drawDescentIcon
		
}