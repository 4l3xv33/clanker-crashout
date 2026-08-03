package entities;

import entities.WorldArt.CoworkerSheet;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.ColorTransform;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFormat;

class Coworker extends Sprite {
    static inline var FRAME_SIZE:Int=256;
    static inline var ART_SCALE:Float=.48;
    var art:Bitmap;
    var restoredMark:Sprite;

    public function new(accent:Int,name:String,role:String,index:Int) {
        super();
        var sheet=new CoworkerSheet(0,0);
        var frame=new BitmapData(FRAME_SIZE,FRAME_SIZE,true,0);
        frame.copyPixels(sheet,new Rectangle((index%5)*FRAME_SIZE,0,FRAME_SIZE,FRAME_SIZE),new Point());
        sheet.dispose();
        art=new Bitmap(frame);art.smoothing=true;art.scaleX=art.scaleY=ART_SCALE;art.x=-FRAME_SIZE*ART_SCALE/2;art.y=29-246*ART_SCALE;addChild(art);
        var t=new TextField();t.defaultTextFormat=new TextFormat("_sans",10,0xF3F6FB,true);t.text=name+"  /  "+role.toUpperCase();t.width=190;t.x=-95;t.y=34;t.selectable=false;t.alpha=.82;addChild(t);
        restoredMark=new Sprite();restoredMark.visible=false;restoredMark.x=42;restoredMark.y=-76;var g=restoredMark.graphics;g.beginFill(0x0A1720,.9);g.drawCircle(0,0,15);g.endFill();g.lineStyle(3,0x72F1B8);g.drawCircle(0,0,14);g.moveTo(-7,0);g.lineTo(-2,6);g.lineTo(8,-7);addChild(restoredMark);
        alpha=.72;
    }

    public function release():Void {alpha=1;art.transform.colorTransform=new ColorTransform(.93,1.08,.98,1,0,8,3,0);restoredMark.visible=true;}
}
