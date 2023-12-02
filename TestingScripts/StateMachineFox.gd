extends StateMachine
var id = 1


func _ready():
    add_state('STAND')
    add_state('JUMP_SQUAT')
    add_state('SHORT_HOP')
    add_state('FULL_HOP')
    add_state('DASH')
    add_state('RUN')
    add_state('WALK')
    add_state('MOONWALK')
    add_state('TURN')
    add_state('CROUCH')
    add_state('AIR')
    add_state('LANDING')
    call_deferred("set_state", state.STAND)

func state_logic(delta):
    parent.updateframes(delta)
    parent._physics_process(delta)

func get_transition(delta):
    parent.move_and_slide_with_snap(parent.velocity*2,Vector2.ZERO,Vector2.UP)
    if Landing() == true:
        parent._frame()
        return states.LANDING
    if Falling() == true:
        return states.AIR
    match state:
        states.STAND:
            if Input.is_action_just_pressed("jump_%s" % id):
                parent._frame()
                return states.JUMP_SQUAT
            if Input.get_action_strength("right_%s" % id) == 1:
                parent.velocity.x = parent.RUNSPEED
                parent._frame()
                parent.turn(false)
                return states.DASH
            if Input.get_action_strength("left_%s" % id) == 1:
                parent.velocity.x = parent.RUNSPEED
                parent._frame()
                parent.turn(true)
                return states.DASH
            if parent.velocity.x > 0 and state == states.STAND:
                parent.velocity.x += -parent.TRACTION*1
                parent.velocity.x = clamp(parent.velocity.x,0,parent.velocity.x)
            elif parent.velocity.x < 0 and state == states.STAND:
                parent.velocity.x += -parent.TRACTION*1
                parent.velocity.x = clamp(parent.velocity.x,parent.velocity.x,0)

        states.JUMP_SQUAT:
            if parent._frame == parent.JUMP_SQUAT:
                if not Input.is_action_pressed("jump_%s" % id):
                    parent.velocity.x = lerp(parent.velocity.x,0,0.08)
                    parent._frame()
                    return states.SHORT_HOP
                else:
                    parent.velocity.x = lerp(parent.velocity.x,0,0.08)
                    parent._frame()
                    return states.FULL_HOP
        states.SHORT_HOP:
            parent.velocity.y = -parent.JUMPFORCE
            parent._frame()
            return states.AIR
        states.FULL_HOP:
            parent.velocity.y = -parent.MAX_JUMPFORCE
            parent._frame()
            return states.AIR
        states.DASH:
            if Input.is_action_pressed("left_%s" % id):
                if parent.velocity.x > 0:
                    parent._frame()
                parent.velocity.x = -parent.DASHSPEED
                parent.turn(true)
            elif Input.is_action_pressed("left_%s" % id):
                if parent.velocity.x < 0:
                    parent._frame()
                parent.velocity.x = -parent.DASHSPEED
                parent.turn(false)
            else:
                if parent._frame >= parent.dash_duration-1:
                    return states.STAND
        states.RUN:
            if Input.is_action_just_pressed("jump_%s" % id):
                parent._frame()
                return states.JUMP_SQUAT
            if Input.is_action_just_pressed("down_%s" % id):
                parent._frame()
                return states.CROUCH
            if Input.get_action_strength("left_%s" % id):
                if parent.velocity.x <= 0:
                    parent.velocity.x = -parent.RUNSPEED
                    parent.turn(true)
                else:
                    parent.frame()
                    return states.TURN
            elif Input.get_action_strength("right_%s" % id):
                if parent.velocity.x >= 0:
                    parent.velocity.x = parent.RUNSPEED
                    parent.turn(false)
                else:
                    parent._frame()
                    return states.TURN
            else:
                parent.frame()
                return states.STAND
        states.TURN:
            if Input.is_action_just_pressed("jump_%s" % id):
                parent.frame()
                return state.JUMP_SQUAT
            if parent.velocity.x > 0:
                parent.turn(true)
                parent.velocity.x += -parent.TRACTION*2
                parent.velocity.x = clamp(parent.velocity.x,0,parent.velocity.x)
            elif parent.velocity.x < 0:
                parent.turn(false)
                parent.velocity.x += parent.TRACTION*2
                parent.velocity.x = clamp(parent.velocity.x,parent.velocity.x,0)
            else:
                if not Input.is_action_just_pressed("left_%s" % id) and not Input.is_action_pressed("right_%s" % id):
                    parent.frame()
                    return state.STAND
                else:
                    parent.frame()
                    return state.RUN
        states.MOONWALK:
            pass
        states.WALK:
            pass
        states.CROUCH:
            pass
        states.AIR:
            AIRMOVEMENT():
        states.LANDING:
            if parent._frame <= parent.landing_frames + parent.lag_frames:
                if parent._frame == 1:
                    pass
                if parent.velocity.x > 0:
                    parent.velocity.x = parent.velocity.x - parent.TRACTION/2
                    parent.velocity.x = clamp(parent.velocity.x, 0 , parent.velocity.x)
                elif parent.velocity.x < 0:
                    parent.velocity.x = parent.velocity.x + parent.TRACTION/2
                    parent.velocity.x = clamp(parent.velocity.x, parent.velocity.x, 0 )
                if Input.is_action_pressed("jump_%s" % id): #and Input.is_action_pressed("shield")
                    parent._frame()
                    return states.JUMP_SQUAT
                else:
                    if Input.is_action_pressed("down_%s" % id):
                        parent.lag_frames = 0
                        parent._frame()
                        return states.CROUCH
                    else:
                        parent._frame()
                        parent.lag_frames = 0
                        return states.STAND
                    parent.lag_frames = 0

