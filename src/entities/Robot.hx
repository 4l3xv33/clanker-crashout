package entities;

import entities.WorldArt.BossSheet;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.ColorTransform;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFormat;

class Robot extends Sprite {
    static inline var FRAME_SIZE:Int=384;
    static inline var ART_SCALE:Float=.48;
    var art:Bitmap;
    var restoredMark:Sprite;
    var time:Float=0;
    public var restored:Bool=false;

    public function new(accent:Int,name:String,index:Int) {super();drawRobot(name,index);}

    function drawRobot(name:String,index:Int):Void {
        var sheet=new BossSheet(0,0);var frame=new BitmapData(FRAME_SIZE,FRAME_SIZE,true,0);frame.copyPixels(sheet,new Rectangle((index%5)*FRAME_SIZE,0,FRAME_SIZE,FRAME_SIZE),new Point());sheet.dispose();
        art=new Bitmap(frame);art.smoothing=true;art.scaleX=art.scaleY=ART_SCALE;art.x=-FRAME_SIZE*ART_SCALE/2;art.y=44-372*ART_SCALE;addChild(art);
        var label=new TextField();label.defaultTextFormat=new TextFormat("_sans",12,0xF3F6FB,true);label.text=name;label.width=130;label.x=-65;label.y=49;label.selectable=false;addChild(label);
        restoredMark=new Sprite();restoredMark.visible=false;restoredMark.x=58;restoredMark.y=-102;var g=restoredMark.graphics;g.beginFill(0x0A1720,.92);g.drawCircle(0,0,19);g.endFill();g.lineStyle(4,0x72F1B8);g.drawCircle(0,0,18);g.moveTo(-9,0);g.lineTo(-3,7);g.lineTo(11,-9);addChild(restoredMark);
    }

    public function update(dt:Float,reducedMotion:Bool):Void {time+=dt;if(!reducedMotion&&!restored){art.alpha=.9+Math.sin(time*8)*.1;rotation=Math.sin(time*4)*.6;}else {rotation=0;art.alpha=1;}}
    public function restore():Void {restored=true;art.transform.colorTransform=new ColorTransform(.9,1.08,.95,1,0,8,2,0);restoredMark.visible=true;alpha=1;}
}
