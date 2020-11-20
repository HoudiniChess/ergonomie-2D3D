extends KinematicBody

var textureBlack = load("res://skin/zombie_spec.dds")
var texture = load("res://skin/zombie_diff.dds")

enum states {PATROL, CHASE, ATTACK, DEAD}
var state = states.PATROL

# For setting animations.

var anim_state
var run_speed = 25
var attacks = ["Zombie attack-loop"]

# For path following.

export (NodePath) var patrol_path
var patrol_points
var patrol_index = 0

# Target for chase mode.

var player = null
var velocity = Vector3(run_speed, 0, 0)

var move_speed = 100


func _physics_process(delta):
	choose_action()
	# Changing the x scale flips the sprite and its attack area.

	if velocity.x > 0:
		$"../Zombie".scale.x = 1
	elif velocity.x < 0:
		$"../Zombie".scale.x = -1

	# If we're moving, show the run animation.

	if velocity.length() > 0:
		$AnimationPlayer.play("Zombie Run-loop")
	# Show the idle animation when coming to a stop (but not attacking).

	if $AnimationPlayer.current_animation == "Zombie Run-loop" and velocity.length() == 0:
		$AnimationPlayer.play("Zombie Attack-loop")

	velocity = move_and_slide(velocity)
	

func choose_action():
	velocity = Vector3.ZERO
	var current = $AnimationPlayer.current_animation 
	# If we're currently attacking, don't move or change state.

	if current in attacks:
		return

	# Depending on the current state, choose a movement target.

	var target
	match state:
		states.DEAD:
			set_physics_process(false)

		# Move along assigned path.

		states.PATROL:
			if !patrol_path:
				return
			target = patrol_points[patrol_index]
			if global_transform.origin.distance_to(target) < 1:
				patrol_index = wrapi(patrol_index + 1, 0, patrol_points.size())
				target = patrol_points[patrol_index]
			velocity = (target - global_transform.origin).normalized() * run_speed

		# Move towards player.

		states.CHASE:
			target = player.global_transform.origin
			velocity = (target - global_transform.origin).normalized() * run_speed

		# Make an attack.

		states.ATTACK:
			print("bonjour toi")
			target = player.global_transform.origin
			print("bonjour toi1")
			if target.x > global_transform.origin.x:
				print("bonjour toi2")
				$"../Zombie".scale.x = 1
				print("bonjour toi3")
			elif target.x < global_transform.origin.x:
				print("bonjour toi4")
				$"../Zombie".scale.x = -1
				print("bonjour toi5")
			$AnimationPlayer.play("Zombie Attack-loop")
			print("bonjour toi6")
	
func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		state = states.CHASE
		player = body
		set_texture_black()

func _on_Area_body_exited(body):
	if body.is_in_group("Player"):
		state = states.PATROL
		player = null
		set_normal_texture()

func _on_AttackRadius_body_entered(body):
	if body.is_in_group("Player"):
		state = states.ATTACK
		set_texture_black()

func _on_AttackRadius_body_exited(body):
	if body.is_in_group("Player"):
		state = states.CHASE
		set_texture_black()
	
func set_texture_black():
	$Armature/Skeleton/LOWPOLY.get_surface_material(0).set_texture(SpatialMaterial.TEXTURE_ALBEDO, textureBlack)

func set_normal_texture():
	$Armature/Skeleton/LOWPOLY.get_surface_material(0).set_texture(SpatialMaterial.TEXTURE_ALBEDO, texture)
