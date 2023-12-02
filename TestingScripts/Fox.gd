extends CharacterBody2D

#Global Variables
var frame = 0

#Ground Variables
var velocity = Vector2(0,0)
var dash_duration = 10

#Air Variables
var landing_frames = 0
var lag_frames = 0
var jump_squat = 3
var fastfall = false

#Onready Variables
onready var GroundL = get_node('Raycasts/GroundL')
onready var GroundR = get_node('Raycasts/GroundR')
onready var states = $States
onready var anim = $Sprite/AnimationPlayer

#FOX's main attributes
var RUNSPEED = 340
var DASHSPEED = 390
var WALKSPEED = 200
var GRAVITY = 1800
var JUMPFORCE = 500
var MAX_JUMPFORCE = 800
var DOUBLEJUMPFORCE = 1000
var MAXAIRSPEED = 300
var AIR_ACCEL = 25
var FALLSPEED = 60
var FALLINGSPEED = 900
var MAXFALLSPEED = 900
var TRACTION = 40
var ROLL_DISTANCE = 350
var AIR_DODGE_SPEED = 500
var UP_B_LAUNCHSPEED = 700

func updateframes(delta):
	frame += 1

func turn(direction):
	var dir = 0
	if direction:
		dir = -1
	else:
		dir = 1
	$Sprite.set_flip_h(direction)

func _frame():
	frame = 0

func play_animation(animation_name):
    anim.play(animation_name)

func _ready():
	pass

func _physics_process(delta):
	pass