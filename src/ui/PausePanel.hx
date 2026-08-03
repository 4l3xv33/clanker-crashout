package ui;

import flash.display.Sprite;
import flash.text.TextField;
import systems.GameSettings;

class PausePanel extends Sprite {
    var body:TextField;
    public function new() {super();graphics.beginFill(Theme.BG,.94);graphics.drawRect(0,0,960,540);graphics.endFill();graphics.beginFill(Theme.PANEL);graphics.drawRoundRect(170,72,620,396,22);graphics.endFill();body=Theme.field(20,Theme.TEXT,false);body.x=205;body.y=100;body.width=550;body.height=340;addChild(body);visible=false;}
    public function show(settings:GameSettings):Void {visible=true;body.htmlText='<font size="32" color="#72F1B8">PAUSED / ACCESSIBILITY</font>\n\n<font color="#FFCB6B">ESC</font> Resume    <font color="#FFCB6B">M</font> Music: '+level(settings.musicLevel)+'    <font color="#FFCB6B">X</font> Effects: '+level(settings.effectsLevel)+'\n<font color="#FFCB6B">R</font> Reduced motion: '+onOff(settings.reducedMotion)+'    <font color="#FFCB6B">P</font> Low effects: '+onOff(settings.lowEffects)+'\n<font color="#FFCB6B">H</font> High contrast: '+onOff(settings.highContrast)+'    <font color="#FFCB6B">T</font> Large text: '+onOff(settings.largeText)+'\n<font color="#FFCB6B">U</font> Large touch controls: '+onOff(settings.largeControls)+'\n\n<font size="15" color="#8FA1C6">WASD / Arrows move - Space jumps - E interacts\n1-3 answer - G field notes - C AI Codex - F fullscreen</font>';}
    public function hide():Void visible=false;
    function onOff(v:Bool):String return v?'ON':'OFF';
    function level(v:Int):String return v==0?'OFF':v==1?'50%':'100%';
    public function setLargeText(enabled:Bool):Void {body.defaultTextFormat=new flash.text.TextFormat("_sans",enabled?23:20,Theme.TEXT,false);}
}
