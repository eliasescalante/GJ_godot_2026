extends Node

## Diccionario de items descubiertos por el jugador durante el día.
## Key: item_name (String) → Value: Dictionary con info del item
var items_vistos: Dictionary = {}


## Registra un item descubierto. Llamado desde Item.ser_visto_por_jugador()
func registrar_item(nombre_item: String, info: Dictionary) -> void:
	if items_vistos.has(nombre_item):
		return

	items_vistos[nombre_item] = info
	print("[GameManager] Item registrado: '%s' en posición %s" % [nombre_item, info.get("posicion", Vector2.ZERO)])


## Devuelve true si el jugador ya vio un item con ese nombre
func fue_item_visto(nombre_item: String) -> bool:
	return items_vistos.has(nombre_item)


## Devuelve la info de un item visto, o un diccionario vacío si no fue visto
func obtener_info_item(nombre_item: String) -> Dictionary:
	return items_vistos.get(nombre_item, {})


## Devuelve la cantidad de items descubiertos
func cantidad_items_vistos() -> int:
	return items_vistos.size()


## Resetea los items vistos (para nueva partida o cambio de día/noche)
func resetear_items() -> void:
	items_vistos.clear()
	print("[GameManager] Items reseteados.")
