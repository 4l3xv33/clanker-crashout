package;

import data.FloorData;
import data.GameContent;
import entities.Coworker;
import entities.Hazard;
import entities.Player;
import entities.Robot;
import flash.Lib;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.display.StageDisplayState;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.geom.ColorTransform;
import flash.ui.Keyboard;
import systems.SaveManager;
import systems.SoundManager;
import ui.Hud;
import ui.EvidenceIcon;
import ui.IncidentPanel;
import ui.PausePanel;
import ui.PromptBar;
import ui.Theme;
import ui.TouchControls;
import visual.TitleArt;
import world.LevelView;

class Main extends Sprite {
    static inline var W=960;
    static inline var H=540;

    var floors:Array<FloorData>;
    var floorIndex=0;
    var save:SaveManager;
    var audio:SoundManager;
    var keys:Map<Int,Bool>=new Map();

    var world:Sprite;
    var level:LevelView;
    var actors:Sprite;
    var player:Player;
    var robot:Robot;
    var coworker:Coworker;
    var stairs:Sprite;
    var terminals:Array<Sprite>=[];
    var hazards:Array<Hazard>=[];

    var hud:Hud;
    var prompt:PromptBar;
    var incident:IncidentPanel;
    var pausePanel:PausePanel;
    var screen:Sprite;
    var screenText:flash.text.TextField;
    var titleArt:Bitmap;
    var playButton:Sprite;
    var actionButton:Sprite;
    var touch:TouchControls;
    var touchEnabled=false;

    var state="TITLE";
    var previousState="PLAY";
    var evidence:Array<Bool>=[false,false,false];
    var integrity=3;
    var questionIndex=0;
    var inspectingIndex=-1;
    var lastEvidenceCorrect=false;
    var lastCorrect=false;
    var resolved=false;
    var cameraX=0.0;
    var checkpointX=70.0;
    var invincible=0.0;
    var lastTime=0;
    var levelTime=0.0;

    public static function main():Void Lib.current.addChild(new Main());
    public function new(){super();addEventListener(Event.ADDED_TO_STAGE,init);}

