extends Button

@export var bip_sfx: AudioStreamPlayer2D
@export var delete_on_pressed: bool
@export var play_detached: bool

func _on_pressed() -> void:

	if play_detached:
		AudioManager.play_detached_2d_sfx(bip_sfx, global_position)
	else:
		bip_sfx.play()
	
	if delete_on_pressed: queue_free()
