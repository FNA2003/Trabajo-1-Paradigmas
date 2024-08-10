import Root.*

object up{
    const limit = root.gameHeight() - 2

    method image() = '_up.png'

    method position(position) {
      if(position.y() < limit){
        return position.up(1)
      }
      else return position
    }
}

object down{
    const limit = 0

    method image() = '_down.png'

    method position(position) {
      if(position.y() > limit){
        return position.down(1)
      }
      else return position
    }
}

object right{
    const limit = root.gameWidth() - 1

    method image() = '_right.png'

    method position(position) {
      if(position.x() < limit){
        return position.right(1)
      }
      else return position
    }
}

object left{
    const limit = 0

    method image() = '_left.png'

    method position(position) {
      if(position.x() > limit){
        return position.left(1)
      }
      else return position
    }
}