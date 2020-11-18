extends Spatial

onready var audio = $BackAudio

func _ready(): 
	audio.play()
