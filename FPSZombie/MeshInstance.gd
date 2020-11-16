extends MeshInstance

func _physics_process(delta):
	rotate(Vector3(45,30,15).normalized(), delta)
