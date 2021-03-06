extends PanelContainer

onready var frame = get_node('frame')
onready var hpbox = frame.get_node('HP')
onready var statsbox = frame.get_node('stats')
onready var statsleft = statsbox.get_node('left')
onready var statsright = statsbox.get_node('right')

onready var namelabel = frame.get_node('Name')
onready var racelabel = frame.get_node('race_class/Race')

onready var currenthplabel = hpbox.get_node('labels/CurrentHP')
onready var maxhplabel = hpbox.get_node('labels/MaxHP')
onready var hpbar = hpbox.get_node('Bar')
onready var xplabel = statsright.get_node('values/XP')

onready var characterlevellabel = statsleft.get_node('values/Level')
onready var attacklabel = statsleft.get_node('values/Attack')
onready var defencelabel = statsleft.get_node('values/Defence')


func name_changed(what):
	namelabel.set_text(what)

func race_changed(what):
	racelabel.set_text(what)

func attack_changed(what):
	attacklabel.set_text(str(what))

func defence_changed(what):
	defencelabel.set_text(str(what))

func hp_changed(current,full):
	currenthplabel.set_text(str(current))
	maxhplabel.set_text(str(full))
	hpbar.set_max(full)
	hpbar.set_value(current)

func xp_changed(what):
	xplabel.set_text(str(what))

func character_level_changed(what):
	characterlevellabel.set_text(str(what))

func _ready():
	pass
