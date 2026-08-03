package systems;

import flash.net.SharedObject;

class SaveManager {
    var store:SharedObject;
    public var settings:GameSettings;
    public var highestFloor:Int = 0;
    public var bestScore:Array<Int> = [0,0,0,0,0];
    public var bestTime:Array<Int> = [0,0,0,0,0];
    public var modelCards:Array<Bool> = [false,false,false,false,false];
    public var challenges:Array<Bool> = [false,false,false,false,false];

    public function new() {
        settings = new GameSettings();
        try {
            store = SharedObject.getLocal("error9to5-save-v2");
            if (store.data.highestFloor != null) highestFloor = Std.int(store.data.highestFloor);
            if (store.data.sound != null) settings.sound = store.data.sound;
            if (store.data.musicLevel != null) settings.musicLevel = Std.int(store.data.musicLevel);
            if (store.data.effectsLevel != null) settings.effectsLevel = Std.int(store.data.effectsLevel);
            if (store.data.reducedMotion != null) settings.reducedMotion = store.data.reducedMotion;
            if (store.data.highContrast != null) settings.highContrast = store.data.highContrast;
            if (store.data.largeText != null) settings.largeText = store.data.largeText;
            if (store.data.largeControls != null) settings.largeControls = store.data.largeControls;
            if (store.data.lowEffects != null) settings.lowEffects = store.data.lowEffects;
            loadInts(store.data.bestScore,bestScore);
            loadInts(store.data.bestTime,bestTime);
            loadBools(store.data.modelCards,modelCards);
            loadBools(store.data.challenges,challenges);
        } catch (_:Dynamic) {}
    }

    public function unlock(floor:Int):Void {
        if (floor > highestFloor) highestFloor = floor;
        persist();
    }

    public function recordFloor(floor:Int,score:Int,seconds:Int,challenge:Bool):Void {
        if(score>bestScore[floor])bestScore[floor]=score;
        if(bestTime[floor]==0||seconds<bestTime[floor])bestTime[floor]=seconds;
        modelCards[floor]=true;if(challenge)challenges[floor]=true;unlock(Std.int(Math.min(4,floor+1)));persist();
    }

    public function grade(floor:Int):String {var score=bestScore[floor];return score>=900?"S":score>=800?"A":score>=650?"B":score>0?"C":"—";}
    public function completed():Int {var total=0;for(value in modelCards)if(value)total++;return total;}

    function loadInts(source:Dynamic,target:Array<Int>):Void {if(source==null)return;try{var values:Array<Dynamic>=cast source;for(i in 0...target.length)if(i<values.length&&values[i]!=null)target[i]=Std.int(values[i]);}catch(_:Dynamic){}}
    function loadBools(source:Dynamic,target:Array<Bool>):Void {if(source==null)return;try{var values:Array<Dynamic>=cast source;for(i in 0...target.length)if(i<values.length&&values[i]!=null)target[i]=values[i];}catch(_:Dynamic){}}

    public function persist():Void {
        if (store == null) return;
        try {
            store.data.highestFloor = highestFloor;
            store.data.sound = settings.sound;
            store.data.musicLevel = settings.musicLevel;
            store.data.effectsLevel = settings.effectsLevel;
            store.data.reducedMotion = settings.reducedMotion;
            store.data.highContrast = settings.highContrast;
            store.data.largeText = settings.largeText;
            store.data.largeControls = settings.largeControls;
            store.data.lowEffects = settings.lowEffects;
            store.data.bestScore = bestScore;
            store.data.bestTime = bestTime;
            store.data.modelCards = modelCards;
            store.data.challenges = challenges;
            store.flush();
        } catch (_:Dynamic) {}
    }
}
