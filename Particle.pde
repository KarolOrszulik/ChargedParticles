class Particle {
  final static float k = 20.0;           // electrostatic constant; discribes how stongly particles repell each other
  final static float scale = 1.5;        // scale of simulation; used to scale the distance between particles
  
  final static float maxSpeed = 5.0;     // maximum speed of particles
  final static float damping = 1.01;     // movement damping of particles or viscosity of enviornment medium
  
  final static float wallCharge = 5.0;   // the repelling charge of walls
  final static float mouseCharge = 25.0; // the repelling charge of mouse when clicked
  
  final static float drawSize = 4.0;     // scale for rendering particles as dots

  float size = 1;              // render size, mass and charge
  PVector pos = new PVector(); //
  PVector vel = new PVector(); // kinematic properties
  PVector acc = new PVector(); //

  Particle(float s, PVector p) {  // construstor for explicit position
    size = s;
    pos = p;
  }

  Particle(float s) {  // constructor for random position within the window
    size = s;
    pos.x = random(width);
    pos.y = random(height);
  }

  void update() {  // update the velocity and position of particle
    vel.add(acc);
    vel.limit(maxSpeed);
    vel.div(damping);
    pos.add(vel);

    pos.x = constrain(pos.x, 0, width);  // keeping the particle
    pos.y = constrain(pos.y, 0, height); // within the window

    acc.setMag(0);
  }

  void show() {  // render the particle
    stroke(255);
    strokeWeight(size*drawSize);
    point(pos.x, pos.y);
  }

  void applyForce(PVector f) {  // accumulate acceleration with force/mass
    acc.add(f.div(size));
  }

  void chargeForces(Particle[] particles) {  // apply a repulsion force from every other particle, walls and mouse (when pressed)
    
    // from other particles
    for (Particle p : particles) {
      if (p != this) {
        applyForce(repulsionForce(this, p));
      }
    }
    
    // from mouse when pressed; a virtual particle located at mouse pointer
    if(mousePressed)
      applyForce(repulsionForce(this, new Particle(mouseCharge, new PVector(mouseX, mouseY))));
    
    // from walls; a virtual particle on each wall closest to the particle in concern
    applyForce(repulsionForce(this, new Particle(wallCharge, new PVector(pos.x, -1))));
    applyForce(repulsionForce(this, new Particle(wallCharge, new PVector(pos.x, height))));  
    applyForce(repulsionForce(this, new Particle(wallCharge, new PVector(-1, pos.y))));
    applyForce(repulsionForce(this, new Particle(wallCharge, new PVector(width, pos.y))));
  }
  
  PVector repulsionForce(Particle p1, Particle p2) { // calculate the repulsion force between two particles
    PVector force = p1.pos.copy().sub(p2.pos);   // gets a vector pointin from the other particle to this particle
    float r2 = pow(force.mag()/scale, 2) + 0.01; // +0.01 avoids division by 0
    force.normalize();                           // force calculation by Coulomb's law:
    force.mult(k * p1.size * p2.size).div(r2);   // https://en.wikipedia.org/wiki/Coulomb%27s_law
    return force;
  }
};
