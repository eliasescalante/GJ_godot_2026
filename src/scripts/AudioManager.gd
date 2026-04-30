extends Node

@export_group("Streamplayer no espaciales")
@export var background_mx: AudioStreamPlayer
@export var ambiance_sfx: AudioStreamPlayer
@export var ui_accept_sfx: AudioStreamPlayer



func play_sfx(player: AudioStreamPlayer) -> void:
	if not player:
		push_warning("SFX player not assigned.")
		return

	player.play()

## Reproduce un sfx aunque su parent ya no este instanciado 
func play_detached_2d_sfx(player: AudioStreamPlayer2D, position: Vector2) -> void:
	if not player:
		push_warning("2D SFX player not assigned.")
		return

	var clone := player.duplicate() as AudioStreamPlayer2D
	add_child(clone)
	clone.global_position = position
	clone.play()
	clone.finished.connect(clone.queue_free)
