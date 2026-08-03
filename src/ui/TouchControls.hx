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
        addHoldButton("LEFT",24,448,68,68,function(active) left=active);
        addHoldButton("RIGHT",108,448,68,68,function(active) right=active);
        addTapButton("NOTES",22,82,82,40,onNotes);
        addTapButton("PAUSE",856,82,82,40,onPause);
        addTapButton("JUMP",748,448,82,68,onJump);
        addTapButton("USE",850,448,82,68,onUse);
        visible=false;
    }

    function shell(label:String,x:Float,y:Float,w:Float,h:Float):Sprite {
        var button=new Sprite();button.x=x;button.y=y;button.buttonMode=true;button.mouseChildren=false;
        button.graphics.beginFill(0x0B1426,.76);button.graphics.drawRoundRect(0,0,w,h,18);button.graphics.endFill();button.graphics.lineStyle(2,Theme.MINT,.82);button.graphics.drawRoundRect(1,1,w-2,h-2,18);
        var text:TextField=Theme.field(label.length>5?12:14,Theme.TEXT,true);text.width=w;text.height=24;text.y=(h-22)*.5;text.defaultTextFormat=new flash.text.TextFormat("_sans",label.length>5?12:14,Theme.TEXT,true,null,null,null,null,flash.text.TextFormatAlign.CENTER);text.text=label;text.setTextFormat(text.defaultTextFormat);button.addChild(text);addChild(button);return button;
    }

    function addHoldButton(label:String,x:Float,y:Float,w:Float,h:Float,setter:Bool->Void):Void {
        var button=shell(label,x,y,w,h);
        button.addEventListener(MouseEvent.MOUSE_DOWN,function(e){setter(true);e.stopPropagation();});
        button.addEventListener(MouseEvent.MOUSE_UP,function(e){setter(false);e.stopPropagation();});
        button.addEventListener(MouseEvent.MOUSE_OUT,function(e){setter(false);});
        button.addEventListener(TouchEvent.TOUCH_BEGIN,function(e){setter(true);e.stopPropagation();});
        button.addEventListener(TouchEvent.TOUCH_END,function(e){setter(false);e.stopPropagation();});
    }

    function addTapButton(label:String,x:Float,y:Float,w:Float,h:Float,action:Void->Void):Void {
        var button=shell(label,x,y,w,h);
        button.addEventListener(MouseEvent.CLICK,function(e){action();e.stopPropagation();});
        button.addEventListener(TouchEvent.TOUCH_TAP,function(e){action();e.stopPropagation();});
    }

    public function reset():Void {left=false;right=false;}
}
