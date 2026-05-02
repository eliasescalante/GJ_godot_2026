extends Node2D

@onready var contenedor_items = $Items

func _ready() -> void:
	if AudioManager.ambiance_sfx_night.playing:
		AudioManager.ambiance_sfx_night.stop()
	AudioManager.ambiance_sfx_day.play()
	
