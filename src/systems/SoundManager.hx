package systems;

import flash.media.Sound;
import flash.utils.ByteArray;
import flash.events.SampleDataEvent;

class SoundManager {
    public var enabled:Bool = true;
    public var musicLevel:Int = 2;
    public var effectsLevel:Int = 2;
    var sound:Sound;
    var ambience:Sound;
    var phase:Float = 0;
    var ambientPhase:Float = 0;
    var ambientStep:Int = 0;
    var remaining:Int = 0;
    var frequency:Float = 440;
    var volume:Float = .12;

    public function new() {
        sound = new Sound();
        sound.addEventListener(SampleDataEvent.SAMPLE_DATA, sample);
        ambience = new Sound();
        ambience.addEventListener(SampleDataEvent.SAMPLE_DATA, ambientSample);
        try ambience.play() catch (_:Dynamic) {}
    }

    public function setFloor(index:Int):Void ambientStep=index;

    public function play(kind:String):Void {
        if (!enabled || effectsLevel==0) return;
        switch kind {
            case "jump": tone(320,.07,.09);
            case "evidence": tone(720,.14,.12);
            case "correct": tone(880,.18,.12);
            case "wrong": tone(150,.2,.11);
            case "repair": tone(540,.32,.1);
            case "damage": tone(105,.16,.12);
            default: tone(440,.06,.08);
        }
    }

    function tone(hz:Float, seconds:Float, amplitude:Float):Void {
        frequency = hz; volume = amplitude; remaining = Std.int(44100*seconds); phase = 0;
        try sound.play() catch (_:Dynamic) {}
    }

    function sample(e:SampleDataEvent):Void {
        var count = remaining > 2048 ? 2048 : remaining;
        for (i in 0...count) {
            var envelope = remaining < 500 ? remaining/500 : 1;
            var v = Math.sin(phase)*volume*envelope*(effectsLevel==1 ? .45 : 1);
            e.data.writeFloat(v); e.data.writeFloat(v);
            phase += Math.PI*2*frequency/44100;
        }
        remaining -= count;
        if (remaining < 0) remaining = 0;
    }

    function ambientSample(e:SampleDataEvent):Void {
        var roots=[82.41,98.0,110.0,123.47,73.42],root=roots[ambientStep%roots.length];
        for(i in 0...2048){var pulse=.55+.45*Math.sin(ambientPhase*.0037);var v=enabled&&musicLevel>0 ? (Math.sin(ambientPhase)+Math.sin(ambientPhase*1.5)*.34)*.012*pulse*(musicLevel==1 ? .45 : 1) : 0.0;e.data.writeFloat(v);e.data.writeFloat(v);ambientPhase+=Math.PI*2*root/44100;}
    }
}
