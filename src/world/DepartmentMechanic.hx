package world;

import data.FloorData;
import flash.display.Sprite;
import flash.filters.GlowFilter;
import world.LevelView.PointData;

class DepartmentMechanic extends Sprite {
    var floorIndex:Int;
    var accent:Int;
    var secondary:Int;
    var gates:Array<GateData>=[];
    var fields:Array<FieldData>=[];
    var time:Float=0;

    public function new(data:FloorData,index:Int,positions:Array<PointData>) {
        super();floorIndex=index;accent=data.accent;secondary=data.secondary;
        switch index {
            case 0:
                addGate(620,0,"SOURCE");addGate(1000,1,"TRACE");addGate(1650,2,"WRITE");
            case 1:
                for(i in 0...3)addField(positions[i].x,i,"BIASED RANKING",false);
            case 2:
                for(i in 0...3)addField(positions[i].x,i,"AMPLIFICATION",true);
            case 3:
                drawProvenanceChain(positions);
            default:
                addGate(570,0,"TASK");addGate(880,1,"ACCESS");addGate(1500,2,"OBJECTIVE");
        }
        drawSystemLabel(data.mechanic,data.mechanicBrief);
    }

    function addGate(x:Float,requirement:Int,label:String):Void {
        var view=new Sprite();view.x=x;var g=view.graphics;g.beginFill(0x050912,.88);g.drawRect(-17,128,34,324);g.endFill();g.lineStyle(3,0xFF3AA7,.95);g.moveTo(0,138);g.lineTo(0,448);for(i in 0...8){var y=150+i*38;g.moveTo(-12,y);g.lineTo(12,y+12);}g.beginFill(0x101A2B,.98);g.drawRoundRect(-54,102,108,31,7);g.endFill();g.lineStyle(1,accent,.8);g.drawRoundRect(-54,102,108,31,7);var t=ui.Theme.field(10,0xF4F7FB,true);t.text=label+" LOCK";t.x=-49;t.y=110;t.width=98;t.height=18;view.addChild(t);view.filters=[new GlowFilter(0xFF3AA7,.75,12,12,2,2,false,false)];addChild(view);gates.push(new GateData(x,requirement,view));
    }

    function addField(x:Float,requirement:Int,label:String,boost:Bool):Void {
        var view=new Sprite();view.x=x;var g=view.graphics;var color=boost?0xFFCB6B:0xD58CFF;g.beginFill(color,.08);g.drawRoundRect(-96,334,192,118,18);g.endFill();g.lineStyle(2,color,.58);g.drawRoundRect(-96,334,192,118,18);for(i in 0...6){g.moveTo(-82+i*30,442);g.lineTo(-62+i*30,425);}var t=ui.Theme.field(10,color,true);t.text=label;t.x=-82;t.y=410;t.width=164;t.height=18;view.addChild(t);view.filters=[new GlowFilter(color,.38,10,10,1.5,1,false,false)];addChild(view);fields.push(new FieldData(x,requirement,boost,view));
    }

    function drawProvenanceChain(positions:Array<PointData>):Void {
        var g=graphics;g.lineStyle(3,0x63F3C8,.44);for(i in 0...positions.length-1){g.moveTo(positions[i].x,positions[i].y);g.lineTo(positions[i+1].x,positions[i+1].y);}for(i in 0...positions.length){g.beginFill(0x0A1720,.96);g.drawCircle(positions[i].x,positions[i].y,14);g.endFill();g.lineStyle(3,0x63F3C8,.8);g.drawCircle(positions[i].x,positions[i].y,13);}
    }

    function drawSystemLabel(title:String,description:String):Void {
        var panel=new Sprite();panel.x=132;panel.y=84;var g=panel.graphics;g.beginFill(0x07101D,.82);g.drawRoundRect(0,0,360,48,9);g.endFill();g.lineStyle(1,accent,.6);g.drawRoundRect(0,0,360,48,9);var t=ui.Theme.field(12,accent,true);t.text=title;t.x=14;t.y=7;t.width=330;t.height=18;panel.addChild(t);var d=ui.Theme.field(10,0xB9CAE7,false);d.text=description;d.x=14;d.y=24;d.width=330;d.height=18;panel.addChild(d);addChild(panel);
    }

    public function update(dt:Float,evidence:Array<Bool>,reducedMotion:Bool):Void {
        time+=dt;for(gate in gates){var open=evidence[gate.requirement];gate.view.alpha=open ? .14 : (reducedMotion ? .82 : .7+Math.sin(time*6+gate.requirement)*.18);gate.view.visible=!open||gate.view.alpha>.05;}
        for(field in fields){var resolved=evidence[field.requirement];field.view.alpha=resolved ? .12 : (reducedMotion ? .72 : .55+Math.sin(time*4+field.requirement)*.17);}
    }

    public function constrain(oldX:Float,nextX:Float,evidence:Array<Bool>):Float {
        for(gate in gates)if(!evidence[gate.requirement]){
            if(oldX<=gate.x-18&&nextX>gate.x-18)return gate.x-18;
            if(oldX>=gate.x+18&&nextX<gate.x+18)return gate.x+18;
        }
        return nextX;
    }

    public function movementFactor(x:Float,evidence:Array<Bool>):Float {
        for(field in fields)if(!evidence[field.requirement]&&Math.abs(x-field.x)<96)return field.boost?1.42:.58;
        return 1;
    }

    public function canInspect(index:Int,evidence:Array<Bool>):Bool {if(floorIndex!=3||index==0)return true;for(i in 0...index)if(!evidence[i])return false;return true;}
    public function lockMessage(index:Int):String return floorIndex==3?"PROVENANCE CHAIN INCOMPLETE · Trace artifact "+index+" first":"SYSTEM LOCKED";
}

private class GateData {public var x:Float;public var requirement:Int;public var view:Sprite;public function new(x:Float,requirement:Int,view:Sprite){this.x=x;this.requirement=requirement;this.view=view;}}
private class FieldData {public var x:Float;public var requirement:Int;public var boost:Bool;public var view:Sprite;public function new(x:Float,requirement:Int,boost:Bool,view:Sprite){this.x=x;this.requirement=requirement;this.boost=boost;this.view=view;}}
