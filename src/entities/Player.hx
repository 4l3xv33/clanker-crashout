package entities;

import entities.PlayerArt.DamageArt;
import entities.PlayerArt.InteractArt;
import entities.PlayerArt.JumpArt;
import entities.PlayerArt.RunArt;
import entities.PlayerArt.ScanArt;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;

class Player extends Sprite {
    public var vx:Float = 0;
    public var vy:Float = 0;
    public var grounded:Bool = false;
    public var coyote:Float = 0;
    public var jumpBuffer:Float = 0;
    public var facing:Int = 1;
    static inline var FRAME_SIZE:Int = 256;
    static inline var ART_SCALE:Float = .46;
    var art:Bitmap;
    var animations:Map<String,Array<BitmapData>>;
    var current:String = "";
    var forced:String = "";
    var frameIndex:Int = 0;
    var frameClock:Float = 0;
    var scannerActive:Bool = false;

    public function new() {
        super();
        animations = new Map();
        animations.set("run", slice(new RunArt(0,0), 8));
        animations.set("jump", slice(new JumpArt(0,0), 6));
        animations.set("interact", slice(new InteractArt(0,0), 6));
        animations.set("scan", slice(new ScanArt(0,0), 6));
        animations.set("damage", slice(new DamageArt(0,0), 4));
        animations.set("idle", [animations.get("interact")[0]]);
        art = new Bitmap(animations.get("idle")[0]);
        art.smoothing = true;
        art.scaleX = art.scaleY = ART_SCALE;
        art.x = -FRAME_SIZE * ART_SCALE / 2;
        art.y = 40 - 240 * ART_SCALE;
        addChild(art);
        current = "idle";
    }

    function slice(sheet:BitmapData, count:Int):Array<BitmapData> {
        var result:Array<BitmapData> = [];
        for (i in 0...count) {
            var frame = new BitmapData(FRAME_SIZE, FRAME_SIZE, true, 0);
            frame.copyPixels(sheet, new Rectangle(i * FRAME_SIZE, 0, FRAME_SIZE, FRAME_SIZE), new Point(0,0));
            result.push(frame);
        }
        sheet.dispose();
        return result;
    }

    public function animate(dt:Float, moving:Bool, scanning:Bool, reducedMotion:Bool):Void {
        scaleX = facing;
        scannerActive = scannerActive || scanning;
        var desired = forced != "" ? forced : (!grounded ? "jump" : (scannerActive ? "scan" : (moving ? "run" : "idle")));
        if (desired != current) select(desired);
        if (!reducedMotion) advance(dt);
        scannerActive = false;
    }

    function select(name:String):Void {
        current = name;
        frameIndex = 0;
        frameClock = 0;
        showFrame();
    }

    function advance(dt:Float):Void {
        var fps = switch current {case "run":12;case "jump":10;case "interact":10;case "scan":8;case "damage":12;default:0;}
        if (fps == 0) return;
        frameClock += dt;
        var frames = animations.get(current);
        while (frameClock >= 1 / fps) {
            frameClock -= 1 / fps;
            frameIndex++;
            if (frameIndex >= frames.length) {
                if (forced != "") {forced = "";frameIndex = frames.length - 1;}
                else if (current == "run" || current == "scan") frameIndex = 0;
                else frameIndex = frames.length - 1;
            }
            showFrame();
        }
    }

    function showFrame():Void art.bitmapData = animations.get(current)[frameIndex];

    public function playAction(name:String):Void {
        if (!animations.exists(name)) return;
        forced = name;
        select(name);
    }

    public function pulseScanner(active:Bool):Void scannerActive = active;
}
