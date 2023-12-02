tool 

extends Node2D

class_name TestBox

export  var x:int = 0
export  var y:int = 0
export  var width:int = 20
export  var height:int = 20
export  var can_draw:bool = true
export var colour:Color 


var editor_selected = false

func box_draw():
		var fill = colour
		var stroke = colour
		fill.a = 0.25
		stroke.a = 1
		draw_rect(Rect2((x - width),(y - height),width*2,height*2), fill, true)
		draw_rect(Rect2((x - width),(y - height),width*2,height*2), stroke, false)
#Rect2(x,y,width,height)


func can_draw_box():
	if editor_selected:
		return true

func _ready():
	z_index = 1000

func _process(delta):
	update()
	if Engine.editor_hint and can_draw:
		editor_selected = true
	else:
		editor_selected = false

func _draw():
	if not editor_selected:
		return 
	box_draw()
