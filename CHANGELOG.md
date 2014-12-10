CHANGELOG
=========
This project is using [Semantic Versioning 2.0.0](http://semver.org/)

1.0.0
-----

After successfully running **division** on production over one year - version 1.0.0. has been finally released.

#### Fixes
 *  Improve handling with broken workers. Now `master` will stop his work when a many `workers` has been killed in 5 minutes since last incident.
    **NOTE:** This change could be incompatible for some applications, but most of them probably will not even notice.
 *  Remove all listeners from process instance, that was added by `master` process.

#### Other
 *  Make number of allowed `workers` suicides to be configurable (defaults to 30).
 *  Add more unit tests.
 *  Implement code coverage.
 *  Implement code linter.
 *  Move documentation to separate file (API.md).

0.4.5
-----

#### Fixes
 *  Fix error with writing error messages when `debug` extension was not enabled.

#### Other
 *  Some code cleanup.
 *  Finished version of documentation.

0.4.4
-----

#### Fixes
 *  Fix error 'IPC channel is already disconnected' in test suite.

#### Other
 *  Update part of documentation.

0.4.3
-----

#### Fixes
 *  Fix test suite for Travis CI.

#### Other
 *  Increase threshold for fast exiting workers.
 *  Changed `npm test` reporter to more readable.

0.4.2
-----

#### Fixes
 *  Fix inconsistency of workers count when calling `increase` and `decrease` in short time period.
 *  Fix bug with resolving paths in `watch` extension.

#### Other
 *  Decrease delay of spawning new workers when previous one exited.
 *  Add new test cases for `watch` extension.

0.4.1
-----

#### Fixes
 *  Fixed next case when program crashed with many **division** instances runs at once.

0.4.0
-----

#### Features
 *  New extension - `watch`.

#### Fixes
 *  Fixed bug with `debug` extension, which crash application when could not read properties of dead worker.
 *  Fixed bug with `use` method, which crash system when cannot find extension to be required.
 *  Fixed bug with `close` in Worker, which not always killing disconnected process.
 *  Fixed bug when many **division** instances runs in one process.

#### Other
 *  Added this file (CHANGELOG.md).
 *  Added basic test suite and Travis CI support.
 *  Removed dependency of grunt in favor of CoffeeScript (Cakefile).

0.3.0
-----

#### Features
 *  New extension - `debug`.

#### Fixes
 *  Fixed `decrease` method, which don't working overall.

#### Other
 *  Listed public attributes and methods in README.md.

0.2.0
-----

#### Features
 *  Added ability to use extensions.
 *  New extension - `signals`.

0.1.0
-----

Initial version.

