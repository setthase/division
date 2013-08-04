division
========

Another wrapper for node.js cluster API

# Usage
More examples you can find in `examples` directory.

### Standard configuratuion example

```javascript
var division = require('division');
var cluster = new division();

// Configuration for development environment
cluster.configure('development', function () {
  cluster.set('args', ['--some-process-args', 'send-to-workers']);
});

// Configuration for production environment
cluster.configure('production', function () {
  cluster.enable('silent');
});

// Configuration for all environments
// TIP: this is pointing to cluster
cluster.configure(function () {
  this.set('path', 'app.js');
});

// You can also set settings without configuration block
cluster.set('size', 2);

// Start your application as a cluster!
cluster.run();
```

You can set environment while launching application - in this way:

```
NODE_ENV=production node cluster.js
```

### Minimum configuration example

```javascript
var division = require('division');
var cluster = new division();

// You can chain methods
cluster.set('path', 'app.js').run();
```

### Micro configuration (one liner!)

```javascript
(new (require('division'))).set('path', 'app.js').run();
```

# API Reference

... comming soon ...
