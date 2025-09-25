extends CanvasLayer

@onready var continue_button: Button = $PanelContainer/MarginContainer/VBoxContainer/ContinueButton
@onready var retry_button: Button = $PanelContainer/MarginContainer/VBoxContainer/RetryButton
@onready var main_menu_button: Button = $PanelContainer/MarginContainer/VBoxContainer/MainMenuButton
@onready var quit_button: Button = $PanelContainer/MarginContainer/VBoxContainer/QuitButton

func _ready() -> void:
	continue_button.pressed.connect(_on_continue_pressed)
	retry_button.pressed.connect(_on_retry_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	visible = false
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = not get_tree().paused
		visible = get_tree().paused
		

func _on_continue_pressed():
	visible = false
	get_tree().paused = false
	
func _on_retry_pressed():
	visible = false
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func _on_main_menu_pressed():
	visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func _on_quit_pressed():
	visible = false
	get_tree().paused = false
	get_tree().quit()
