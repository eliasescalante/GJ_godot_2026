extends Button

@export var bip_sfx: AudioStreamPlayer2D
@export var delete_on_pressed: bool

func _on_pressed() -> void:

	AudioManager.play_detached_2d_sfx(bip_sfx, global_position)
	
	if delete_on_pressed: queue_free()
