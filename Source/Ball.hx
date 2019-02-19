package;
import openfl.display.Tile;
import openfl.geom.ColorTransform;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;

class Ball extends Tile
{
	public static inline var BALL_WIDTH = 30;
	public static inline var BALL_HEIGHT = 28;
	public static inline var CAMERA_EASING = 0.05;
	
	public var realX:Float;
	public var realY:Float;
	public var realZ:Float;

	public var velocity = {'x': .0, 'y': .0, 'z': .0}
	public var accel = {'x': .0, 'y': .0, 'z': .0}
	public var gravity = {'x': .0, 'y': .0, 'z': 0.2}
	
	var autoJumpThreshold = 0;
	var autoJumpCount = 0;
	
	var shadow:Tile;
	
	public function new(x, y, z, player = true) 
	{
		super();
		this.id = 0;
		this.shadow = new Tile();
		this.shadow.id = 1;
		this.realX = x;
		this.realY = y;
		this.realZ = z;
		this.originX = BALL_WIDTH / 2;
		this.originY = BALL_HEIGHT / 2;
		this.shadow.originX = BALL_WIDTH / 2;
		this.shadow.originY = BALL_HEIGHT / 2;
		
		autoJumpThreshold = 30 + Math.floor(Math.random() * 30);
		
		if (player == false) this.colorTransform = new ColorTransform(1, 1, 1, 1, -(Math.random() * 255), -(Math.random() * 255), -(Math.random() * 255));
		
		this.shadow.alpha = 0.5; 
		@:privateAccess Main.instance.tilemap.addTile(this.shadow);
		updatePosition();
	}
	
	public function setVelocity(x, y, z) {
		this.velocity.x = x;
		this.velocity.y = y;
		this.velocity.z = z;
	}
	
	public function setAccel(x, y, z) {
		this.accel.x = x;
		this.accel.y = y;
		this.accel.z = z;
	}
	
	public function onKeyDown(e:KeyboardEvent):Void {
		if (e.keyCode == Keyboard.SPACE) {
			//setVelocity(5, 5, -20);
		}
	}
	
	public function update() {
		updateAutoJump();
		updateForces();
		updatePosition();
	}
	
	public function updateAutoJump() {
		if (isTargeted()) return;
		if (autoJumpCount < autoJumpThreshold) {
			autoJumpCount++;
		} else {
			if (Math.random() > 0.8) {
				var dx = (Math.random() > 0.5 ? 1 : -1) * Math.floor(Math.random() * 50);
				var dy = (Math.random() > 0.5 ? 1 : -1) * Math.floor(Math.random() * 50);
				trace(dx, dy);
				setVelocity(dx, dy, -60);
			}
			autoJumpCount = 0;
		}
	}
	
	public function updateForces() {
		this.velocity.x += accel.x;
		this.velocity.y += accel.y;
		this.velocity.z += accel.z;
		
		if (this.velocity.z < 0) {
			this.velocity.z += 6.5;
			if (this.velocity.z > 0) {
				accel.z = 5;
			}
		}
		this.realX += this.velocity.x;
		this.realY += this.velocity.y;
		this.realZ += this.velocity.z;
		
		if (this.realZ > 0) this.realZ = 0;
		if (this.velocity.z > 0 && this.realZ == 0) {
			this.velocity.z *= -0.99;
		}
		
		this.velocity.x *= 0.9;
		this.velocity.y *= 0.9;
	}
	
	public function isTargeted():Bool {
		var camera = @:privateAccess Main.instance.camera;
		return camera.target == this;
	}
	
	public function updatePosition(){
		// Update Camera Following Target
		var camera = @:privateAccess Main.instance.camera;
		if (isTargeted()) {
			var dx = this.realX - camera.x;
			var dy = this.realY - camera.y;
			camera.x += dx * CAMERA_EASING;
			camera.y += dy * CAMERA_EASING;
		}
		
		var cameraOffsetX = camera.x - camera.width * 0.5;
		var cameraOffsetY = camera.y - camera.height * 0.5;
		
		this.x = this.realX + BALL_WIDTH * 0.5;
		this.y = this.realY + this.realZ + BALL_HEIGHT / 2;
		this.shadow.x = this.realX + BALL_WIDTH * 0.5;
		this.shadow.y = this.realY + BALL_HEIGHT * 0.5 + 12;
		
		this.x -= cameraOffsetX;
		this.y -= cameraOffsetY;
		this.shadow.x -= cameraOffsetX;
		this.shadow.y -= cameraOffsetY;
	}
	
}