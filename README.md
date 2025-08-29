# BlackOps Solver (Legacy)

[BlackOps](https://github.com/BlackOpsAI/blackops-solver-legacy)

[![PyPI](https://img.shields.io/pypi/v/blackops-legacy?style=for-the-badge& "PyPI")](https://pypi.org/project/blackops-legacy)
[![Python support](https://img.shields.io/badge/Python-3.10+-brightgreen.svg?style=for-the-badge)](https://www.python.org/downloads)
[![License](https://img.shields.io/github/license/BlackOpsAI/blackops-solver-legacy?style=for-the-badge&logo=apache)](https://www.apache.org/licenses/LICENSE-2.0)

### Powered by:

![Timefold Logo](https://raw.githubusercontent.com/TimefoldAI/timefold-solver/main/docs/src/modules/ROOT/images/shared/timefold-logo.png)

_Planning optimization made easy_: [timefold.ai](https://timefold.ai)

BlackOps Solver is a 100% Timefold 1.24.0 compatible AI constraint solver you can use to optimize
the Vehicle Routing Problem, Employee Rostering, Maintenance Scheduling, Task Assignment, School Timetabling,
Cloud Optimization, Conference Scheduling, Job Shop Scheduling and many more planning problems with Python.

Using [Timefold Solver in Python](https://github.com/TimefoldAI/timefold-solver-python) used to be significantly slower than using [Timefold Solver for Java or Kotlin](https://github.com/TimefoldAI/timefold-solver).

Therefore, the official Timefold Python solver has been [discontinued](https://github.com/TimefoldAI/timefold-solver/discussions/1698#discussioncomment-13842196) and the Timefold team is focusing on the Java and Kotlin solvers.

BlackOps Solver is committed to three core goals:

- **Performance:** We are optimizing quickstart examples and have already achieved significant speedups by removing bottlenecks (for example, pydantic now validates only at the API boundary, not during solving). See our latest [benchmark results](https://github.com/BlackOpsAI/blackops-quickstarts-python/tree/main/benchmarks/report.md) for reference.

- **Sustained Support:** This fork offers ongoing community support—issues and bugs will be addressed — but _we will not track every new Timefold release_. Our baseline remains version 1.24.0.

- **Next-Generation Architecture:** In the meantime, we are developing a fully native Rust backend to deliver a new 100% API-compatible Python solver. This approach eliminates JPype overhead and connects directly to the Timefold JVM via JNI for maximum performance and efficiency.

## Get started with BlackOps Solver

* [Clone BlackOps Solver](https://github.com/BlackOpsAI/blackops-solver-legacy): `git clone https://github.com/BlackOpsAI/blackops-solver-legacy.git`

* Navigate to the `quickstarts` directory and choose a quickstart: `cd blackops-solver/quickstarts/hello-world`

## Requirements

- [Install Python 3.10, 3.11 or 3.12.](https://www.python.org)
- [Install JDK 17 or later](https://adoptium.net) with the environment variable `JAVA_HOME` configured to the JDK installation directory.
  For example, with [Sdkman](https://sdkman.io/):
  ```shell
  $ sdk install java
  ```

## Build from source

1. Install the repo
   ```shell
   $ pip install git+https://github.com/BlackOpsAI/blackops-solver-legacy.git
   ```

## Source code overview

### Domain

In Timefold Solver, the domain has three parts:

- Problem Facts, which do not change.
- Planning Entities, which have one or more planning variables.
- Planning Solution, which define the facts and entities of the problem.

#### Problem Facts

Problem facts can be any Python class, which are used to describe unchanging facts in your problem:

```python
from dataclasses import dataclass
from datetime import time

@dataclass
class Timeslot:
    id: int
    day_of_week: str
    start_time: time
    end_time: time
```

#### Planning Entities

To declare Planning Entities, use the `@planning_entity` decorator along with annotations:

```python
from dataclasses import dataclass, field
from typing import Annotated
from blackops_legacy.solver.domain import planning_entity, PlanningId, PlanningVariable

@planning_entity
@dataclass
class Lesson:
    id: Annotated[int, PlanningId]
    subject: str
    teacher: str
    student_group: str
    timeslot: Annotated[Timeslot, PlanningVariable] = field(default=None)
    room: Annotated[Room, PlanningVariable] = field(default=None)
```

- The `PlanningVariable` annotation is used to mark what fields the solver is allowed to change.

- The `PlanningId` annotation is used to uniquely identify an entity object of a particular class. The same Planning Id can be used on entities of different classes, but the ids of all entities in the same class must be different.

#### Planning Solution

To declare the Planning Solution, use the `@planning_solution` decorator:

```python
from dataclasses import dataclass, field
from typing import Annotated
from blackops_legacy.solver.domain import (planning_solution, ProblemFactCollectionProperty, ValueRangeProvider,
                                    PlanningEntityCollectionProperty, PlanningScore)
from blackops_legacy.solver.score import HardSoftScore

@planning_solution
@dataclass
class TimeTable:
    timeslots: Annotated[list[Timeslot], ProblemFactCollectionProperty, ValueRangeProvider]
    rooms: Annotated[list[Room], ProblemFactCollectionProperty, ValueRangeProvider]
    lessons: Annotated[list[Lesson], PlanningEntityCollectionProperty]
    score: Annotated[HardSoftScore, PlanningScore] = field(default=None)
```

- The `ValueRangeProvider` annotation is used to denote a field that contains possible planning values for a `PlanningVariable`.

- The`ProblemFactCollection` annotation is used to denote a field that contains problem facts. This allows these facts to be queried in your constraints.

- The `PlanningEntityCollection` annotation is used to denote a field that contains planning entities. The planning variables of these entities will be modified during solving.

- The `PlanningScore` annotation is used to denote the field that holds the score of the current solution. The solver will set this field during solving.

### Constraints

You define your constraints by using the ConstraintFactory:

```python
from domain import Lesson
from blackops_legacy.solver.score import (Joiners, HardSoftScore, ConstraintFactory,
                                   Constraint, constraint_provider)

@constraint_provider
def define_constraints(constraint_factory: ConstraintFactory) -> list[Constraint]:
    return [
        # Hard constraints
        room_conflict(constraint_factory),
        # Other constraints here...
    ]

def room_conflict(constraint_factory: ConstraintFactory) -> Constraint:
    # A room can accommodate at most one lesson at the same time.
    return (
        constraint_factory.for_each_unique_pair(Lesson,
                # ... in the same timeslot ...
                Joiners.equal(lambda lesson: lesson.timeslot),
                # ... in the same room ...
                Joiners.equal(lambda lesson: lesson.room))
            .penalize(HardSoftScore.ONE_HARD)
            .as_constraint("Room conflict")
    )
```

Also see [Timefold Solver Documentation on Constraint Streams](https://github.com/TimefoldAI/timefold-solver/blob/1.24.x/docs/src/modules/ROOT/pages/constraints-and-score/score-calculation.adoc).

### Solve

```python
from blackops_legacy.solver import SolverFactory
from blackops_legacy.solver.config import SolverConfig, TerminationConfig, ScoreDirectorFactoryConfig, Duration
from constraints import define_constraints
from domain import TimeTable, Lesson, generate_problem

solver_config = SolverConfig(
    solution_class=TimeTable,
    entity_class_list=[Lesson],
    score_director_factory_config=ScoreDirectorFactoryConfig(
        constraint_provider_function=define_constraints
    ),
    termination_config=TerminationConfig(
        spent_limit=Duration(seconds=30)
    )
)

solver = SolverFactory.create(solver_config).build_solver()
solution = solver.solve(generate_problem())
```

`solution` will be a `TimeTable` instance with planning
variables set to the final best solution found.

For a full API spec, visit [the Timefold Documentation](https://github.com/TimefoldAI/timefold-solver/blob/1.24.x/docs/src/modules/ROOT/pages/introduction.adoc).

## Legal notice

BlackOps Solver was forked on 03 August 2025 from Timefold's Python Solver, which was entirely Apache-2.0 licensed (a permissive license).

The original Timefold Python Solver was [forked](https://timefold.ai/blog/2023/optaplanner-fork/) on 20 April 2023 from OptaPlanner and OptaPy.

BlackOps Solver  is a derivative work of the Timefold Python Solver and OptaPy, which includes copyrights of the original creators, Timefold AI, Red Hat Inc., affiliates, and contributors, that were all entirely licensed under the Apache-2.0 license.
Every source file has been modified.
