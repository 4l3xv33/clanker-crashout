package entities;

import entities.WorldArt.EnemySheet;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
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

    public function new(accent:Int,x:Float,minX:Float,maxX:Float,kind:Int) {
        this.minX=minX;this.maxX=maxX;phase=Math.random()*6.28;sprite=new Sprite();sprite.x=x;draw(kind);
    }

    function draw(kind:Int):Void {
        var sheet=new EnemySheet(0,0);var frame=new BitmapData(FRAME_SIZE,FRAME_SIZE,true,0);frame.copyPixels(sheet,new Rectangle((kind%6)*FRAME_SIZE,0,FRAME_SIZE,FRAME_SIZE),new Point());sheet.dispose();
        var art=new Bitmap(frame);art.smoothing=true;art.scaleX=art.scaleY=ART_SCALE;art.x=-FRAME_SIZE*ART_SCALE/2;art.y=23-182*ART_SCALE;sprite.addChild(art);
    }

    public function update(dt:Float,ground:Float,reducedMotion:Bool):Void {phase+=dt;sprite.x+=dir*68*dt;if(sprite.x<minX||sprite.x>maxX)dir*=-1;sprite.y=ground-23;sprite.rotation=0;}
}
