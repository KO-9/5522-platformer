extends Node

var checkpoint_coord = Vector2.ZERO
var checkpoint_triggered = false
var world_logic
var current_world = 1
var previous_world = 1
var player
var timer
var previous_world_timer = 0
var world
const GRAVITY = 20
var TopRightHUD
var score = 0
var previous_world_score = 0
var ms = 0
var s = 0
var m = 0
const DYNAMIC_MESSAGE = preload("res://Scripts/UI/dynamicMessage.tscn")

func _ready():
	pass

func addScore(toAdd):
	score += toAdd

func resetTimer():
	ms = 0
	s = 0
	m = 0
	timer.reset()
