extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func fade(callable: Callable) -> void:
	get_tree().paused = true
	animation_player.play("fade_out")
	await animation_player.animation_finished
	await callable.call()
	animation_player.play("fade_in")
	await animation_player.animation_finished
	get_tree().paused = false
