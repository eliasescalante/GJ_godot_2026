extends CharacterBody2D


@export var SPEED = 300.0
@onready var personaje = $Cuerpo

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		
		var angulito_del_movimiento = direction.angle()
		personaje.rotation = angulito_del_movimiento -(PI / 2)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
	
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
