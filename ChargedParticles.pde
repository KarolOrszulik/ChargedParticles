/*
  This is a sketch made to simulate a field of suspended,
  mutually repellent electrostatically charged particles.
  This also desctibes magnetised bodies.
  
  Each particle is repelled from every other particle
  with a force given by Coulomb's law of electrostatic attraction/repulsion.
  
  Particles are also repelled from the mouse pointer
  whenever the left mouse button is pressed.
  
  Visual inspired by a Cody'sLab video:
  https://www.youtube.com/watch?v=XNCIp3fm7V0&t=310s
  
  Author: Karol Orszulik
  2021
*/

Particle[] particles;         // array for particles
final int numParticles = 200; // number of particles in simulation

final PVector gravity = new PVector(0, 0.1); // gravity vector

final float minsize = 1; // minimum and maximum size of particles
final float maxsize = 3; // chosen randomly for each particle

void setup() {
  size(800, 600); // create the window

  particles = new Particle[numParticles];      // create and populate the array of particles
  for (int i = 0; i < particles.length; i++) {
    particles[i] = new Particle(random(minsize, maxsize));
  }
}

void draw() {

  background(0); // clear the background

  for (Particle p : particles) {
    p.chargeForces(particles);          // apply charge forces
    p.applyForce(gravity.mult(p.size)); // gravity force proportional to mass
    p.update();                         // update kinematics
    p.show();                           // render to window
  }
  
  println(frameRate);
}
