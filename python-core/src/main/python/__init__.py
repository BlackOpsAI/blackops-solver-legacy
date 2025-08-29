"""
`Timefold Solver <https://solver.timefold.ai/>`_ is a lightweight,
embeddable constraint satisfaction engine which optimizes planning problems.

It solves use cases such as:

 - Employee shift rostering: timetabling nurses, repairmen, ...

 - Vehicle routing: planning vehicle routes for moving freight and/or passengers through
   multiple destinations using known mapping tools ...

 - Agenda scheduling: scheduling meetings, appointments, maintenance jobs, advertisements, ...


Planning problems are defined using Python classes and functions.

Examples
--------
>>> from blackops_legacy.solver import Solver, SolverFactory
>>> from blackops_legacy.solver.config import (SolverConfig, ScoreDirectorFactoryConfig,
...                                     TerminationConfig, Duration)
>>> from domain import Timetable, Lesson, generate_problem
>>> from constraints import my_constraints
...
>>> solver_config = SolverConfig(solution_class=Timetable, entity_class_list=[Lesson],
...                              score_director_factory_config=ScoreDirectorFactoryConfig(
...                                  constraint_provider_function=my_constraints
...                                  ),
...                              termination_config=TerminationConfig(
...                                  spent_limit=Duration(seconds=30))
...                              )
>>> solver = SolverFactory.create(solver_config).build_solver()
>>> problem = generate_problem()
>>> solution = solver.solve(problem)

See Also
--------
:mod:`blackops_legacy.solver.config`
:mod:`blackops_legacy.solver.domain`
:mod:`blackops_legacy.solver.score`
:mod:`blackops_legacy.solver.test`
"""
from ._problem_change import *
from ._solution_manager import *
from ._solver import *
from ._solver_factory import *
from ._solver_manager import *

import blackops_legacy.solver.config as config
import blackops_legacy.solver.domain as domain
import blackops_legacy.solver.heuristic as heuristic
import blackops_legacy.solver.score as score
import blackops_legacy.solver.test as test

from ._blackops_java_interop import init, set_class_output_directory
