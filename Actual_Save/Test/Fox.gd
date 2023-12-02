extends KinematicBody2D

onready var states = $State

var velocity = Vector2(0,0)
var dash_duration = 10
var frame = 0

#Landing stuff
var landing_frames = 0
var lag_frames = 0
var jump_squat = 3

#Air stuff
var airJump = 0
export var airJumpMax = 1
var fastfall = false

#Ledges 
var last_ledge = false
var regrab = 30
var catch = false

onready var GroundL = get_node('Raycasts/GroundL')
onready var GroundR = get_node('Raycasts/GroundR')
onready var Ledge_Grab_F= get_node('Raycasts/Ledge_Grab_F') #NEW
onready var Ledge_Grab_B = get_node('Raycasts/Ledge_Grab_B') #NEW

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
var air_dodge_speed = 500
var UP_B_LAUNCHSPEED = 700

func updateframes(delta):
	frame += 1
	$Frames.text = str(frame)

func turn(direction):
	var dir = 0
	if direction:
		dir = -1
	else:
		dir = 1
	$Sprite.set_flip_h(direction)
	Ledge_Grab_F.set_cast_to(Vector2(dir*abs(Ledge_Grab_F.get_cast_to().x),Ledge_Grab_F.get_cast_to().y))
	Ledge_Grab_F.position.x = dir * abs(Ledge_Grab_F.position.x)
	Ledge_Grab_B.position.x = dir * abs(Ledge_Grab_B.position.x)
	Ledge_Grab_B.set_cast_to(Vector2(-dir*abs(Ledge_Grab_F.get_cast_to().x),Ledge_Grab_F.get_cast_to().y))
	

func direction(): #NEW
	if Ledge_Grab_F.get_cast_to().x > 0: #NEW
		return 1 #NEW
	else: #NEW
		return -1 #NEW

func reset_Jumps():
	airJump = airJumpMax

func reset_ledge():
	last_ledge = false

func frame():
	frame = 0

func play_animation(animation_name):
	$Sprite/AnimationPlayer.play(animation_name)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass 

func _physics_process(delta):
	pass
