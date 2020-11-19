extends Control

onready var health_bar = $BarreDeVie

func _on_health_updated(health, amount):
	health_bar.value = 100
