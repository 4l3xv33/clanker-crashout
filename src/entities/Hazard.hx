package entities;

import entities.WorldArt.EnemySheet;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.ColorTransform;
import flash.geom.Point;
import flash.geom.Rectangle;

class Hazard {
    static inline var FRAME_SIZE:Int=192;
    static inline var ART_SCALE:Float=.48;
    public var sprite:Sprite;
    public var minX:Float;
    public var maxX:Float;
    public var dir:Float=1;
    public var phase:Float;
    public var failureName:String;
    public var disabled:Bool=false;
    var speed:Float;
    var art:Bitmap;
    var warning:Sprite;

    public function new(accent:Int,x:Float,minX:Float,maxX:Float,kind:Int,failureType:Int) {
        this.minX=minX;this.maxX=maxX;phase=Math.random()*6.28;sprite=new Sprite();sprite.x=x;
        var names=["HALLUCINATION PROCESS","BIAS PROXY","PERSUASION BOT","PROVENANCE SCRAPER","RUNAWAY OPTIMIZER"];
        var speeds=[60.0,66.0,74.0,68.0,82.0];failureName=names[failureType%names.length];speed=speeds[failureType%speeds.length];draw(kind,accent);
    }

    function draw(kind:Int,accent:Int):Void {
        warning=new Sprite();var wg=warning.graphics;wg.lineStyle(2,0xFF3AA7,.72);wg.drawEllipse(-30,12,60,13);wg.moveTo(-24,18);wg.lineTo(-18,11);wg.moveTo(24,18);wg.lineTo(18,11);sprite.addChild(warning);
        var sheet=new EnemySheet(0,0);var frame=new BitmapData(FRAME_SIZE,FRAME_SIZE,true,0);frame.copyPixels(sheet,new Rectangle((kind%6)*FRAME_SIZE,0,FRAME_SIZE,FRAME_SIZE),new Point());sheet.dispose();
        art=new Bitmap(frame);art.smoothing=true;art.scaleX=art.scaleY=ART_SCALE;art.x=-FRAME_SIZE*ART_SCALE/2;art.y=23-182*ART_SCALE;sprite.addChild(art);
    }

    public function update(dt:Float,ground:Float,reducedMotion:Bool):Void {
        phase+=dt;if(!disabled)sprite.x+=dir*speed*dt;
        if(sprite.x<=minX){sprite.x=minX;dir=1;}else if(sprite.x>=maxX){sprite.x=maxX;dir=-1;}
        sprite.y=ground-23;sprite.rotation=0;warning.alpha=disabled ? .18 : (reducedMotion ? .72 : .55+Math.sin(phase*7)*.25);
    }
    public function disable():Void {disabled=true;art.transform.colorTransform=new ColorTransform(.65,1.08,.82,.62,0,18,5,0);sprite.alpha=.62;}
}
