extends CPUParticles2D

func _on_area_2d_body_entered(body):
	$CPUParticles2D.position = to_local(body.global_position)
	$CPUParticles2D.emitting = true
	await get_tree().create_timer($CPUParticles2D.lifetime).timeout
	$CPUParticles2D.emitting = false
	queue_free()
