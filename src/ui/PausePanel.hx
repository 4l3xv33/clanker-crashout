package ui;

import flash.display.Sprite;
import flash.text.TextField;
import systems.GameSettings;

class PausePanel extends Sprite {
    var body:TextField;
    public function new() {super();graphics.beginFill(Theme.BG,.94);graphics.drawRect(0,0,960,540);graphics.endFill();graphics.beginFill(Theme.PANEL);graphics.drawRoundRect(210,88,540,360,22);graphics.endFill();body=Theme.field(20,Theme.TEXT,false);body.x=250;body.y=120;body.width=460;body.height=290;addChild(body);visible=false;}
    public function show(settings:GameSettings):Void {visible=true;body.htmlText='<font size="32" color="#72F1B8">PAUSED</font>\n\n<font color="#FFCB6B">ESC</font>  Resume\n<font color="#FFCB6B">M</font>  Sound: '+onOff(settings.sound)+'\n<font color="#FFCB6B">R</font>  Reduced motion: '+onOff(settings.reducedMotion)+'\n<font color="#FFCB6B">H</font>  High contrast: '+onOff(settings.highContrast)+'\n<font color="#FFCB6B">T</font>  Large text: '+onOff(settings.largeText)+'\n\n<font size="15" color="#8FA1C6">WASD / Arrows move · Space jumps · E interacts\n1–3 answer · G opens field notes</font>';}
    public function hide():Void visible=false;
    function onOff(v:Bool):String return v?'ON':'OFF';
    public function setLargeText(enabled:Bool):Void {body.defaultTextFormat=new flash.text.TextFormat("_sans",enabled?23:20,Theme.TEXT,false);}
}
