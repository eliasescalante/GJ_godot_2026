extends CharacterBody2D

@export var SPEED = 300.0

@export_group("Audio")
@export var footstep_audio_freq: float = 1


@onready var personaje = $Cuerpo
@onready var raycasts_node: Node2D = $Cuerpo/Raycasts
@onready var foot_steps: AudioStreamPlayer2D = $FootSteps


# --- Estado de detección ---
## Almacena todos los RayCast2D hijos del nodo Raycasts
var _raycasts: Array[RayCast2D] = []

## Throttle para no spamear prints cada frame
var _debug_timer: float = 0.0
const DEBUG_INTERVAL: float = 0.2  # imprimir cada 0.2 segundos máximo

var _paso_esperando: bool = false

func _ready():
	# Recopilar todos los RayCast2D hijos del nodo Raycasts
	if raycasts_node:
		for child in raycasts_node.get_children():
			if child is RayCast2D:
				_raycasts.append(child)
		print("[Player] %d raycasts de detección de items inicializados." % _raycasts.size())
	else:
		push_warning("[Player] No se encontró el nodo 'Raycasts' en Cuerpo.")


func _physics_process(delta: float) -> void:
	# 1. Movimiento y rotación
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Calculamos la velocidad basada en el intervalo de pasos.
	# Si el delay es mayor (ej: 2.0s), la velocidad se reduce a la mitad.
	var current_speed = SPEED
	if footstep_audio_freq > 0.01: # Evitar división por cero
		current_speed = SPEED / footstep_audio_freq
	
	if direction != Vector2.ZERO:
		velocity = direction * current_speed
		var angulo = direction.angle()
		# Ajuste de rotación para que el sprite mire hacia donde camina
		personaje.rotation = angulo - (PI / 2)
		_reproducir_pasos(true)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, current_speed)
		_reproducir_pasos(false)
	
	move_and_slide()
	
	# 2. Gestión de timers y detección
	_debug_timer += delta
	_detectar_items_con_raycasts()
	
	# Resetear timer de debug después de procesar todas las detecciones del frame
	if _debug_timer >= DEBUG_INTERVAL:
		_debug_timer = 0.0


## Itera sobre todos los raycasts y verifica qué está viendo cada uno
func _detectar_items_con_raycasts() -> void:
	for raycast in _raycasts:
		if not raycast.is_colliding():
			continue
		
		var collider = raycast.get_collider()
		if not collider:
			continue
		
		# El RayCast choca con el StaticBody2D (el área física del item)
		var parent_node = collider.get_parent()
		
		if parent_node is Item:
			var item: Item = parent_node
			
			# Verificamos con el GameManager si el item ya fue registrado globalmente
			if not GameManager.fue_item_visto(item.item_name):
				# Preparamos el diccionario de información para el GameManager
				var info_item = {
					"posicion": item.global_position,
					"timestamp": Time.get_time_string_from_system(),
					"tipo": "descubrimiento_directo"
				}
				
				# Registramos en el sistema global
				GameManager.registrar_item(item.item_name, info_item)
				
				# Marcamos el item localmente para efectos visuales o lógica interna del objeto
				item.ser_visto_por_jugador()
				
				print("[Player] ¡Nuevo item descubierto y enviado al Manager!: %s" % item.item_name)
				
		else:
			# --- Lógica de obstáculos (Paredes, etc.) ---
			if _debug_timer >= DEBUG_INTERVAL:
				if collider.is_in_group("pared"):
					# Aquí podrías activar alguna variable como 'pared_en_frente' si la necesitas
					pass


func _reproducir_pasos(active: bool) -> void:
	
	if !active:
		foot_steps.stop()
		return
	
	if _paso_esperando:
		return
	
	_paso_esperando = true
	foot_steps.play()
	await get_tree().create_timer(footstep_audio_freq).timeout
	_paso_esperando = false
