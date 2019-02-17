package;
import openfl.display.Tile;
import openfl.geom.ColorTransform;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;

/**
 * ...
 * @author ...
 */
class Ball extends Tile
{
	var shadow:Tile;
	public var realX:Float;
	public var realY:Float;
	public var realZ:Float;

	public var velocity = {'x': .0, 'y': .0, 'z': .0}
	public var accel = {'x': .0, 'y': .0, 'z': .0}
	public var gravity = {'x': .0, 'y': .0, 'z': 0.2}
	
	static var BALL_WIDTH = 30;
	static var BALL_HEIGHT = 28;
	public function new(x, y, z) 
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
		
		this.shadow.alpha = 0.5; 
		@:privateAccess Main.instance.tilemap.addTile(this.shadow);
		updatePosition();
	}
	
	public function setVelocity(x, y, z) {
		trace('Here');
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
			//setAccel(0, 0, -20);
			setVelocity(5, 5, -20);
		}
	}
	
	public function update() {
		updateForces();
		updatePosition();
	}
	
	public function updateForces() {
		this.velocity.x += accel.x;
		this.velocity.y += accel.y;
		this.velocity.z += accel.z;
		
		accel.x *= 0.8;
		accel.y *= 0.8;
		accel.z *= 0.8;
		
		
		
		if (this.velocity.z < 0) {
			this.velocity.z += 6.5;
		}
		trace(this.velocity);
		this.realX += this.velocity.x;
		this.realY += this.velocity.y;
		this.realZ += this.velocity.z;
		
		if (this.realZ > 0) this.realZ = 0;
		if (this.velocity.z > 0 && this.realZ == 0) {
			this.velocity.z = 0;
		}
		this.velocity.x *= 0.89;
		this.velocity.y *= 0.89;
	}
	
	public function updatePosition() {
		this.x = this.realX + BALL_WIDTH / 2;
		this.y = this.realY + this.realZ + BALL_HEIGHT / 2;
		this.shadow.x = this.realX + BALL_WIDTH / 2;
		this.shadow.y = this.realY + BALL_HEIGHT / 2 + 12;
	}
	
}