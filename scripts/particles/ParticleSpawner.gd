extends Node

class_name ParticleSpawner

static func spawn(path: String, position: Vector2, parent: Node) -> void:
	var particle_scene = load(path)
	var particle = particle_scene.instantiate()
	particle.global_position = position
	particle.emitting = true
	parent.add_child(particle)

	# Clean up after lifetime
	await parent.get_tree().create_timer(particle.lifetime).timeout
	particle.queue_free()
#spawn a particle, use this line of code
#ParticleSpawner.spawn("res://art/particles/fireball_explode.tscn", global_position, get_tree().current_scene)

	#if particle_scene == null:
		#push_error("Failed to load particle scene at: " + path)
		#return
