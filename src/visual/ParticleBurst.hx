package visual;

import flash.display.Sprite;

class ParticleBurst extends Sprite {
    var motes:Array<Mote>=[];
    public var finished=false;
    public function new(color:Int,count:Int=12) {super();for(i in 0...count){var mote=new Mote(color,i);addChild(mote);motes.push(mote);}}
    public function update(dt:Float,reduced:Bool):Void {if(reduced){alpha-=dt*4;if(alpha<=0)finished=true;return;}var alive=false;for(mote in motes){mote.life-=dt;if(mote.life>0){alive=true;mote.x+=mote.vx*dt;mote.y+=mote.vy*dt;mote.vy+=150*dt;mote.alpha=Math.min(1,mote.life*2);}}if(!alive)finished=true;}
}

private class Mote extends Sprite {
    public var vx:Float;public var vy:Float;public var life:Float;
    public function new(color:Int,index:Int){super();var angle=index*.91;vx=Math.cos(angle)*(55+(index%5)*18);vy=Math.sin(angle)*(45+(index%4)*15)-55;life=.45+(index%4)*.11;graphics.beginFill(color,.9);graphics.drawRect(-2,-2,4+(index%2)*2,4+(index%2)*2);graphics.endFill();}
}
