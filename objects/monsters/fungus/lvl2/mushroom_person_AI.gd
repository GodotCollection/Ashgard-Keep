# mushroom_person_AI

extends Node

onready var parent = get_parent()
var seen = false # Changes to true when the mushroom first sees the player
var utterances = ['J... Join us!', 'D-Die....', 'NOOooooooo!', 'MMM-Matango....', 'Run...']

func _ready():
	parent.ai = self

func take_turn():
	if parent.fighter.has_status_effect('confused'):
		wander()
	
	var target = GameData.player
	var distance = parent.distance_to(target.get_map_position())
	if distance <= (GameData.player_radius - 1):
		if seen == false:
			grunt()
		if distance <= 1:
			parent.fighter.fight(target)
		else:
			# flip a coin to see if mushroom gets
			# distracted whilst chasing player
			var attention = randi()%2
			if attention == 1:
				parent.step_to(target.get_map_position())

func grunt():
	var chance_to_grunt = randi()%4
	if chance_to_grunt == 1:
		var message = utterances[GameData.roll(0, utterances.size()-1)]
		GameData.broadcast("Mushroom person moans \""+message+"\"")
	seen = true
