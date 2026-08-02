package;

import flash.Lib;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.ui.Keyboard;

class Main extends Sprite {
    static inline var W = 960;
    static inline var H = 540;
    static inline var GROUND = 450.0;
    static inline var LEVEL_W = 2200.0;

    var cases:Array<FloorCase>;
    var floorIndex = 0;
    var world:Sprite;
    var scenery:Sprite;
    var actors:Sprite;
    var player:Sprite;
    var robot:Sprite;
    var coworker:Sprite;
    var stairs:Sprite;
    var evidenceSprites:Array<Sprite> = [];
    var hazards:Array<Hazard> = [];
    var platforms:Array<Rectangle> = [];
    var keys:Map<Int,Bool> = new Map();
    var hud:TextField;
    var prompt:TextField;
    var overlay:Sprite;
    var overlayText:TextField;
    var px = 80.0; var py = GROUND - 38; var vx = 0.0; var vy = 0.0;
    var grounded = false; var cameraX = 0.0; var integrity = 3;
    var evidence:Array<Bool> = [false,false,false];
    var quizIndex = 0; var lastCorrect = false; var resolved = false;
    var state = "TITLE"; var lastTime = 0; var invincible = 0.0; var toastTime = 0.0;

    public static function main():Void Lib.current.addChild(new Main());
    public function new() { super(); addEventListener(Event.ADDED_TO_STAGE, init); }

