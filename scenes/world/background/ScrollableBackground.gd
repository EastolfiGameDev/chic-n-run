extends Node2D

export(float) var scroll_speed: float = -1.5
export(StreamTexture) var background_image

onready var sprite_left: Sprite = $SpriteLeft
onready var sprite_right: Sprite = $SpriteRight

var texture_width: float
var speed: float = 0.0

func _ready():
    if background_image:
        $SpriteLeft.texture = background_image
        $SpriteRight.texture = background_image
    texture_width = sprite_left.texture.get_size().x * sprite_left.scale.x
    
    Game.connect("scroll_started", self, "on_Game_scroll_started")
    Game.connect("scroll_speed_increased", self, "on_ScrollSpeed_increased")

func _physics_process(delta):
    sprite_left.position.x += speed
    
    if sprite_left.position.x < -texture_width:
        sprite_left.position.x += 2 * texture_width
    
    sprite_right.position.x += speed
    
    if sprite_right.position.x < -texture_width:
        sprite_right.position.x += 2 * texture_width

func on_ScrollSpeed_increased(factor: float) -> void:
    speed *= factor

func on_Game_scroll_started() -> void:
    speed = scroll_speed
