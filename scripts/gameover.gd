extends Node2D
func _ready():
	pass
func _on_restart_pressed() -> void:
	# Remove all balls before unpausing
	get_tree().paused = false   # unpause before reload
	get_tree().reload_current_scene()


# Removes balls and all powerups
func _cleaning_up():
	var balls = get_tree().get_nodes_in_group("balls")
	var doubles = get_tree().get_nodes_in_group("doubles")
	var hots = get_tree().get_nodes_in_group("hots")
	var longs = get_tree().get_nodes_in_group("longs")
	for ball in balls:
		ball.queue_free()
	for double in doubles :
		double.queue_free()
	for hot in hots :
		hot.queue_free()
	for long in longs :
		long.queue_free()

func _on_quit_pressed() -> void:
	get_tree().quit()
