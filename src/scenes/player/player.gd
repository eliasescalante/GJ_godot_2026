extends CharacterBody2D

@export var SPEED = 300.0
@onready var personaje = $Cuerpo
var pared_en_frente = false


func _ready():
	pass


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		var angulo = direction.angle()
		personaje.rotation = angulo - (PI / 2)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
	
	move_and_slide()

#logica villera para detectar cuerpecitos diferentes:
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("pared"):
		print("esta la pared")
		pared_en_frente = true


func _on_detector_item_body_entered(body: Node2D) -> void:
	if body.is_in_group("cuadradito") and not pared_en_frente:
		print("veo el item")
	elif body.is_in_group("cuadradito") and pared_en_frente:
		print("veo el item pero esta tapado por la pared")


func _on_detector_pared_body_exited(body: Node2D) -> void:
	if body.is_in_group("pared"):
		pared_en_frente = false
		print("ya no veo la pared")
