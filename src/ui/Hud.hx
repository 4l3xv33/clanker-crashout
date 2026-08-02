package ui;

import flash.display.Sprite;
import flash.text.TextField;

class Hud extends Sprite {
    var floorText:TextField;
    var objectiveText:TextField;
    var integrityText:TextField;
    public function new() {
        super();graphics.beginFill(0x0D1527,.94);graphics.drawRect(0,0,960,56);graphics.endFill();graphics.lineStyle(1,0x31425F);graphics.moveTo(0,55);graphics.lineTo(960,55);
        floorText=Theme.field(15,Theme.TEXT,true);floorText.x=18;floorText.y=9;floorText.width=320;floorText.height=24;addChild(floorText);
        objectiveText=Theme.field(13,Theme.MUTED,false);objectiveText.x=18;objectiveText.y=31;objectiveText.width=620;objectiveText.height=22;addChild(objectiveText);
        integrityText=Theme.field(15,Theme.MINT,true);integrityText.x=700;integrityText.y=18;integrityText.width=240;integrityText.height=24;addChild(integrityText);
    }
    public function update(floor:Int,department:String,evidence:Int,integrity:Int,resolved:Bool):Void {floorText.text="FLOOR "+(floor+1)+" / 5    "+department.toUpperCase();objectiveText.text=resolved?"SYSTEM RESTORED · Reach the stairwell":"EVIDENCE "+evidence+" / 3 · Investigate before you intervene";integrityText.text="SYSTEM INTEGRITY  "+integrity+" / 3";}
    public function setLargeText(enabled:Bool):Void {floorText.defaultTextFormat=new flash.text.TextFormat("_sans",enabled?18:15,Theme.TEXT,true);objectiveText.defaultTextFormat=new flash.text.TextFormat("_sans",enabled?15:13,Theme.MUTED,false);integrityText.defaultTextFormat=new flash.text.TextFormat("_sans",enabled?18:15,Theme.MINT,true);}
}
