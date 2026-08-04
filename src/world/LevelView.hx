package world;

import data.FloorData;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.filters.GlowFilter;
import flash.geom.Rectangle;
import world.LevelArt.FloorFiveArt;
import world.LevelArt.FloorFourArt;
import world.LevelArt.FloorOneArt;
import world.LevelArt.FloorThreeArt;
import world.LevelArt.FloorTwoArt;

class LevelView extends Sprite {
    public static inline var WIDTH=2400;
    public static inline var GROUND=452;
    public var platforms:Array<Rectangle>=[];
    public var evidencePositions:Array<PointData>=[];
    public var robotX:Float=1830;
    public var exitX:Float=2370;

    public function new(data:FloorData,index:Int) {super();draw(data,index);}

    function draw(data:FloorData,index:Int):Void {
        var g=graphics;g.beginFill(0x060A12);g.drawRect(0,0,WIDTH,540);g.endFill();
        var background=new Bitmap(backgroundFor(index));background.x=0;background.y=56;background.smoothing=true;background.alpha=.9;addChild(background);
        var veil=new Sprite();var vg=veil.graphics;vg.beginFill(0x06101A,.14);vg.drawRect(0,56,WIDTH,396);vg.endFill();addChild(veil);
        var foreground=new Sprite();addChild(foreground);drawFloor(foreground,data);
        platforms=layout(index);for(p in platforms)if(p.y<GROUND)drawPlatform(foreground,p,data);
        evidencePositions=positions(index);
    }

    function backgroundFor(index:Int):BitmapData return switch index {case 0:new FloorOneArt(0,0);case 1:new FloorTwoArt(0,0);case 2:new FloorThreeArt(0,0);case 3:new FloorFourArt(0,0);default:new FloorFiveArt(0,0);}

    function drawFloor(layer:Sprite,data:FloorData):Void {
        var g=layer.graphics;g.beginFill(0x09101C,.96);g.drawRect(0,GROUND,WIDTH,88);g.endFill();g.beginFill(data.accent,.92);g.drawRect(0,GROUND,WIDTH,4);g.endFill();g.beginFill(0xDCE6F2,.25);g.drawRect(0,GROUND+5,WIDTH,2);g.endFill();
        for(i in 0...20){g.beginFill(data.secondary,.09);g.drawRect(i*130+45,GROUND+31,70,3);g.endFill();}
    }

    function drawPlatform(layer:Sprite,p:Rectangle,data:FloorData):Void {
        var platform=new Sprite();platform.x=p.x;platform.y=p.y;layer.addChild(platform);
        var g=platform.graphics;g.beginFill(0x081525,.99);g.drawRoundRect(0,0,p.width,p.height,6);g.endFill();g.lineStyle(2,0x5CDAFF,.92);g.drawRoundRect(0,0,p.width,p.height,6);g.beginFill(0x86E7FF,1);g.drawRect(5,0,p.width-10,3);g.endFill();g.beginFill(data.accent,.28);g.drawRect(12,7,p.width-24,5);g.endFill();
        platform.filters=[new GlowFilter(0x20BFFF,.9,12,12,2,2,false,false)];
    }

    function layout(index:Int):Array<Rectangle> return switch index {
        case 0:[ground(),new Rectangle(350,387,210,18),new Rectangle(690,330,190,18),new Rectangle(1010,388,220,18),new Rectangle(1330,322,190,18),new Rectangle(1570,380,150,18)];
        case 1:[ground(),new Rectangle(300,374,170,18),new Rectangle(610,306,210,18),new Rectangle(950,364,180,18),new Rectangle(1260,290,210,18),new Rectangle(1560,368,160,18)];
        case 2:[ground(),new Rectangle(360,392,190,18),new Rectangle(710,344,170,18),new Rectangle(980,292,210,18),new Rectangle(1305,357,190,18),new Rectangle(1580,310,150,18)];
        case 3:[ground(),new Rectangle(315,365,200,18),new Rectangle(650,298,180,18),new Rectangle(945,370,240,18),new Rectangle(1300,315,180,18),new Rectangle(1580,376,150,18)];
        default:[ground(),new Rectangle(330,384,180,18),new Rectangle(630,322,180,18),new Rectangle(930,260,190,18),new Rectangle(1250,325,180,18),new Rectangle(1540,380,180,18)];
    }
    function positions(index:Int):Array<PointData> {var p=layout(index);return [new PointData(p[1].x+p[1].width*.5,p[1].y-22),new PointData(p[2].x+p[2].width*.5,p[2].y-22),new PointData(p[4].x+p[4].width*.5,p[4].y-22)];}
    function ground():Rectangle return new Rectangle(0,GROUND,WIDTH,88);
}

class PointData {public var x:Float;public var y:Float;public function new(x:Float,y:Float){this.x=x;this.y=y;}}
