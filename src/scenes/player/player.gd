extends CharacterBody2D

@export var SPEED = 300.0
@onready var personaje = $Cuerpo
@onready var raycasts_node: Node2D = $Cuerpo/Raycasts

# --- Estado de detección ---
var pared_en_frente = 0
## Almacena todos los RayCast2D hijos del nodo Raycasts
var _raycasts: Array[RayCast2D] = []

## Throttle para no spamear prints cada frame
var _debug_timer: float = 0.0
const DEBUG_INTERVAL: float = 0.2  # imprimir cada 0.2 segundos máximo


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
	var direction := Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		var angulo = direction.angle()
		personaje.rotation = angulo - (PI / 2)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
	
	move_and_slide()
	
	# Throttle del debug para no imprimir cada frame
	_debug_timer += delta
	_detectar_items_con_raycasts()


## Itera sobre todos los raycasts y verifica qué está viendo cada uno
func _detectar_items_con_raycasts() -> void:
	for raycast in _raycasts:
		if not raycast.is_colliding():
			continue
		
		var collider = raycast.get_collider()
		if not collider:
			continue
		
		# El RayCast choca con el StaticBody2D → chequeamos su parent
		var parent_node = collider.get_parent()
		
		if parent_node is Item:
			# --- Vemos un Item directamente ---
			var item: Item = parent_node
			if not item.fue_visto:
				print("[Player][%s] ¡ITEM DETECTADO! → '%s' en posición %s" % [raycast.name, item.item_name, item.global_position])
				item.ser_visto_por_jugador()
			elif _debug_timer >= DEBUG_INTERVAL:
				print("[Player][%s] Item '%s' ya fue visto anteriormente, ignorando." % [raycast.name, item.item_name])
		else:
			# --- Algo está bloqueando la vista (pared, obstáculo, etc) ---
			if _debug_timer >= DEBUG_INTERVAL:
				var blocker_name = collider.name if collider else "desconocido"
				var grupo_info = ""
				if collider.is_in_group("pared"):
					grupo_info = " (es una PARED)"
				print("[Player][%s] Vista bloqueada por: '%s'%s" % [raycast.name, blocker_name, grupo_info])
	
	# Resetear timer de debug después de imprimir
	if _debug_timer >= DEBUG_INTERVAL:
		_debug_timer = 0.0
