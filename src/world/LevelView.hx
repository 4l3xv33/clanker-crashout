package world;

import data.FloorData;
import flash.display.Sprite;
import flash.geom.Rectangle;
import ui.Theme;

class LevelView extends Sprite {
    public static inline var WIDTH=2400;
    public static inline var GROUND=452;
    public var platforms:Array<Rectangle>=[];
    public var evidencePositions:Array<PointData>=[];
    public var robotX:Float=1830;
    public var stairsX:Float=2200;

    public function new(data:FloorData,index:Int) {super();draw(data,index);}

    function draw(data:FloorData,index:Int):Void {
        var g=graphics;g.beginFill(0x080D18);g.drawRect(0,0,WIDTH,540);g.endFill();
        g.beginFill(data.wall);g.drawRect(0,56,WIDTH,396);g.endFill();
        drawWindows(g,data,index);drawDepartment(g,data,index);drawFloor(g,data,index);
        platforms=layout(index);for(p in platforms)if(p.y<GROUND){g.beginFill(0x263550);g.drawRoundRect(p.x,p.y,p.width,p.height,8);g.endFill();g.beginFill(data.accent,.85);g.drawRect(p.x+4,p.y,p.width-8,3);g.endFill();}
        evidencePositions=positions(index);
    }

    function drawWindows(g:flash.display.Graphics,data:FloorData,index:Int):Void {
        for(i in 0...12){var x=70+i*200;g.beginFill(0x08111F);g.drawRoundRect(x,100,142,92,8);g.endFill();g.lineStyle(2,data.accent,.25);g.drawRoundRect(x,100,142,92,8);g.lineStyle(1,data.secondary,.16);g.moveTo(x+20,130);g.lineTo(x+122,130);g.moveTo(x+20,151);g.lineTo(x+100,151);}
        g.lineStyle(1,data.accent,.12);for(x in 0...25){g.moveTo(x*100,56);g.lineTo(x*100,GROUND);}
    }

    function drawFloor(g:flash.display.Graphics,data:FloorData,index:Int):Void {g.beginFill(0x111A2E);g.drawRect(0,GROUND,WIDTH,88);g.endFill();g.beginFill(data.accent,.75);g.drawRect(0,GROUND,WIDTH,4);g.endFill();for(i in 0...20){g.beginFill(data.secondary,.06);g.drawRect(i*130+45,GROUND+28,70,3);g.endFill();}}

    function drawDepartment(g:flash.display.Graphics,data:FloorData,index:Int):Void {
        switch index {
            case 0: // sales desks and call booths
                for(i in 0...6){var x=210+i*360;g.beginFill(0x17243A);g.drawRect(x,375,190,14);g.drawRect(x+18,389,12,63);g.drawRect(x+160,389,12,63);g.endFill();g.beginFill(data.accent,.25);g.drawRect(x+62,316,80,50);g.endFill();g.lineStyle(2,data.accent,.55);g.drawRect(x+62,316,80,50);}
            case 1: // files and interview rooms
                for(i in 0...7){var x=130+i*320;g.beginFill(0x181325);g.drawRect(x,245,120,207);g.endFill();g.lineStyle(2,data.accent,.35);g.drawRect(x,245,120,207);for(r in 0...5){g.moveTo(x+10,275+r*33);g.lineTo(x+110,275+r*33);}}
            case 2: // campaign billboards
                for(i in 0...5){var x=160+i*430;g.beginFill(0x1E1A12);g.drawRoundRect(x,226,260,132,10);g.endFill();g.lineStyle(3,data.accent,.45);g.drawRoundRect(x,226,260,132,10);g.beginFill(data.secondary,.25);g.drawCircle(x+58,292,31);g.endFill();g.beginFill(data.accent,.25);g.drawRect(x+110,262,115,10);g.drawRect(x+110,286,82,8);g.endFill();}
            case 3: // editing bays and light rigs
                for(i in 0...6){var x=115+i*360;g.beginFill(0x0D1C22);g.drawRect(x,282,230,106);g.endFill();g.lineStyle(2,data.accent,.38);g.drawRect(x,282,230,106);g.moveTo(x+115,282);g.lineTo(x+115,388);g.beginFill(data.secondary,.25);g.drawCircle(x+58,335,27);g.drawCircle(x+173,335,27);g.endFill();}
            case 4: // server core
                for(i in 0...10){var x=80+i*235;g.beginFill(0x11101A);g.drawRoundRect(x,205,146,247,8);g.endFill();g.lineStyle(2,data.accent,.33);g.drawRoundRect(x,205,146,247,8);for(r in 0...7){g.beginFill(r%2==0?data.accent:data.secondary,.45);g.drawRect(x+18,232+r*27,12,5);g.endFill();g.lineStyle(1,0x334055);g.moveTo(x+44,234+r*27);g.lineTo(x+128,234+r*27);}}
        }
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
