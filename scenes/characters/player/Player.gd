extends KinematicBody2D

enum STATES {
    IDLE, RUN, JUMP, CROUCH
}

const UP: Vector2 = Vector2(0, -1)
const JUMP_SPEED: float = 1200.0
const GRAVITY: float = 80.0

var state: int = STATES.IDLE
var motion := Vector2.ZERO
var is_on_air := false
var is_crouch_registered := false

onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
    randomize()

    # Count down -> activate scroll
    yield(get_tree().create_timer(1.0), "timeout")
    _change_state(STATES.RUN)

func _physics_process(delta: float) -> void:
    move_and_slide(motion, UP)
    _apply_gravity()
    _check_state()

func _input(event: InputEvent) -> void:
    if state != STATES.CROUCH:
        if state != STATES.JUMP and event.is_action_pressed("jump"):
            _change_state(STATES.JUMP)
        elif event.is_action_pressed("crouch"):
            # Delay the crouch to able to track is the crouch key is pressed while jumping
            is_crouch_registered = true

    if state == STATES.CROUCH:
        if event.is_action_released("crouch"):
            is_crouch_registered = false
            _change_state(STATES.RUN)

func _apply_gravity() -> void:
    if is_on_floor() and not is_on_air:
        motion.y = 0
    else:
        motion.y += GRAVITY

func _change_state(new_state: int) -> void:
    match state:
        STATES.CROUCH:
            if new_state != STATES.CROUCH:
                _expand_collision()

    match new_state:
        STATES.RUN:
            is_on_air = false
        STATES.JUMP:
            motion.y -= JUMP_SPEED
            yield(get_tree(), "idle_frame")
            is_on_air = true
        STATES.CROUCH:
            _shrink_collision()
    
    state = new_state

func _check_state() -> void:
    if is_crouch_registered and state == STATES.RUN:
        _change_state(STATES.CROUCH)

    match state:
        STATES.IDLE:
            _state_idle()
        STATES.RUN:
            _state_run()
        STATES.JUMP:
            _state_jump()
        STATES.CROUCH:
            _state_crouch()
        _:
            _change_state(STATES.IDLE)

func _state_idle() -> void:
    pass

func _state_run() -> void:
    pass

func _state_jump() -> void:
    if is_on_air and is_on_floor():
        _change_state(STATES.RUN)

func _state_crouch() -> void:
    pass

func _shrink_collision() -> void:
    collision_shape.shape.extents.y = 15
    collision_shape.position.y = 15

func _expand_collision() -> void:
    collision_shape.shape.extents.y = 30
    collision_shape.position.y = 0
