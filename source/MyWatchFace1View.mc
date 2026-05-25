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
        var battery = stats.battery;
        var batteryPercentage = battery.format("%d");

        // Update battery view
        var batteryView = View.findDrawableById("BatteryLabel") as Text;
        batteryView.setColor(Application.Properties.getValue("ForegroundColor") as Number);
        batteryView.setText(Lang.format("$1$%", [batteryPercentage]));

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        var settings = System.getDeviceSettings();

        // Draw connectivity icon
        if (settings.phoneConnected) {
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
            var bx = dc.getWidth() / 2 - 10;
            var by = dc.getHeight() * 0.10;
            // Simple Bluetooth-like icon using lines
            dc.drawLine(bx, by, bx, by + 10);
            dc.drawLine(bx, by, bx + 5, by + 3);
            dc.drawLine(bx + 5, by + 3, bx - 5, by + 7);
            dc.drawLine(bx - 5, by + 3, bx + 5, by + 7);
            dc.drawLine(bx + 5, by + 7, bx, by + 10);
        }

        // Draw notification count
        if (settings.notificationCount > 0) {
            dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
            var nx = dc.getWidth() / 2 + 10;
            var ny = dc.getHeight() * 0.10;
            dc.drawCircle(nx, ny + 5, 6);
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
            dc.drawText(nx, ny + 5, Graphics.FONT_XTINY, settings.notificationCount.toString(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }

        // Draw battery icon
        var batteryColor = Graphics.COLOR_GREEN;
        if (battery <= 20) {
            batteryColor = Graphics.COLOR_RED;
        } else if (battery <= 50) {
            batteryColor = Graphics.COLOR_YELLOW;
        }

        dc.setColor(batteryColor, Graphics.COLOR_TRANSPARENT);
        // Position it near the battery label (y="78%")
        var x = dc.getWidth() / 2 - 40;
        var y = dc.getHeight() * 0.78 - 10;
        dc.drawRectangle(x, y, 20, 10);
        dc.fillRectangle(x + 2, y + 2, (16 * (battery / 100.0)).toNumber(), 6);
        dc.fillRectangle(x + 20, y + 3, 2, 4);
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
