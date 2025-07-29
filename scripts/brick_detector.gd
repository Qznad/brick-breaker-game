extends Area2D

func _process(delta):
	var bricks_inside = get_overlapping_bodies()
	#print("Bodies inside area:", bricks_inside.size())
	if bricks_inside.is_empty():
		print("You win!")
		$"../.."._winner()
