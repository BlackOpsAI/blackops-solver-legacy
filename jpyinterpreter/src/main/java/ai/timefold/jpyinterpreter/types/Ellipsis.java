package ai.timefold.jpyinterpreter.types;

import ai.timefold.jpyinterpreter.builtins.GlobalBuiltins;

public class Ellipsis extends AbstractPythonLikeObject {
    public static final Ellipsis INSTANCE;
    public static final PythonLikeType ELLIPSIS_TYPE = new PythonLikeType("EllipsisType", Ellipsis.class);
    public static final PythonLikeType $TYPE = ELLIPSIS_TYPE;

    static {
        INSTANCE = new Ellipsis();

        GlobalBuiltins.addBuiltinConstant("Ellipsis", INSTANCE);
    }

    private Ellipsis() {
        super(ELLIPSIS_TYPE);
    }

    @Override
    public String toString() {
        return "NotImplemented";
    }
}
