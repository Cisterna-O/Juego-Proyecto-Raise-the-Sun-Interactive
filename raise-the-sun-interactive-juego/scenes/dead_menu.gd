extends CanvasLayer

@onready var replay_menu_dead: Button = $PanelContainer/MarginContainer/VBoxContainer/ReplayMenuDead
@onready var main_menu_menu_dead: Button = $PanelContainer/MarginContainer/VBoxContainer/MainMenuMenuDead
@onready var quit_dead: Button = $PanelContainer/MarginContainer/VBoxContainer/QuitDead

func _ready() -> void:
	replay_menu_dead.pressed.connect(_on_replay_dead_pressed)
	main_menu_menu_dead.pressed.connect(_on_main_menu_dead_pressed)
	quit_dead.pressed.connect(_on_quit_dead_pressed)
	visible = false
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dead"):
		get_tree().paused = not get_tree().paused
		visible = get_tree().paused
		
func _on_replay_dead_pressed():
	visible = false
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func _on_main_menu_dead_pressed():
	visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func _on_quit_dead_pressed():
	visible = false
	get_tree().paused = false
	get_tree().quit()
