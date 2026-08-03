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
    public var stairsX:Float=2200;
    var background:Bitmap;
    var veil:Sprite;

    public function new(data:FloorData,index:Int) {super();draw(data,index);}

    function draw(data:FloorData,index:Int):Void {
        var g=graphics;g.beginFill(0x060A12);g.drawRect(0,0,WIDTH,540);g.endFill();
        background=new Bitmap(backgroundFor(index));background.x=0;background.y=56;background.smoothing=true;background.alpha=.9;addChild(background);
        veil=new Sprite();var vg=veil.graphics;vg.beginFill(0x06101A,.14);vg.drawRect(0,56,WIDTH,396);vg.endFill();addChild(veil);
        var foreground=new Sprite();addChild(foreground);drawFloor(foreground,data,index);
        platforms=groundSegments(index).concat(elevated(index));for(p in platforms)if(p.y<GROUND)drawPlatform(foreground,p,data);
        evidencePositions=positions(index);
    }

    function backgroundFor(index:Int):BitmapData return switch index {case 0:new FloorOneArt(0,0);case 1:new FloorTwoArt(0,0);case 2:new FloorThreeArt(0,0);case 3:new FloorFourArt(0,0);default:new FloorFiveArt(0,0);}

    function drawFloor(layer:Sprite,data:FloorData,index:Int):Void {
        var g=layer.graphics;g.beginFill(0x09101C,.96);g.drawRect(0,GROUND,WIDTH,88);g.endFill();g.beginFill(data.accent,.92);g.drawRect(0,GROUND,WIDTH,4);g.endFill();g.beginFill(0xDCE6F2,.25);g.drawRect(0,GROUND+5,WIDTH,2);g.endFill();
        for(i in 0...20){g.beginFill(data.secondary,.09);g.drawRect(i*130+45,GROUND+31,70,3);g.endFill();}
        for(pit in pits(index)){g.beginFill(0x02030A,1);g.drawRect(pit.x,GROUND-3,pit.width,91);g.endFill();g.lineStyle(3,0xFF3AA7,.82);g.moveTo(pit.x,GROUND);var step=pit.width/6;for(i in 0...6)g.lineTo(pit.x+i*step,GROUND+(i%2==0?0:8));g.lineTo(pit.x+pit.width,GROUND);g.lineStyle(1,0xC86BFF,.42);for(i in 1...5){g.moveTo(pit.x+i*pit.width/5,GROUND+12);g.lineTo(pit.x+(i-.5)*pit.width/5,GROUND+72);}}
    }

    function drawPlatform(layer:Sprite,p:Rectangle,data:FloorData):Void {
        var platform=new Sprite();platform.x=p.x;platform.y=p.y;layer.addChild(platform);
        var g=platform.graphics;g.beginFill(0x081525,.99);g.drawRoundRect(0,0,p.width,p.height,6);g.endFill();g.lineStyle(2,0x5CDAFF,.92);g.drawRoundRect(0,0,p.width,p.height,6);g.beginFill(0x86E7FF,1);g.drawRect(5,0,p.width-10,3);g.endFill();g.beginFill(data.accent,.28);g.drawRect(12,7,p.width-24,5);g.endFill();
        platform.filters=[new GlowFilter(0x20BFFF,.9,12,12,2,2,false,false)];
    }

    function elevated(index:Int):Array<Rectangle> return switch index {
        case 0:[new Rectangle(350,387,210,18),new Rectangle(690,330,190,18),new Rectangle(1010,388,220,18),new Rectangle(1330,322,190,18),new Rectangle(1570,380,150,18)];
        case 1:[new Rectangle(300,374,170,18),new Rectangle(610,306,210,18),new Rectangle(950,364,180,18),new Rectangle(1260,290,210,18),new Rectangle(1560,368,160,18)];
        case 2:[new Rectangle(360,392,190,18),new Rectangle(710,344,170,18),new Rectangle(980,292,210,18),new Rectangle(1305,357,190,18),new Rectangle(1580,310,150,18)];
        case 3:[new Rectangle(315,365,200,18),new Rectangle(650,298,180,18),new Rectangle(945,370,240,18),new Rectangle(1300,315,180,18),new Rectangle(1580,376,150,18)];
        default:[new Rectangle(330,384,180,18),new Rectangle(630,322,180,18),new Rectangle(930,260,190,18),new Rectangle(1250,325,180,18),new Rectangle(1540,380,180,18)];
    }
    function positions(index:Int):Array<PointData> {var p=elevated(index);return [new PointData(p[0].x+p[0].width*.5,p[0].y-22),new PointData(p[1].x+p[1].width*.5,p[1].y-22),new PointData(p[3].x+p[3].width*.5,p[3].y-22)];}
    function pits(index:Int):Array<Rectangle> return switch index {case 0:[new Rectangle(720,GROUND,82,88),new Rectangle(1040,GROUND,82,88),new Rectangle(1330,GROUND,82,88),new Rectangle(1665,GROUND,84,88)];case 1:[new Rectangle(700,GROUND,88,88),new Rectangle(1030,GROUND,86,88),new Rectangle(1322,GROUND,84,88),new Rectangle(1660,GROUND,90,88)];case 2:[new Rectangle(730,GROUND,90,88),new Rectangle(1025,GROUND,78,88),new Rectangle(1325,GROUND,90,88),new Rectangle(1655,GROUND,88,88)];case 3:[new Rectangle(705,GROUND,94,88),new Rectangle(1030,GROUND,90,88),new Rectangle(1330,GROUND,90,88),new Rectangle(1660,GROUND,98,88)];default:[new Rectangle(710,GROUND,95,88),new Rectangle(1020,GROUND,100,88),new Rectangle(1320,GROUND,100,88),new Rectangle(1650,GROUND,110,88)];}
    function groundSegments(index:Int):Array<Rectangle> {var result:Array<Rectangle>=[],start=0.0;for(pit in pits(index)){result.push(new Rectangle(start,GROUND,pit.x-start,88));start=pit.x+pit.width;}result.push(new Rectangle(start,GROUND,WIDTH-start,88));return result;}
    public function safeCheckpointNear(value:Float):Float {var best=70.0,distance=1e9;for(p in platforms)if(p.y==GROUND){var candidate=Math.max(p.x+30,Math.min(p.x+p.width-30,value));var delta=Math.abs(candidate-value);if(delta<distance){distance=delta;best=candidate;}}return best;}
    public function updateCamera(value:Float,reduced:Bool):Void {background.x=value*(reduced ? .94 : .78);veil.x=value*.9;}
}

class PointData {public var x:Float;public var y:Float;public function new(x:Float,y:Float){this.x=x;this.y=y;}}
