/*
 * See LICENSE file in distribution for copyright and licensing information.
 */
package ioke.lang;

/**
 *
 * @author <a href="mailto:ola.bini@gmail.com">Ola Bini</a>
 */
public class Rescue {
    public static void init(IokeObject obj) {
        Runtime runtime = obj.runtime;
        obj.setKind("Rescue");
    }
}// Rescue
