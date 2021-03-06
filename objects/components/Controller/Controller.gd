extends Node

onready var owner = get_parent()

# Confused
func random_step():
	var UP = randi()%2
	var DOWN = randi()%2
	var LEFT = randi()%2
	var RIGHT = randi()%2
	var dir = Vector2( RIGHT-LEFT, DOWN-UP )
	owner.step(dir)


# GRAB action
func Grab():
	var items = []
	for ob in GameData.map.get_objects_in_cell(owner.get_map_pos()):
		if ob.item:
			items.append(ob)
	if not items.empty():
		var result = items[0].item.pickup()
		if result == OK:
			owner.emit_signal('object_acted')

# DROP action
func Drop():
	if GameData.in_use == true:
		GameData.broadcast("Click the map to confirm, RMB to cancel")
		return
	GameData.inventory.call_drop_menu()
	var items = yield(GameData.inventory_menu, 'items_selected')
	if items.empty():
		GameData.broadcast("action cancelled")
	else:
		for obj in items:
			obj.item.drop()
			owner.emit_signal('object_acted')

#THROW action
func Throw():
	if GameData.in_use == true:
		GameData.broadcast("Click the map to confirm, RMB to cancel")
		return
	GameData.inventory.call_throw_menu()
	var obj = yield(GameData.inventory_menu, 'items_selected')
	if obj.empty():
		GameData.broadcast("action cancelled")
	else:
		obj = obj[0]
		obj.item.throw(1)

# WAIT action
func Wait():
	owner.emit_signal('object_acted')

func _ready():
	GameData.player = owner
	owner.connect("object_moved", GameData.map.get_node('Fogmap'), '_on_player_pos_changed')
	owner.connect("object_acted", GameData.map, "_on_player_acted")
	set_process_input(true)


func _input(event):
	var N = event.is_action_pressed('step_N')
	var NE = event.is_action_pressed('step_NE')
	var E = event.is_action_pressed('step_E')
	var SE = event.is_action_pressed('step_SE')
	var S = event.is_action_pressed('step_S')
	var SW = event.is_action_pressed('step_SW')
	var W = event.is_action_pressed('step_W')
	var NW = event.is_action_pressed('step_NW')
	var WAIT = event.is_action_pressed('step_WAIT')
	
	var GRAB = event.is_action_pressed('act_GRAB')
	var DROP = event.is_action_pressed('act_DROP')
	var THROW = event.is_action_pressed('act_THROW')
	# Status effects
	if owner.fighter.has_status_effect('confused'):
		if N || NE || E || SE || S || SW || W || NW || WAIT:
			random_step()
			return
	if owner.fighter.has_status_effect('paralysed') || owner.fighter.has_status_effect('stuck'):
		if N || NE || E || SE || S || SW || W || NW:
			Wait()
			return
	
	if N:
		owner.step(Vector2(0,-1))
	if NE:
		owner.step(Vector2(1,-1))
	if E:
		owner.step(Vector2(1,0))
	if SE:
		owner.step(Vector2(1,1))
	if S:
		owner.step(Vector2(0,1))
	if SW:
		owner.step(Vector2(-1,1))
	if W:
		owner.step(Vector2(-1,0))
	if NW:
		owner.step(Vector2(-1,-1))
	
	if WAIT:
		Wait()
	if GRAB:
		Grab()
	if DROP:
		Drop()
	if THROW:
		Throw()