    function init(_:Event):Void {
        touchEnabled=Reflect.field(loaderInfo.parameters,"mobile")=="1";stage.scaleMode=touchEnabled?flash.display.StageScaleMode.EXACT_FIT:flash.display.StageScaleMode.SHOW_ALL;stage.align=flash.display.StageAlign.TOP_LEFT;stage.color=Theme.BG;
        floors=GameContent.floors();save=new SaveManager();audio=new SoundManager();audio.enabled=save.settings.sound;
        world=new Sprite();actors=new Sprite();addChild(world);
        player=new Player();
        hud=new Hud();addChild(hud);prompt=new PromptBar();addChild(prompt);incident=new IncidentPanel();addChild(incident);pausePanel=new PausePanel();addChild(pausePanel);makeScreen();
        touch=new TouchControls(touchJump,touchUse,touchNotes,touchPause);addChild(touch);if(touchEnabled)prompt.setTouchLayout();
        stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDown);stage.addEventListener(KeyboardEvent.KEY_UP,keyUp);stage.addEventListener(MouseEvent.CLICK,onClick);addEventListener(Event.ENTER_FRAME,update);
        applyAccessibility();showTitle();
    }

    function makeScreen():Void {
        screen=new Sprite();screen.graphics.beginFill(Theme.BG);screen.graphics.drawRect(0,0,W,H);screen.graphics.endFill();addChild(screen);
        titleArt=new Bitmap(new TitleArt(0,0));titleArt.width=W;titleArt.height=H;titleArt.smoothing=true;screen.addChild(titleArt);
        var shade=new Sprite();shade.graphics.beginFill(0x050810,.22);shade.graphics.drawRect(0,0,W,H);shade.graphics.endFill();shade.graphics.beginFill(0x050810,.84);shade.graphics.drawRect(0,0,525,H);shade.graphics.endFill();screen.addChild(shade);
        screenText=Theme.field(20,Theme.TEXT,false);screenText.x=48;screenText.y=46;screenText.width=455;screenText.height=350;screen.addChild(screenText);
        playButton=makeButton("PLAY",48,415,190,58,Theme.MINT);screen.addChild(playButton);playButton.addEventListener(MouseEvent.CLICK,function(e:MouseEvent){e.stopPropagation();if(state=="TITLE")beginFloor(Std.int(Math.min(save.highestFloor,floors.length-1)));else if(state=="ENDING")showTitle();});
        actionButton=makeButton("ENTER FLOOR",365,405,230,56,Theme.MINT);addChild(actionButton);actionButton.addEventListener(MouseEvent.CLICK,function(e:MouseEvent){e.stopPropagation();if(state=="BRIEFING")startPlay();else if(state=="FEEDBACK")continueFeedback();else if(state=="EVIDENCE_FEEDBACK")continueEvidenceFeedback();else if(state=="NOTES")hideNotes();else if(state=="PAUSE")togglePause();});actionButton.visible=false;
    }

    function makeButton(label:String,x:Float,y:Float,w:Float,h:Float,color:Int):Sprite {var button=new Sprite();button.x=x;button.y=y;button.buttonMode=true;button.mouseChildren=false;button.graphics.beginFill(color);button.graphics.drawRoundRect(0,0,w,h,12);button.graphics.endFill();button.graphics.lineStyle(2,0xFFFFFF,.18);button.graphics.drawRoundRect(1,1,w-2,h-2,12);var text=Theme.field(19,0x07110D,true);text.name="label";text.x=0;text.y=16;text.width=w;text.height=28;text.autoSize=flash.text.TextFieldAutoSize.NONE;var format=new flash.text.TextFormat("_sans",19,0x07110D,true,null,null,null,null,flash.text.TextFormatAlign.CENTER);text.defaultTextFormat=format;text.text=label;text.setTextFormat(format);button.addChild(text);return button;}
    function buttonLabel(button:Sprite,label:String):Void {var text=cast(button.getChildByName("label"),flash.text.TextField);text.text=label;}

    function showTitle():Void {
        state="TITLE";screen.visible=true;titleArt.visible=true;playButton.visible=true;buttonLabel(playButton,"PLAY");actionButton.visible=false;touch.visible=false;touch.reset();hud.visible=false;prompt.visible=false;incident.hide();pausePanel.hide();
        screenText.htmlText='<font size="40" color="#72F1B8">ROGUE INFERENCE</font>\n<font size="18" color="#FFFFFF"><i>Correct the model. Rescue the humans.</i></font>\n\n<font size="20" color="#FFFFFF">The system is confident.\nThe system is wrong.</font>\n\n<font size="18" color="#D8E3F5">Investigate five corrupted departments, repair their decisions, and restore the humans.</font>\n\n<font size="14" color="#A8B8D4">WASD / Arrows  ·  Space jump  ·  E inspect  ·  Esc settings</font>';
    }

    function showFloorSelect():Void {
        state="SELECT";screen.visible=true;titleArt.visible=false;playButton.visible=false;actionButton.visible=false;touch.visible=false;var list="";for(i in 0...floors.length){var unlocked=i<=save.highestFloor;list+='<font color="'+(unlocked?'#72F1B8':'#52617D')+'">'+(i+1)+'  '+floors[i].department+(unlocked?'':'  [LOCKED]')+'</font>\n\n';}
        screenText.htmlText='<font size="31" color="#FFFFFF">SELECT A FLOOR</font>\n<font size="15" color="#8FA1C6">Completed departments remain available for review.</font>\n\n<font size="20">'+list+'</font><font size="14" color="#8FA1C6">Press 1–5 · Esc returns to title</font>';
    }

    function beginFloor(index:Int):Void {
        floorIndex=index;state="BRIEFING";screen.visible=false;playButton.visible=false;touch.visible=false;hud.visible=true;pausePanel.hide();incident.briefing(floors[index]);buttonLabel(actionButton,"ENTER FLOOR");actionButton.visible=true;
        buildFloor();
    }

    function buildFloor():Void {
        while(world.numChildren>0)world.removeChildAt(0);level=new LevelView(floors[floorIndex],floorIndex);world.addChild(level);actors=new Sprite();world.addChild(actors);
        evidence=[false,false,false];integrity=3;questionIndex=0;inspectingIndex=-1;resolved=false;cameraX=0;checkpointX=70;levelTime=0;terminals=[];hazards=[];
        player.x=70;player.y=LevelView.GROUND-40;player.vx=0;player.vy=0;actors.addChild(player);
        for(i in 0...3){var terminal=makeTerminal(i,floors[floorIndex].accent);var p=level.evidencePositions[i];terminal.x=p.x;terminal.y=p.y;actors.addChild(terminal);terminals.push(terminal);}
        robot=new Robot(floors[floorIndex].accent,floors[floorIndex].robot,floorIndex);robot.x=level.robotX;robot.y=LevelView.GROUND-44;actors.addChild(robot);
        coworker=new Coworker(floors[floorIndex].accent,floors[floorIndex].coworker,floors[floorIndex].role,floorIndex);coworker.x=level.robotX+112;coworker.y=LevelView.GROUND-29;actors.addChild(coworker);
        stairs=makeStairs(floors[floorIndex].accent);stairs.x=level.stairsX;stairs.y=LevelView.GROUND;actors.addChild(stairs);
        var xs=[590.0,920.0,1210.0,1540.0];for(i in 0...xs.length){var minX=xs[i]-75,maxX=xs[i]+75;actors.addChildAt(makePatrolTrack(minX,maxX,floors[floorIndex].accent),0);var hazard=new Hazard(floors[floorIndex].accent,xs[i],minX,maxX,i+floorIndex,floorIndex);hazard.sprite.y=LevelView.GROUND-23;actors.addChild(hazard.sprite);hazards.push(hazard);}
        #if qa
        evidence=[true,true,true];for(terminal in terminals)terminal.alpha=.28;player.x=level.robotX-105;checkpointX=player.x;
        #end
        updateHud();
    }

    function startPlay():Void {state="PLAY";incident.hide();actionButton.visible=false;touch.visible=touchEnabled;prompt.toast(touchEnabled?"Find the evidence. Use the on-screen controls to investigate.":"Find the evidence. Press E near highlighted objects to inspect them.",3.5);}

    function update(_:Event):Void {
        var now=Lib.getTimer();if(lastTime==0)lastTime=now;var dt=Math.min((now-lastTime)/1000,.04);lastTime=now;
        prompt.update(dt);if(state!="PLAY")return;levelTime+=dt;invincible-=dt;
        var input=0.0;if(down(Keyboard.LEFT)||down(65)||touch.left)input-=1;if(down(Keyboard.RIGHT)||down(68)||touch.right)input+=1;
        if(player.grounded)player.coyote=.1;else player.coyote-=dt;player.jumpBuffer-=dt;
        var acceleration=player.grounded ? 1250 : 760;player.vx+=input*acceleration*dt;var drag=player.grounded ? .035 : .32;player.vx*=Math.pow(drag,dt);if(player.vx>285)player.vx=285;if(player.vx< -285)player.vx=-285;
        if(input!=0)player.facing=input<0?-1:1;
        if(player.jumpBuffer>0&&player.coyote>0){player.vy=-470;player.jumpBuffer=0;player.coyote=0;player.grounded=false;audio.play("jump");}
        var oldY=player.y;player.vy+=1120*dt;player.x+=player.vx*dt;player.y+=player.vy*dt;if(player.x<18){player.x=18;player.vx=0;}if(player.x>LevelView.WIDTH-18){player.x=LevelView.WIDTH-18;player.vx=0;}
        collide(oldY);if(player.y>H+100)respawn("A broken workflow dropped you from the process.");
        for(h in hazards){h.update(dt,LevelView.GROUND,save.settings.reducedMotion);if(!h.disabled&&invincible<=0&&distance(player.x,player.y,h.sprite.x,h.sprite.y)<31)damage(h.failureName+" interrupted your investigation.");}
        player.animate(dt,Math.abs(player.vx)>20,false,save.settings.reducedMotion);player.alpha=(invincible>0&&Std.int(invincible*12)%2==0) ? .3 : 1;robot.update(dt,save.settings.reducedMotion);
        var target=Math.max(0,Math.min(LevelView.WIDTH-W,player.x-W*.42));cameraX+=save.settings.reducedMotion?(target-cameraX):(target-cameraX)*Math.min(1,dt*6);world.x=-cameraX;context();updateTarget();
    }

    function collide(oldY:Float):Void {
        player.grounded=false;var oldFeet=oldY+40;var feet=player.y+40;
        for(p in level.platforms)if(player.vy>=0&&player.x+13>p.x&&player.x-13<p.x+p.width&&oldFeet<=p.y+7&&feet>=p.y){player.y=p.y-40;player.vy=0;player.grounded=true;return;}
    }

    function context():Void {
        player.pulseScanner(false);
        for(i in 0...3)if(!evidence[i]&&distance(player.x,player.y,terminals[i].x,terminals[i].y)<82){prompt.hint("[E] "+floors[floorIndex].mechanic+" · "+floors[floorIndex].evidence[i].title);player.pulseScanner(true);return;}
        for(h in hazards)if(!h.disabled&&distance(player.x,player.y,h.sprite.x,h.sprite.y)<115){prompt.hint(h.failureName+" · Follow its fixed track and time your crossing");return;}
        if(distance(player.x,player.y,robot.x,robot.y)<125){prompt.hint(allEvidence()?(questionIndex==0?"[E] Confront "+floors[floorIndex].robot:"[E] Apply control "+(questionIndex+1)+" / 3"):"ACCESS DENIED · Find all three evidence records");return;}
        if(distance(player.x,player.y,stairs.x,LevelView.GROUND-40)<120){prompt.hint(resolved?"[E] Take the stairs":"STAIRWELL LOCKED · Restore this floor");return;}
        player.pulseScanner(false);
    }

    function interact():Void {
        for(i in 0...3)if(!evidence[i]&&distance(player.x,player.y,terminals[i].x,terminals[i].y)<82){player.playAction("interact");inspectEvidence(i);return;}
        if(distance(player.x,player.y,robot.x,robot.y)<125&&allEvidence()){player.playAction("interact");showQuestion();return;}
        if(distance(player.x,player.y,stairs.x,LevelView.GROUND-40)<120&&resolved){player.playAction("interact");if(floorIndex<floors.length-1)beginFloor(floorIndex+1);else showEnding();}
    }

    function inspectEvidence(index:Int):Void {inspectingIndex=index;state="EVIDENCE";touch.visible=false;touch.reset();actionButton.visible=false;incident.evidence(floors[floorIndex],floors[floorIndex].evidence[index],index);}
    function answerEvidence(choice:Int):Void {if(state!="EVIDENCE")return;var item=floors[floorIndex].evidence[inspectingIndex];lastEvidenceCorrect=choice==item.correct;if(lastEvidenceCorrect)audio.play("correct");else{integrity--;audio.play("wrong");if(integrity<=0)integrity=3;}state="EVIDENCE_FEEDBACK";incident.evidenceFeedback(item,lastEvidenceCorrect,integrity);buttonLabel(actionButton,lastEvidenceCorrect?"LOG EVIDENCE":"RETRY ANALYSIS");actionButton.visible=true;updateHud();}
    function continueEvidenceFeedback():Void {if(lastEvidenceCorrect)collectEvidence(inspectingIndex);else inspectEvidence(inspectingIndex);}
    function collectEvidence(index:Int):Void {evidence[index]=true;terminals[index].alpha=.28;if(index<hazards.length)hazards[index].disable();checkpointX=Math.max(checkpointX,terminals[index].x-90);audio.play("evidence");incident.hide();actionButton.visible=false;state="PLAY";touch.visible=touchEnabled;prompt.toast("CASE NOTE "+(index+1)+": "+floors[floorIndex].evidence[index].summary+"  Related process isolated.",5.4);updateHud();}
    function showQuestion():Void {state="QUIZ";touch.visible=false;touch.reset();actionButton.visible=false;incident.question(floors[floorIndex],questionIndex);}
    function answer(choice:Int):Void {if(state!="QUIZ")return;var q=floors[floorIndex].questions[questionIndex];lastCorrect=choice==q.correct;if(lastCorrect)audio.play("correct");else{integrity--;audio.play("wrong");if(integrity<=0)integrity=3;}state="FEEDBACK";incident.feedback(q,lastCorrect,integrity);buttonLabel(actionButton,lastCorrect?"CONTINUE":"TRY AGAIN");actionButton.visible=true;updateHud();}
    function continueFeedback():Void {if(!lastCorrect){showQuestion();return;}questionIndex++;robot.applyPatch(questionIndex);if(questionIndex>=3)restoreFloor();else{state="PLAY";incident.hide();actionButton.visible=false;touch.visible=touchEnabled;prompt.toast("CONTROL "+questionIndex+" / 3 APPLIED · Corruption weakened. Re-engage "+floors[floorIndex].robot+".",4.2);updateHud();}}

    function restoreFloor():Void {state="PLAY";resolved=true;incident.hide();touch.visible=touchEnabled;robot.restore();coworker.release();audio.play("repair");save.unlock(Std.int(Math.min(floors.length-1,floorIndex+1)));prompt.toast(floors[floorIndex].coworker+": "+floors[floorIndex].rescueLine+"  Stairwell access restored.",5.5);updateHud();}

    function damage(message:String):Void {integrity--;invincible=1.4;player.playAction("damage");player.vx=-player.facing*210;player.vy=-260;audio.play("damage");if(integrity<=0){integrity=3;respawn("Coaching checkpoint restored your integrity.");}else prompt.toast(message+"  Integrity -1",3.4);updateHud();}
    function respawn(message:String):Void {player.x=checkpointX;player.y=250;player.vx=0;player.vy=0;invincible=1.5;prompt.toast(message,3.5);}

    function showNotes():Void {previousState=state;state="NOTES";touch.visible=false;touch.reset();screen.visible=true;if(touchEnabled){buttonLabel(actionButton,"CLOSE NOTES");actionButton.visible=true;}var body="";for(i in 0...3)body+='<font color="'+(evidence[i]?'#72F1B8':'#52617D')+'">'+(i+1)+'  '+(evidence[i]?floors[floorIndex].evidence[i].summary:'Evidence not yet verified')+'</font>\n\n';screenText.htmlText='<font size="30" color="#FFFFFF">CASE FILE · '+floors[floorIndex].department.toUpperCase()+'</font>\n<font size="14" color="#8FA1C6">'+floors[floorIndex].mechanicBrief+'</font>\n\n<font size="17">'+body+'</font><font size="14" color="#FFCB6B">'+(touchEnabled?'Use Close Notes to return':'Press G or Esc to close')+'</font>';}
    function hideNotes():Void {screen.visible=false;actionButton.visible=false;state=previousState;touch.visible=touchEnabled&&state=="PLAY";}

    function togglePause():Void {if(state=="PAUSE"){state="PLAY";pausePanel.hide();actionButton.visible=false;touch.visible=touchEnabled;}else if(state=="PLAY"){state="PAUSE";touch.visible=false;touch.reset();pausePanel.show(save.settings);if(touchEnabled){buttonLabel(actionButton,"RESUME");actionButton.visible=true;}}}
    function updatePause():Void {audio.enabled=save.settings.sound;applyAccessibility();save.persist();pausePanel.show(save.settings);}
    function applyAccessibility():Void {world.transform.colorTransform=save.settings.highContrast?new ColorTransform(1.24,1.24,1.24,1,10,10,10,0):new ColorTransform();hud.setLargeText(save.settings.largeText);prompt.setLargeText(save.settings.largeText);incident.setLargeText(save.settings.largeText);pausePanel.setLargeText(save.settings.largeText);}

    function showEnding():Void {state="ENDING";screen.visible=true;titleArt.visible=true;playButton.visible=true;buttonLabel(playButton,"RETURN TO TITLE");actionButton.visible=false;incident.hide();hud.visible=false;screenText.htmlText='<font size="38" color="#72F1B8">SYSTEM RESTORED</font>\n\n<font size="21" color="#FFFFFF">The robots were never evil. They followed a reckless objective with too much access and no permission to admit uncertainty.</font>\n\n<font size="24" color="#FFCB6B">HELP PEOPLE. SHOW YOUR EVIDENCE.\nSTOP WHEN YOU ARE UNSURE.</font>\n\n<font size="17" color="#B9CAE7">Five teams rescued · Fifteen controls restored</font>';}

    function keyDown(e:KeyboardEvent):Void {
        keys.set(e.keyCode,true);
        #if qa
        if(state=="PLAY"&&e.keyCode==78){if(floorIndex<floors.length-1)beginFloor(floorIndex+1);else showEnding();return;}
        #end
        if(state=="TITLE"){if(e.keyCode==76)showFloorSelect();return;}
        if(state=="SELECT"){var selected=Std.int(e.keyCode)-49;if(e.keyCode==Keyboard.ESCAPE)showTitle();else if(e.keyCode>=49&&e.keyCode<=53&&selected<=save.highestFloor)beginFloor(selected);return;}
        if(state=="BRIEFING")return;
        if(state=="QUIZ"&&e.keyCode>=49&&e.keyCode<=51){answer(Std.int(e.keyCode)-48);return;}
        if(state=="EVIDENCE"&&e.keyCode>=49&&e.keyCode<=51){answerEvidence(Std.int(e.keyCode)-48);return;}
        if(state=="FEEDBACK"||state=="EVIDENCE_FEEDBACK"||state=="ENDING")return;
        if(state=="NOTES"&&(e.keyCode==71||e.keyCode==Keyboard.ESCAPE)){hideNotes();return;}
        if(state=="PAUSE"){switch e.keyCode{case Keyboard.ESCAPE:togglePause();case 77:save.settings.sound=!save.settings.sound;updatePause();case 82:save.settings.reducedMotion=!save.settings.reducedMotion;updatePause();case 72:save.settings.highContrast=!save.settings.highContrast;updatePause();case 84:save.settings.largeText=!save.settings.largeText;updatePause();}return;}
        if(state!="PLAY")return;
        if(e.keyCode==Keyboard.ESCAPE){togglePause();return;}if(e.keyCode==71){showNotes();return;}if(e.keyCode==69){interact();return;}if(e.keyCode==70){try stage.displayState=stage.displayState==StageDisplayState.NORMAL?StageDisplayState.FULL_SCREEN_INTERACTIVE:StageDisplayState.NORMAL catch(_:Dynamic){}return;}
        if(e.keyCode==Keyboard.SPACE||e.keyCode==Keyboard.UP||e.keyCode==87)player.jumpBuffer=.12;
    }
    function keyUp(e:KeyboardEvent):Void {keys.set(e.keyCode,false);if((e.keyCode==Keyboard.SPACE||e.keyCode==Keyboard.UP||e.keyCode==87)&&player.vy< -160)player.vy=-160;}
    function touchJump():Void {if(state=="PLAY")player.jumpBuffer=.12;}
    function touchUse():Void {if(state=="PLAY")interact();}
    function touchNotes():Void {if(state=="PLAY")showNotes();else if(state=="NOTES")hideNotes();}
    function touchPause():Void {if(state=="PLAY"||state=="PAUSE")togglePause();}
    function onClick(e:MouseEvent):Void {if(state=="QUIZ"&&e.stageY>=180&&e.stageY<430){var choice=Std.int((e.stageY-180)/82)+1;if(choice>=1&&choice<=3)answer(choice);}else if(state=="EVIDENCE"&&e.stageY>=288&&e.stageY<384){var evidenceChoice=Std.int((e.stageY-288)/32)+1;if(evidenceChoice>=1&&evidenceChoice<=3)answerEvidence(evidenceChoice);}}
    function down(code:Int):Bool return keys.exists(code)&&keys.get(code);
    function allEvidence():Bool return evidence[0]&&evidence[1]&&evidence[2];
    function evidenceCount():Int {var n=0;for(v in evidence)if(v)n++;return n;}
    function updateHud():Void hud.update(floorIndex,floors[floorIndex].department,floors[floorIndex].mechanic,evidenceCount(),integrity,resolved);
    function updateTarget():Void {var targetX=0.0,label="";if(resolved){targetX=stairs.x;label="STAIRS";}else if(!allEvidence()){var best=1e9;for(i in 0...3)if(!evidence[i]){var d=Math.abs(terminals[i].x-player.x);if(d<best){best=d;targetX=terminals[i].x;label="E"+(i+1);}}}else{targetX=robot.x;label=questionIndex==0?"BOSS":"PATCH "+(questionIndex+1);}hud.setTarget(targetX-player.x,label);}
    function distance(x1:Float,y1:Float,x2:Float,y2:Float):Float {var dx=x1-x2,dy=y1-y2;return Math.sqrt(dx*dx+dy*dy);}

    function makeTerminal(index:Int,accent:Int):Sprite return new EvidenceIcon(index,accent);
    function makePatrolTrack(minX:Float,maxX:Float,accent:Int):Sprite {var s=new Sprite();s.x=minX;s.y=LevelView.GROUND-5;var width=maxX-minX,g=s.graphics;g.lineStyle(7,0x07101D,.95);g.moveTo(0,0);g.lineTo(width,0);g.lineStyle(2,0x5CDAFF,.82);g.moveTo(0,0);g.lineTo(width,0);g.beginFill(0x5CDAFF,.9);g.drawRoundRect(-3,-10,6,13,3);g.drawRoundRect(width-3,-10,6,13,3);g.endFill();g.lineStyle(1,accent,.55);for(i in 1...5){var x=width*i/5;g.moveTo(x,-3);g.lineTo(x,3);}return s;}
    function makeStairs(accent:Int):Sprite {var s=new Sprite(),g=s.graphics;g.lineStyle(6,accent);for(i in 0...6){g.moveTo(i*24-72,-i*18);g.lineTo(i*24-48,-i*18);g.lineTo(i*24-48,-(i+1)*18);}var t=Theme.field(13,accent,true);t.text="STAIRWELL";t.x=-48;t.y=8;t.width=100;t.height=20;s.addChild(t);return s;}
}
