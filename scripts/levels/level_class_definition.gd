class_name Level
extends Node2D

 # wave numer 0 will be empty

@export var all_waves: Array[Wave]

@export var spawn_areas: Array[Area2D]

# ! this might be commented out, but it will be used !

var amount_of_waves = all_waves.size()
var current_wave: int = 0 # wave numer 0 will be empty
var status: String

# credits
# with thanks to alexcavadora and antimundo, https://forum.godotengine.org/t/whats-the-best-way-to-create-a-modular-wave-spawning-node/54271

func spawn_next_wave():
	current_wave += 1
	print("enemy   ", all_waves)
	print("enemy   ", all_waves[current_wave])
	print("enemy   ", all_waves[current_wave].subwaves)
	if current_wave > amount_of_waves or status == "spawning":
		return
	status = "spawning"
	emit_signal('wave_changed', current_wave)
	for enemy in all_waves[current_wave].subwaves:
		print("enemy", enemy)
		#await spawn_unit(waves['wave%d' % wave][enemy]['name'], waves['wave%d' % wave][enemy]['time'], waves['wave%d' % wave][enemy]['amount'])
	#status = 'idle'
	#wave += 1
#
#
#func spawn_unit(enemy_name, time, amount):
	#for i in amount:
		#if enemy_name == 'zombies':
			#x = zombie_scene.instantiate()
		#elif enemy_name == 'slime':
			#x = slime_scene.instantiate()
		#elif enemy_name == 'orc':
			#x = orc_scene.instantiate()
		#x.startIndex = spawner_tile_index
		#get_parent().add_child.call_deferred(x)
		#await get_tree().create_timer(time).timeout
	
	
