import wollok.game.*
    
const velocidad = 250

object juego{

	method configurar(){
		game.width(12)
		game.height(8)
		game.title("Dino Game")
		game.boardGround("fondo.png")
		game.addVisual(suelo)
		game.addVisual(cactus)
		game.addVisual(dino)
		game.addVisual(reloj)
		game.addVisual(estrella)
	
		keyboard.space().onPressDo{ self.jugar()}
		keyboard.space().onPressDo({sonidodesalto.play()})
		game.onCollideDo(dino,{ obstaculo => obstaculo.chocar()})
	} 
	
	method    iniciar(){
		dino.iniciar()
		reloj.iniciar()
		cactus.iniciar()
		estrella.iniciar()
	}
	
	method jugar(){
		if (dino.estaVivo()) 
			dino.saltar()
		else {
			game.removeVisual(gameOver)
			self.iniciar()
		}
		
	}
	method video(){
		game.addVisual(lluvia)
		
	}
	method sacarvideo(){
		game.removeVisual(lluvia)
	}
	method terminar(){
		game.addVisual(gameOver)
		cactus.detener()
		estrella.detener()
		reloj.detener()
		dino.morir()
		game.removeVisual(lluvia)
	}
	
}

object gameOver {
	method position() = game.at(3,4)
//	method text() = "GAME OVER"//
	method image() = "gameover.png"	

}


object reloj {
	
	var tiempo = 0
	
	method text() = tiempo.toString()
	method position() = game.at(10, game.height()-2)
	
	method pasarTiempo() {
		tiempo = tiempo +1
	}
	method iniciar(){
		tiempo = 0
		game.onTick(100,"tiempo",{self.pasarTiempo()})
	}
	method detener(){
		game.removeTickEvent("tiempo")
	}
}

object sonidodesalto{
	method play(){
		game.sound("salto.mp3").play()
	}
}

object cactus {
	 
	const posicionInicial = game.at(game.width()-1,suelo.position().y())
	var position = posicionInicial

	method image() = "cactus.png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
		game.onTick(velocidad,"moverCactus",{self.mover()})
	}
	
	method mover(){
		position = position.left(1)
		if (position.x() == -1)
			position = posicionInicial
	}
	
	method chocar(){
		juego.terminar()
	}
    method detener(){
		game.removeTickEvent("moverCactus")
	}
}

object estrella {
	 
	const posicionInicial = game.at (game.width()+6,2)
	var position = posicionInicial

	method image() = "estrella.png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
		game.onTick(velocidad,"moverEstrella",{self.movere()})
	}
	
	method movere(){
		position = position.left(1)
		if (position.x() == -1)
			position = posicionInicial
	}
	method chocar(){
		juego.video()
	}
	method detener(){
		game.removeTickEvent("moverEstrella")
}
}

object suelo{
	method position()=game.origin().up(1)
	method image() ="suelo.png"
}

object dino {
	var vivo = true
	var position = game.at(1,suelo.position().y())
	
	method image() = "dino.png"
	method position() = position
	
	method saltar(){
		if(position.y() == suelo.position().y()) {
			self.subir()
			game.schedule(velocidad*3,{self.bajar()})
		}
	}
	
	method subir(){
		position = position.up(1)
	}
	
	method bajar(){
		position = position.down(1)
	}
	method morir(){
		game.say(self,"¡Auch!")
		vivo = false
	}
	method iniciar() {
		vivo = true
	}
	method estaVivo() {
		return vivo
	}
}
object lluvia{
	var tiempo1 = 0
	method position()=game.origin()
 	method image()="lluvia.png"
 	


	method pasarTiempo() {
		tiempo1 = tiempo1 +1
	}
	method detenervideo(tiempo){
 		if(tiempo1=15) {
			(tiempo1=0) and (game.removeVisual(self))}
			else{self.pasarTiempo()}
	}
	method iniciar(){
		tiempo1 = 0
		game.onTick(100,"tiempo1",{self.pasarTiempo()})
	}

	method detener(){
		game.removeTickEvent("tiempo1")
	}
}