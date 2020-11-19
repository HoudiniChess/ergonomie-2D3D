extends Fist

export var fire_range = 40

func _ready():
	raycast.cast_to = Vector3(0, 0, -fire_range)
