extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _input(ev):
	if Input.is_key_pressed(KEY_ENTER):
		get_tree().change_scene("res://Terrain_jeux.tscn")
