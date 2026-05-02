extends Node2D

@onready var contenedor_items = $Items

@export var fade_out: PackedScene

func _ready() -> void:
	AudioManager.ambiance_day.play()
	if AudioManager.ambiance_night.playing:
		AudioManager.ambiance_night.stop()


var _transicionando: bool = false

func _on_me_duermo_body_entered(body: Node2D) -> void:
	if _transicionando:
		return
		
	if body.is_in_group("player"):
		_transicionando = true
		
		if fade_out:
			var fade_instance = fade_out.instantiate()
			add_child(fade_instance)
			
			var anim = fade_instance.get_node_or_null("AnimationPlayer")
			if anim:
				anim.play("FadeOut")
				await anim.animation_finished
		
		get_tree().change_scene_to_file("res://src/scenes/world/Level1/level_1.tscn")
