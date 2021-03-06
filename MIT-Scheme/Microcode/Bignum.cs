﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Microcode
{
    [Serializable]
    struct BignumDigit
    {
        const int BIGNUM_HALF_DIGIT_LENGTH = 31;
        const long BIGNUM_RADIX = 0x4000000000000000L;
        const long BIGNUM_RADIX_ROOT = 0x0000000080000000L;
        // A bignum digit is a positive integer 62 bits long.
        long bigit;

        public BignumDigit (int n)
        {
            if (n < 0)
                throw new NotImplementedException ();
            this.bigit = (long) n;
        }

        public BignumDigit (long n)
        {
            if (n < 0)
                throw new NotImplementedException ();
            this.bigit = n;
        }

        public BignumDigit (ulong n)
        {
            if (n >= 0x8000000000000000UL)
                throw new NotImplementedException ();
            this.bigit = (long) n;
        }

        public BignumDigit (long high, long low)
        {
            if ((high < 0)
                || (high >= 0x0000000080000000L)
            || (low < 0)
                || (low >= 0x0000000080000000L))
                throw new NotImplementedException ();
            this.bigit = (high << 31) + low;
        }

        static public explicit operator BignumDigit (int n)
        {
            return new BignumDigit (n);
        }

        static public explicit operator BignumDigit (long n)
        {
            return new BignumDigit (n);
        }

        static public explicit operator BignumDigit (ulong n)
        {
            return new BignumDigit (n);
        }

        public long ToLong ()
        {
            return this.bigit;
        }

        public override bool Equals (object other)
        {
            return this.ToLong () == ((BignumDigit) (other)).ToLong ();
        }

        public override int GetHashCode ()
        {
            return (this.ToLong ()).GetHashCode ();
        }

        static public bool operator > (BignumDigit left, int right)
        {
            return left.ToLong () > (long) right;
        }

        static public bool operator > (BignumDigit left, long right)
        {
            return left.ToLong () > right;
        }

        static public bool operator > (BignumDigit left, BignumDigit right)
        {
            return left.ToLong () > right.ToLong ();
        }

        static public bool operator >= (BignumDigit left, int right)
        {
            return left.ToLong () >= right;
        }


        static public bool operator >= (BignumDigit left, long right)
        {
            return left.ToLong () >= right;
        }

        static public bool operator >= (BignumDigit left, BignumDigit right)
        {
            return left.ToLong () >= right.ToLong ();
        }


        static public bool operator < (BignumDigit left, int right)
        {
            return left.ToLong () < (long) right;
        }

        static public bool operator < (BignumDigit left, long right)
        {
            return left.ToLong () < right;
        }

        static public bool operator < (BignumDigit left, BignumDigit right)
        {
            return left.ToLong () < right.ToLong ();
        }

        static public bool operator <= (BignumDigit left, int right)
        {
            return left.ToLong () <= (long) right;
        }

        static public bool operator <= (BignumDigit left, long right)
        {
            return left.ToLong () <= right;
        }

        static public bool operator <= (BignumDigit left, BignumDigit right)
        {
            return left.ToLong () <= right.ToLong ();
        }


        static public bool operator == (BignumDigit left, int right)
        {
            return left.ToLong () == (long) right;
        }

        static public bool operator == (BignumDigit left, long right)
        {
            return left.ToLong () == right;
        }

        static public bool operator == (BignumDigit left, BignumDigit right)
        {
            return left.ToLong () == right.ToLong ();
        }

        static public BignumDigit operator << (BignumDigit left, int right)
        {
            return new BignumDigit ((left.ToLong ()) << right);
        }

        static public BignumDigit operator >> (BignumDigit left, int right)
        {
            return new BignumDigit ((left.ToLong ()) >> right);
        }

        static public BignumDigit operator + (BignumDigit left, BignumDigit right)
        {
            return new BignumDigit (left.ToLong () + right.ToLong ());
        }

        static public BignumDigit operator + (BignumDigit left, long right)
        {
            return new BignumDigit (left.ToLong () + right);
        }



        static public BignumDigit operator + (BignumDigit left, int right)
        {
            return new BignumDigit (left.ToLong () + right);
        }


        static public BignumDigit operator * (BignumDigit left, BignumDigit right)
        {
            return new BignumDigit (left.ToLong () * right.ToLong ());
        }

        static public BignumDigit operator * (BignumDigit left, long right)
        {
            return new BignumDigit (left.ToLong () * right);
        }


        static public BignumDigit operator / (BignumDigit left, BignumDigit right)
        {
            return new BignumDigit (left.ToLong () / right.ToLong ());
        }

        static public long operator / (BignumDigit left, long right)
        {
            return left.ToLong () / right;
        }

        static public BignumDigit operator % (BignumDigit left, BignumDigit right)
        {
            return new BignumDigit (left.ToLong () % right.ToLong ());
        }

        static public long operator % (BignumDigit left, long right)
        {
            return left.ToLong () % right;
        }




        static public BignumDigit operator - (BignumDigit left, BignumDigit right)
        {
            return new BignumDigit (left.ToLong () - right.ToLong ());
        }

        static public BignumDigit operator - (BignumDigit left, long right)
        {
            return new BignumDigit (left.ToLong () - right);
        }



        static public BignumDigit operator & (BignumDigit left, BignumDigit right)
        {
            return new BignumDigit (left.ToLong () & right.ToLong ());
        }

        static public BignumDigit operator | (BignumDigit left, BignumDigit right)
        {
            return new BignumDigit (left.ToLong () | right.ToLong ());
        }


        static public bool operator != (BignumDigit left, int right)
        {
            return left.ToLong () != (long) right;
        }

        static public bool operator != (BignumDigit left, long right)
        {
            return left.ToLong () != right;
        }

        static public bool operator != (BignumDigit left, BignumDigit right)
        {
            return left.ToLong () != right.ToLong ();
        }

        public long Low
        {
            get
            {
                return this.bigit & 0x7FFFFFFF;
            }
        }

        public long High
        {
            get
            {
                return this.bigit >> 31;
            }
        }

        static long DivideSubtract (long v1, long v2, long guess, long [] u)
        {
            {
                BignumDigit product;
                long diff;
                long carry;
                //BDDS_MULSUB (v2, (u [2]), 0);
                {
                    product = (BignumDigit) (v2 * guess + 0);
                    diff = u [2] - product.Low;
                    if (diff < 0) {
                        u [2] = diff + BIGNUM_RADIX_ROOT;
                        carry = product.High + 1;
                    }
                    else {
                        u [2] = diff;
                        carry = product.High;
                    }
                }

                //BDDS_MULSUB (v1, (u [1]), carry);
                {
                    product = (BignumDigit) (v1 * guess + carry);
                    diff = u [1] - product.Low;
                    if (diff < 0) {
                        u [1] = diff + BIGNUM_RADIX_ROOT;
                        carry = product.High + 1;
                    }
                    else {
                        u [1] = diff;
                        carry = product.High;
                    }
                }
                if (carry == 0)
                    return guess;
                diff = ((u [0]) - carry);
                if (diff < 0)
                    (u [0]) = (diff + BIGNUM_RADIX);
                else {
                    (u [0]) = diff;
                    return guess;
                }
            }
            {
                long sum;
                long carry;
                // BDDS_ADD (v2, (u [2]), 0);
                {
                    sum = (v2 + u [2] + 0);
                    if (sum < BIGNUM_RADIX_ROOT) {
                        u [2] = sum;
                        carry = 0;
                    }
                    else {
                        u [2] = (sum - BIGNUM_RADIX_ROOT);
                        carry = 1;
                    }
                }

                //BDDS_ADD (v1, (u [1]), carry);
                {
                    sum = (v1 + u [1] + carry);
                    if (sum < BIGNUM_RADIX_ROOT) {
                        u [1] = sum;
                        carry = 0;
                    }
                    else {
                        u [1] = (sum - BIGNUM_RADIX_ROOT);
                        carry = 1;
                    }
                }

                if (carry == 1)
                    (u [0]) += 1;
            }
            return guess - 1;
        }

        public static BignumDigit Divide (BignumDigit uh, BignumDigit ul, BignumDigit v, out BignumDigit q)
        {
            long guess;
            BignumDigit comparand;
            long v1 = v.High; //(HD_HIGH (v));
            long v2 = v.Low; //(HD_LOW (v));
            long uj;
            BignumDigit uj_uj1;
            long q1;
            long q2;
            long [] u = new long [4];
            if (uh == 0) {
                if (ul < v) {
                    q = (BignumDigit) 0;
                    return ul;
                }
                else if (ul == v) {
                    q = (BignumDigit) 1;
                    return (BignumDigit) 0;
                }
            }
            (u [0]) = uh.High; // (HD_HIGH (uh));
            (u [1]) = uh.Low;  // (HD_LOW (uh));
            (u [2]) = ul.High; // (HD_HIGH (ul));
            (u [3]) = ul.Low;  // (HD_LOW (ul));
            v1 = v.High; // (HD_HIGH (v));
            v2 = v.Low; // (HD_LOW (v));
            //BDD_STEP (q1, 0);
            //#define BDD_STEP(qn, j)							
            {
                uj = (u [0]);
                if (uj != v1) {
                    uj_uj1 = new BignumDigit (uj, (u [0 + 1]));
                    guess = (uj_uj1 / v1);
                    comparand = new BignumDigit (uj_uj1 % v1, u [0 + 2]);
                }
                else {
                    guess = BIGNUM_RADIX_ROOT - 1;
                    comparand = new BignumDigit (u [0 + 1] + v1, u [0 + 2]);
                }
                while ((guess * v2) > comparand.ToLong ()) {
                    guess -= 1;
                    comparand += (v1 << BIGNUM_HALF_DIGIT_LENGTH);
                    if (comparand >= (BignumDigit) BIGNUM_RADIX)
                        break;
                }

                q1 = (DivideSubtract (v1, v2, guess, u));
            }
            {
                uj = (u [1]);
                if (uj != v1) {
                    uj_uj1 = new BignumDigit (uj, (u [1 + 1]));
                    guess = (uj_uj1 / v1);
                    comparand = new BignumDigit (uj_uj1 % v1, u [1 + 2]);
                }
                else {
                    guess = BIGNUM_RADIX_ROOT - 1;
                    comparand = new BignumDigit (u [1 + 1] + v1, u [1 + 2]);
                }
                while ((guess * v2) > comparand.ToLong ()) {
                    guess -= 1;
                    comparand += (v1 << BIGNUM_HALF_DIGIT_LENGTH);
                    if (comparand >= (BignumDigit) BIGNUM_RADIX)
                        break;
                }

                q2 = (DivideSubtract (v1, v2, guess, u));
            }
            //
            q = new BignumDigit (q1, q2); // (HD_CONS (q1, q2));
            return new BignumDigit (u [2], u [3]);
        }

    }

    enum bignum_comparison
    {
        equal,
        less,
        greater
    }

    [Serializable]
    sealed class Bignum
    {
        const int BIGNUM_DIGIT_LENGTH = 62; // (8 * 8) - 2;
        const int BIGNUM_HALF_DIGIT_LENGTH = 31; // BIGNUM_DIGIT_LENGTH / 2;
        //((long) 1) << BIGNUM_DIGIT_LENGTH;
        const long BIGNUM_RADIX = 0x4000000000000000L;
        // ((long) 1) << BIGNUM_HALF_DIGIT_LENGTH;
        const long BIGNUM_RADIX_ROOT = 0x0000000080000000L;
        const long BIGNUM_DIGIT_MASK = 0x3FFFFFFFFFFFFFFFL;
        const long BIGNUM_HALF_DIGIT_MASK = 0x000000007FFFFFFFL;
        const int BIGNUM_DIGITS_FOR_LONG = 2;

        bool sign;
        BignumDigit [] digits;

        static int BitsToDigits (int n)
        {
            return (n + BIGNUM_DIGIT_LENGTH - 1) / BIGNUM_DIGIT_LENGTH;
        }

        Bignum (bool sign, int ndigits)
        {
            this.sign = sign;
            this.digits = new BignumDigit [ndigits];
        }

        Bignum (bool sign, BignumDigit digit)
        {
            if (digit == 0)
            {
                this.digits = new BignumDigit [0];
            }
            else
            {
                this.sign = sign;
                this.digits = new BignumDigit [1];
                this.digits [0] = digit;
            }
        }

        static public explicit operator Bignum (int n)
        {
            bool sign = n < 0L;
            UInt64 magnitude = Misc.Abs64 (n);
            Bignum result;
            if (magnitude == 0)
            {
                result = new Bignum (false, 0);
            }
            else
            {
                result = new Bignum (sign, 1);
                result [0] = (BignumDigit) magnitude;
            }
            return result;
        }

        static public explicit operator Bignum (long n)
        {
            bool sign = n < 0L;
            UInt64 magnitude = Misc.Abs64 (n);
            Bignum result;
            if (magnitude == 0)
            {
                result = new Bignum (sign, 0);
            }
            else if (magnitude < BIGNUM_RADIX)
            {
                result = new Bignum (sign, 1);
                result [0] = (BignumDigit) magnitude;
            }
            else
            {
                result = new Bignum (sign, 2);
                result [0] = (BignumDigit) (magnitude & BIGNUM_DIGIT_MASK);
                result [1] = (BignumDigit) (magnitude >> BIGNUM_DIGIT_LENGTH);
            }
            return result;
        }

        static public explicit operator Bignum (ulong magnitude)
        {
            Bignum result;
            if (magnitude == 0)
            {
                result = new Bignum (false, 0);
            }
            else if (magnitude < BIGNUM_RADIX)
            {
                result = new Bignum (false, 1);
                result [0] = (BignumDigit) magnitude;
            }
            else
            {
                result = new Bignum (false, 2);
                result [0] = (BignumDigit) (magnitude & BIGNUM_DIGIT_MASK);
                result [1] = (BignumDigit) (magnitude >> BIGNUM_DIGIT_LENGTH);
            }
            return result;
        }

        static public Bignum operator * (Bignum left, Bignum right)
        {
            int left_length = left.Length;
            int right_length = right.Length;
            bool negative = left.IsNegative ? (!right.IsNegative) : right.IsNegative;
            if (left.IsZero)
                return left;
            if (right.IsZero)
                return right;
            if (left_length == 1)
            {
                long digit = left [0].ToLong ();
                if (digit == 1)
                    return right.MaybeNewSign (negative);
                if (digit < BIGNUM_RADIX_ROOT)
                    return MultiplyUnsignedSmallFactor (right, digit, negative);
            }
            if (right_length == 1)
            {
                long digit = right [0].ToLong ();
                if (digit == 1)
                    return left.MaybeNewSign (negative);
                if (digit < BIGNUM_RADIX_ROOT)
                    return MultiplyUnsignedSmallFactor (left, digit, negative);
            }
            return MultiplyUnsigned (left, right, negative);
        }

        static public object ToInteger (Bignum item)
        {
            if (item.Length == 0)
                return 0;
            else if (item.Length == 1)
            {
                long answer = item [0].ToLong ();
                if (item.IsNegative == true)
                    answer = -answer;
                if ((answer < Int32.MinValue) || (answer > Int32.MaxValue))
                    return answer;
                else
                    return (int) answer;
            }
            else
                return item;
        }

        public bool IsZero
        {
            get
            {
                return this.digits.Length == 0;
            }
        }

        public int Length
        {
            get
            {
                return this.digits.Length;
            }
        }

        public bool IsNegative
        {
            get
            {
                return this.sign == true;
            }
        }

        BignumDigit this [int index]
        {
            get
            {
                return this.digits [index];
            }

            set
            {
                this.digits [index] = value;
            }
        }

        public double ToDouble ()
        {
            if (this.IsZero)
                return 0.0;

            {
                int length = this.Length;
                int index = length - 1;
                int scale_words = length - 1;
                BignumDigit msd = this [index];

                int bits_to_get = 53; //DBL_MANT_DIG; /* includes implicit 1 */

                double value = 0;
                long mask = 0;
                long guard_bit_mask = BIGNUM_RADIX >> 1;
                long rounding_correction = 0;
                int current_digit_bit_count = 0;
                long w = msd.ToLong ();
                current_digit_bit_count = 0;

                while (w > 0xff)
                {
                    current_digit_bit_count += 8;
                    w >>= 8;
                }

                while (w > 0)
                {
                    current_digit_bit_count += 1;
                    w >>= 1;
                }

                mask = (1 << (current_digit_bit_count)) - 1;

                while (true)
                {
                    if (current_digit_bit_count > bits_to_get)
                    {
                        guard_bit_mask = (1 << (current_digit_bit_count - bits_to_get - 1));
                        mask &= ~((guard_bit_mask << 1) - 1);
                        current_digit_bit_count = bits_to_get;
                        bits_to_get = 0;
                    }
                    else
                    {
                        bits_to_get -= current_digit_bit_count;
                    }

                    value = (value * BIGNUM_RADIX) + (this [index].ToLong () & mask);

                    if (bits_to_get == 0)
                    {
                        scale_words = index;
                        if (current_digit_bit_count == BIGNUM_DIGIT_LENGTH)
                        {
                            if (index == 0) /* there is no guard bit */
                                goto finished;
                            guard_bit_mask = (1 << (BIGNUM_DIGIT_LENGTH - 1));
                            rounding_correction = 1;
                            index -= 1;
                        }
                        else
                        {
                            rounding_correction = (guard_bit_mask << 1);
                        }
                        break;
                    }
                    if (index == 0)  /* fewer than DBL_MANT_DIG bits */
                        goto finished;

                    index -= 1;
                    current_digit_bit_count = BIGNUM_DIGIT_LENGTH;
                    mask = BIGNUM_DIGIT_MASK;
                }

                /* round-to-even depending on lsb, guard and following bits: lgfffff */

                if ((this [index].ToLong () & guard_bit_mask) == 0) /* case x0xxxx */
                    goto round_down;

                if ((this [index].ToLong () & (guard_bit_mask - 1)) != 0) /* case x1xx1x */
                    goto round_up;

                /* cases 110000 and 1101xx: test "odd?", i.e. round-to-even rounds up */
                if ((guard_bit_mask << 1) == BIGNUM_RADIX)
                {
                    if ((this [index + 1].ToLong () & 1) != 0)  /* "odd?" */
                        goto round_up;
                }
                else
                {
                    if ((this [index].ToLong () & (guard_bit_mask << 1)) != 0)
                        goto round_up;
                }

                if (index == 0)   /* case 010000, no more words of following bits */
                    goto finished;

                { /* distinguish between cases 0100...00 and 0100..1xx, multiple words */
                    int index2 = index - 1;
                    while (index2 >= 0)
                    {
                        if (this [index] != 0)
                            goto round_up;
                        index2--;
                    }
                    goto round_down;
                }

            round_up:
                value += rounding_correction;
            round_down:
                /* note, ldexp `sticks' at the maximal non-infinity value, which
                   is a reasonable compromise for numbers with DBL_MAX_EXP bits
                   that round up */
                if (scale_words > 0)
                    value = FloatArithmetic.LdExp (value, scale_words * BIGNUM_DIGIT_LENGTH);

            finished:
                return (this.IsNegative ? (-value) : value);
            }

        }

        static public Bignum Multiply (Bignum left, Bignum right)
        {
            int x_length = left.Length;
            int y_length = right.Length;
            bool negative_p = left.IsNegative ? (!right.IsNegative) : right.IsNegative;
            if (left.IsZero)
                return left;
            if (right.IsZero)
                return right;
            if (x_length == 1)
            {
                long digit = left [0].ToLong ();
                if (digit == 1)
                    return right.MaybeNewSign (negative_p);
                if (digit < BIGNUM_RADIX_ROOT)
                    return MultiplyUnsignedSmallFactor (right, digit, negative_p);
            }
            if (y_length == 1)
            {
                long digit = right [0].ToLong ();
                if (digit == 1)
                    return left.MaybeNewSign (negative_p);
                if (digit < BIGNUM_RADIX_ROOT)
                    return MultiplyUnsignedSmallFactor (left, digit, negative_p);
            }

            return MultiplyUnsigned (left, right, negative_p);
        }

        static Bignum MultiplyUnsignedSmallFactor (Bignum old, long digit, bool sign)
        {
            int length_x = old.Length;
            Bignum p = new Bignum (sign, length_x + 1);
            old.DestructiveCopy (p);
            p [length_x] = (BignumDigit) 0L;
            bignum_destructive_scale_up (p, digit);
            return p.Trim ();
        }

        static void bignum_destructive_scale_up (Bignum bignum, long factor)
        {
            BignumDigit carry = (BignumDigit) 0L;
            int scan = 0;
            BignumDigit two_digits;
            BignumDigit product_low;
            int end = bignum.Length;

            while (scan < end)
            {
                two_digits = bignum [scan];
                product_low = (BignumDigit) ((factor * two_digits.Low) + carry.Low);
                carry = (BignumDigit) ((factor * two_digits.High) + product_low.High + carry.High);
                bignum [scan++] = new BignumDigit (carry.Low, product_low.Low);
                carry = (BignumDigit) (carry.High);
            }
            return;
        }

        static Bignum MultiplyUnsigned (Bignum x, Bignum y, bool negative)
        {
            if (y.Length > x.Length)
            {
                Bignum z = x;
                x = y;
                y = z;
            }
            BignumDigit carry;
            BignumDigit y_digit;
            long y_digit_low;
            long y_digit_high;
            BignumDigit x_digit;
            long x_digit_low;
            long x_digit_high;
            BignumDigit product_low;
            BignumDigit product_high;
            int scan_r;
            int scan_y;
            int x_length = x.Length;
            int y_length = y.Length;
            Bignum r = new Bignum (negative, x_length + y_length);
            int scan_x = 0;
            int end_x = x_length;
            int start_y = 0;
            int end_y = y_length;
            int start_r = 0;
            while (scan_x < end_x)
            {
                x_digit = x [scan_x++];
                x_digit_low = x_digit.Low;
                x_digit_high = x_digit.High;
                carry = (BignumDigit) 0L;
                scan_y = start_y;
                scan_r = start_r++;
                while (scan_y < end_y)
                {
                    y_digit = y [scan_y++];
                    y_digit_low = y_digit.Low;
                    y_digit_high = y_digit.High;
                    product_low = (BignumDigit) (r [scan_r].ToLong () +
                                  (x_digit_low * y_digit_low) +
                                  carry.Low);
                    product_high = (BignumDigit) ((x_digit_high * y_digit_low) +
                                   (x_digit_low * y_digit_high) +
                                   product_low.High +
                                   carry.High);
                    r [scan_r++] = new BignumDigit (product_high.Low, product_low.Low);
                    carry = (BignumDigit) ((x_digit_high * y_digit_high) +
                            product_high.High);
                }
                r [scan_r] = (BignumDigit) (r [scan_r].ToLong () + carry.ToLong ());
            }
            return r.Trim ();
        }

        static public bool operator > (Bignum left, Bignum right)
        {
            if (left.IsNegative) {
                if (right.IsNegative) {
                    throw new NotImplementedException ();
                }
                return false;
            }
            else if (right.IsNegative) {
                return true;
            }
            else
                return bignum_compare_unsigned (left, right) == bignum_comparison.greater;
        }

        static public bool operator < (Bignum left, Bignum right)
        {
            if (left.IsNegative) {
                if (right.IsNegative) {
                    throw new NotImplementedException ();
                }
                return true;
            }
            else if (right.IsNegative) {
                return false;
            }
            else
                return bignum_compare_unsigned (left, right) == bignum_comparison.less;
        }

        // Note, bignums must be normalized (no leading zeros in representation)
        static bignum_comparison bignum_compare_unsigned (Bignum left, Bignum right)
        {
            int left_length = left.Length;
            int right_length = right.Length;
            if (left_length < right_length)
                return bignum_comparison.less;
            if (left_length > right_length)
                return bignum_comparison.greater;
            int scan_left = left_length;
            int scan_right = right_length;
            while (0 < scan_left)
            {
                BignumDigit digit_left = left [--scan_left];
                BignumDigit digit_right = right [--scan_right];
                if (digit_left < digit_right)
                    return bignum_comparison.less;
                if (digit_left > digit_right)
                    return bignum_comparison.greater;
            }
            return bignum_comparison.equal;
        }

        static public Bignum Quotient (Bignum numerator, Bignum denominator)
        {
            if (denominator.IsZero)
                throw new NotImplementedException ();
            else if (numerator.IsZero)
                return numerator;
            else
            {
                bool q_negative_p = denominator.IsNegative ? (!numerator.IsNegative) : numerator.IsNegative;
                switch (bignum_compare_unsigned (numerator, denominator))
                {

                    case bignum_comparison.equal:
                        return (Bignum) (q_negative_p ? -1 : 1);

                    case bignum_comparison.less:
                        return (Bignum) (0);

                    case bignum_comparison.greater:
                        {
                            Bignum quotient;
                            Bignum remainder;
                            if (denominator.Length == 1)
                            {
                                BignumDigit digit = denominator [0];
                                if (digit == 1)
                                    return numerator.MaybeNewSign (q_negative_p);
                                else if (digit < BIGNUM_RADIX_ROOT)
                                    bignum_divide_unsigned_small_denominator (numerator, digit, out quotient, out remainder, q_negative_p, false);
                                else
                                    bignum_divide_unsigned_medium_denominator (numerator, digit, out quotient, out remainder, q_negative_p, false);
                            }
                            else
                                bignum_divide_unsigned_large_denominator (numerator, denominator, out quotient, out remainder, q_negative_p, false);

                            return quotient;
                        }

                    default:
                        throw new NotImplementedException ();
                }
            }
        }

        static void bignum_divide_unsigned_small_denominator (Bignum numerator, BignumDigit denominator, out Bignum quotient, out Bignum remainder, bool qsign, bool rsign)
        {
            Bignum q = numerator.NewSign (qsign);
            BignumDigit r = q.DestructiveScaleDown (denominator);
            quotient = q.Trim ();
            remainder = new Bignum (rsign, r);
        }

        static void bignum_divide_unsigned_medium_denominator (Bignum numerator, BignumDigit denominator, out Bignum quotient, out Bignum remainder, bool qsign, bool rsign)
        {
            throw new NotImplementedException ();
        }

        static void bignum_divide_unsigned_large_denominator (Bignum numerator, Bignum denominator, out Bignum quotient, out Bignum remainder, bool qsign, bool rsign)
        {
            int length_n = numerator.Length + 1;
            int length_d = denominator.Length;
            Bignum q = new Bignum (qsign, length_n - length_d);
            Bignum u = new Bignum (rsign, length_n);

            int shift = 0;
            if (!(length_d > 1)) throw new NotImplementedException ();

            {
                BignumDigit v1 = denominator[length_d - 1];
                while (v1 < (BIGNUM_RADIX / 2)) {
                    v1 <<= 1;
                    shift += 1;
                }
            }
            if (shift == 0) {
                numerator.DestructiveCopy (u); // bignum_destructive_copy (numerator, u);
                u [length_n - 1] = (BignumDigit) 0; // (BIGNUM_REF (u, (length_n - 1))) = 0;
                throw new NotImplementedException ();
                // bignum_divide_unsigned_normalized (u, denominator, q);
            }
            else {
                Bignum v = new Bignum (false, length_d); // (bignum_allocate (length_d, 0));
                numerator.DestructiveNormalization (u, shift);   //bignum_destructive_normalization (numerator, u, shift);
                denominator.DestructiveNormalization (v, shift); //bignum_destructive_normalization (denominator, v, shift);
                bignum_divide_unsigned_normalized (u, v, q);
                //bignum_divide_unsigned_normalized (u, v, q);
                //BIGNUM_DEALLOCATE (v);
                //if (remainder != ((bignum_type*) 0))
                //    bignum_destructive_unnormalization (u, shift);
            }
                quotient = q.Trim ();// (bignum_trim (q));
                remainder = u.Trim(); //(bignum_trim (u));
            //else
            //    BIGNUM_DEALLOCATE (u);
            return;
        }

        void DestructiveNormalization (Bignum target, int shift_left)
        {
            BignumDigit digit;
            int scan_source = 0;
            BignumDigit carry = (BignumDigit) 0;
            int scan_target = 0;
            int end_source = this.Length;
            int end_target = target.Length;
            int shift_right = (BIGNUM_DIGIT_LENGTH - shift_left);
            BignumDigit mask = (BignumDigit) ((1UL << shift_right) - 1UL);
            while (scan_source < end_source) {
                digit = this[scan_source++];
                target [scan_target++] = (((digit & mask) << shift_left) | carry);
                carry = (digit >> shift_right);
            }
            if (scan_target < end_target)
                target [scan_target] = carry;
            else if (carry != 0)
                throw new NotImplementedException ();
            else
                return;
        }

static void bignum_divide_unsigned_normalized (Bignum u, Bignum v, Bignum q)
{
  int u_length = u.Length; //(BIGNUM_LENGTH (u));
  int v_length = v.Length; // (BIGNUM_LENGTH (v));
  int u_start = 0; // (BIGNUM_START_PTR (u));
  int u_scan = (u_start + u_length);
  int u_scan_limit = (u_start + v_length);
  int u_scan_start = (u_scan - v_length);
  int v_start = 0; // (BIGNUM_START_PTR (v));
  int v_end = (v_start + v_length);
  int q_scan = 0;
  BignumDigit v1 = v[v_end -1];
  BignumDigit v2 = v[v_end -2];
  BignumDigit ph;	/* high half of double-digit product */
  BignumDigit pl;	/* low half of double-digit product */
  BignumDigit guess;
  long gh;	/* high half-digit of guess */
  BignumDigit ch;	/* high half of double-digit comparand */
  long v2l = v2.Low; //(HD_LOW (v2));
  long v2h = v2.High; // (HD_HIGH (v2));
  BignumDigit cl;	/* low half of double-digit comparand */

  BignumDigit gm;		/* memory loc for reference parameter */
  //if (q != BIGNUM_OUT_OF_BAND)
  //  q_scan = ((BIGNUM_START_PTR (q)) + (BIGNUM_LENGTH (q)));
  q_scan = 0 + q.Length;
  while (u_scan_limit < u_scan)
    {
      pl = u [--u_scan] ; //uj = (*--u_scan);
      if (pl != v1)
	{
	  /* comparand =
	     (((((uj * BIGNUM_RADIX) + uj1) % v1) * BIGNUM_RADIX) + uj2);
	     guess = (((uj * BIGNUM_RADIX) + uj1) / v1); */
	  cl = u[u_scan -2];
	  ch = BignumDigit.Divide (pl, u[u_scan -1], v1, out gm);
	  guess = gm;
	}
      else
	{
	  cl = u [u_scan-2];
	  ch = u [u_scan-1] + v1;
	  guess = new BignumDigit (BIGNUM_RADIX - 1);
	}
//#define gl ph			/* low half-digit of guess */
//#define uj pl
//#define qj ph
      while (true)
	{
	  /* product = (guess * v2); */
	  ph = (BignumDigit) (guess.Low); // gl = (HD_LOW (guess));
	  gh = guess.High; // (HD_HIGH (guess));
      pl = ph * v2l;
	  ph = ((BignumDigit)(v2l * gh) + (ph * v2h) + (BignumDigit)(pl.High));
	  pl = new BignumDigit (ph.Low, pl.Low); // (HD_CONS ((HD_LOW (ph)), (HD_LOW (pl))));
	  ph = ((BignumDigit)(v2h * gh) + ph.High);
	  /* if (comparand >= product) */
	  if ((ch > ph) || ((ch == ph) && (cl >= pl)))
	    break;
	  guess -= 1;
	  /* comparand += (v1 << BIGNUM_DIGIT_LENGTH) */
	  ch += v1;
	  /* if (comparand >= (BIGNUM_RADIX * BIGNUM_RADIX)) */
	  if (ch >= BIGNUM_RADIX)
	    break;
	}
      
      ph = (bignum_divide_subtract (v, v_start, v_end, guess, u, (--u_scan_start)));
      q [--q_scan] = ph; // (*--q_scan) = qj;
	
    }
  return;
//#undef gl
//#undef uj
//#undef qj
}

static BignumDigit bignum_divide_subtract (Bignum v, int v_start, int v_end, BignumDigit guess, Bignum u, int u_start)
{
  int v_scan = v_start;
  int u_scan = u_start;
  BignumDigit carry = (BignumDigit)0;
  if (guess == 0) return (BignumDigit)0;
  {
    long gl = guess.Low; //(HD_LOW (guess));
    long gh = guess.High; //(HD_HIGH (guess));
    BignumDigit vx;
    BignumDigit pl;
    BignumDigit vl;
//#define vh vx
//#define ph carry
//#define diff pl
    while (v_scan < v_end)
      {
	vx = v[v_scan++];
	vl = (BignumDigit)(vx.Low); //(HD_LOW (v));
	vx = (BignumDigit)(vx.High); // (HD_HIGH (v));
	pl = ((vl * gl) + carry.Low);
	carry = ((vl * gh) + (vx * gl) + pl.High + carry.High);
	pl = u[u_scan] - new BignumDigit (carry.Low, pl.Low); //(HD_CONS ((HD_LOW (ph)), (HD_LOW (pl)))));
	if (pl < 0)
	  {
	    u[u_scan++] = pl + (BignumDigit)(BIGNUM_RADIX);
	    carry = ((vx * gh) + carry.High + 1);
	  }
	else
	  {
	    u[u_scan++] = carry;
	    carry = ((vx * gh) + carry.High);
	  }
      }
    if (carry == 0)
      return (guess);
    pl = u[u_scan] - carry;
    if (pl < 0)
      u[u_scan] = (pl + BIGNUM_RADIX);
    else
      {
	u[u_scan] = pl;
	return (guess);
      }
//#undef vh
//#undef diff
  }
  /* Subtraction generated carry, implying guess is one too large.
     Add v back in to bring it back down. */
  v_scan = v_start;
  u_scan = u_start;
  carry = (BignumDigit) 0;
  while (v_scan < v_end)
    {
      BignumDigit sum = (v[v_scan++] + u[u_scan] + carry);
      if (sum < BIGNUM_RADIX)
	{
	  u[u_scan++] = sum;
	  carry = (BignumDigit)0;
	}
      else
	{
	  u[u_scan++] = (sum - BIGNUM_RADIX);
	  carry = (BignumDigit) 1;
	}
    }
  if (carry == 1)
    {
      BignumDigit sum = (u[u_scan] + carry);
      u[u_scan] = ((sum < BIGNUM_RADIX) ? sum : (sum - BIGNUM_RADIX));
    }
  return (guess - 1);
}


        BignumDigit DestructiveScaleDown (BignumDigit denominator)
        {
            BignumDigit numerator;
            BignumDigit remainder = (BignumDigit) 0L;
            BignumDigit twoDigits;
            int start = 0;
            int scan = start + this.Length;

            while (start < scan)
            {
                twoDigits = this [--scan];
                numerator = new BignumDigit (remainder.ToLong (), twoDigits.High);
                remainder = (BignumDigit) (numerator.ToLong () / denominator.ToLong ());
                numerator = new BignumDigit (numerator.ToLong () % denominator.ToLong (), twoDigits.Low);
                this [scan] = new BignumDigit (remainder.ToLong (), numerator.ToLong () / denominator.ToLong ());
                remainder = (BignumDigit) (numerator.ToLong () % denominator.ToLong ());
            }
            return remainder;
        }

        Bignum RemainderUnsignedSmallDenominator (Bignum d, bool sign)
        {
            throw new NotImplementedException ();
        }

        Bignum Trim ()
        {
            int last_digit = this.Length;
            while (this [last_digit - 1].ToLong () == 0)
            {
                last_digit -= 1;
            }
            if (last_digit < this.Length)
            {
                BignumDigit [] new_digits = new BignumDigit [last_digit];
                for (int i = 0; i < last_digit; i++)
                {
                    new_digits [i] = this [i];
                }
                this.digits = new_digits;
            }
            return this;
        }

        Bignum Copy ()
        {
            Bignum target = new Bignum (this.IsNegative, this.Length);
            this.DestructiveCopy (target);
            return target;
        }

        Bignum NewSign (bool sign)
        {
            Bignum result = new Bignum (sign, this.Length);
            this.DestructiveCopy (result);
            return result;
        }

        Bignum MaybeNewSign (bool sign)
        {
            if (this.IsNegative ? sign : (!sign))
                return this;

            Bignum answer = new Bignum (sign, this.Length);
            this.DestructiveCopy (answer);
            return answer;
        }

        void DestructiveCopy (Bignum target)
        {
            for (int i = 0; i < this.Length; i++)
                target [i] = this [i];
        }

        [SchemePrimitive ("BIGNUM?", 1, true)]
        public static bool IsBignum (out object answer, object arg)
        {
            answer = arg is Bignum;
            return false;
        }
    }
}
