extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if AudioManager.ambiance_sfx_day.playing:
		AudioManager.ambiance_sfx_day.stop()
	AudioManager.ambiance_sfx_night.play()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://src/scenes/world/ending/ending.tscn")
	pass # Replace with function body.
