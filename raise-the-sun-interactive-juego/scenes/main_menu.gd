extends Control

@onready var start_button: Button = $VBoxContainer/StartButton
@onready var credits_button: Button = $VBoxContainer/CreditsButton
@onready var quit_button: Button = $VBoxContainer/QuitButton

func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	credits_button.pressed.connect(_on_credits_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/hito_1.tscn")
	
func _on_credits_pressed():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
	
func _on_quit_pressed():
	get_tree().quit()
	