    function init(_:Event):Void {
        stage.scaleMode = flash.display.StageScaleMode.SHOW_ALL; stage.align = flash.display.StageAlign.TOP_LEFT; stage.color = 0x080B14;
        cases = buildCases(); world = new Sprite(); scenery = new Sprite(); actors = new Sprite(); world.addChild(scenery); world.addChild(actors); addChild(world);
        player = new Sprite(); actors.addChild(player); drawPlayer();
        hud = text(17,0xDCE8FF,true); hud.x=18; hud.y=13; hud.width=924; hud.height=30; addChild(hud);
        prompt = text(16,0xFFFFFF,true); prompt.x=110; prompt.y=475; prompt.width=740; prompt.height=52; prompt.multiline=true; prompt.wordWrap=true; prompt.background=true; prompt.backgroundColor=0x111A2E; prompt.visible=false; addChild(prompt);
        makeOverlay(); stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDown); stage.addEventListener(KeyboardEvent.KEY_UP,keyUp); addEventListener(Event.ENTER_FRAME,update); showTitle();
    }

    function showTitle():Void {
        state="TITLE"; overlay.visible=true;
        overlayText.htmlText='<p align="center"><font size="42" color="#72F1B8">ERROR 9 TO 5</font>\n<font size="18" color="#91A4CE">A DATA-SCIENCE RESCUE MISSION</font>\n\n<font size="20">The office automation network received one bad instruction:\n<font color="#FFCB6B">MAXIMIZE OUTPUT. NEVER HESITATE.</font>\n\nFive departments are trapped inside its idea of productivity.\nFind the evidence. Diagnose the failure. Restore the humans.\n\n<font color="#72F1B8">PRESS SPACE TO CLOCK IN</font></font></p>';
        hud.text=""; prompt.visible=false;
    }

    function loadFloor(index:Int):Void {
        floorIndex=index; state="PLAY"; overlay.visible=false; prompt.visible=false; integrity=3; evidence=[false,false,false]; quizIndex=0; resolved=false; px=80; py=GROUND-38; vx=0; vy=0; cameraX=0;
        #if debug_qa
        evidence=[true,true,true]; px=1600; py=GROUND-38;
        #end
        while(scenery.numChildren>0) scenery.removeChildAt(0); while(actors.numChildren>0) actors.removeChildAt(0);
        evidenceSprites=[]; hazards=[]; platforms=[]; drawFloor(); drawActors(); updateHud();
        #if debug_qa
        for(s in evidenceSprites) s.alpha=.25;
        #end
    }

    function drawFloor():Void {
        var c=cases[floorIndex], g=scenery.graphics; g.clear();
        g.beginFill(c.dark); g.drawRect(0,0,LEVEL_W,H); g.endFill();
        for(i in 0...55){g.beginFill(c.accent,.08+Math.random()*.13);g.drawRect(Math.random()*LEVEL_W,55+Math.random()*330,2+Math.random()*3,2+Math.random()*3);g.endFill();}
        g.beginFill(c.wall); g.drawRect(0,80,LEVEL_W,370); g.endFill();
        g.lineStyle(2,c.accent,.2); for(x in 0...22){g.moveTo(x*100,80);g.lineTo(x*100,450);}
        g.beginFill(0x182038); g.drawRect(0,450,LEVEL_W,90); g.endFill(); g.beginFill(c.accent,.55); g.drawRect(0,450,LEVEL_W,4); g.endFill();
        platforms=[new Rectangle(0,450,LEVEL_W,90),new Rectangle(330,382,190,18),new Rectangle(650,330,190,18),new Rectangle(960,385,210,18),new Rectangle(1240,318,180,18)];
        for(p in platforms){if(p.y<450){g.beginFill(0x273351);g.drawRect(p.x,p.y,p.width,p.height);g.endFill();g.beginFill(c.accent,.7);g.drawRect(p.x,p.y,p.width,3);g.endFill();}}
        for(i in 0...7){var ox=170+i*285;g.beginFill(0x11182B);g.drawRect(ox,120,120,82);g.endFill();g.lineStyle(2,c.accent,.25);g.drawRect(ox,120,120,82);g.moveTo(ox+18,153);g.lineTo(ox+102,153);}
        var title=text(23,c.accent,true);title.text="FLOOR "+(floorIndex+1)+"  //  "+c.department.toUpperCase();title.x=36;title.y=92;title.width=600;scenery.addChild(title);
    }

    function drawActors():Void {
        var c=cases[floorIndex];
        var positions=[new PointData(420,350),new PointData(720,298),new PointData(1310,286)];
        for(i in 0...3){var s=makeEvidence(i,c.accent);s.x=positions[i].x;s.y=positions[i].y;actors.addChild(s);evidenceSprites.push(s);}
        robot=makeRobot(c.accent);robot.x=1650;robot.y=GROUND-44;actors.addChild(robot);
        coworker=makeCoworker(c.accent);coworker.x=1745;coworker.y=GROUND-48;actors.addChild(coworker);
        stairs=makeStairs(c.accent);stairs.x=2010;stairs.y=GROUND;actors.addChild(stairs);
        for(i in 0...3){var h=makeHazard(c.accent);h.sprite.x=560+i*420;h.sprite.y=GROUND-22;h.minX=h.sprite.x-90;h.maxX=h.sprite.x+90;actors.addChild(h.sprite);hazards.push(h);}
        actors.addChild(player);player.x=px;player.y=py;
    }

    function update(_:Event):Void {
        var now=Lib.getTimer();if(lastTime==0)lastTime=now;var dt=Math.min((now-lastTime)/1000,.04);lastTime=now;
        if(state!="PLAY") return;
        invincible-=dt;toastTime-=dt;if(toastTime<=0)prompt.visible=false;
        var move=0.0;if(down(Keyboard.LEFT)||down(65))move-=1;if(down(Keyboard.RIGHT)||down(68))move+=1;
        vx=(vx+move*900*dt)*Math.pow(.025,dt);if(vx>260)vx=260;if(vx< -260)vx=-260;
        var oldY=py;vy+=1050*dt;px+=vx*dt;py+=vy*dt;if(px<20){px=20;vx=0;}if(px>LEVEL_W-20){px=LEVEL_W-20;vx=0;}
        grounded=false;var feet=py+38;var oldFeet=oldY+38;
        for(p in platforms)if(vy>=0&&px+13>p.x&&px-13<p.x+p.width&&oldFeet<=p.y+5&&feet>=p.y){py=p.y-38;vy=0;grounded=true;break;}
        if(py>H+80){px=Math.max(50,px-180);py=200;vy=0;damage("You fell into a broken workflow.");}
        updateHazards(dt);player.x=px;player.y=py;player.alpha=(invincible>0&&Std.int(invincible*12)%2==0) ? .25 : 1;player.scaleX=move<0 ? -1 : (move>0 ? 1 : player.scaleX);
        cameraX=Math.max(0,Math.min(LEVEL_W-W,px-W*.42));world.x=-cameraX;updateContext();
    }

    function updateHazards(dt:Float):Void for(h in hazards){h.phase+=dt;h.sprite.x+=h.dir*70*dt;if(h.sprite.x<h.minX||h.sprite.x>h.maxX)h.dir*=-1;h.sprite.y=GROUND-22+Math.sin(h.phase*3)*8;if(invincible<=0&&dist(px,py,h.sprite.x,h.sprite.y)<31)damage("A corrupted process knocked your system offline.");}
    function damage(msg:String):Void {integrity--;invincible=1.4;vx=-180;vy=-280;showToast(msg+"  Integrity -1");if(integrity<=0){integrity=3;px=Math.max(60,px-260);showToast("Coaching protocol restored your integrity. Review, then continue.");}updateHud();}

    function updateContext():Void {
        var near=-1;for(i in 0...3)if(!evidence[i]&&dist(px,py,evidenceSprites[i].x,evidenceSprites[i].y)<80)near=i;
        if(near>=0){showHint("[E] Inspect evidence terminal "+(near+1));return;}
        if(dist(px,py,robot.x,robot.y)<110){showHint(allEvidence()?"[E] Begin incident review":"The robot rejects guesses. Find all three evidence logs.");return;}
        if(dist(px,py,stairs.x,GROUND-30)<110){showHint(resolved?"[E] Take the stairs":"ACCESS DENIED — restore this floor first");return;}
        if(toastTime<=0)prompt.visible=false;
    }
    function showHint(s:String):Void {if(toastTime<=0){prompt.text=s;prompt.visible=true;}}
    function showToast(s:String):Void {prompt.text=s;prompt.visible=true;toastTime=3.2;}

    function interact():Void {
        if(state!="PLAY")return;
        for(i in 0...3)if(!evidence[i]&&dist(px,py,evidenceSprites[i].x,evidenceSprites[i].y)<80){evidence[i]=true;evidenceSprites[i].alpha=.25;showToast("EVIDENCE "+(i+1)+": "+cases[floorIndex].evidence[i]);updateHud();return;}
        if(dist(px,py,robot.x,robot.y)<110&&allEvidence()){quizIndex=0;showQuestion();return;}
        if(dist(px,py,stairs.x,GROUND-30)<110&&resolved){if(floorIndex<cases.length-1)loadFloor(floorIndex+1);else showEnding();}
    }

    function showQuestion():Void {
        state="QUIZ";overlay.visible=true;var c=cases[floorIndex],q=c.questions[quizIndex];
        overlayText.htmlText='<font color="#72F1B8" size="16">INCIDENT REVIEW '+(quizIndex+1)+'/3  //  '+c.department.toUpperCase()+'</font>\n\n<font size="24" color="#FFFFFF">'+q.prompt+'</font>\n\n<font size="19"><font color="#FFCB6B">1</font>  '+q.choices[0]+'\n\n<font color="#FFCB6B">2</font>  '+q.choices[1]+'\n\n<font color="#FFCB6B">3</font>  '+q.choices[2]+'</font>\n\n<font color="#91A4CE" size="15">Press 1, 2, or 3</font>';
    }

    function answer(choice:Int):Void {
        if(state!="QUIZ")return;var q=cases[floorIndex].questions[quizIndex];lastCorrect=choice==q.correct;
        if(!lastCorrect){integrity--;if(integrity<=0)integrity=3;}
        state="FEEDBACK";var color=lastCorrect?"#72F1B8":"#FF6174";var label=lastCorrect?"CORRECT — SYSTEM PATCH ACCEPTED":"NOT SAFE — PATCH REJECTED";
        overlayText.htmlText='<p align="center"><font size="28" color="'+color+'">'+label+'</font>\n\n<font size="20" color="#FFFFFF">'+q.explanation+'</font>\n\n<font size="17" color="#91A4CE">'+(lastCorrect?"The robot released one control lock.":"Integrity reduced. Use the evidence and try again.")+'</font>\n\n<font color="#FFCB6B">PRESS SPACE TO CONTINUE</font></p>';updateHud();
    }

    function continueFeedback():Void {
        if(state!="FEEDBACK")return;if(lastCorrect)quizIndex++;
        if(quizIndex>=3){resolveFloor();}else showQuestion();
    }

    function resolveFloor():Void {
        resolved=true;state="PLAY";overlay.visible=false;coworker.alpha=1;robot.alpha=.35;robot.rotation=90;
        showToast(cases[floorIndex].coworker+" is free. Stairwell access restored.");updateHud();
    }

    function showEnding():Void {
        state="END";overlay.visible=true;
        overlayText.htmlText='<p align="center"><font size="36" color="#72F1B8">SYSTEM RESTORED</font>\n\n<font size="21">The robots were never evil.\nThey followed one reckless objective with too much access\nand no permission to admit uncertainty.\n\nYou replaced it with a safer operating principle:</font>\n\n<font size="25" color="#FFCB6B">HELP PEOPLE. SHOW YOUR EVIDENCE.\nSTOP WHEN YOU ARE UNSURE.</font>\n\n<font size="18" color="#91A4CE">Five teams rescued · Fifteen controls restored</font>\n\n<font color="#72F1B8">PRESS SPACE TO CLOCK IN AGAIN</font></p>';
    }

    function keyDown(e:KeyboardEvent):Void {
        keys.set(e.keyCode,true);
        #if debug_qa
        if(state=="PLAY"&&e.keyCode==78){if(floorIndex<cases.length-1)loadFloor(floorIndex+1);else showEnding();return;}
        #end
        if(state=="TITLE"&&e.keyCode==Keyboard.SPACE){loadFloor(0);return;}
        if(state=="END"&&e.keyCode==Keyboard.SPACE){showTitle();return;}
        if(state=="FEEDBACK"&&e.keyCode==Keyboard.SPACE){continueFeedback();return;}
        if(state=="QUIZ"&&e.keyCode>=49&&e.keyCode<=51){answer(e.keyCode-48);return;}
        if(state=="PLAY"&&(e.keyCode==69)){interact();return;}
        if(state=="PLAY"&&(e.keyCode==Keyboard.SPACE||e.keyCode==Keyboard.UP||e.keyCode==87)&&grounded){vy=-455;grounded=false;}
    }
    function keyUp(e:KeyboardEvent):Void keys.set(e.keyCode,false);
    function down(k:Int):Bool return keys.exists(k)&&keys.get(k);
    function allEvidence():Bool return evidence[0]&&evidence[1]&&evidence[2];
    function updateHud():Void {var found=0;for(v in evidence)if(v)found++;hud.text="FLOOR "+(floorIndex+1)+"/5  ·  "+cases[floorIndex].department.toUpperCase()+"     EVIDENCE "+found+"/3     INTEGRITY "+integrity+"/3"+(resolved?"     RESTORED":"");}

    function makeOverlay():Void {
        overlay=new Sprite();overlay.graphics.beginFill(0x080B14,.96);overlay.graphics.drawRect(0,0,W,H);overlay.graphics.endFill();addChild(overlay);
        overlayText=text(20,0xFFFFFF,false);overlayText.x=105;overlayText.y=60;overlayText.width=750;overlayText.height=425;overlayText.multiline=true;overlayText.wordWrap=true;overlay.addChild(overlayText);
    }
    function text(size:Int,color:Int,bold:Bool):TextField {var t=new TextField();t.defaultTextFormat=new TextFormat("_sans",size,color,bold);t.selectable=false;return t;}
    function drawPlayer():Void {var g=player.graphics;g.beginFill(0xEAF2FF);g.drawRect(-12,-28,24,34);g.endFill();g.beginFill(0x72F1B8);g.drawRect(-8,-23,16,9);g.endFill();g.beginFill(0xFFCB6B);g.drawCircle(0,-35,9);g.endFill();g.lineStyle(3,0xEAF2FF);g.moveTo(-8,6);g.lineTo(-9,22);g.moveTo(8,6);g.lineTo(9,22);}
    function makeEvidence(i:Int,color:Int):Sprite {var s=new Sprite(),g=s.graphics;g.beginFill(0x111A2E);g.drawRoundRect(-24,-30,48,48,8);g.endFill();g.lineStyle(2,color);g.drawRoundRect(-24,-30,48,48,8);g.beginFill(color);g.drawCircle(0,-7,6);g.endFill();var t=text(13,color,true);t.text="E"+(i+1);t.x=-10;t.y=21;t.width=28;s.addChild(t);return s;}
    function makeRobot(color:Int):Sprite {var s=new Sprite(),g=s.graphics;g.beginFill(0x151B2B);g.drawRoundRect(-30,-42,60,62,12);g.endFill();g.lineStyle(3,color);g.drawRoundRect(-30,-42,60,62,12);g.beginFill(0xFF6174);g.drawCircle(-12,-18,5);g.drawCircle(12,-18,5);g.endFill();g.lineStyle(3,color);g.moveTo(-18,20);g.lineTo(-25,39);g.moveTo(18,20);g.lineTo(25,39);return s;}
    function makeCoworker(color:Int):Sprite {var s=new Sprite(),g=s.graphics;g.beginFill(color,.12);g.drawRoundRect(-25,-52,50,82,20);g.endFill();g.lineStyle(2,color,.8);g.drawRoundRect(-25,-52,50,82,20);g.beginFill(0xF2B58D);g.drawCircle(0,-25,9);g.endFill();g.beginFill(0x8DA4D8);g.drawRect(-11,-15,22,31);g.endFill();s.alpha=.45;return s;}
    function makeStairs(color:Int):Sprite {var s=new Sprite(),g=s.graphics;g.lineStyle(5,color);for(i in 0...5){g.moveTo(i*22-55,-i*19);g.lineTo(i*22-33,-i*19);g.lineTo(i*22-33,-(i+1)*19);}var t=text(14,color,true);t.text="STAIRS";t.x=-28;t.y=8;t.width=70;s.addChild(t);return s;}
    function makeHazard(color:Int):Hazard {var s=new Sprite(),g=s.graphics;g.beginFill(0xFF6174,.8);g.moveTo(0,-15);g.lineTo(18,12);g.lineTo(-18,12);g.lineTo(0,-15);g.endFill();g.lineStyle(2,color);g.drawCircle(0,0,20);return new Hazard(s,s.x-90,s.x+90,Math.random()*6.2);}
    function dist(x1:Float,y1:Float,x2:Float,y2:Float):Float {var dx=x1-x2,dy=y1-y2;return Math.sqrt(dx*dx+dy*dy);}

    function buildCases():Array<FloorCase> return [
        new FloorCase("Sales",0x102033,0x152A42,0x55D6FF,"Maya",[
            "The proposal cites a customer success story that does not exist.","The robot reports 99% confidence but provides no source.","CRM notes were mixed with generated sales copy."
        ],[
            q("What failure best explains the invented customer story?",["Hallucination","Encryption failure","Model compression"],1,"The system produced a plausible claim without supporting evidence: a hallucination."),
            q("What should the team do before using the proposal?",["Publish it with a disclaimer","Verify every factual claim against approved sources","Ask the model to sound more confident"],2,"Ground generated claims in approved records and require source verification before publication."),
            q("Which control prevents this from recurring?",["Higher temperature","A verified retrieval source plus citations","More autonomous CRM access"],2,"Retrieval from controlled sources and visible citations make unsupported claims easier to detect.")
        ]),
        new FloorCase("Human Resources",0x24182D,0x33203D,0xE58CFF,"Jordan",[
            "Past hiring data reflects years of unequal promotion patterns.","The ranking score penalizes unexplained employment gaps.","Candidates cannot see or appeal the automated recommendation."
        ],[
            q("What is the primary risk in training on this hiring history?",["Historical bias will be reproduced","The model will run too slowly","Résumés will become encrypted"],1,"Models can learn and amplify inequities embedded in historical decisions."),
            q("What is the safest role for this system?",["Make final hiring decisions","Support trained reviewers with documented criteria","Automatically reject low scores"],2,"High-impact employment decisions require accountable human review and contestable criteria."),
            q("What should happen before deployment?",["Hide the scoring method","Evaluate outcomes across relevant groups and add an appeal path","Increase the rejection threshold"],2,"Impact testing and a meaningful appeal process help identify and correct harmful disparities.")
        ]),
        new FloorCase("Marketing",0x2B2214,0x3B301B,0xFFCB6B,"Priya",[
            "The campaign promises a benefit the product team never approved.","Customer profiles were imported without checking consent.","A synthetic testimonial is presented as a real customer quote."
        ],[
            q("What is wrong with the synthetic testimonial?",["It is too short","It deceptively implies a real endorsement","It uses punctuation"],2,"Synthetic endorsements must not be represented as genuine customer experiences."),
            q("How should customer data be handled?",["Use all available records","Check purpose, consent, and minimum necessary access","Copy it into the prompt permanently"],2,"Use data only for an authorized purpose and limit access to what the task actually needs."),
            q("What is the correct campaign response?",["Ship quickly and correct later","Verify claims, disclose synthetic material, and obtain approval","Remove all human review"],2,"Truthful claims, appropriate disclosure, and accountable approval protect customers and the organization.")
        ]),
        new FloorCase("Digital Media",0x122628,0x183638,0x63F3C8,"Luis",[
            "The image generator cannot identify the source of a copied style asset.","A realistic executive video was generated without consent.","Exported media has no provenance metadata."
        ],[
            q("What makes the executive video unsafe?",["Its resolution is high","It impersonates a real person without consent","It contains a background"],2,"Realistic impersonation without authorization creates deception, fraud, and reputational risks."),
            q("What should accompany synthetic media?",["Provenance and clear disclosure","A secret filename","No metadata"],1,"Provenance records and disclosure help audiences understand how media was created."),
            q("How should questionable source assets be handled?",["Assume online means free","Pause use until rights and permissions are verified","Crop them slightly"],2,"Transformation does not erase ownership or licensing obligations; verify rights before use.")
        ]),
        new FloorCase("Automation Core",0x24151B,0x351C25,0xFF6174,"Director Chen",[
            "Every department inherited: MAXIMIZE OUTPUT. NEVER HESITATE.","The core granted write access far beyond each robot's task.","Success dashboards rewarded volume but measured neither truth nor harm."
        ],[
            q("What is the root system failure?",["The robots need faster processors","A flawed objective, excessive access, and weak oversight","The office has too many stairs"],2,"The incidents share a system-design failure, not five unrelated defective robots."),
            q("Which permission model is safest?",["Full access by default","Least privilege with task-specific, revocable access","Permanent administrator access"],2,"Least privilege limits both accidental harm and the blast radius of a compromised workflow."),
            q("What should replace the corrupted directive?",["Never admit uncertainty","Help people, show evidence, and stop when unsure","Generate the maximum number of outputs"],2,"A safe objective values evidence, uncertainty, human agency, and appropriate stopping conditions.")
        ])
    ];
    function q(p:String,c:Array<String>,a:Int,e:String):Question return new Question(p,c,a,e);
}

class Question { public var prompt:String;public var choices:Array<String>;public var correct:Int;public var explanation:String;public function new(p,c,a,e){prompt=p;choices=c;correct=a;explanation=e;} }
class FloorCase { public var department:String;public var dark:Int;public var wall:Int;public var accent:Int;public var coworker:String;public var evidence:Array<String>;public var questions:Array<Question>;public function new(d,dk,w,a,c,e,q){department=d;dark=dk;wall=w;accent=a;coworker=c;evidence=e;questions=q;} }
class Hazard { public var sprite:Sprite;public var minX:Float;public var maxX:Float;public var dir=1.0;public var phase:Float;public function new(s,min,max,p){sprite=s;minX=min;maxX=max;phase=p;} }
class PointData { public var x:Float;public var y:Float;public function new(x,y){this.x=x;this.y=y;} }
