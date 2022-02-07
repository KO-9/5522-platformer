extends RichTextLabel

var score

func _ready():
	Global.TopRightHUD = self
	score = Global.score

func incScore(new_score):
	score += new_score
	Global.score = score

func _process(delta):
	set_text("Score: %d" % [score])
