package ui;

import flash.display.Sprite;
import flash.text.TextField;

class Hud extends Sprite {
    var floorText:TextField;
    var objectiveText:TextField;
    var integrityText:TextField;
    var targetText:TextField;
    public function new() {
        super();graphics.beginFill(0x0D1527,.94);graphics.drawRect(0,0,960,56);graphics.endFill();graphics.lineStyle(1,0x31425F);graphics.moveTo(0,55);graphics.lineTo(960,55);
        floorText=Theme.field(15,Theme.TEXT,true);floorText.x=18;floorText.y=9;floorText.width=420;floorText.height=24;addChild(floorText);
        objectiveText=Theme.field(13,Theme.MUTED,false);objectiveText.x=18;objectiveText.y=31;objectiveText.width=480;objectiveText.height=22;addChild(objectiveText);
        targetText=Theme.field(13,0x8FE8FF,true);targetText.x=500;targetText.y=31;targetText.width=185;targetText.height=22;addChild(targetText);
        integrityText=Theme.field(15,Theme.MINT,true);integrityText.x=700;integrityText.y=18;integrityText.width=240;integrityText.height=24;addChild(integrityText);
    }
    public function update(floor:Int,department:String,mechanic:String,evidence:Int,integrity:Int,resolved:Bool):Void {floorText.text="FLOOR "+(floor+1)+" / 5    "+department.toUpperCase();objectiveText.text=resolved?("SYSTEM RESTORED · Reach the stairwell"):(mechanic+" · EVIDENCE "+evidence+" / 3");integrityText.text="SYSTEM INTEGRITY  "+integrity+" / 3";}
    public function setTarget(delta:Float,label:String):Void {var meters=Std.int(Math.abs(delta)/10);targetText.text="TARGET "+(delta< -18?"< ":delta>18?"> ":"· ")+meters+"m  "+label;}
    public function setLargeText(enabled:Bool):Void {floorText.defaultTextFormat=new flash.text.TextFormat("_sans",enabled?18:15,Theme.TEXT,true);objectiveText.defaultTextFormat=new flash.text.TextFormat("_sans",enabled?15:13,Theme.MUTED,false);targetText.defaultTextFormat=new flash.text.TextFormat("_sans",enabled?15:13,0x8FE8FF,true);integrityText.defaultTextFormat=new flash.text.TextFormat("_sans",enabled?18:15,Theme.MINT,true);}
}
