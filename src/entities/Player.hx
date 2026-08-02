package entities;

import flash.display.Sprite;

class Player extends Sprite {
    public var vx:Float = 0;
    public var vy:Float = 0;
    public var grounded:Bool = false;
    public var coyote:Float = 0;
    public var jumpBuffer:Float = 0;
    public var facing:Int = 1;
    var body:Sprite;
    var scanner:Sprite;
    var legA:Sprite;
    var legB:Sprite;
    var time:Float = 0;

    public function new() {
        super();
        drawRig();
    }

    function drawRig():Void {
        body = new Sprite(); addChild(body);
        var coat = body.graphics;
        coat.beginFill(0xE8EEF7); coat.moveTo(-13,-27); coat.lineTo(13,-27); coat.lineTo(19,12); coat.lineTo(7,16); coat.lineTo(0,3); coat.lineTo(-7,16); coat.lineTo(-19,12); coat.lineTo(-13,-27); coat.endFill();
        coat.beginFill(0x14233A); coat.drawRect(-8,-23,16,29); coat.endFill();
        coat.beginFill(0x72F1B8); coat.drawRect(-7,-20,14,6); coat.endFill();
        coat.beginFill(0xB56F4A); coat.drawCircle(0,-38,11); coat.endFill();
        coat.beginFill(0x101728); coat.moveTo(-10,-43); coat.curveTo(0,-56,11,-44); coat.lineTo(7,-48); coat.curveTo(-2,-55,-11,-44); coat.endFill();
        coat.lineStyle(2,0x55D6FF); coat.drawRoundRect(-10,-42,9,7,2); coat.drawRoundRect(1,-42,9,7,2); coat.moveTo(-1,-39); coat.lineTo(1,-39);
        legA = leg(-7,15); legB = leg(7,15); addChildAt(legA,0); addChildAt(legB,0);
        scanner = new Sprite(); var g=scanner.graphics; g.beginFill(0x101A2D);g.drawRoundRect(0,-17,16,25,4);g.endFill();g.lineStyle(2,0x72F1B8);g.drawRoundRect(0,-17,16,25,4);g.beginFill(0x55D6FF);g.drawRect(4,-12,8,9);g.endFill();scanner.x=13;scanner.y=-10;body.addChild(scanner);
    }

    function leg(x:Float,y:Float):Sprite {var s=new Sprite();s.x=x;s.y=y;var g=s.graphics;g.lineStyle(6,0x16243B);g.moveTo(0,0);g.lineTo(0,18);g.lineStyle(5,0xE8EEF7);g.moveTo(0,18);g.lineTo(7,18);return s;}

    public function animate(dt:Float, moving:Bool, scanning:Bool, reducedMotion:Bool):Void {
        time += dt;
        scaleX = facing;
        scanner.rotation = scanning ? -18 : 0;
        if (reducedMotion) { body.y=0;legA.rotation=0;legB.rotation=0;return; }
        if (!grounded) {
            body.rotation = vx/450;
            legA.rotation = vy < 0 ? -12 : 12; legB.rotation = -legA.rotation;
        } else if (moving) {
            var stride = Math.sin(time*12)*24;
            legA.rotation = stride; legB.rotation = -stride; body.y = Math.abs(Math.sin(time*12))*1.5; body.rotation=0;
        } else {
            legA.rotation=0;legB.rotation=0;body.rotation=0;body.y=Math.sin(time*2.5)*1.2;
        }
    }

    public function pulseScanner(active:Bool):Void {scanner.alpha=active?1:.72;scanner.scaleX=scanner.scaleY=active?1.12:1;}
}
