# rock_troll_AI

extends Node

onready var owner = get_parent()
onready var new_name = PlotGen.npc_rock_troll1

func _ready():
	owner.ai = self
	owner.get_node(".").name = new_name

func take_turn():
	if owner.fighter.has_status_effect('confused'):
		wander()
	
	var target = GameData.player
	var distance = owner.distance_to(target.get_map_pos())
	if distance <= (GameData.player_radius - 3):
		if distance <= 1:
			owner.fighter.fight(target)
		else:
			# flip a coin to see if troll gets
			# distracted whilst chasing player
			var attention = randi()%2
			if attention == 1:
				owner.step_to(target.get_map_pos())

func wander():
	var UP = randi()%2
	var DOWN = randi()%2
	var LEFT = randi()%2
	var RIGHT = randi()%2
	var dir = Vector2( RIGHT-LEFT, DOWN-UP )
	owner.step(dir)