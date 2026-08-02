package entities;

import flash.display.Sprite;

class Hazard {
    public var sprite:Sprite;
    public var minX:Float;
    public var maxX:Float;
    public var dir:Float=1;
    public var phase:Float;

    public function new(accent:Int,x:Float,minX:Float,maxX:Float,kind:Int) {
        this.minX=minX;this.maxX=maxX;phase=Math.random()*6.28;sprite=new Sprite();sprite.x=x;draw(accent,kind);
    }
    function draw(accent:Int,kind:Int):Void {var g=sprite.graphics;if(kind%3==0){g.beginFill(0xFF4F75,.9);g.moveTo(0,-18);g.lineTo(20,13);g.lineTo(-20,13);g.endFill();g.lineStyle(2,accent);g.drawCircle(0,0,22);}else if(kind%3==1){g.beginFill(0x162238);g.drawRoundRect(-22,-16,44,32,8);g.endFill();g.lineStyle(3,0xFF4F75);g.drawRoundRect(-22,-16,44,32,8);g.moveTo(-10,-23);g.lineTo(0,-15);g.lineTo(10,-23);}else{g.lineStyle(5,0xFF4F75);g.moveTo(-21,-18);g.lineTo(21,18);g.moveTo(21,-18);g.lineTo(-21,18);g.lineStyle(2,accent);g.drawCircle(0,0,25);}}
    public function update(dt:Float,ground:Float,reducedMotion:Bool):Void {phase+=dt;sprite.x+=dir*68*dt;if(sprite.x<minX||sprite.x>maxX)dir*=-1;sprite.y=ground-23+(reducedMotion?0:Math.sin(phase*3)*7);if(!reducedMotion)sprite.rotation+=dir*45*dt;}
}
