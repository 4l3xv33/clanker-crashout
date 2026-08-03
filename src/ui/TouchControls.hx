package ui;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.events.TouchEvent;
import flash.text.TextField;

class TouchControls extends Sprite {
    public var left=false;
    public var right=false;

    public function new(onJump:Void->Void,onUse:Void->Void,onNotes:Void->Void,onPause:Void->Void) {
        super();
        addDirectionButton("up",108,366,64,64,null,onJump);
        addDirectionButton("left",38,436,64,64,function(active) left=active,null);
        addHandButton(108,436,64,64,onUse);
        addDirectionButton("right",178,436,64,64,function(active) right=active,null);
        addTapButton("NOTES",22,82,82,40,onNotes);
        addTapButton("PAUSE",856,82,82,40,onPause);
        visible=false;
    }

    function shell(label:String,x:Float,y:Float,w:Float,h:Float):Sprite {
        var button=new Sprite();button.x=x;button.y=y;button.buttonMode=true;button.mouseChildren=false;
        button.graphics.beginFill(0x0B1426,.76);button.graphics.drawRoundRect(0,0,w,h,18);button.graphics.endFill();button.graphics.lineStyle(2,Theme.MINT,.82);button.graphics.drawRoundRect(1,1,w-2,h-2,18);
        if(label!=""){var text:TextField=Theme.field(label.length>5?12:14,Theme.TEXT,true);text.width=w;text.height=24;text.y=(h-22)*.5;text.defaultTextFormat=new flash.text.TextFormat("_sans",label.length>5?12:14,Theme.TEXT,true,null,null,null,null,flash.text.TextFormatAlign.CENTER);text.text=label;text.setTextFormat(text.defaultTextFormat);button.addChild(text);}addChild(button);return button;
    }

    function addDirectionButton(direction:String,x:Float,y:Float,w:Float,h:Float,setter:Null<Bool->Void>,tap:Null<Void->Void>):Void {
        var button=shell("",x,y,w,h),g=button.graphics;g.beginFill(Theme.TEXT,.95);
        switch direction {case "up":g.moveTo(32,16);g.lineTo(17,45);g.lineTo(47,45);case "left":g.moveTo(16,32);g.lineTo(45,17);g.lineTo(45,47);default:g.moveTo(48,32);g.lineTo(19,17);g.lineTo(19,47);}g.lineTo(direction=="up"?32:direction=="left"?16:48,direction=="up"?16:32);g.endFill();
        if(setter!=null)bindHold(button,setter);if(tap!=null)bindTap(button,tap);
    }

    function addHandButton(x:Float,y:Float,w:Float,h:Float,action:Void->Void):Void {
        var button=shell("",x,y,w,h),g=button.graphics;g.lineStyle(2,Theme.TEXT);g.beginFill(Theme.MINT,.22);g.drawRoundRect(23,28,25,22,8);g.drawRoundRect(22,14,7,24,5);g.drawRoundRect(30,10,7,26,5);g.drawRoundRect(38,13,7,23,5);g.drawRoundRect(46,18,7,20,5);g.endFill();bindTap(button,action);
    }

    function addHoldButton(label:String,x:Float,y:Float,w:Float,h:Float,setter:Bool->Void):Void {
        var button=shell(label,x,y,w,h);bindHold(button,setter);
    }

    function bindHold(button:Sprite,setter:Bool->Void):Void {
        button.addEventListener(MouseEvent.MOUSE_DOWN,function(e){setter(true);e.stopPropagation();});
        button.addEventListener(MouseEvent.MOUSE_UP,function(e){setter(false);e.stopPropagation();});
        button.addEventListener(MouseEvent.MOUSE_OUT,function(e){setter(false);});
        button.addEventListener(TouchEvent.TOUCH_BEGIN,function(e){setter(true);e.stopPropagation();});
        button.addEventListener(TouchEvent.TOUCH_END,function(e){setter(false);e.stopPropagation();});
    }

    function addTapButton(label:String,x:Float,y:Float,w:Float,h:Float,action:Void->Void):Void {
        var button=shell(label,x,y,w,h);bindTap(button,action);
    }

    function bindTap(button:Sprite,action:Void->Void):Void {
        button.addEventListener(MouseEvent.CLICK,function(e){action();e.stopPropagation();});
        button.addEventListener(TouchEvent.TOUCH_TAP,function(e){action();e.stopPropagation();});
    }

    public function reset():Void {left=false;right=false;}
}
