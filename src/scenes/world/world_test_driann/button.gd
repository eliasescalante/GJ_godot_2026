extends Button

@export var bip_sfx: AudioStreamPlayer2D
@export var delete_on_pressed: bool
@export var play_detached: bool
@export var sfx_start_offset: float = 1.5

func _on_pressed() -> void:

	if play_detached:
		AudioManager.play_detached_2d_sfx(bip_sfx, global_position, sfx_start_offset)
	else:
		bip_sfx.play(sfx_start_offset)
	
	if delete_on_pressed: queue_free()
