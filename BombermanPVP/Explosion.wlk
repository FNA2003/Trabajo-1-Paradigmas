import Root.*
class Explosion inherits DefaultVisual(tag='explosion'){
    method collide(player, explosionPart){
        player.getExplosion()
        game.removeVisual(explosionPart)
    }
}