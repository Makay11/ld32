keyCodes =
	space: 32
	left: 37
	right: 39
	1: 49
	2: 50
	3: 51
	4: 52

MS = 8

$ ->
	gameManager = new GameManager()

	$("body").append(gameManager.renderer.domElement)

	$(window).on "resize", ->
		gameManager.resize()

	$(document).on "keydown", (event) ->
		gameManager.keyDown(event)

	previousTime = 0

	gameLoop = (time) ->
		delta = time - previousTime
		previousTime = time

		gameManager.update(delta)
		gameManager.render()

		requestAnimationFrame(gameLoop)

	gameLoop()
