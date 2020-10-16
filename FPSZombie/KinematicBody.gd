#extends KinematicBody

#var zumbie = self
#var speed = 2
#onready var target = get_parent().get_node("Player")
#func _ready():
#   set_fixed_process(true)
#pass

#func set_fixed_process(delta):
#	var direction = (target.get_global_pos() - zumbie.get_global_pos()).normalized()
#	move(direction*speed) 
#pass

