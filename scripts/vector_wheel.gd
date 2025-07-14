extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#get_most_favourable_direction(Vector2(randi_range(-100, 100), randi_range(-100, 100)))
	#get_local_mouse_position() - Vector2(300, 200)
	#get_most_favourabel_direction(Vector2(get_local_mouse_position() - $".".position).normalized())
	#print("bbb ", Vector2(get_local_mouse_position() -$".".position).normalized())
	#get_most_favourabel_direction(Vector2(1, 0).get_vector_to(get_local_mouse_position()))

# get_direction_array

# credits to JackyCodes
func get_most_favourable_direction(desired_vector): # desired_vector should be the same as navigation_agent returns
	pass
	desired_vector = desired_vector.normalized()
	var interest_array = [0, 0, 0, 0, 0, 0, 0, 0]
	var danger_array = [0, 0, 0, 0, 0, 0, 0, 0]
	var context_map = [0, 0, 0, 0, 0, 0, 0, 0]
	var steering_force : Vector2 # (desired_vel - current_vel) * steering_constant (the higher, the sharper)
	var ray_ast = $RayCast0
	#var test = $RayCast0.target_position.x
	for i in interest_array.size():
		#print("iii ", i)
		var current_raycast = get_child(i)
		interest_array[i] = desired_vector.dot(Vector2(current_raycast.target_position.x, current_raycast.target_position.y).normalized())
		# VERGEET JE MASKS NIET !!
		if current_raycast.get_collider() is Enemy:
			danger_array[i] += 1
			#print("enemy detected")
		elif current_raycast.get_collider() is Player:
			#print("player detected")
			pass
		if current_raycast.is_colliding(): # ALERT! must be elif
			#print("something detectd: ", current_raycast.get_collider())
			danger_array[i] += 5
			danger_array[i-1] += 2
			danger_array[i-7] += 2
		elif current_raycast.get_collider() == null:
			#print("vector_wheel tested and verified!")
			pass
		else:
			#print("vector_wheel tested but had some problems")
			pass
	for i in context_map.size():
		context_map[i] = interest_array[i] - danger_array[i]
	var highest_value = context_map[0]
	var highest_value_index = 0
	for i in context_map.size():
		if context_map[i] > highest_value:
			highest_value = context_map[i]
			highest_value_index = i
	#var returned_vector = [
	#Vector2(0, -1),
	#Vector2(0.500, -0.866),
	#Vector2(0.866, -0.500),
	#Vector2(1, 0),
	#Vector2(0.866, 0.500),
	#Vector2(0.500, 0.866),
	#Vector2(0, 1),
	#Vector2(-0.500, 0.866),
	#Vector2(-0.866, 0.500),
	#Vector2(-1, 0),
	#Vector2(-0.866, -0.500),
	#Vector2(-0.500, -0.866),
#]
	print("interest_array ", interest_array)
	print("danger_array ", danger_array)
	print("context_map ", context_map)
	#print("vector_wheel will return: ", (get_child(context_map.find(context_map.max())).target_position).normalized())
	return (get_child(context_map.find(context_map.max())).target_position).normalized()
