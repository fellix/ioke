/*
 * See LICENSE file in distribution for copyright and licensing information.
 */
package ioke.lang.exceptions;

import ioke.lang.IokeObject;

/**
 *
 * @author <a href="mailto:ola.bini@gmail.com">Ola Bini</a>
 */
public class NoSuchCellException extends IokeException {
    public NoSuchCellException(String name, IokeObject on) {
        super("Couldn't find slot " + name + " on " + on);
    }
}// NoSuchCellException
