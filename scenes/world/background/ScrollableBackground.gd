extends Node2D

export(float) var scroll_speed: float = -1.5

onready var sprite_left: Sprite = $SpriteLeft
onready var sprite_right: Sprite = $SpriteRight
onready var speed_inc_timer: Timer = $SpeedIncrementTimer

var texture_width: float
var speed: float = 0.0

func _ready():
    texture_width = sprite_left.texture.get_size().x * sprite_left.scale.x
    
    Game.connect("scroll_started", self, "on_Game_scroll_started")
    
#    speed_inc_timer.start(2.0)

func _physics_process(delta):
    sprite_left.position.x += speed
    
    if sprite_left.position.x < -texture_width:
        sprite_left.position.x += 2 * texture_width
    
    sprite_right.position.x += speed
    
    if sprite_right.position.x < -texture_width:
        sprite_right.position.x += 2 * texture_width


func on_Game_scroll_started() -> void:
    speed = scroll_speed

func _on_SpeedIncrementTimer_timeout() -> void:
    scroll_speed *= 2
