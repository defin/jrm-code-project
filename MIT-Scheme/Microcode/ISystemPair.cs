﻿
using System;
using System.Collections.Generic;

namespace Microcode
{
    public interface ISystemPair
    {
        object SystemPairCar
        {
            get;
            set;
        }

        object SystemPairCdr
        {
            get;
            set;
        }
    }

    static class SystemPair
    {
        [SchemePrimitive ("SYSTEM-PAIR-CONS", 3, false)]
        public static bool SystemPairCons (out object answer, object acode, object car, object cdr)
        {
            TC typeCode = (TC) (int) acode; // for debugging porpoises

            switch ((TC) acode) {
                case TC.ACCESS:
                    answer = new Access (car, (string) cdr);
                    break;

                case TC.ASSIGNMENT:
                    answer = new Assignment (car, cdr);
                    break;

                case TC.COMBINATION_1:
                    answer = Combination1.Make (car, cdr);
                    break;

                case TC.COMMENT:
                    answer = new Comment (car, cdr);
                    break;

                case TC.DEFINITION:
                    answer = new Definition (car, cdr);
                    break;

                case TC.DISJUNCTION:
                    answer = Disjunction.Make (car, cdr);
                    break;

                case TC.ENTITY:
                    answer = new Entity (car, cdr);
                    break;

                case TC.LAMBDA:
                    // passed in backwards.
                    object [] names = (object []) cdr;
                    object [] formals = new object [names.Length - 1];
                    Array.Copy (names, 1, formals, 0, formals.Length);
                    answer = Lambda.Make (names[0], formals, car);
                    break;

                case TC.PCOMB1:
                    answer = PrimitiveCombination1.Make ((Primitive1) car, cdr);
                    break;

                case TC.PROCEDURE:
                    answer = ((Lambda) car).Close ((cdr is bool && (bool) cdr == false) ? Environment.Global : (Environment) cdr);
                    break;

                case TC.RATNUM:
                    answer = new Ratnum (car, cdr);
                    break;

                case TC.SEQUENCE_2:
                    answer = Sequence2.Make (car, cdr);
                    break;

                case TC.UNINTERNED_SYMBOL:
                    // What gives?  Uninterned strings are squirrely on the CLR.
                    // We put them in a class object to have more control.
                    answer = new UninternedSymbol (new String ((char []) car));
                    break;

                case TC.WEAK_CONS:
                    answer = new WeakCons (car, cdr);
                    break;

                default:
                    throw new NotImplementedException ();
            }
            return false;
        }

        [SchemePrimitive ("SYSTEM-PAIR-CAR", 1, false)]
        public static bool SystemPairCar (out object answer, object arg)
        {
            ISystemPair systemPair = arg as ISystemPair;
            if (systemPair != null)
                answer = systemPair.SystemPairCar;
            else {
                // special case strings to act like symbols
                // with a print varname in the system pair car.
                string sarg = arg as string;
                if (sarg == null)
                    throw new NotImplementedException ();
                else
                    answer = sarg.ToCharArray ();
            }
            return false;
        }

        [SchemePrimitive ("SYSTEM-PAIR-CDR", 1, false)]
        public static bool SystemPairCdr (out object answer, object arg)
        {
            ISystemPair systemPair = arg as ISystemPair;
            if (systemPair == null)
                throw new NotImplementedException ();
            else {
                answer = systemPair.SystemPairCdr;
                return false;
            }
        }

        [SchemePrimitive ("SYSTEM-PAIR-SET-CAR!", 2, false)]
        public static bool SystemPairSetCar (out object answer, object arg, object newValue)
        {
            ISystemPair systemPair = arg as ISystemPair;
            answer = systemPair.SystemPairCar;
            systemPair.SystemPairCar = newValue;
            return false;
        }

        [SchemePrimitive ("SYSTEM-PAIR-SET-CDR!", 2, false)]
        public static bool SystemPairSetCdr (out object answer, object arg, object newValue)
        {
            ISystemPair systemPair = arg as ISystemPair;
            answer = systemPair.SystemPairCdr;
            systemPair.SystemPairCdr = newValue;
            return false;
        }
    }
}
