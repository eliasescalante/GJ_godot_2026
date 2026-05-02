class_name Item
extends Node2D

# --- Enumeración para el Inspector ---
# Los nombres deben coincidir con los nombres de tus nodos Sprite2D
enum TipoDeObjeto { ANTEOJOS, ANTEOJOS_ROTO, BOTELLA, BOTELLA_ROTA, PELOTA, PELOTA_ROTA, LIBRO, LIBRO_ROTO}

@export_group("Configuración Visual")
## Selecciona qué objeto es esta instancia
@export var objeto_a_mostrar: TipoDeObjeto = TipoDeObjeto.BOTELLA:
	set(val):
		objeto_a_mostrar = val
		if is_node_ready():
			_actualizar_visibilidad_nodos()

# --- Nodos Internos ---
@onready var static_body: StaticBody2D = $StaticBody2D
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

# Diccionario para mapear el Enum con los nombres reales de tus nodos
@onready var nodos_sprites = {
	TipoDeObjeto.ANTEOJOS: $anteojos,
	TipoDeObjeto.ANTEOJOS_ROTO: $anteojos_roto,
	TipoDeObjeto.BOTELLA: $botella,
	TipoDeObjeto.BOTELLA_ROTA: $botella_rota,
	TipoDeObjeto.PELOTA: $pelota,
	TipoDeObjeto.PELOTA_ROTA: $pelota_rota,
	TipoDeObjeto.LIBRO : $libro,
	TipoDeObjeto.LIBRO_ROTO : $libro_roto
}

# --- Estado ---
var fue_visto: bool = false
var item_name: String = ""

func _ready() -> void:
	add_to_group("item")
	_actualizar_visibilidad_nodos()
	
	# El nombre del item será el nombre del nodo seleccionado
	item_name = TipoDeObjeto.keys()[objeto_a_mostrar].to_lower()

## Oculta todos los sprites y solo muestra el seleccionado
func _actualizar_visibilidad_nodos() -> void:
	for tipo in nodos_sprites:
		var nodo = nodos_sprites[tipo]
		if nodo:
			nodo.visible = (tipo == objeto_a_mostrar)

## Llamado por el RayCast del jugador
func ser_visto_por_jugador() -> void:
	if fue_visto: return
	
	fue_visto = true
	$FoundSFX.play()
	# Preparamos la info para el GameManager
	var info := {
		"posicion": global_position,
		"tipo": item_name,
		"es_roto": item_name.contains("roto"),
		"referencia": self
	}
	
	GameManager.registrar_item(item_name, info)
	
	# Feedback
	if audio_player and audio_player.stream:
		audio_player.play()
	
	# Efecto visual: hacemos que el sprite activo brille
	var sprite_activo = nodos_sprites[objeto_a_mostrar]
	var tween = create_tween()
	tween.tween_property(sprite_activo, "modulate", Color(2, 2, 2), 0.1)
	tween.tween_property(sprite_activo, "modulate", Color(1, 1, 1), 0.2)
