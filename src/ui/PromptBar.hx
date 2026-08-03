package ui;

import flash.display.Sprite;
import flash.text.TextField;

class PromptBar extends Sprite {
    var label:TextField;
    var timer:Float=0;
    public function new() {super();x=120;y=470;graphics.beginFill(Theme.PANEL,.96);graphics.drawRoundRect(0,0,720,54,12);graphics.endFill();graphics.lineStyle(1,0x334665);graphics.drawRoundRect(0,0,720,54,12);label=Theme.field(15,Theme.TEXT,true);label.x=20;label.y=9;label.width=680;label.height=38;addChild(label);visible=false;}
    public function hint(value:String):Void {if(timer<=0){label.text=value;visible=true;}}
    public function toast(value:String,seconds:Float=3.2):Void {label.text=value;visible=true;timer=seconds;}
    public function update(dt:Float):Void {timer-=dt;if(timer<=0){timer=0;visible=false;}}
    public function hasToast():Bool return timer>0;
    public function setTouchLayout():Void {x=270;y=466;graphics.clear();graphics.beginFill(Theme.PANEL,.96);graphics.drawRoundRect(0,0,650,54,12);graphics.endFill();graphics.lineStyle(1,0x334665);graphics.drawRoundRect(0,0,650,54,12);label.width=610;}
    public function setLargeText(enabled:Bool):Void {label.defaultTextFormat=new flash.text.TextFormat("_sans",enabled?18:15,Theme.TEXT,true);label.setTextFormat(label.defaultTextFormat);}
}
