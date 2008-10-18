/*
 * See LICENSE file in distribution for copyright and licensing information.
 */
package ioke.lang;

/**
 *
 * @author <a href="mailto:ola.bini@gmail.com">Ola Bini</a>
 */
public class Base {
    public static void init(IokeObject base) {
        base.setKind("Base");
        base.registerMethod(base.runtime.newJavaMethod("will return a new derivation of the receiving object. Might throw exceptions if the object is an oddball object.", 
                                                       new JavaMethod("mimic") {
                                                           @Override
                                                           public IokeObject activate(IokeObject method, IokeObject context, IokeObject message, IokeObject on) {
                                                               IokeObject clone = on.allocateCopy(message, context);
                                                               clone.mimics(on);
                                                               return clone;
                                                           }}));
    }
}// Base
