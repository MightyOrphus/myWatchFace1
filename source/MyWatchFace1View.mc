import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;

class MyWatchFace1View extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Get the current time and format it correctly
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } 
        var timeFormat = "$1$:$2$";
        if (Application.Properties.getValue("UseMilitaryFormat")) {
            timeFormat = "$1$$2$";
            hours = hours.format("%02d");
        }
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);

        // Update the view
        var view = View.findDrawableById("TimeLabel") as Text;
        view.setColor(Application.Properties.getValue("ForegroundColor") as Number);
        view.setText(timeString);

        // Get date info from the Toybox.Time.Gregorian package
        var info = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dateString = Lang.format("$1$ $2$", [info.day_of_week, info.day]);
        // Update date view
        var dateView = View.findDrawableById("DateLabel") as Text;
        dateView.setColor(Application.Properties.getValue("ForegroundColor") as Number);
        dateView.setText(dateString);

        // Get battery info
        var stats = System.getSystemStats();
        var batteryPercentage = stats.battery.format("%d");
        var estimatedDaysLeft = stats.batteryInDays.format("%d");

        // Update battery view
        var batteryView = View.findDrawableById("BatteryLabel") as Text;
        batteryView.setColor(Application.Properties.getValue("ForegroundColor") as Number);
        batteryView.setText(Lang.format("$1$% $2$ days", [batteryPercentage, estimatedDaysLeft]));

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
