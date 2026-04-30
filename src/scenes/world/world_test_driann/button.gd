extends Button

@export var bip_sfx: AudioStreamPlayer2D


func _on_pressed() -> void:

	AudioManager.play_detached_2d_sfx(bip_sfx, self.global_position)

	queue_free()
