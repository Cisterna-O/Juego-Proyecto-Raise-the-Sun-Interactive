extends Node

var _pending_scene_path: String = ""
var _pending_spawn_name: String = ""
var _from_portal_id: String = ""

func request_transition(scene_path: String, spawn_name: String, from_portal: String = "") -> void:
	print("\n=== SceneTransition.request_transition ===")
	print("→ scene_path: ", scene_path)
	print("→ spawn_name: ", spawn_name)
	print("→ from_portal: ", from_portal)

	_pending_scene_path = scene_path
	_pending_spawn_name = spawn_name
	_from_portal_id = from_portal

	print("✓ Llamando a TransitionManager.fade...")
	TransitionManager.fade(Callable(self, "_perform_transition"))


func _perform_transition() -> void:
	print("\n=== SceneTransition._perform_transition ===")

	if _pending_scene_path == "":
		print("✗ ERROR: _pending_scene_path está vacío.")
		push_warning("SceneTransition: no pending scene path")
		return
	else:
		print("✓ pending scene path OK: ", _pending_scene_path)

	# Cargamos la escena destino
	print("→ Cargando escena: ", _pending_scene_path)
	var packed = ResourceLoader.load(_pending_scene_path)

	if not packed:
		print("✗ ERROR: No se pudo cargar el recurso")
		push_error("SceneTransition: no se pudo cargar: %s" % _pending_scene_path)
		return
	else:
		print("✓ PackedScene cargado correctamente")

	# Cambiamos la escena
	print("→ Llamando a change_scene_to()...")
	var err = get_tree().change_scene_to_packed(packed)


	print("→ Resultado change_scene_to(): ", err)

	if err != OK:
		print("✗ ERROR change_scene_to falló.")
		push_error("SceneTransition: change_scene_to falló: %s" % str(err))
		return
	else:
		print("✓ change_scene_to OK")

	print("→ Esperando un frame para cargar la nueva escena…")
	await get_tree().process_frame
	print("✓ Frame avanzado, escena nueva activa")

	# Buscar root_scene
	var root_scene = get_tree().current_scene
	print("→ current_scene: ", root_scene)

	# Buscar spawn
	print("→ Buscando spawn: ", _pending_spawn_name)
	var spawn_node = root_scene.get_node_or_null(_pending_spawn_name)

	if spawn_node == null:
		print("⚠ spawn no encontrado con get_node_or_null, probando find_node...")
		spawn_node = root_scene.find_node(_pending_spawn_name, true, false)

	if spawn_node:
		print("✓ spawn encontrado: ", spawn_node)
	else:
		print("✗ NO se encontró el spawn ", _pending_spawn_name)

	# Buscar player
	print("→ Buscando player en grupo 'player'...")
	var players = get_tree().get_nodes_in_group("player")

	if players.size() == 0:
		print("✗ ERROR: NO existe player en la escena nueva")
		push_warning("SceneTransition: no se encontró player en la scene (grupo 'player').")
		return

	var player = players[0]
	print("✓ Player encontrado: ", player)

	# Mover al player
	if spawn_node:
		print("→ Moviendo player al spawn...")
		player.global_position = spawn_node.global_position
		print("✓ Player movido a ", player.global_position)
	else:
		print("⚠ Spawn no encontrado, NO se mueve el player")

	# Limpiar
	print("→ Limpiando pending vars")
	_pending_scene_path = ""
	_pending_spawn_name = ""
	_from_portal_id = ""

	print("=== FIN DE TRANSICIÓN ===\n")
