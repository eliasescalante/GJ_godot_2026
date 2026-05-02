extends Node2D

@onready var contenedor_items = $Items

func _ready() -> void:
	AudioManager.ambiance_day.play()
	if AudioManager.ambiance_night.playing:
		AudioManager.ambiance_night.stop()


func _on_me_duermo_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://src/scenes/world/Level1/level_1.tscn")
