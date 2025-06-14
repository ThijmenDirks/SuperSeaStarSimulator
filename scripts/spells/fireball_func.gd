extends Spell


func get_damage_by_explosion(base_damage, distance_enemy_to_center, aoe_size):
	var distance_to_center_ratio : float =  (1 - float(distance_enemy_to_center/aoe_size)) # 1 op center, 0 op rand)
	print("HP   ", distance_to_center_ratio)
	return (2 ** distance_to_center_ratio) * base_damage


func deal_damage(a,b):
	pass
	#anti-eroor func!
	#don't leave it here!
	#^true!


func cast_this_spell():
	var caster = get_parent()
	var texture = load("res://art/Small-8-Direction-Characters_by_AxulArt/Small-8-Direction-Characters_by_AxulArt.png")
	var other_texture = $Sprite2D
	var this_spell = SpellDatabase.fireball
	var hit_enemies = ["goblin", "goblin", "orc"]
	var damage_multiplier = get_parent().get_node("interface/Control/Kleurenbalkje/PanelContainer/HBoxContainer").functie_die_op_basis_van_naam_ofwel_kleur_alle_informaite_van_desbetrefend_balkje_kan_halen("red").size_flags_stretch_ratio
	var base_damage = this_spell.spell_damage * damage_multiplier
	var damage_type = this_spell.spell_damage_type
	var aoe_size = this_spell.spell_aoe_size
	var noise = this_spell.spell_noise
	var kleurenbalkje_change = this_spell.spell_kleurenbalkje_change
	var orb_cost = this_spell.spell_orb_cost
#------- hierzo kijken of je kan betalen
	if caster: # == player	#CharacterBody2D/interface/kleurenalbkje/PanelContainer/HBoxContainer/@Panel@2
		for child in caster.get_node("interface").get_children():
			if child is ManaThingy:
				if child.my_color == "red":
					if orb_cost <= child.filled_orbs:
						child.filled_orbs -= orb_cost
						print("mana_thingy red FALSE",child.filled_orbs)

					else:
						print("gigantic miscast!")
						return
#-------
	print("boom")
	print(this_spell)
	print(this_spell.spell_type)
	print(self)
	spell_builtin_function_test(this_spell.spell_name)
#_get enemies hit:------------------------------
	var damage_area = Area2D.new() # gets automatically deleted when this function is done # ?
	var damage_area_collision = CollisionShape2D.new()
	damage_area_collision.shape = CircleShape2D.new()
	damage_area_collision.shape.radius = aoe_size
	damage_area.set_collision_mask_value(5, true)
	damage_area.add_child(damage_area_collision)
	add_child(damage_area)
	await get_tree().physics_frame
	await get_tree().physics_frame
	print("damage_area", damage_area.get_overlapping_bodies())
	for enemy in damage_area.get_overlapping_bodies():
		if enemy is Enemy:
			print("hit an enemy")
			enemy.take_damage(get_damage_by_explosion(base_damage, self.global_position.distance_to(enemy.global_position) , aoe_size), damage_type)
	damage_area.queue_free()
#-------------------------------------
	for enemy in hit_enemies:
#-
		var distance_enemy_to_center = 30
		var current_enemy_damage = get_damage_by_explosion(base_damage, distance_enemy_to_center, aoe_size)
		deal_damage(enemy, current_enemy_damage)
		print(enemy)
#----- en hiezro kleurenbalkje aanpassen
	if caster: # == player	#CharacterBody2D/interface/kleurenalbkje/PanelContainer/HBoxContainer/@Panel@2
		print("kleurkleurkl ", caster.get_node("interface/Control/Kleurenbalkje/PanelContainer/HBoxContainer").functie_die_op_basis_van_naam_ofwel_kleur_alle_informaite_van_desbetrefend_balkje_kan_halen("red").size_flags_stretch_ratio)
		if caster.get_node("interface/Control/Kleurenbalkje/PanelContainer/HBoxContainer").functie_die_op_basis_van_naam_ofwel_kleur_alle_informaite_van_desbetrefend_balkje_kan_halen("red").size_flags_stretch_ratio == 1.0:
			caster.get_node("interface/Control/Kleurenbalkje/PanelContainer/HBoxContainer").functie_die_op_basis_van_naam_ofwel_kleur_alle_informaite_van_desbetrefend_balkje_kan_halen("red").size_flags_stretch_ratio /= kleurenbalkje_change
			caster.get_node("interface/Control/Kleurenbalkje/PanelContainer/HBoxContainer").keep_scales_fancy()
			print("kleurkleurkleur")
		else:
			caster.get_node("interface/Control/Kleurenbalkje/PanelContainer/HBoxContainer").functie_die_op_basis_van_naam_ofwel_kleur_alle_informaite_van_desbetrefend_balkje_kan_halen("red").size_flags_stretch_ratio /= kleurenbalkje_change
#----
	make_noise(noise)
	#await animation
	#self.queue_free() # MOET WEL WEER TERUG!
	#print_tree_pretty()
