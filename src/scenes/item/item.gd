class_name Item
extends Node2D

## Clase base para todos los items del laberinto.
## El jugador los detecta con su RayCast2D y los registra en GameManager
## para recordar su ubicación durante la noche.

# --- Configuración exportada ---
## Nombre único del item (se usa como key en el diccionario de GameManager)
@export var item_name: String = "item_sin_nombre"
## Descripción corta del item (para UI o pistas)
@export var item_description: String = ""
## Icono o textura representativa (para UI de inventario/memoria)
@export var item_icon: Texture2D

# --- Nodos internos ---
@onready var static_body: StaticBody2D = $StaticBody2D
@onready var collision_shape: CollisionShape2D = $StaticBody2D/CollisionShape2D
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

# --- Estado ---
## Indica si el jugador ya vio este item
var fue_visto: bool = false


func _ready() -> void:
	# Agregar al grupo para que el RayCast pueda identificar items fácilmente
	add_to_group("item")
	print("[Item] '%s' inicializado en posición %s" % [item_name, global_position])
	
	if not static_body:
		push_warning("[Item] '%s' no tiene StaticBody2D asignado!" % item_name)
	if not collision_shape:
		push_warning("[Item] '%s' no tiene CollisionShape2D asignado!" % item_name)
	if not audio_player:
		push_warning("[Item] '%s' no tiene AudioStreamPlayer2D asignado!" % item_name)
	elif not audio_player.stream:
		print("[Item] '%s' no tiene audio stream asignado (no sonará al ser descubierto)." % item_name)


## Llamado cuando el jugador detecta este item con su RayCast.
## Registra el item en GameManager y reproduce el sonido de descubrimiento.
func ser_visto_por_jugador() -> void:
	if fue_visto:
		print("[Item] '%s' → el jugador ya me vio antes, ignorando." % item_name)
		return

	print("[Item] ====================================")
	print("[Item] '%s' → ¡PRIMER CONTACTO VISUAL!" % item_name)
	print("[Item] Posición del item: %s" % global_position)
	
	fue_visto = true
	_registrar_en_game_manager()
	_reproducir_sonido_descubrimiento()
	
	print("[Item] '%s' → Proceso de descubrimiento completado." % item_name)
	print("[Item] ====================================")


## Registra la información del item en el diccionario de GameManager
func _registrar_en_game_manager() -> void:
	var info := {
		"descripcion": item_description,
		"posicion": global_position,
		"icono": item_icon,
		"referencia": self,
	}
	
	print("[Item] '%s' → Registrando en GameManager..." % item_name)
	GameManager.registrar_item(item_name, info)
	print("[Item] '%s' → ¡Registrado! Total items vistos: %d" % [item_name, GameManager.cantidad_items_vistos()])


## Reproduce el sonido de descubrimiento (si tiene stream asignado)
func _reproducir_sonido_descubrimiento() -> void:
	if audio_player and audio_player.stream:
		print("[Item] '%s' → Reproduciendo sonido de descubrimiento." % item_name)
		audio_player.play()
	else:
		print("[Item] '%s' → Sin audio asignado, no se reproduce sonido." % item_name)
