package ui;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.filters.GlowFilter;
import flash.geom.Point;
import flash.geom.Rectangle;

@:bitmap("assets/game/production/evidence/evidence-icons-runtime.png")
private class EvidenceIconSheet extends BitmapData {}

class EvidenceIcon extends Sprite {
    static inline var FRAME_SIZE:Int=192;
    static inline var ART_SCALE:Float=.38;

    public function new(index:Int,accent:Int) {
        super();
        var sheet=new EvidenceIconSheet(0,0);
        var frame=new BitmapData(FRAME_SIZE,FRAME_SIZE,true,0);
        frame.copyPixels(sheet,new Rectangle((index%3)*FRAME_SIZE,0,FRAME_SIZE,FRAME_SIZE),new Point());
        sheet.dispose();
        var art=new Bitmap(frame);art.smoothing=true;art.scaleX=art.scaleY=ART_SCALE;art.x=-FRAME_SIZE*ART_SCALE/2;art.y=20-FRAME_SIZE*ART_SCALE;addChild(art);
        filters=[new GlowFilter(0x20BFFF,.72,10,10,1.7,2,false,false)];
        var tag=Theme.field(11,accent,true);tag.text="E"+(index+1);tag.x=-14;tag.y=20;tag.width=28;tag.height=18;addChild(tag);
    }
}
