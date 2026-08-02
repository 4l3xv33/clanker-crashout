package systems;

import flash.net.SharedObject;

class SaveManager {
    var store:SharedObject;
    public var settings:GameSettings;
    public var highestFloor:Int = 0;

    public function new() {
        settings = new GameSettings();
        try {
            store = SharedObject.getLocal("error9to5-save-v2");
            if (store.data.highestFloor != null) highestFloor = Std.int(store.data.highestFloor);
            if (store.data.sound != null) settings.sound = store.data.sound;
            if (store.data.reducedMotion != null) settings.reducedMotion = store.data.reducedMotion;
            if (store.data.highContrast != null) settings.highContrast = store.data.highContrast;
            if (store.data.largeText != null) settings.largeText = store.data.largeText;
        } catch (_:Dynamic) {}
    }

    public function unlock(floor:Int):Void {
        if (floor > highestFloor) highestFloor = floor;
        persist();
    }

    public function persist():Void {
        if (store == null) return;
        try {
            store.data.highestFloor = highestFloor;
            store.data.sound = settings.sound;
            store.data.reducedMotion = settings.reducedMotion;
            store.data.highContrast = settings.highContrast;
            store.data.largeText = settings.largeText;
            store.flush();
        } catch (_:Dynamic) {}
    }
}
