extends KinematicBody

export var speed : float = 30
export var acceleration : float = 20
export var air_acceleration : float = 7
export var gravity : float = 0.98
export var max_terminal_velocity : float = 54
export var jump_power : float = 30

export(float, 0.1, 1) var mouse_sensitivity : float = 0.3
export(float, -40, 0) var min_pitch : float = -40
export(float, 0, 50) var max_pitch : float = 50
export (PackedScene) var Bullet

var velocity : Vector3
var y_velocity : float

onready var Camera_pivot = $CameraPivot
onready var camera = $CameraPivot/SpringArm/Camera


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_just_pressed("shoot"):
		var b = Bullet.instance()
		owner.add_child(b)
		b.transform = $Fist.global_transform
		b.velocity = b.transform.basis.z * b.muzzle_velocity
		
func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		Camera_pivot.rotation_degrees.x -= event.relative.y * mouse_sensitivity
		Camera_pivot.rotation_degrees.x = clamp(Camera_pivot.rotation_degrees.x, min_pitch, max_pitch)

func _physics_process(delta):
	handle_movement(delta)

func handle_movement(delta):

	var direction = Vector3()

	if Input.is_action_pressed("move_up"):
		direction += transform.basis.z
	
	if Input.is_action_pressed("move_back"):
		direction -= transform.basis.z
		
	if Input.is_action_pressed("move_left"):
		direction += transform.basis.x
	
	if Input.is_action_pressed("move_right"):
		direction -= transform.basis.x
		
	if Input.is_action_pressed("salto"):
		$AnimationPlayer.play("Salto-loop")
		yield($AnimationPlayer, "animation_finished")
		$AnimationPlayer.play("Wheelbarrow Walk-loop")

	direction = direction.normalized()
	
	var accel = acceleration if is_on_floor() else air_acceleration
	velocity = velocity.linear_interpolate(direction * speed, accel * delta)
	
	if is_on_floor():
		y_velocity = -0.01
	else:
		y_velocity = clamp(y_velocity - gravity, -max_terminal_velocity, max_terminal_velocity)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		y_velocity = jump_power
	
	velocity.y = y_velocity
	velocity = move_and_slide(velocity, Vector3.UP)

