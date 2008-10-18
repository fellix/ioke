/*
 * See LICENSE file in distribution for copyright and licensing information.
 */
package ioke.lang.mixins;

import ioke.lang.Runtime;
import ioke.lang.IokeObject;
import ioke.lang.JavaMethod;
import ioke.lang.Context;
import ioke.lang.Number;

import ioke.lang.exceptions.ControlFlow;

/**
 *
 * @author <a href="mailto:ola.bini@gmail.com">Ola Bini</a>
 */
public class Comparing extends IokeObject {
    public Comparing(Runtime runtime, String documentation) {
        super(runtime, documentation);
    }

    public void init() {
        registerMethod(runtime.newJavaMethod("return true if the receiver is less than the argument, otherwise false", new JavaMethod("<") {
                @Override
                public IokeObject activate(IokeObject method, IokeObject context, IokeObject message, IokeObject on) throws ControlFlow {
                    IokeObject arg = message.getEvaluatedArgument(0, context);
                    Number num = (Number)runtime.spaceShip.sendTo(context, on, arg).convertToNumber(message, context).data;
                    return (num.asJavaInteger() < 0 ? runtime._true : runtime._false);
                }
            }));

        registerMethod(runtime.newJavaMethod("return true if the receiver is less than or equal to the argument, otherwise false", new JavaMethod("<=") {
                @Override
                public IokeObject activate(IokeObject method, IokeObject context, IokeObject message, IokeObject on) throws ControlFlow {
                    IokeObject arg = message.getEvaluatedArgument(0, context);
                    Number num = (Number)runtime.spaceShip.sendTo(context, on, arg).convertToNumber(message, context).data;
                    return (num.asJavaInteger() <= 0 ? runtime._true : runtime._false);
                }
            }));

        registerMethod(runtime.newJavaMethod("return true if the receiver is greater than the argument, otherwise false", new JavaMethod(">") {
                @Override
                public IokeObject activate(IokeObject method, IokeObject context, IokeObject message, IokeObject on) throws ControlFlow {
                    IokeObject arg = message.getEvaluatedArgument(0, context);
                    Number num = (Number)runtime.spaceShip.sendTo(context, on, arg).convertToNumber(message, context).data;
                    return (num.asJavaInteger() > 0 ? runtime._true : runtime._false);
                }
            }));

        registerMethod(runtime.newJavaMethod("return true if the receiver is greater than or equal to the argument, otherwise false", new JavaMethod(">=") {
                @Override
                public IokeObject activate(IokeObject method, IokeObject context, IokeObject message, IokeObject on) throws ControlFlow {
                    IokeObject arg = message.getEvaluatedArgument(0, context);
                    Number num = (Number)runtime.spaceShip.sendTo(context, on, arg).convertToNumber(message, context).data;
                    return (num.asJavaInteger() >= 0 ? runtime._true : runtime._false);
                }
            }));

        registerMethod(runtime.newJavaMethod("return true if the receiver is equal to the argument, otherwise false", new JavaMethod("==") {
                @Override
                public IokeObject activate(IokeObject method, IokeObject context, IokeObject message, IokeObject on) throws ControlFlow {
                    IokeObject arg = message.getEvaluatedArgument(0, context);
                    Number num = (Number)runtime.spaceShip.sendTo(context, on, arg).convertToNumber(message, context).data;
                    return (num.asJavaInteger() == 0 ? runtime._true : runtime._false);
                }
            }));

        registerMethod(runtime.newJavaMethod("return true if the receiver is not equal to the argument, otherwise false", new JavaMethod("!=") {
                @Override
                public IokeObject activate(IokeObject method, IokeObject context, IokeObject message, IokeObject on) throws ControlFlow {
                    IokeObject arg = message.getEvaluatedArgument(0, context);
                    Number num = (Number)runtime.spaceShip.sendTo(context, on, arg).convertToNumber(message, context).data;
                    return (num.asJavaInteger() != 0 ? runtime._true : runtime._false);
                }
            }));
    }

    public String toString() {
        return "Comparing";
    }
}// Comparing
