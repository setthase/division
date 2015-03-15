var division = require('..');
var _cluster_ = require('cluster');
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
  this.set('path', './noop.js');
});

// You can also set settings without configuration block
cluster.set('size', 2);

// Use extensions
cluster.use('debug');
cluster.use('signals');
cluster.use('watch', [__dirname], { ignored : ['src'] });

// Start your application as a cluster!
cluster.run(function () {
  // `this` is the Master instance

});
