﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Microcode
{
    static class IntegerArithmetic
    {
        static object Narrow (long arg)
        {
            if ((arg > Int32.MaxValue) || (arg < Int32.MinValue))
                return arg;
            else
                return (int) arg;
        }

        static object Narrow (Decimal arg)
        {
            if ((arg > Int32.MaxValue) || (arg < Int32.MinValue))
            {
                if ((arg > Int64.MaxValue) || (arg < Int64.MinValue))
                    return arg;
                else
                    return (long) arg;
            }
            else
                return (int) arg;
        }

        static long Widen (object arg)
        {
            if (arg is int)
                return (long) (int) arg;
            else if (arg is long)
                return (long) arg;
            else 
                throw new NotImplementedException ();
        }

        [SchemePrimitive ("INTEGER-ZERO?", 1, false)]
        public static bool ZeroP (out object answer, object arg)
        {
            if (arg is int)
                answer = (int) (arg) == 0;
            else if (arg is long)
                answer = (long) (arg) == 0;
            else if (arg is Bignum)
                answer = (Bignum) arg == 0;
            else
                throw new NotImplementedException ();
            return false;
        }

        [SchemePrimitive ("INTEGER-NEGATIVE?", 1, false)]
        public static bool NegativeP (out object answer, object arg)
        {
            if (arg is int)
                answer = (int) (arg) < 0;
            else if (arg is long)
                answer = (long) (arg) < 0;
            else
                throw new NotImplementedException ();
            return false;
        }

        [SchemePrimitive ("INTEGER-POSITIVE?", 1, false)]
        public static bool PositiveP (out object answer, object arg)
        {
            if (arg is int)
                answer = (int) (arg) > 0;
            else if (arg is long)
                answer = (long) (arg) > 0;
            else
                throw new NotImplementedException ();
            return false;
        }

        [SchemePrimitive ("INTEGER-EQUAL?", 2, false)]
        public static bool EqualP (out object answer, object left, object right)
        {
            if (left is int) {
                if (right is int)
                    answer = (int) left == (int) right;
                else if (right is long)
                    answer = (int) left == (long) right;
                else
                    throw new NotImplementedException ();
            }
            else if (left is long) {
                if (right is int)
                    throw new NotImplementedException ();
                else if (right is long)
                    answer = (long) left == (long) right;
                else
                    throw new NotImplementedException ();
            }
            else if (left is Bignum) {
                if (right is Bignum)
                    answer = (Bignum) left == (Bignum) right;
                else
                    throw new NotImplementedException ();
            }
            // kludge
            else if (left is History && right is History)
                answer =  ((History) left).Element == ((History) right).Element;
            else
                throw new NotImplementedException ();

            return false;
        }

        [SchemePrimitive ("INTEGER-LESS?", 2, false)]
        public static bool LessP (out object answer, object left, object right)
        {
            if (left is int) {
                if (right is int)
                    answer = (int) left < (int) (right);
                else if (right is long)
                    answer = (int) left < (long) right;
                else
                    throw new NotImplementedException ();
            }
            else if (left is long) {
                if (right is int)
                    answer = (long) left < (int) right;
                else if (right is long)
                    answer = (long) left < (long) right;
                else
                    throw new NotImplementedException ();
            }
            else if (left is Bignum) {
                if (right is int)
                    answer = (Bignum) left < (Bignum) (int) right;
                else if (right is long)
                    answer = (Bignum) left < (Bignum) (long) right;
                else if (right is Bignum)
                    answer = (Bignum) left < (Bignum) right;
                else
                    throw new NotImplementedException ();
            }
            else
                throw new NotImplementedException ();
            return false;
        }

        [SchemePrimitive ("INTEGER-GREATER?", 2, false)]
        public static bool GreaterP (out object answer, object left, object right)
        {
            if (left is int) {
                if (right is int)
                    answer = (int) left > (int) right;
                else if (right is long)
                    answer = (int) left > (long) right;
                else if (right is Bignum)
                    answer = (int) left > (Bignum) right;
                else
                    throw new NotImplementedException ();
            }
            else if (left is long) {
                if (right is long)
                    answer = (long) left > (long) right;
                else if (right is Bignum)
                    answer = (long) left > (Bignum) right;
                else
                    throw new NotImplementedException ();
            }
            else if (left is Bignum) {
                if (right is int)
                    answer = (Bignum) left > (Bignum) (int) right;
                else if (right is long)
                    answer = (Bignum) left > (Bignum) (long) right;
                else if (right is Bignum)
                    answer = (Bignum) left > (Bignum) right;
                else
                    throw new NotImplementedException ();
            }
            else
                throw new NotImplementedException ();
            return false;
        }

        [SchemePrimitive ("INTEGER-ADD", 2, false)]
        public static bool Add (out object answer, object left, object right)
        {
            if (left is int) {
                if (right is int)
                    answer = Narrow ((long) (int) left + (long) (int) (right));
                else
                    throw new NotImplementedException ();
            }
            else if (left is long) {
                if (right is int)
                    answer = Narrow ((long) left + (long) (int) (right));
                else if (right is long)
                    answer = Narrow ((long) left + (long) (right));
                else
                    throw new NotImplementedException ();
            }
            else if (left is Bignum) {
                if (right is int)
                    answer = Bignum.ToInteger ((Bignum) left + (int) right);
                else
                    throw new NotImplementedException ();
            }
            else
                throw new NotImplementedException ();
            return false;
        }

        [SchemePrimitive ("INTEGER-SUBTRACT", 2, false)]
        public static bool Subtract (out object answer, object left, object right)
        {
            if (left is int) {
                if (right is int)
                    answer = Narrow ((long) (int) left - (long) (int) right);
                else if (right is long)
                    answer = Narrow ((long) (int) left - (long) right);
                else
                    throw new NotImplementedException ();
            }
            else if (left is long) {
                if (right is int)
                    answer = Narrow ((long) left - (long) (int) right);
                else if (right is long)
                    answer = Narrow ((long) left - (long) right);
                else
                    throw new NotImplementedException ();
            }
            else if (left is Bignum) {
                if (right is int)
                    answer = Bignum.ToInteger ((Bignum) left - (int) right);
                else if (right is long)
                    answer = Bignum.ToInteger ((Bignum) left - (long) right);
                else if (right is Bignum)
                    answer = Bignum.ToInteger ((Bignum) left - (Bignum) right);
                else
                    throw new NotImplementedException ();
            }
            else
                throw new NotImplementedException ();
            return false;
        }

        [SchemePrimitive ("INTEGER-MULTIPLY", 2, false)]
        public static bool Multiply (out object answer, object left, object right)
        {
            if (left is int) {
                if (right is int)
                    answer = Narrow (Widen (left) * Widen (right));
                else if (right is long)
                    answer = Bignum.ToInteger ((Bignum) (long) (int) left * (Bignum) (long) (right));
                else if (right is Bignum)
                    answer = Bignum.ToInteger ((Bignum) (long) (int) left * (Bignum) (right));
                else
                    throw new NotImplementedException ();
            }
            else if (left is long) {
                if (right is int)
                    answer = Bignum.ToInteger ((Bignum) (long) (left) * (Bignum) (long) (int) (right));
                else if (right is long)
                    answer = Bignum.ToInteger ((Bignum) (long) (left) * (Bignum) (long) (right));
                else if (right is Bignum)
                    answer = Bignum.ToInteger ((Bignum) (long) (left) * (Bignum) (right));
                else
                    throw new NotImplementedException ();
            }
            else if (left is Bignum) {
                if (right is int)
                    answer = Bignum.ToInteger ((Bignum) (left) * (Bignum) (int) (right));
                else if (right is long)
                    answer = Bignum.ToInteger ((Bignum) (left) * (Bignum) (long) (right));
                else if (right is Bignum)
                    answer = Bignum.ToInteger ((Bignum) (left) * (Bignum) (right));
                else
                    throw new NotImplementedException ();
            }
            else
                throw new NotImplementedException ();
            return false;
        }

        [SchemePrimitive ("INTEGER-NEGATE", 1, false)]
        public static bool Negate (out object answer, object arg)
        {
            if (arg is int)
                answer = -((int) arg);
            else
                throw new NotImplementedException ();
            return false;
        }

        [SchemePrimitive ("INTEGER-ADD-1", 1, false)]
        public static bool Add1 (out object answer, object arg)
        {
            if (arg is int)
                answer = (Narrow (((long) (int) (arg)) + 1));
            else {
                answer = null;
                throw new NotImplementedException ();
            }
            return false;
        }

        [SchemePrimitive ("INTEGER-SUBTRACT-1", 1, false)]
        public static bool Subtract1 (out object answer, object arg)
        {
            if (arg is int)
                answer = (Narrow (((long) (int) (arg)) - 1));
            else if (arg is long)
                answer = (Narrow (((long) (arg)) - 1L));
            else {
                answer = null;
                throw new NotImplementedException ();
            }
            return false;
        }

        //public static PartialResult LengthInBits (object arg)
        //{
        //    throw new NotImplementedException ();
        //}

        [SchemePrimitive ("INTEGER-DIVIDE", 2, false)]
        public static bool Divide (out object answer, object left, object right)
        {
            if (left is Bignum) {
                if (right is int) {
                    Bignum remainder;
                    Bignum q = Bignum.DivRem ((Bignum) left, (Bignum) (long) (int) right, out remainder);
                    answer = new Cons (Bignum.ToInteger (q), Bignum.ToInteger (remainder));
                    return false;
                }
                else if (right is long) {
                    Bignum remainder;
                    Bignum q = Bignum.DivRem ((Bignum) left, (Bignum) (long) right, out remainder);
                    answer = new Cons (Bignum.ToInteger (q), Bignum.ToInteger (remainder));
                    return false;
                }
                if (right is Bignum) {
                    Bignum remainder;
                    Bignum q = Bignum.DivRem ((Bignum) left, (Bignum) right, out remainder);
                    answer = new Cons (Bignum.ToInteger (q), Bignum.ToInteger (remainder));
                    return false;
                }
                else
                    throw new NotImplementedException ("Divide bignum by non-bignum.");
            }
            else {
                long w0 = Widen (left);
                long w1 = Widen (right);
                long remainder = 0;
                long quotient = Math.DivRem (w0, w1, out remainder);

                answer = new Cons (Narrow (quotient), Narrow (remainder));
                return false;
            }
        }

        [SchemePrimitive ("INTEGER-QUOTIENT", 2, false)]
        public static bool Quotient (out object answer, object left, object right)
        {
            if (left is int) {
                if (right is int)
                    answer = (int) (left) / (int) (right);
                else
                    throw new NotImplementedException ();
            }
            else if (left is long) {
                if (right is int)
                    answer = Narrow ((long) (left) / (long) (int) (right));
                else if (right is long)
                    answer = Narrow ((long) (left) / (long) (right));
                else
                    throw new NotImplementedException ();

            }
            else if (left is Bignum) {
                if (right is int)
                    answer = Bignum.ToInteger ((Bignum) left / (Bignum) (long) (int) right);
                else if (right is long)
                    answer = Bignum.ToInteger ((Bignum) left / (Bignum) (long) right);
                else
                    throw new NotImplementedException ();
            }
            else
                throw new NotImplementedException ();
            return false;
        }

        [SchemePrimitive ("INTEGER-REMAINDER", 2, false)]
        public static bool Remainder (out object answer, object left, object right)
        {
            if (left is int) {
                if (right is int) {
                    long remainder;
                    Math.DivRem ((long) (int) (left), (long) (int) (right), out remainder);
                    answer = Narrow (remainder);
                }
                else if (right is long) {
                    long remainder;
                    Math.DivRem ((long) (int) (left), (long) (right), out remainder);
                    answer = Narrow (remainder);
                }
                else {
                    throw new NotImplementedException ();
                }
            }
            else if (left is long) {
                if (right is int) {
                    long remainder;
                    Math.DivRem ((long) (left), (long) (int) (right), out remainder);
                    answer = Narrow (remainder);
                }
                else if (right is long) {
                    long remainder;
                    Math.DivRem ((long) (left), (long) (right), out remainder);
                    answer = Narrow (remainder);
                }
                else
                    throw new NotImplementedException ();
            }
            else
                throw new NotImplementedException ();
            return false;
        }

        //[SchemePrimitive ("INTEGER?", 1, false)]
        //public static PartialResult IsInteger (object arg)
        //{
        //    if (arg is int)
        //        return new PartialResult (true);
        //    else
        //        throw new NotImplementedException ();
        //}

        [SchemePrimitive ("INTEGER->FLONUM", 2, false)]
        public static bool ToFlonum (out object answer, object left, object right)
        {
            if (left is int)
                answer = (double) (int) left;
            else if (left is long)
                answer = (double) (long) left;
            else if (left is Bignum)
                answer = (double) ((Bignum) left);
            else
                throw new NotImplementedException ();
            return false;
        }

        [SchemePrimitive ("INTEGER-SHIFT-LEFT", 2, false)]
        public static bool ShiftLeft (out object answer, object left, object right)
        {
            answer = Narrow (Widen (left) << (int) right);
            return false;
        }
    }
}
