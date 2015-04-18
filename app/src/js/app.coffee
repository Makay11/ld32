defer = (f) -> setTimeout -> f()

class Player
	constructor: ->
		@geometry = new THREE.PlaneBufferGeometry(0.7, 1.5)
		@material = new THREE.MeshBasicMaterial(color: 0xff0000, side: THREE.DoubleSide)
		@mesh = new THREE.Mesh(@geometry, @material)
		@mesh.position.x = 0
		@mesh.position.y = 1.5
		@mesh.position.z = 1.5 / 2
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
				if @mesh.position.x <= @position - 1
					@position = @position - 1
					@mesh.position.x = @position
					@moving = false
			else if @moving == "right"
				@mesh.position.x += @movementSpeed * delta
				if @mesh.position.x >= @position + 1
					@position = @position + 1
					@mesh.position.x = @position
					@moving = false


defer ->
	renderer = new THREE.WebGLRenderer()

	width = window.innerWidth
	height = window.innerHeight
	renderer.setSize(width, height - 4)

	$("body").append(renderer.domElement)

	camera = new THREE.PerspectiveCamera(75, width / height, 0.1, 1000)

	camera.position.z = 2
	camera.lookAt(new THREE.Vector3(0, 5, 0))

	$(window).on "resize", ->
		width = window.innerWidth
		height = window.innerHeight
		renderer.setSize(width, height - 4)
		camera.aspect = width / height
		camera.updateProjectionMatrix()

	scene = new THREE.Scene()

	geometry = new THREE.PlaneBufferGeometry(3, 1000)
	material = new THREE.MeshBasicMaterial({color: 0xffff00, side: THREE.DoubleSide})
	plane = new THREE.Mesh(geometry, material)
	scene.add(plane)

	player = new Player()
	scene.add(player.mesh)

	keyboard = new THREEx.KeyboardState()

	wasPressed = left: false, right: false

	update = (delta) ->
		if left = keyboard.pressed("left")
			if not wasPressed.left and not player.moving
				player.moveLeft()

		wasPressed.left = left

		if right = keyboard.pressed("right")
			if not wasPressed.right and not player.moving
				player.moveRight()

		wasPressed.right = right

		player.update(delta)

	render = ->
		renderer.render(scene, camera)

	previousTime = 0

	gameLoop = (time) ->
		requestAnimationFrame(gameLoop)
		delta = time - previousTime
		update(delta)
		render()

	gameLoop()
