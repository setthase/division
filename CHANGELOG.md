CHANGELOG
=========
This project is using [Semantic Versioning 2.0.0](http://semver.org/)

0.4.2
-----

#### Fixes
 *  Fix inconsistency of workers count when calling `increase` and `decrease` in short time period
 *  Fix bug with resolving paths in `watch` extension

#### Other
 *  Decrease delay of spawning new workers when previous one exited
 *  Add new test cases for `watch` extension

0.4.1
-----

#### Fixes
 *  Fixed next case when program crashed with many **division** instances runs at once

0.4.0
-----

#### Features
 *  New extension - `watch`

#### Fixes
 *  Fixed bug with `debug` extension, which crash application when could not read properties of dead worker
 *  Fixed bug with `use` method, which crash system when cannot find extension to be required
 *  Fixed bug with `close` in Worker, which not always killing disconnected process
 *  Fixed bug when many **division** instances runs in one process

#### Other
 *  Added this file (CHANGELOG.md)
 *  Added basic test suite and Travis CI support
 *  Removed dependency of grunt in favour of CoffeeScript (Cakefile)

0.3.0
-----

#### Features
 *  New extension - `debug`

#### Fixes
 *  Fixed `decrease` method, which don't working overall

#### Other
 *  Listed public attributes and methods in README.md

0.2.0
-----

#### Features
 *  Added ability to use extensions
 *  New extension - `signals`

0.1.0
-----
Initial version
