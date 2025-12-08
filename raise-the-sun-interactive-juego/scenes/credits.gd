extends Control

@onready var rich_text_label: RichTextLabel = $RichTextLabel

var started = false
var speed = 100
var last_scroll_value = 0

func _ready() -> void:
	start()
	
func _process(delta: float) -> void:
	var scroll_bar = rich_text_label.get_v_scroll_bar()
	scroll_bar.value += speed * delta
	if last_scroll_value == scroll_bar.value:
		stop()
	last_scroll_value = scroll_bar.value
	
func start():
	await get_tree().create_timer(3.0).timeout #modificar tiempo segun convenga
	started = true
	
func stop():
	await get_tree().create_timer(3.0).timeout #modificar tiempo segun convenga
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
