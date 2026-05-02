extends Node

@export_group("Streamplayer no espaciales")
@export var background_mx: AudioStreamPlayer
@export var ambiance_sfx_day: AudioStreamPlayer
@export var ambiance_sfx_night: AudioStreamPlayer
@export var ui_accept_sfx: AudioStreamPlayer



func play_sfx(player: AudioStreamPlayer) -> void:
	if not player:
		push_warning("SFX player not assigned.")
		return

	player.play()

## Reproduce un sfx en la posicion 2d correcta aunque su parent ya no este instanciado 
func play_detached_2d_sfx(stream_player_2d: AudioStreamPlayer2D, position: Vector2, start_time: float = 0.0) -> void:
	if not stream_player_2d:
		push_warning("Stream_player_2d not assigned.")
		return

	var sfx_clone := stream_player_2d.duplicate() as AudioStreamPlayer2D
	add_child(sfx_clone)
	sfx_clone.global_position = position
	
	sfx_clone.play(start_time)
	sfx_clone.finished.connect(sfx_clone.queue_free)
