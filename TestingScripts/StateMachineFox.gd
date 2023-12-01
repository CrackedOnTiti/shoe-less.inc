extends StateMachine
var id = 1


func _ready():
    add_state('STAND')
    add_state('JUMP_SQUAT')
    add_state('SHORT_HOP')
    add_state('FULL_HOP')
    add_state('DASH')
    add_state('MOONWALK')
    add_state('WALK')
    add_state('CROUCH')
    call_deferred("set_state", state.STAND)

func state_logic(delta):
    parent.updateframes(delta)
    parent._physics_process(delta)

func get_transition(delta):
    parent.move_and_slide_with_snap(parent.velocity*2,Vector2.ZERO,Vector2.UP)
    match state:
        states.STAND:
            if Input.get_action_strength("right_%s" % id) == 1:
                parent.velocity.x = parent.RUNSPEED
                parent.frame()
                parent.turn(false)
                return states.DASH
            if Input.get_action_strength("left_%s" % id) == 1:
                parent.velocity.x = parent.RUNSPEED
                parent.frame()
                parent.turn(true)
                return states.DASH
            if parent.velocity.x > 0 and state == states.STAND:
                parent.velocity.x += -parent.TRACTION*1
                parent.velocity.x = clamp(parent.velocity.x,0,parent.velocity.x)
            elif parent.velocity.x < 0 and state == states.STAND:
                parent.velocity.x += -parent.TRACTION*1
                parent.velocity.x = clamp(parent.velocity.x,parent.velocity.x,0)
        states.JUMP_SQUAT:
            pass
        states.SHORT_HOP:
            pass
        states.FULL_HOP:
            pass
        states.DASH:
            if Input.is_action_pressed("left_%s" % id):
                if parent.velocity.x > 0:
                    parent.frame()
                parent.velocity.x = -parent.DASHSPEED
            elif Input.is_action_pressed("left_%s" % id):
                if parent.velocity.x < 0:
                    parent.frame()
                parent.velocity.x = -parent.DASHSPEED
            else:
                if parent.frame >= parent.dash_duration-1:
                    return states.STAND

        states.MOONWALK:
            pass
        states.WALK:
            pass
        states.CROUCH:
            pass

func enter_state(new_state, old_state):
    pass

func exit_state(old_state, new_state):
    pass

func state_includes(state_array):
    for each_state in state_array:
        if state == each_state:
            return true
    return false
