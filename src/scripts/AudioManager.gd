extends Node

@export_group("Streamplayer no espaciales")
@export var background_mx: AudioStreamPlayer
@export var ambiance_sfx: AudioStreamPlayer
@export var ui_accept_sfx: AudioStreamPlayer

## Plays a 2D SFX from a temporary clone so it can finish even if its owner is freed.
func play_detached_2d_sfx(stream_node : AudioStreamPlayer2D, position: Vector2):
	if not stream_node: 
		push_warning("Error: Nodo SFX no asignado en el inspector.")
		return
		
	var clone = stream_node.duplicate()
	
	# EL ORDEN CORRECTO:
	add_child(clone)                  # 1. Nace en el mundo
	clone.global_position = position  # 2. Ahora sí puede calcular dónde pararse
	
	clone.play()
	clone.finished.connect(clone.queue_free)
