extends RichTextLabel


var ms = 0
var s = 0
var m = 0

func _ready():
	Global.timer = self
	ms = Global.ms
	s = Global.s
	m = Global.m

# warning-ignore:unused_argument
func _process(delta):
	if Global.ms > 9:
		Global.s += 1
		Global.ms = 0
	if Global.s > 59:
		Global.m += 1
		Global.s = 0
		
		print("%0*d" % [2, 3])
		
	set_text("%0*d:" % [2, Global.m]+"%0*d:" % [2, Global.s]+"%0*d" % [2, Global.ms])

func is_stopped():
	return $Timerms.is_stopped()

func reset():
	ms = Global.ms
	s = Global.s
	m = Global.m

func start():
	$Timerms.start()

func _on_Timerms_timeout():
	Global.ms += 1
