# Changelog

All notable changes to this project will be documented in this file. See [commit-and-tag-version](https://github.com/absolute-version/commit-and-tag-version) for commit guidelines.

## 1.24.0 (2025-08-29)


### ⚠ BREAKING CHANGES

* change package name to blackops_legacy

* change package name to blackops_legacy ([5476920](https://github.com/TimefoldAI/timefold-solver-python/commit/54769201a0857f5271a55d5d2fa6541ff5e0e2e9))


### Features

* Add expand, concat, consecutive collector, collectAndThen collector ([#5](https://github.com/TimefoldAI/timefold-solver-python/issues/5)) ([632a092](https://github.com/TimefoldAI/timefold-solver-python/commit/632a092cfe9552ca759e99faf6c7e14fbf8e5387))
* Add file and line numbers to exception traceback ([#28](https://github.com/TimefoldAI/timefold-solver-python/issues/28)) ([850ff44](https://github.com/TimefoldAI/timefold-solver-python/commit/850ff443f21a7fbf880ccb6132f9187153e2a268))
* Add parse methods to all score implementations ([#77](https://github.com/TimefoldAI/timefold-solver-python/issues/77)) ([3942327](https://github.com/TimefoldAI/timefold-solver-python/commit/3942327a8da5ae7aa504e929f5219fd545a0f6d8))
* Add SolverConfigOverride support ([#36](https://github.com/TimefoldAI/timefold-solver-python/issues/36)) ([ba56c9a](https://github.com/TimefoldAI/timefold-solver-python/commit/ba56c9a219c50146ada188d6e76c635964aaba29))
* Add strptime and strftime to datetime classes ([#101](https://github.com/TimefoldAI/timefold-solver-python/issues/101)) ([81bbd40](https://github.com/TimefoldAI/timefold-solver-python/commit/81bbd40020cdb0192debd9a8d0d9fca69d2bfc51))
* Add support for as_constraint, remove deprecated methods, move types to subpackages ([#30](https://github.com/TimefoldAI/timefold-solver-python/issues/30)) ([eee0950](https://github.com/TimefoldAI/timefold-solver-python/commit/eee0950e359b04e9d0df3eff5f7b4c3161dfee0a))
* Add support for ConstraintConfiguration ([#37](https://github.com/TimefoldAI/timefold-solver-python/issues/37)) ([244e1d9](https://github.com/TimefoldAI/timefold-solver-python/commit/244e1d98d6f2c149aca089cf5b63c25ea194dea2))
* Add support for custom justifications ([#39](https://github.com/TimefoldAI/timefold-solver-python/issues/39)) ([45132a1](https://github.com/TimefoldAI/timefold-solver-python/commit/45132a12fa2c4322ea8e747dfbc2ee5e31708914))
* add support for Decimal and Decimal score types ([#110](https://github.com/TimefoldAI/timefold-solver-python/issues/110)) ([1c7d902](https://github.com/TimefoldAI/timefold-solver-python/commit/1c7d9022eef416b10b7ce9eb1fb59674fba5ee5e))
* Add support for enterprise edition and multithreaded solving ([#31](https://github.com/TimefoldAI/timefold-solver-python/issues/31)) ([158aca7](https://github.com/TimefoldAI/timefold-solver-python/commit/158aca77357952d929a4ad21700d7bde2d15e856))
* add support for fairness constraints ([#94](https://github.com/TimefoldAI/timefold-solver-python/issues/94)) ([e1dac95](https://github.com/TimefoldAI/timefold-solver-python/commit/e1dac9548cc5f7ba5386886bbf6498f42b9ce8ab))
* Add support for nearby selection ([#32](https://github.com/TimefoldAI/timefold-solver-python/issues/32)) ([30a13b9](https://github.com/TimefoldAI/timefold-solver-python/commit/30a13b982291cf4b59057f3a8c8c8650c2ba078a))
* Add support for problem changes ([#34](https://github.com/TimefoldAI/timefold-solver-python/issues/34)) ([fb72d9c](https://github.com/TimefoldAI/timefold-solver-python/commit/fb72d9c13cf1f07bb02b75440ca89f3fe4fa16a0))
* Add support for Python 3.12 ([#27](https://github.com/TimefoldAI/timefold-solver-python/issues/27)) ([5f4c79d](https://github.com/TimefoldAI/timefold-solver-python/commit/5f4c79dc7a5181eae8658bdd3d2c6b74aa3f2c23)), closes [/github.com/python/cpython/blob/17a82a1d16a46b6c008240bcc698619419ce5554/Python/bytecodes.c#L2289-L2293](https://github.com/TimefoldAI//github.com/python/cpython/blob/17a82a1d16a46b6c008240bcc698619419ce5554/Python/bytecodes.c/issues/L2289-L2293)
* Allow jpyinterpreter to create annotations on classes, fields and methods ([#21](https://github.com/TimefoldAI/timefold-solver-python/issues/21)) ([5fd92c8](https://github.com/TimefoldAI/timefold-solver-python/commit/5fd92c86ca41a7669edfb966437369ff7a4d4b2b))
* Improve ScoreAnalysis debug information ([#105](https://github.com/TimefoldAI/timefold-solver-python/issues/105)) ([4396e2d](https://github.com/TimefoldAI/timefold-solver-python/commit/4396e2da06d7ba204c1b98afcf2f92094e6c92f0))
* Support custom indictments and fully implement the ScoreExplanation and ScoreAnalysis API ([#38](https://github.com/TimefoldAI/timefold-solver-python/issues/38)) ([d0a5811](https://github.com/TimefoldAI/timefold-solver-python/commit/d0a5811449cfdc092eadb9630e485c609997ca6b))


### Bug Fixes

* Allow Constraint Streams to be used as parameters to join ([47fe2fe](https://github.com/TimefoldAI/timefold-solver-python/commit/47fe2fef54cf288746e9cf011a078cb583c8592c))
* Build 999-SNAPSHOT of upstream before running script ([#47](https://github.com/TimefoldAI/timefold-solver-python/issues/47)) ([8922fe3](https://github.com/TimefoldAI/timefold-solver-python/commit/8922fe36784a1353e8f2927a0aa84d8d51a078b9))
* Build quickly so update-child-modules work ([#50](https://github.com/TimefoldAI/timefold-solver-python/issues/50)) ([5b65cf7](https://github.com/TimefoldAI/timefold-solver-python/commit/5b65cf7adce80aa91200ba553e31090eb9398645))
* Case handling in byte and bytearray methods, converting unicode to ascii array ([#80](https://github.com/TimefoldAI/timefold-solver-python/issues/80)) ([c87d1b4](https://github.com/TimefoldAI/timefold-solver-python/commit/c87d1b4cabb7bf045f976e34cc1d76473f75d97a))
* Generate getters/setters that replace null with None (or vice versa) ([#29](https://github.com/TimefoldAI/timefold-solver-python/issues/29)) ([d6ad7a1](https://github.com/TimefoldAI/timefold-solver-python/commit/d6ad7a164dfaba540435a6ee95386570b79bae15))
* Load globals that are subclasses or instances of a class being compiled lazily ([#67](https://github.com/TimefoldAI/timefold-solver-python/issues/67)) ([a573b12](https://github.com/TimefoldAI/timefold-solver-python/commit/a573b1208e34d98ac70625937bd9a5e2b8a41914))
* Stack effect for Python 3.11+ with, ignore missing forward references in type hints, copy extra and function attributes ([#68](https://github.com/TimefoldAI/timefold-solver-python/issues/68)) ([03dd634](https://github.com/TimefoldAI/timefold-solver-python/commit/03dd634359dbd4169dca50fe9693c05a7a8a1b37))
* type in change_versions.sh script ([#48](https://github.com/TimefoldAI/timefold-solver-python/issues/48)) ([69b6547](https://github.com/TimefoldAI/timefold-solver-python/commit/69b654783ffc7509697dbfa323a561063c3cbe43))
* Use `mvn:versions:update-child-modules` ([#49](https://github.com/TimefoldAI/timefold-solver-python/issues/49)) ([e1dddf5](https://github.com/TimefoldAI/timefold-solver-python/commit/e1dddf54c900ee2d6af61f6d84e78f43bc26deb9))
* use coverage:paths to rewrite paths in coverage files ([#62](https://github.com/TimefoldAI/timefold-solver-python/issues/62)) ([deb60d1](https://github.com/TimefoldAI/timefold-solver-python/commit/deb60d12e2535fa436085fd3dab16e2bb68248ef))
* Use daemon threads for SolverManager  ([#69](https://github.com/TimefoldAI/timefold-solver-python/issues/69)) ([57ac260](https://github.com/TimefoldAI/timefold-solver-python/commit/57ac2601c5f66bd153dab8af2cd90eafc5219ed4))
* Use new license file name ([#55](https://github.com/TimefoldAI/timefold-solver-python/issues/55)) ([94b7b9a](https://github.com/TimefoldAI/timefold-solver-python/commit/94b7b9a8c7f420709dd838b7a0fa0104f21e8804))
* Use Python object for Score, handle descriptor correctly, do not copy parent fields ([#66](https://github.com/TimefoldAI/timefold-solver-python/issues/66)) ([dc5fc78](https://github.com/TimefoldAI/timefold-solver-python/commit/dc5fc78cfe328f9630d977339feb610e8a5fc3b2))
