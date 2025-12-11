# res://singletons/GameState.gd
extends Node

# Diccionario de items: key -> bool (true si recogido)
var collected := {} # e.g. { "level1_A": true }

# Señal para notificar cambios
signal collected_changed(item_id: String, value: bool)

# Marcar un item como recogido (id único)
func collect(item_id: String) -> void:
	if has_item(item_id):
		return
	collected[item_id] = true
	emit_signal("collected_changed", item_id, true)
	print("GameState: collected -> ", item_id)

func has_item(item_id: String) -> bool:
	return collected.get(item_id, false)

# Consulta si tiene todos los items de una lista
func has_all(list_items: Array) -> bool:
	for id in list_items:
		if not has_item(id):
			return false
	return true