func enter_state(new_state, old_state):
    match new_state:
        states.STAND:
            parent.play_animation('IDLE')
            parent.states.text = str('STAND')
        states.DASH:
            parent.play_animation('DASH')
            parent.states.text = str('DASH')
        states.JUMP_SQUAT:
            parent.play_animation('JUMP_SQUAT')
            parent.states.text = str('JUMP_SQUAT')
        states.SHORT_HOP:
            parent.play_animation('AIR')
            parent.states.text = str('SHORT_HOP')
        states.FULL_HOP:
            parent.play_animation('AIR')
            parent.states.text = str('FULL_HOP')
        states.AIR:
            parent.play_animation('AIR')
            parent.states.text = str('AIR')
        states.LANDING:
            parent.play_animation('LANDING')
            parent.states.text = str('LANDING')
        

func exit_state(old_state, new_state):
    pass

func state_includes(state_array):
    for each_state in state_array:
        if state == each_state:
            return true
    return false

func AIRMOVEMENT():
    if parent.velocity.y < parent.FALLINGSPEED:
        parent.velocity.y +=parent.FALLSPEED
    if Input.is_action_pressed("down_%s" % id) and parent.down_buffer == 1 and parent.velocity.y > -150 and not parent.fastfall:
        parent.velocity.y = parent.MAXFALLSPEED
        parent.fastfall = true
    if parent.fastfall == true:
        parent.set_collision_mask_bit(2,false)
        parent.velocity.y = parent.MAXFALLSPEED

    if abs(parent.velocity.x) >= abs(parent.MAXAIRSPEED):
        if parent.velocity.x > 0:
            if Input.is_action_pressed("left_%s" % id):
                parent.velocity.x += -parent.AIR_ACCEL
            elif Input.is_action_pressed("right_%s" % id):
                parent.velocity.x += -parent.velocity.x
        if parent.velocity.x < 0:
            if Input.is_action_pressed("left_%s" % id):
                parent.velocity.x = parent.velocity.x
            elif Input.is_action_pressed("right_%s" % id):
                parent.velocity.x += parent.AIR_ACCEL

    elif abs(parent.velocity.x) < abs(parent.MAXAIRSPEED):
        if Input.is_action_pressed("left_%s" % id):
            parent.velocity.x += -parent.AIR_ACCEL#*2
        if Input.is_action_pressed("right_%s" % id):
            parent.velocity.x += parent.AIR_ACCEL#*2

    if not Input.is_action_pressed("left_%s" % id) and not Input.is_action_pressed("right_%s" % id):
        if parent.velocity.c < 0:
            parent.velocity.x += parent.AIR_ACCEL/ 5
        elif parent.velocity.x > 0:
            parent.velocity.x += -parent.AIR_ACCEL / 5

func  Landing():
    if state_includes([states.AIR]):
        if (parent.GroundL.is_colliding()) and parent.velocity.y > 0:
                var collider =parent.GroundL.get_collider()
                parent.frame = 0
                if parent.velocity.y > 0:
                    parent.velocity.y = 0
                parent.fastfall = false
                return true

func Falling():
    if state_includes([states.RUN,states.WALK,states.STAND,states.CROUCH,states.DASH,states.LANDING,states.TURN,states.JUMP_SQUAT,states.MOONWALK,states.ROLL_RIGHT,states.ROLL_LEFT,states.PARRY]):
        if not parent.GroundL.is_colliding() and not parent.GroundR.is_colliding():
            return true