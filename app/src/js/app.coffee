defer = (f) -> setTimeout -> f()

class Player
	constructor: ->
		@width = 1
		@height = 1.5

		@geometry = new THREE.PlaneBufferGeometry(@width, @height)
		@material = new THREE.MeshBasicMaterial(color: 0xff0000, side: THREE.DoubleSide)
		@mesh = new THREE.Mesh(@geometry, @material)
		@mesh.position.z = @height / 2
		@mesh.rotateOnAxis(new THREE.Vector3(1, 0, 0), Math.PI / 2)

		@position = 0
		@moving = false

		@movementSpeed = 1 / 250

	moveLeft: ->
		if @moving then return
		if @position > -1
			@moving = "left"

	moveRight: ->
		if @moving then return
		if @position < 1
			@moving = "right"

	update: (delta) ->
		if @moving
			if @moving == "left"
				@mesh.position.x -= @movementSpeed * delta
				if @mesh.position.x <= @position - 2
					@position = @position - 2
					@mesh.position.x = @position
					@moving = false
			else if @moving == "right"
				@mesh.position.x += @movementSpeed * delta
				if @mesh.position.x >= @position + 2
					@position = @position + 2
					@mesh.position.x = @position
					@moving = false


defer ->
	renderer = new THREE.WebGLRenderer()

	width = window.innerWidth
	height = window.innerHeight
	renderer.setSize(width, height - 4)

	$("body").append(renderer.domElement)

	camera = new THREE.PerspectiveCamera(75, width / height, 0.1, 1000)

	camera.position.y = -2.5
	camera.position.z = 2
	camera.rotateOnAxis(new THREE.Vector3(1, 0, 0), Math.PI / 2.2)

	$(window).on "resize", ->
		width = window.innerWidth
		height = window.innerHeight
		renderer.setSize(width, height - 4)
		camera.aspect = width / height
		camera.updateProjectionMatrix()

	scene = new THREE.Scene()

	geometry = new THREE.PlaneBufferGeometry(6, 1000)
	material = new THREE.MeshBasicMaterial({color: 0xffff00, side: THREE.DoubleSide})
	plane = new THREE.Mesh(geometry, material)
	scene.add(plane)

	player = new Player()
	scene.add(player.mesh)

	keyCodes =
		left: 37
		right: 39

	$(document).on "keydown", (event) ->
		switch event.keyCode
			when keyCodes.left
				player.moveLeft()
			when keyCodes.right
				player.moveRight()

	update = (delta) ->
		player.update(delta)

	render = ->
		renderer.render(scene, camera)

	previousTime = 0

	gameLoop = (time) ->
		requestAnimationFrame(gameLoop)

		delta = time - previousTime
		previousTime = time

		update(delta)
		render()

	gameLoop()
