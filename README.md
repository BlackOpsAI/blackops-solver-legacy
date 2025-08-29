# BlackOps Solver

_Legacy constraint solver for optimization problems._
[BlackOps](https://github.com/blackops-solver/blackops-solver-legacy)

[![PyPI](https://img.shields.io/pypi/v/blackops_legacy?style=for-the-badge& "PyPI")](https://pypi.org/project/blackops_legacy/)
[![Python support](https://img.shields.io/badge/Python-3.10+-brightgreen.svg?style=for-the-badge)](https://www.python.org/downloads)
[![License](https://img.shields.io/github/license/blackops-solver/blackops-solver-legacy?style=for-the-badge&logo=apache)](https://www.apache.org/licenses/LICENSE-2.0)

BlackOps Solver is an AI constraint solver you can use to optimize
the Vehicle Routing Problem, Employee Rostering, Maintenance Scheduling, Task Assignment, School Timetabling,
Cloud Optimization, Conference Scheduling, Job Shop Scheduling and many more planning problems.

Using BlackOps Solver in Python is significantly slower
than using the original Java constraint solver implementations.

## Get started with BlackOps Solver in Python

* [Clone BlackOps Solver repository](https://github.com/blackops-solver/blackops-solver-legacy): `git clone https://github.com/blackops-solver/blackops-solver-legacy.git`

* Navigate to the project directory: `cd blackops-solver-legacy`

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
   $ pip install git+https://github.com/blackops-solver/blackops-solver-legacy.git
   ```

## Source code overview

### Domain

In BlackOps Solver, the domain has three parts:

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

This is based on constraint streams from the original Timefold Solver implementation.

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

This is a legacy version of a constraint solver based on the Timefold architecture.

## Legal notice

BlackOps Solver is a derivative work of Timefold Solver, OptaPlanner and OptaPy,
which includes copyrights of the original creators, Red Hat Inc., TimefoldAI, affiliates, and contributors,
that were all entirely licensed under the Apache-2.0 license.
This is a legacy version with modified package structure.
