extends KinematicBody

var textureBlack = load("res://skin/zombie_spec.dds")
var texture = load("res://skin/zombie_diff.dds")

export var speed = 100
var space_state
var target

func _ready(): 
	space_state = get_world().direct_space_state

func _physics_process(delta):
	if target:
		var result = space_state.intersect_ray(global_transform.origin, target.global_transform.origin)
		print(global_transform.origin)
		print(target.global_transform.origin)
		print(result.collider.name == 'TheRealNinja')
		if result.collider.is_in_group("Player"):
			look_at(target.global_transform.origin, Vector3.UP)
			move_to_target(delta)
			
func move_to_target(delta):
	var direction = (target.transform.origin - transform.origin).normalized()
	move_and_slide(direction * speed * delta, Vector3.UP)

func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		target = body
		print(body.name + "enter")
		set_texture_black()


func _on_Area_body_exited(body):
	if body.is_in_group("Player"):
		target = null
		print(body.name + "exit")
		set_normal_texture()
	
func set_texture_black():
	$Armature/Skeleton/LOWPOLY.get_surface_material(0).set_texture(SpatialMaterial.TEXTURE_ALBEDO, textureBlack)

func set_normal_texture():
	$Armature/Skeleton/LOWPOLY.get_surface_material(0).set_texture(SpatialMaterial.TEXTURE_ALBEDO, texture)
