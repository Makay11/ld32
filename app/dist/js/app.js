// Generated by CoffeeScript 1.9.2
var Enemy, Player, defer;

defer = function(f) {
  return setTimeout(function() {
    return f();
  });
};

defer(function() {
  var camera, enemies, enemyPool, gameLoop, generateNextSpawn, geometry, height, keyCodes, material, movementQueue, nextSpawn, plane, player, previousTime, render, renderer, scene, transparentObjects, update, width;
  renderer = new THREE.WebGLRenderer();
  width = window.innerWidth;
  height = window.innerHeight;
  renderer.setSize(width, height - 4);
  $("body").append(renderer.domElement);
  camera = new THREE.PerspectiveCamera(75, width / height, 0.1, 1000);
  camera.position.y = -2.5;
  camera.position.z = 2;
  camera.rotateOnAxis(new THREE.Vector3(1, 0, 0), Math.PI / 2.2);
  $(window).on("resize", function() {
    width = window.innerWidth;
    height = window.innerHeight;
    renderer.setSize(width, height - 4);
    camera.aspect = width / height;
    return camera.updateProjectionMatrix();
  });
  scene = new THREE.Scene();
  geometry = new THREE.PlaneBufferGeometry(6, 1000);
  material = new THREE.MeshBasicMaterial({
    color: 0xffff00,
    side: THREE.DoubleSide
  });
  plane = new THREE.Mesh(geometry, material);
  scene.add(plane);
  player = new Player(renderer);
  scene.add(player.mesh);
  transparentObjects = [player.mesh];
  enemies = [];
  enemyPool = [];
  THREEx.Transparency.init(transparentObjects);
  keyCodes = {
    left: 37,
    right: 39
  };
  movementQueue = [];
  $(document).on("keydown", function(event) {
    switch (event.keyCode) {
      case keyCodes.left:
        if (movementQueue.length < 2 && !(player.position === 0 && player.moving === "left")) {
          return movementQueue.push("left");
        }
        break;
      case keyCodes.right:
        if (movementQueue.length < 2 && !(player.position === 0 && player.moving === "right")) {
          return movementQueue.push("right");
        }
    }
  });
  nextSpawn = 0;
  generateNextSpawn = function() {
    return nextSpawn = Math.floor(Math.random() * 2 * 1000 / 1);
  };
  update = function(delta) {
    var canCollide, deadEnemies, enemy, enemyX, i, j, len, len1, playerX;
    if (!player.moving && movementQueue.length > 0) {
      switch (movementQueue[0]) {
        case "left":
          player.moveLeft();
          break;
        case "right":
          player.moveRight();
      }
      movementQueue.splice(0, 1);
    }
    player.update(delta);
    deadEnemies = [];
    for (i = 0, len = enemies.length; i < len; i++) {
      enemy = enemies[i];
      if (!enemy.collided && enemy.mesh.position.y > 0) {
        canCollide = true;
      }
      enemy.update(delta);
      if (canCollide && enemy.mesh.position.y < 0.25) {
        enemyX = enemy.mesh.position.x;
        playerX = player.mesh.position.x;
        if (enemyX - enemy.width / 2 <= playerX + player.width / 2 && playerX - player.width / 2 <= enemyX + enemy.width / 2) {
          enemy.collided = true;
          console.log("ded");
        }
      }
      if (enemy.mesh.position.y <= camera.position.y) {
        enemyPool.push(enemy);
        scene.remove(enemy.mesh);
        deadEnemies.push(enemy);
      }
    }
    for (j = 0, len1 = deadEnemies.length; j < len1; j++) {
      enemy = deadEnemies[j];
      enemies.splice(enemies.indexOf(enemy), 1);
    }
    nextSpawn -= delta || 0;
    if (nextSpawn <= 0) {
      if (enemyPool.length > 0) {
        enemy = enemyPool.pop();
        enemy.reset();
      } else {
        enemy = new Enemy(renderer);
      }
      enemies.push(enemy);
      scene.add(enemy.mesh);
      return generateNextSpawn();
    }
  };
  render = function() {
    return renderer.render(scene, camera);
  };
  previousTime = 0;
  gameLoop = function(time) {
    var delta;
    requestAnimationFrame(gameLoop);
    delta = time - previousTime;
    previousTime = time;
    update(delta);
    return render();
  };
  return gameLoop();
});

Player = (function() {
  function Player(renderer) {
    this.width = 1;
    this.height = 1.5;
    this.position = 0;
    this.moving = false;
    this.movementSpeed = 1 / 200;
    this.texture = THREE.ImageUtils.loadTexture("/images/runner.png");
    this.texture.minFilter = THREE.LinearFilter;
    this.texture.anisotropy = renderer.getMaxAnisotropy();
    this.geometry = new THREE.PlaneBufferGeometry(this.width, this.height);
    this.material = new THREE.MeshBasicMaterial({
      map: this.texture
    });
    this.mesh = new THREE.Mesh(this.geometry, this.material);
    this.mesh.position.z = this.height / 2;
    this.mesh.rotateOnAxis(new THREE.Vector3(1, 0, 0), Math.PI / 2);
  }

  Player.prototype.moveLeft = function() {
    if (this.moving) {
      return;
    }
    if (this.position > -1) {
      return this.moving = "left";
    }
  };

  Player.prototype.moveRight = function() {
    if (this.moving) {
      return;
    }
    if (this.position < 1) {
      return this.moving = "right";
    }
  };

  Player.prototype.update = function(delta) {
    if (this.moving) {
      if (this.moving === "left") {
        this.mesh.position.x -= this.movementSpeed * delta;
        if (this.mesh.position.x <= this.position - 2) {
          this.position = this.position - 2;
          this.mesh.position.x = this.position;
          return this.moving = false;
        }
      } else if (this.moving === "right") {
        this.mesh.position.x += this.movementSpeed * delta;
        if (this.mesh.position.x >= this.position + 2) {
          this.position = this.position + 2;
          this.mesh.position.x = this.position;
          return this.moving = false;
        }
      }
    }
  };

  return Player;

})();

Enemy = (function() {
  function Enemy(renderer) {
    this.width = 1;
    this.height = 1.5;
    this.movementSpeed = 3 / 1000;
    this.collided = false;
    this.texture = THREE.ImageUtils.loadTexture("/images/runner.png");
    this.texture.minFilter = THREE.LinearFilter;
    this.texture.anisotropy = renderer.getMaxAnisotropy();
    this.geometry = new THREE.PlaneBufferGeometry(this.width, this.height);
    this.material = new THREE.MeshBasicMaterial({
      map: this.texture
    });
    this.mesh = new THREE.Mesh(this.geometry, this.material);
    this.mesh.position.x = Math.floor(Math.random() * 3 / 1) * 2 - 2;
    this.mesh.position.y = 20;
    this.mesh.position.z = this.height / 2;
    this.mesh.rotateOnAxis(new THREE.Vector3(1, 0, 0), Math.PI / 2);
  }

  Enemy.prototype.update = function(delta) {
    return this.mesh.position.y -= this.movementSpeed * delta;
  };

  Enemy.prototype.reset = function() {
    this.mesh.position.x = Math.floor(Math.random() * 3 / 1) * 2 - 2;
    this.mesh.position.y = 20;
    return this.collided = false;
  };

  return Enemy;

})();
