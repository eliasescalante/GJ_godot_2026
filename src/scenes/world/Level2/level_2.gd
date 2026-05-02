extends Node2D

@onready var contenedor_items = $Items

func _ready() -> void:
	AudioManager.ambiance_day.play()
	if AudioManager.ambiance_night.playing:
		AudioManager.ambiance_night.stop()
