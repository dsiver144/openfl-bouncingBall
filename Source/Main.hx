package;


import openfl.Assets;
import openfl.display.Tile;
import openfl.geom.Rectangle;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
import openfl.events.MouseEvent;
import haxe.Timer;
import openfl.text.TextField;
import openfl.display.FPS;

class Main extends Sprite {
	
	public static inline var SCREEN_WIDTH = 1920;
	public static inline var SCREEN_HEIGHT = 1080;
	
	public static var instance(default, null):Main;
	
	var tilemap(default, null):Tilemap;
	
	var ball:Ball;
	var balls:Array<Ball> = [];
	
	var previousTime(default, null):Float = Timer.stamp();
	var deltaTime(default, null):Float = 0;
	
	var camera(default, null) = {'x': .0, 'y': .0, 'width': SCREEN_WIDTH, 'height': SCREEN_HEIGHT, 'target': null};
	var targetIndex = 0;
	
	public function new () {
		instance = this;
		super ();
		this.graphics.beginFill(0xf14e61);
		this.graphics.drawRect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
		this.graphics.endFill();
		var bmd = Assets.getBitmapData("assets/Ball.png");
		
		tilemap = new Tilemap(SCREEN_WIDTH, SCREEN_HEIGHT, new Tileset(bmd, [
			new Rectangle(0, 0, 30, 28), // Ball
			new Rectangle(30, 0, 30, 28) // Ball Shadow
		]));
		
		addChild(tilemap);
		
		balls.push(new Ball(200, 200, 0));
		for (i in 0...20) {
			balls.push(new Ball(Math.random() * SCREEN_WIDTH, Math.random() * SCREEN_HEIGHT, 0, false));
		}
		// Set Default Camera Target To The First Ball
		targetIndex = 0;
		setCameraTarget(balls[targetIndex]);
		
		for (otherBall in balls) {
			tilemap.addTile(otherBall);
		}
		tilemap.addTile(ball);
		
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.addEventListener(MouseEvent.CLICK, onClick);
		stage.addEventListener(Event.RESIZE, onStageResize);
		
		var textField = new TextField();
		textField.text = "Click to move \n Press [Space] to target other ball.";
		textField.textColor = 0xffffff;
		textField.width = 300;
		textField.height = 300;
		textField.x = 0;
		textField.y = 0;
		textField.scaleX = textField.scaleY = 2.0;
		addChild(textField);
		
		var fps = new FPS();
		fps.y = 64;
		fps.textColor = 0xffffff;
		addChild(fps);
		
	}
	
	function setCameraTarget(target: Ball) {
		camera.target = target;
	}
	
	function onClick(e:MouseEvent):Void {
		var target = camera.target;
		trace(e.localX, e.localY);
		var dx = e.localX - target.x;
		var dy = e.localY - target.y;
		target.setVelocity(dx * 0.14, dy * 0.14, -60);
	}
	
	function onStageResize(e:Event):Void {
		scaleX = scaleY = Math.min(stage.stageWidth / SCREEN_WIDTH, stage.stageHeight / SCREEN_HEIGHT);
		x = (stage.stageWidth - width) * 0.5;
		y = (stage.stageHeight - height) * 0.5;
	}
	
	function onKeyDown(e:KeyboardEvent):Void {
		//ball.onKeyDown(e);
		if (e.keyCode == Keyboard.SPACE) {
			targetIndex += 1;
			if (targetIndex == balls.length) targetIndex = 0;
			setCameraTarget(balls[targetIndex]);
			tilemap.addTile(camera.target);
		}
	}
	
	function onEnterFrame(e:Event):Void {
		// Update stuff here
		for (otherBall in balls) {
			otherBall.update();
		}
	}
	
	
}