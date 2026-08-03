package entities;

import entities.WorldArt.BossSheet;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.filters.GlowFilter;
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
    var corruptionNodes:Array<Sprite>=[];
    var time:Float=0;
    public var restored:Bool=false;

    public function new(accent:Int,name:String,index:Int) {super();drawRobot(name,index);}

    function drawRobot(name:String,index:Int):Void {
        var sheet=new BossSheet(0,0);var frame=new BitmapData(FRAME_SIZE,FRAME_SIZE,true,0);frame.copyPixels(sheet,new Rectangle((index%5)*FRAME_SIZE,0,FRAME_SIZE,FRAME_SIZE),new Point());sheet.dispose();
        art=new Bitmap(frame);art.smoothing=true;art.scaleX=art.scaleY=ART_SCALE;art.x=-FRAME_SIZE*ART_SCALE/2;art.y=44-372*ART_SCALE;addChild(art);
        var label=new TextField();label.defaultTextFormat=new TextFormat("_sans",12,0xF3F6FB,true);label.text=name;label.width=130;label.x=-65;label.y=49;label.selectable=false;addChild(label);
        restoredMark=new Sprite();restoredMark.visible=false;restoredMark.x=58;restoredMark.y=-102;var g=restoredMark.graphics;g.beginFill(0x0A1720,.92);g.drawCircle(0,0,19);g.endFill();g.lineStyle(4,0x72F1B8);g.drawCircle(0,0,18);g.moveTo(-9,0);g.lineTo(-3,7);g.lineTo(11,-9);addChild(restoredMark);
        var positions=[[-54.0,-88.0],[56.0,-52.0],[0.0,4.0]];for(i in 0...3){var node=new Sprite();node.x=positions[i][0];node.y=positions[i][1];var ng=node.graphics;ng.beginFill(0x190B20,.94);ng.drawCircle(0,0,11);ng.endFill();ng.lineStyle(3,0xFF3AA7);ng.drawCircle(0,0,10);ng.moveTo(-6,0);ng.lineTo(0,-6);ng.lineTo(6,1);ng.lineTo(1,7);ng.lineTo(-6,0);node.filters=[new GlowFilter(0xFF3AA7,.85,10,10,2,2,false,false)];addChild(node);corruptionNodes.push(node);}
    }

    public function update(dt:Float,reducedMotion:Bool):Void {time+=dt;if(!reducedMotion&&!restored){art.alpha=.9+Math.sin(time*8)*.1;rotation=Math.sin(time*4)*.6;for(i in 0...corruptionNodes.length)if(corruptionNodes[i].visible)corruptionNodes[i].scaleX=corruptionNodes[i].scaleY=1+Math.sin(time*6+i)*.08;}else {rotation=0;art.alpha=1;}}
    public function applyPatch(stage:Int):Void {if(stage>0&&stage<=corruptionNodes.length)corruptionNodes[stage-1].visible=false;art.transform.colorTransform=new ColorTransform(.94+stage*.015,1+stage*.02,.97+stage*.01,1,0,stage*2,stage,0);}
    public function restore():Void {restored=true;for(node in corruptionNodes)node.visible=false;art.transform.colorTransform=new ColorTransform(.9,1.08,.95,1,0,8,2,0);restoredMark.visible=true;alpha=1;}
}
