package entities;

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;

class Robot extends Sprite {
    var accent:Int;
    var face:Sprite;
    var corruption:Sprite;
    var time:Float=0;
    public var restored:Bool=false;

    public function new(accent:Int, name:String) {
        super(); this.accent=accent; drawRobot(name);
    }

    function drawRobot(name:String):Void {
        var g=graphics;g.beginFill(0xDCE6F2);g.drawRoundRect(-38,-44,76,68,15);g.endFill();g.lineStyle(3,0x26364F);g.drawRoundRect(-38,-44,76,68,15);
        g.beginFill(0x25344C);g.drawRect(-28,22,56,18);g.endFill();g.beginFill(0x172138);g.drawCircle(-20,42,13);g.drawCircle(20,42,13);g.endFill();g.lineStyle(3,accent);g.drawCircle(-20,42,13);g.drawCircle(20,42,13);
        face=new Sprite();face.y=-28;addChild(face);drawFace(false);
        g.lineStyle(7,0xDCE6F2);g.moveTo(-34,-10);g.lineTo(-54,8);g.moveTo(34,-10);g.lineTo(53,-3);
        corruption=new Sprite();addChild(corruption);var c=corruption.graphics;c.lineStyle(3,0xFF3AA7);for(i in 0...7){var y=-42+i*12;c.moveTo(7,y);c.lineTo(18,y+4);c.lineTo(14,y+10);c.lineTo(30,y+14);}
        var label=new TextField();label.defaultTextFormat=new TextFormat("_sans",11,accent,true);label.text=name;label.width=80;label.x=-40;label.y=58;label.selectable=false;addChild(label);
    }

    function drawFace(good:Bool):Void {var g=face.graphics;g.clear();g.beginFill(0x111B2D);g.drawRoundRect(-29,-14,58,29,8);g.endFill();g.beginFill(good?0x72F1B8:0xFF6174);g.drawRoundRect(-17,-5,8,11,5);g.drawRoundRect(9,-5,8,11,5);g.endFill();if(good){g.lineStyle(2,0x72F1B8);g.moveTo(-8,8);g.curveTo(0,13,8,8);}}

    public function update(dt:Float,reducedMotion:Bool):Void {time+=dt;if(!reducedMotion&&!restored){corruption.alpha=.55+Math.sin(time*10)*.35;rotation=Math.sin(time*4)*.5;}else rotation=0;}
    public function restore():Void {restored=true;corruption.visible=false;drawFace(true);alpha=1;}
}
