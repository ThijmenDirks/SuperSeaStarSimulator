extends Node

# wont all this just move to level_class_definition ?

var n_waves = waves.size()

func spawn_next_wave():
	if wave > n_waves or status == 'spawning':
		return
	status = 'spawning'
	emit_signal('wave_changed', wave)
	for enemy in waves['wave%d' % wave]:
		await spawn_unit(waves['wave%d' % wave][enemy]['name'], waves['wave%d' % wave][enemy]['time'], waves['wave%d' % wave][enemy]['amount'])
	status = 'idle'
	wave += 1
	
	
func spawn_unit(enemy_name, time, amount):
	for i in amount:
		if enemy_name == 'zombies':
			x = zombie_scene.instantiate()
		elif enemy_name == 'slime':
			x = slime_scene.instantiate()
		elif enemy_name == 'orc':
			x = orc_scene.instantiate()
		x.startIndex = spawner_tile_index
		get_parent().add_child.call_deferred(x)
		await get_tree().create_timer(time).timeout
