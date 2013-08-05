var division = require('..');
var cluster = new division();

// Configuration for development environment
cluster.configure('development', function () {
  // Put your development configuration here

});

// Configuration for production environment
cluster.configure('production', function () {
  // Put your production configuration here

});

// Configuration for all environments
// TIP: this is pointing to cluster
cluster.configure(function () {
  this.set('path', 'server.js');
});

// You can also set settings without configuration block
cluster.set('size', 2);

// Start your application as a cluster!
cluster.run(function () {
  // `this` is the Master instance

});

