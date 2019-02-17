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
import openfl.events.MouseEvent;

class Main extends Sprite {
	
	public static inline var SCREEN_WIDTH = 1600;
	public static inline var SCREEN_HEIGHT = 900;
	
	public static var instance(default, null):Main;
	var tilemap(default, null):Tilemap;
	var ball:Ball;
	
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
		
		ball = new Ball(200, 200, 0);
		
		tilemap.addTile(ball);
		
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.addEventListener(MouseEvent.CLICK, onClick);
	}
	
	function onClick(e:MouseEvent):Void {
		trace(e.localX, e.localY);
		var dx = e.localX - ball.realX;
		var dy = e.localY - ball.realY;
		ball.setVelocity(dx * 0.14, dy * 0.14, -35);
	}
	
	function onKeyDown(e:KeyboardEvent):Void {
		trace('Here');
		ball.onKeyDown(e);
	}
	
	function onEnterFrame(e:Event):Void {
		// Update stuff here
		ball.update();
	}
	
	
}