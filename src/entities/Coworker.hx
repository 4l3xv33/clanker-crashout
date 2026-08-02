package entities;

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;

class Coworker extends Sprite {
    var chamber:Sprite;
    var person:Sprite;
    public function new(accent:Int,name:String,role:String,index:Int) {
        super();
        chamber=new Sprite();addChild(chamber);var g=chamber.graphics;g.beginFill(accent,.1);g.drawRoundRect(-31,-64,62,96,22);g.endFill();g.lineStyle(3,accent,.75);g.drawRoundRect(-31,-64,62,96,22);
        person=new Sprite();addChild(person);var p=person.graphics;var skins=[0xB56F4A,0x8B5A3C,0xD69A72,0x7A4A35,0xC6865A];p.beginFill(skins[index%skins.length]);p.drawCircle(0,-34,10);p.endFill();p.beginFill([0x4F7CAC,0x7E57C2,0xD9822B,0x2C9C85,0x51617D][index%5]);p.drawRoundRect(-13,-23,26,37,7);p.endFill();p.lineStyle(4,0xDCE6F2);p.moveTo(-7,14);p.lineTo(-8,28);p.moveTo(7,14);p.lineTo(8,28);
        var t=new TextField();t.defaultTextFormat=new TextFormat("_sans",11,accent,true);t.text=name+" · "+role;t.width=170;t.x=-85;t.y=37;t.selectable=false;addChild(t);alpha=.52;
    }
    public function release():Void {alpha=1;chamber.visible=false;person.scaleX=person.scaleY=1.1;}
}
