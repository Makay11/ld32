defer = (f) -> setTimeout -> f()

defer ->
	width = window.innerWidth
	height = window.innerHeight

	renderer = new THREE.WebGLRenderer()
	renderer.setSize(width, height - 4)
	document.body.appendChild(renderer.domElement)

	camera = new THREE.PerspectiveCamera(75, width / height, 0.1, 1000)

	camera.position.z = 2
	camera.lookAt(new THREE.Vector3(0, 10, 0))

	scene = new THREE.Scene()

	geometry = new THREE.PlaneBufferGeometry(5, 1000)
	material = new THREE.MeshBasicMaterial({color: 0xffff00, side: THREE.DoubleSide})
	plane = new THREE.Mesh(geometry, material)
	scene.add(plane)

	geometry = new THREE.PlaneBufferGeometry(0.7, 2)
	material = new THREE.MeshBasicMaterial({color: 0xff0000, side: THREE.DoubleSide})
	player = new THREE.Mesh(geometry, material)
	player.position.x = 0
	player.position.y = 2
	player.position.z = 0.5
	player.rotateOnAxis(new THREE.Vector3(1, 0, 0), Math.PI / 2)
	scene.add(player)

	update = ->

	render = ->
		renderer.render(scene, camera)

	gameLoop = ->
		requestAnimationFrame(gameLoop)
		update()
		render()

	gameLoop()
