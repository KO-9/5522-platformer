extends Timer

var ms = 0

func _ready():
	Global.world_logic = self
	
func stop_music():
	$bg_music.stop()

func _process(delta):
	if ms > 20:
		var i = 195
		while i < 206:
			i += 1
			#get_node("../PeacefulTileMap").set_cellv(Vector2(i, 1), -1)
	elif ms < 20:
		var i = 195
		while i < 206:
			i += 1
			#get_node("../PeacefulTileMap").set_cellv(Vector2(i, 1), 8)
	if ms < 30:
		var i = 152
		while i < 167:
			i += 1
			#get_node("../PeacefulTileMap").set_cellv(Vector2(i, 1), -1)
	elif ms > 30:
		var i = 152
		while i < 167:
			i += 1
			#get_node("../PeacefulTileMap").set_cellv(Vector2(i, 1), 8)
			#get_node("../PeacefulTileMap").get_cellv(Vector2(i, 1)).modulate = Color(1,1,1,1)

func _on_WorldTrapTimer_timeout():
	ms += 1
	if ms >= 40:
		ms = 0
