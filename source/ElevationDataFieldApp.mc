using Toybox.Application as App;
using Toybox.System as Sys;

//  Realeases :
//   12/07/2015 - mog82 - v1.0

class ElevationDataFieldApp extends App.AppBase {

    //! onStart() is called on application start up
    function onStart() {
 //  		Sys.println("ElevationDataFieldApp : onStart");   	
    }

    //! onStop() is called when your application is exiting
    function onStop() {
//   		Sys.println("ElevationDataFieldApp : onStop");   	
    }

    //! Return the initial view of your application here
    function getInitialView() {
//   		Sys.println("ElevationDataFieldApp : getInitialView");   	
        return [ new ElevationDataFieldView() ];
    }

}