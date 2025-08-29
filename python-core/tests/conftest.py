import blackops_legacy.solver


def pytest_addoption(parser):
    """
    Allows adding command line options to pytest
    """
    parser.addoption("--jacoco-agent", action="store", default="")
    parser.addoption("--jacoco-output", action="store", default="target/jacoco.exec")
    parser.addoption("--output-generated-classes", action="store", default="false")


def pytest_sessionstart(session):
    """
    Called after the Session object has been created and
    before performing collection and entering the run test loop.
    """
    import pathlib
    import sys

    jacoco_agent = session.config.getoption("--jacoco-agent")
    if jacoco_agent != "":
        jacoco_output = session.config.getoption("--jacoco-output")
        blackops_legacy.solver.init(
            f"-javaagent:{jacoco_agent}=destfile={jacoco_output}"
        )
    else:
        blackops_legacy.solver.init()

    if session.config.getoption("--output-generated-classes") != "false":
        blackops_legacy.solver.set_class_output_directory(
            pathlib.Path(
                "target",
                "tox-generated-classes",
                "python",
                f"{sys.version_info[0]}.{sys.version_info[1]}",
            )
        )
