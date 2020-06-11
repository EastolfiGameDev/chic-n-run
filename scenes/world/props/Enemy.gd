extends StaticBody2D


# Initially at 0, characters are made to move by the ObjectPool.
var initial_velocity: float = 0
var speed: float = 0
var animation: AnimationPlayer

func _ready() -> void:
    if has_node("AnimationPlayer"):
        animation = $AnimationPlayer
    
    Game.connect("scroll_speed_increased", self, "on_ScrollSpeed_increased")

func _physics_process(_delta: float) -> void:
    position.x += speed

# @note: for ObjectPool.
func get_height() -> float:
    return $Sprite.texture.get_size().y * scale.y * $Sprite.scale.y

# @note: for ObjectPool.
func reset() -> void:
    initial_velocity = 0

# @note: for ObjectPool.
func start(velocity: float) -> void:
    initial_velocity = -velocity
    speed = initial_velocity * Game.speed_factor
    if animation:
        animation.play("move")

func on_ScrollSpeed_increased(factor: float) -> void:
    speed *= factor
