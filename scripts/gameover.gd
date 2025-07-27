extends Node2D
func _ready():
	pass
func _on_restart_pressed() -> void:
	get_tree().paused = false   # unpause before reload
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().quit()
