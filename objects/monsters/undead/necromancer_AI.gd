# necromancer_AI

extends Node

onready var owner = get_parent()
var random_location = Vector2(0,0) # somewhere to wander
var has_random_location = false # has somewhere to wander
var ready_to_zap = false
var zap_timer = 3 # timer before zapping the player
var warning_message = ['Necrotic magic fills the air',\
	'Strange chanting reaches your ears','The necromancer begins tracing magical symbols in the air',\
	'Purple sparks dance in the air', 'The necromancer prepares to cast a spell']

func _ready():
	owner.ai = self

func take_turn():
	if owner.fighter.has_status_effect('confused'):
		confused_wander()
	var target = GameData.player
	var distance = owner.distance_to(target.get_map_position())
	# If not in range of the player
	if distance > GameData.player_radius:
		if has_random_location == false:
			choose_random_location() # Select location
			owner.step_to(random_location) # Move to location
			check_if_at_location() # check if arrived, set new location if needed
		else:
			owner.step_to(random_location) # move to location
			check_if_at_location() # check if arrived, set new location if needed
	# If in range of player
	elif distance <= GameData.player_radius:
		if distance > (GameData.player_radius / 2): # if player is over half distance of LoS away
			necromancy()
		elif distance <= 1:
			owner.fighter.fight(target)
		else:
			owner.step_to(target.get_map_position())

func confused_wander():
	var UP = randi()%2
	var DOWN = randi()%2
	var LEFT = randi()%2
	var RIGHT = randi()%2
	var dir = Vector2( RIGHT-LEFT, DOWN-UP )
	owner.step(dir)

func choose_random_location():
	var x = GameData.roll(owner.get_map_position().x+5, owner.get_map_position().x-5)
	var y = GameData.roll(owner.get_map_position().y+5, owner.get_map_position().y-5)
	var pos = Vector2(x,y)
		# stops location being placed in a wall
	while GameData.map.is_cell_blocked(pos):
		x = min(GameData.roll(owner.get_map_position().x+5, owner.get_map_position().x-5), (GameData.MAP_SIZE.x-1))
		y = min(GameData.roll(owner.get_map_position().y+5, owner.get_map_position().y-5), (GameData.MAP_SIZE.y-1))
		pos = Vector2(x,y)
	random_location = pos
	has_random_location = true

func check_if_at_location():
	if owner.get_map_position() == random_location:
		has_random_location = false

func necromancy():
	if ready_to_zap == false:
		glow_with_necromantic_energy()
		ready_to_zap = true
		return
	else:
		if zap_timer > 1:
			zap_timer -=1
			return
		else:
			zap_player()

func glow_with_necromantic_energy():
	owner.get_node('Light2D').show()
	var message = warning_message[GameData.roll(0, warning_message.size()-1)]
	GameData.broadcast(message, GameData.COLOUR_NECROTIC_PURPLE)

func stop_glowing():
	owner.get_node('Light2D').hide()
	ready_to_zap = false
	zap_timer = 3

func zap_player():
	var damage = GameData.roll(8, 12)
	var target = GameData.player
	var distance = owner.distance_to(target.get_map_position())
	if distance <= GameData.player_radius:
		var necromancer_position = get_parent().get_position()
		GameData.map.spawn_necrotic_energy_fx(necromancer_position)
		GameData.player.get_node("Camera").shake(0.3, 10)
		GameData.player.fighter.take_damage('Necromantic energy blast', damage)
		stop_glowing()
	else:
		stop_glowing()

