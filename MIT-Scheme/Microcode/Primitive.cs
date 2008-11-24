﻿using System;
using System.Diagnostics;
using System.Collections.Generic;
using System.Globalization;
using System.Reflection;
using System.Runtime.Serialization;
using System.Security.Permissions;

namespace Microcode
{
    delegate bool PrimitiveMethod (out object answer, object [] arglist);

    delegate bool PrimitiveMethod0 (out object answer);
    delegate bool PrimitiveMethod1 (out object answer, object argument0);
    delegate bool PrimitiveMethod2 (out object answer, object argument0, object argument1);
    delegate bool PrimitiveMethod3 (out object answer, object argument0, object argument1, object argument2);

    [Serializable]
    public abstract class Primitive : SchemeObject //SCode
    {
#if DEBUG
        [NonSerialized]
        public static bool Noisy = false;

        [NonSerialized]
        internal static Histogram<Primitive> hotPrimitives = new Histogram<Primitive> ();
#endif

        // Global table mapping names to primitive procedures.
        [NonSerialized]
        static Dictionary<string, Primitive> primitiveTable = new Dictionary<string, Primitive> ();

        readonly string name;
        [DebuggerBrowsable (DebuggerBrowsableState.Never)]
        readonly int arity;

        internal static Primitive1 Car;
        internal static Primitive1 Cdr;
        internal static Primitive1 CharToInteger;
        internal static Primitive1 ClearInterrupts;
        internal static Primitive1 ExitWithValue;
        internal static Primitive1 FixnumAdd1;
        internal static Primitive1 FixnumIsNegative;
        internal static Primitive1 FixnumNegate;
        internal static Primitive1 FixnumSub1;
        internal static Primitive1 FlonumIsPositive;
        internal static Primitive1 FlonumIsNegative;
        internal static Primitive1 FloatingVectorCons;
        internal static Primitive1 Add1;
        internal static Primitive1 InitializeCCompiledBlock;
        internal static Primitive1 IntegerAdd1;
        internal static Primitive1 IntegerSub1;
        internal static Primitive1 IsBigFixnum;
        internal static Primitive1 IsBigFlonum;
        internal static Primitive1 IsChar;
        internal static Primitive1 IsComplex;
        internal static Primitive1 IsFixnum;
        internal static Primitive1 IsFixnumZero;
        internal static Primitive1 IsNull;
        internal static Primitive1 IsPair;
        internal static Primitive1 IsRatnum;
        internal static Primitive1 IsRecord;
        internal static Primitive1 IsSymbol;
        internal static Primitive1 IsTrue;
        internal static Primitive1 IsVector;
        internal static Primitive1 Not;
        internal static Primitive1 ObjectDatum;
        internal static Primitive1 ObjectType;
        internal static Primitive1 ObjectIsZero;
        internal static Primitive1 SetInterruptEnables;
        internal static Primitive1 SetTrapState;
        internal static Primitive1 StringAllocate;
        internal static Primitive1 SystemVectorSize;
        internal static Primitive1 RequestInterrupts;
        internal static Primitive1 PositiveFixnum;

        internal static Primitive2 BoolIsEq;
        internal static Primitive2 Cons;
        internal static Primitive2 CharIsEq;
        internal static Primitive2 IsEq;
        internal static Primitive2 IsFixnumEqual;
        internal static Primitive2 IntegerMultiply;
        internal static Primitive2 IntegerSubtract;
        internal static Primitive2 IntIsEq;
        internal static Primitive2 FileAccess;
        internal static Primitive2 FixnumAnd;
        internal static Primitive2 FixnumIsGreaterThan;
        internal static Primitive2 FixnumLsh;
        internal static Primitive2 FixnumMultiply;
        internal static Primitive2 FixnumOr;
        internal static Primitive2 FixnumRemainder;
        internal static Primitive2 FixnumSubtract;
        internal static Primitive2 FixnumXor;
        internal static Primitive2 FixnumQuotient;
        internal static Primitive2 FloatingVectorRef;
        internal static Primitive2 FlonumAdd;
        internal static Primitive2 FlonumDivide;
        internal static Primitive2 FlonumIsEqual;
        internal static Primitive2 FlonumIsGreaterThan;
        internal static Primitive2 FlonumIsLessThan;
        internal static Primitive2 FlonumExpt;
        internal static Primitive2 FlonumMultiply;
        internal static Primitive2 FlonumSubtract;
        internal static Primitive2 GeneralCarCdr;
        internal static Primitive2 GenericAdd;
        internal static Primitive2 GenericDivide;
        internal static Primitive2 GenericIsEqual;
        internal static Primitive2 GenericIsLessThan;
        internal static Primitive2 GenericIsGreaterThan;
        internal static Primitive2 GenericMultiply;
        internal static Primitive2 GenericSubtract;
        internal static Primitive2 GetServiceByName;
        internal static Primitive2 GreaterThanFixnum;
        internal static Primitive2 IntegerAdd;
        internal static Primitive2 IntegerDivide;
        internal static Primitive2 IntegerIsEqual;
        internal static Primitive2 IntegerIsGreater;
        internal static Primitive1 IntegerIsPositive;
        internal static Primitive2 IntegerRemainder;
        internal static Primitive2 IntegerShiftLeft;
        internal static Primitive2 IntegerToFlonum;
        internal static Primitive2 IntegerQuotient;
        internal static Primitive2 LessThanFixnum;
        internal static Primitive2 LexicalReference;
        internal static Primitive2 LexicalUnreferenceable;
        internal static Primitive2 MakeBitString;
        internal static Primitive2 MapCodeToMachineAddress;
        internal static Primitive2 MapMachineAddressToCode;
        internal static Primitive2 ObjectIsEq;
        internal static Primitive2 ObjectSetType;
        internal static Primitive2 PlusFixnum;
        internal static Primitive2 PrimitiveAddress;
        internal static Primitive2 PrimitiveIsObjectType;
        internal static Primitive2 PrimitiveObjectEq;
        internal static Primitive2 PrimitiveObjectRef;
        internal static Primitive2 PrimitiveObjectSetType;
        internal static Primitive2 IsObjectType;
        internal static Primitive2 Quotient;
        internal static Primitive2 RealTimerSet;
        internal static Primitive2 RecordRef;
        internal static Primitive2 Remainder;
        internal static Primitive2 SetCar;
        internal static Primitive2 SetCdr;
        internal static Primitive2 ShutdownSocket;
        internal static Primitive2 StringRef;
        internal static Primitive2 SystemListToVector;
        internal static Primitive2 SystemPairSetCar;
        internal static Primitive2 SystemVectorRef;
        internal static Primitive2 VectorCons;
        internal static Primitive2 Vector8BRef;
        internal static Primitive2 VectorRef;
        internal static Primitive2 Win32ExpandEnvironmentStrings;
        internal static Primitive2 WithInterruptMask;

        public static void Initialize ()
        {
            Assembly asm = Assembly.GetExecutingAssembly ();
            foreach (Type type in asm.GetTypes ())
                AddPrimitives (type);

            Car = (Primitive1) Find ("CAR", 1);
            Cdr = (Primitive1) Find ("CDR", 1);
            CharToInteger = (Primitive1) Find ("CHAR->INTEGER", 1);
            ClearInterrupts = (Primitive1) Find ("CLEAR-INTERRUPTS!", 1);
            ExitWithValue = (Primitive1) Find ("EXIT-WITH-VALUE", 1);
            FloatingVectorCons = (Primitive1) Find ("FLOATING-VECTOR-CONS", 1);
            FlonumIsPositive = (Primitive1) Find ("FLONUM-POSITIVE?", 1);
            FlonumIsNegative = (Primitive1) Find ("FLONUM-NEGATIVE?", 1);
            FixnumAdd1 = (Primitive1) Find ("ONE-PLUS-FIXNUM", 1);
            FixnumIsNegative = (Primitive1) Find ("NEGATIVE-FIXNUM?", 1);
            FixnumSub1 = (Primitive1) Find ("MINUS-ONE-PLUS-FIXNUM", 1);
            FixnumNegate = (Primitive1) Find ("FIXNUM-NEGATE", 1);
            Add1 = (Primitive1) Find ("1+", 1);
            InitializeCCompiledBlock = (Primitive1) Find ("INITIALIZE-C-COMPILED-BLOCK", 1);
            IntegerAdd1 = (Primitive1) Find ("INTEGER-ADD-1", 1);
            IntegerSub1 = (Primitive1) Find ("INTEGER-SUBTRACT-1", 1);
            IsBigFixnum = (Primitive1) Find ("BIG-FIXNUM?", 1);
            IsBigFlonum = (Primitive1) Find ("BIG-FLONUM?", 1);
            IsChar = (Primitive1) Find ("CHAR?", 1);
            IsComplex = (Primitive1) Find ("COMPLEX?", 1);
            IsFixnum = (Primitive1) Find ("FIXNUM?", 1);
            IsFixnumZero = (Primitive1) Find ("ZERO-FIXNUM?", 1);
            IsNull = (Primitive1) Find ("NULL?", 1);
            IsTrue = (Primitive1) Find ("OBJECT-IS-TRUE?", 1);
            IsPair = (Primitive1) Find ("PAIR?", 1);
            PositiveFixnum = (Primitive1) Find ("POSITIVE-FIXNUM?", 1);
            IsRatnum = (Primitive1) Find ("RATNUM?", 1);
            IsRecord = (Primitive1) Find ("%RECORD?", 1);
            IsSymbol = (Primitive1) Find ("SYMBOL?", 1);
            IsVector = (Primitive1) Find ("VECTOR?", 1);
            Not = (Primitive1) Find ("NOT", 1);
            ObjectDatum = (Primitive1) Find ("OBJECT-DATUM", 1);
            ObjectIsZero = (Primitive1) Find ("OBJECT-IS-ZERO?", 1);
            ObjectType = (Primitive1) Find ("OBJECT-TYPE", 1);
            SetInterruptEnables = (Primitive1) Find ("SET-INTERRUPT-ENABLES!", 1);
            SetTrapState = (Primitive1) Find ("SET-TRAP-STATE!", 1);
            StringAllocate = (Primitive1) Find ("STRING-ALLOCATE", 1);
            SystemVectorSize = (Primitive1) Find ("SYSTEM-VECTOR-SIZE", 1);
            RequestInterrupts = (Primitive1) Find ("REQUEST-INTERRUPTS!", 1);

            IntIsEq = (Primitive2) Find ("INT-EQ?", 2);
            BoolIsEq = (Primitive2) Find ("BOOL-EQ?", 2);
            CharIsEq = (Primitive2) Find ("CHAR-EQ?", 2);
            Cons = (Primitive2) Find ("CONS", 2);

            IsEq = (Primitive2) Find ("EQ?", 2);
            FileAccess = (Primitive2) Find ("FILE-ACCESS", 2);
            FixnumAnd = (Primitive2) Find ("FIXNUM-AND", 2);
            FixnumIsGreaterThan = (Primitive2) Find ("GREATER-THAN-FIXNUM?", 2);
            FixnumLsh = (Primitive2) Find ("FIXNUM-LSH", 2);
            FixnumMultiply = (Primitive2) Find ("MULTIPLY-FIXNUM", 2);
            FixnumOr = (Primitive2) Find ("FIXNUM-OR", 2);
            FixnumSubtract = (Primitive2) Find ("MINUS-FIXNUM", 2);
            FixnumQuotient = (Primitive2) Find ("FIXNUM-QUOTIENT", 2);
            FixnumRemainder = (Primitive2) Find ("FIXNUM-REMAINDER", 2);
            FixnumXor = (Primitive2) Find ("FIXNUM-XOR", 2);
            FloatingVectorRef = (Primitive2) Find ("FLOATING-VECTOR-REF", 2);
            FlonumAdd = (Primitive2) Find ("FLONUM-ADD", 2);
            FlonumDivide = (Primitive2) Find ("FLONUM-DIVIDE", 2);
            FlonumExpt = (Primitive2) Find ("FLONUM-EXPT", 2);
            FlonumIsEqual = (Primitive2) Find ("FLONUM-EQUAL?", 2);
            FlonumIsGreaterThan = (Primitive2) Find ("FLONUM-GREATER?", 2);
            FlonumIsLessThan = (Primitive2) Find ("FLONUM-LESS?", 2);
            FlonumMultiply = (Primitive2) Find ("FLONUM-MULTIPLY", 2);
            FlonumSubtract = (Primitive2) Find ("FLONUM-SUBTRACT", 2);
            GeneralCarCdr = (Primitive2) Find ("GENERAL-CAR-CDR", 2);
            GenericAdd = (Primitive2) Find ("&+", 2);
            GenericDivide = (Primitive2) Find ("&/", 2);
            GenericIsEqual = (Primitive2) Find ("&=", 2);
            GenericIsLessThan = (Primitive2) Find ("&<", 2);
            GenericIsGreaterThan = (Primitive2) Find ("&>", 2);
            GenericMultiply = (Primitive2) Find ("&*", 2);
            GenericSubtract = (Primitive2) Find ("&-", 2);
            GreaterThanFixnum = (Primitive2) Find ("GREATER-THAN-FIXNUM?", 2);
            GetServiceByName = (Primitive2) Find ("GET-SERVICE-BY-NAME", 2);
            IntegerIsGreater = (Primitive2) Find ("INTEGER-GREATER?", 2);
            IntegerAdd = (Primitive2) Find ("INTEGER-ADD", 2);
            IntegerDivide = (Primitive2) Find ("INTEGER-DIVIDE", 2);
            IntegerIsEqual = (Primitive2) Find ("INTEGER-EQUAL?", 2);
            IntegerMultiply = (Primitive2) Find ("INTEGER-MULTIPLY", 2);
            IntegerSubtract = (Primitive2) Find ("INTEGER-SUBTRACT", 2);
            IntegerRemainder = (Primitive2) Find ("INTEGER-REMAINDER", 2);
            IntegerQuotient = (Primitive2) Find ("INTEGER-QUOTIENT", 2);
            IntegerIsPositive = (Primitive1) Find ("INTEGER-POSITIVE?", 1);
            IntegerShiftLeft = (Primitive2) Find ("INTEGER-SHIFT-LEFT", 2);
            IntegerToFlonum = (Primitive2) Find ("INTEGER->FLONUM", 2);
            IsFixnumEqual = (Primitive2) Find ("EQUAL-FIXNUM?", 2);
            LessThanFixnum = (Primitive2) Find ("LESS-THAN-FIXNUM?", 2);
            LexicalReference = (Primitive2) Find ("LEXICAL-REFERENCE", 2);
            LexicalUnreferenceable = (Primitive2) Find ("LEXICAL-UNREFERENCEABLE?", 2);
            MakeBitString = (Primitive2) Find ("MAKE-BIT-STRING", 2);
            MapCodeToMachineAddress = (Primitive2) Find ("MAP-CODE-TO-MACHINE-ADDRESS", 2);
            MapMachineAddressToCode = (Primitive2) Find ("MAP-MACHINE-ADDRESS-TO-CODE", 2);
            PlusFixnum = (Primitive2) Find ("PLUS-FIXNUM", 2);
            ObjectIsEq = (Primitive2) Find ("OBJECT-EQ?", 2);
            ObjectSetType = (Primitive2) Find ("OBJECT-SET-TYPE", 2);
            PrimitiveAddress = (Primitive2) Find ("GET-PRIMITIVE-ADDRESS", 2);
            PrimitiveIsObjectType = (Primitive2) Find ("PRIMITIVE-OBJECT-TYPE?", 2);
            PrimitiveObjectEq = (Primitive2) Find ("PRIMITIVE-OBJECT-EQ?", 2);
            PrimitiveObjectRef = (Primitive2) Find ("PRIMITIVE-OBJECT-REF", 2);
            PrimitiveObjectSetType = (Primitive2) Find ("PRIMITIVE-OBJECT-SET-TYPE", 2);
            IsObjectType = (Primitive2) Find ("OBJECT-TYPE?", 2);
            Quotient = (Primitive2) Find ("QUOTIENT", 2);
            RealTimerSet = (Primitive2) Find ("REAL-TIMER-SET", 2);
            RecordRef = (Primitive2) Find ("%RECORD-REF", 2);
            Remainder = (Primitive2) Find ("REMAINDER", 2);
            ObjectSetType = (Primitive2) Find ("OBJECT-SET-TYPE", 2);
            SetCar = (Primitive2) Find ("SET-CAR!", 2);
            SetCdr = (Primitive2) Find ("SET-CDR!", 2);
            ShutdownSocket = (Primitive2) Find ("SHUTDOWN-SOCKET", 2);
            StringRef = (Primitive2) Find ("STRING-REF", 2);
            SystemPairSetCar = (Primitive2) Find ("SYSTEM-PAIR-SET-CAR!", 2);
            SystemListToVector = (Primitive2) Find ("SYSTEM-LIST-TO-VECTOR", 2);
            SystemVectorRef = (Primitive2) Find ("SYSTEM-VECTOR-REF", 2);
            VectorCons = (Primitive2) Find ("VECTOR-CONS", 2);
            Vector8BRef = (Primitive2) Find ("VECTOR-8B-REF", 2);
            VectorRef = (Primitive2) Find ("VECTOR-REF", 2);
            Win32ExpandEnvironmentStrings = (Primitive2) Find ("WIN32-EXPAND-ENVIRONMENT-STRINGS", 2);
            WithInterruptMask = (Primitive2) Find ("WITH-INTERRUPT-MASK", 2);
        }

        internal Primitive (string name, int arity)
            : base (TC.PRIMITIVE)
        {
            this.name = name;
            this.arity = arity;
        }

        public string Name
        {
            [DebuggerStepThrough]
            get
            {
                return this.name;
            }
        }

        public int Arity
        {
            [DebuggerStepThrough]
            get
            {
                return this.arity;
            }
        }

        public override string ToString ()
        {
            return "#<PRIMITIVE " + this.name + " " + this.arity.ToString (CultureInfo.InvariantCulture) + ">";
        }

        static string CanonicalizeName (string name)
        {
            return String.Intern (name.ToUpperInvariant ());
        }

        static void AddPrimitive (string name, int arity, PrimitiveMethod method)
        {
            string cname = CanonicalizeName (name);
            primitiveTable.Add (cname, new PrimitiveN (String.Intern (name), arity, method));
        }

        static void AddPrimitive (string name, PrimitiveMethod0 method)
        {
            string cname = CanonicalizeName (name);
            primitiveTable.Add (cname, new Primitive0 (String.Intern (name), method));
        }

        static void AddPrimitive (string name, PrimitiveMethod1 method)
        {
            string cname = CanonicalizeName (name);
            primitiveTable.Add (cname, new Primitive1 (String.Intern (name), method));
        }

        static void AddPrimitive (string name, PrimitiveMethod2 method)
        {
            string cname = CanonicalizeName (name);
            primitiveTable.Add (cname, new Primitive2 (String.Intern (name), method));
        }

        static void AddPrimitive (string name, PrimitiveMethod3 method)
        {
            primitiveTable.Add (CanonicalizeName (name), new Primitive3 (String.Intern (name), method));
        }

        static void AddPrimitives (Type type)
        {
            MemberInfo [] minfos = type.FindMembers (MemberTypes.Method, BindingFlags.Public | BindingFlags.Static, null, null);
            foreach (MemberInfo minfo in minfos) {
                object [] attributes = minfo.GetCustomAttributes (typeof (SchemePrimitiveAttribute), false);
                if (attributes.Length == 1) {
                    string name = ((SchemePrimitiveAttribute) (attributes [0])).Name;
                    int arity = ((SchemePrimitiveAttribute) (attributes [0])).Arity;
                    MethodInfo mtdinfo = (MethodInfo) minfo;
                    // Console.WriteLine ("Add Primitive {0}", ((PrimitiveAttribute) (attributes [0])).Name);
                    if (arity == 0) {
                        PrimitiveMethod0 del = (PrimitiveMethod0) System.Delegate.CreateDelegate (typeof (PrimitiveMethod0), mtdinfo);
                        AddPrimitive (name, del);
                    }
                    else if (arity == 1) {
                        PrimitiveMethod1 del = (PrimitiveMethod1) System.Delegate.CreateDelegate (typeof (PrimitiveMethod1), mtdinfo);
                        AddPrimitive (name, del);
                    }
                    else if (arity == 2) {
                        PrimitiveMethod2 del = (PrimitiveMethod2) System.Delegate.CreateDelegate (typeof (PrimitiveMethod2), mtdinfo);
                        AddPrimitive (name, del);
                    }
                    else if (arity == 3) {
                        PrimitiveMethod3 del = (PrimitiveMethod3) System.Delegate.CreateDelegate (typeof (PrimitiveMethod3), mtdinfo);
                        AddPrimitive (name, del);
                    }
                    else {
                        PrimitiveMethod del = (PrimitiveMethod) System.Delegate.CreateDelegate (typeof (PrimitiveMethod), mtdinfo);
                        AddPrimitive (name, arity, del);
                    }
                }
            }
        }

        internal static Primitive Find (string name)
        {
            string cname = CanonicalizeName (name);
            Primitive value;
            if (primitiveTable.TryGetValue (cname, out value)) {
                return value;
            }
            throw new NotImplementedException ();
        }

        internal static Primitive Find (string name, int arity)
        {
            string cname = CanonicalizeName (name);
            Primitive value;
            if (primitiveTable.TryGetValue (cname, out value)) {
                // found one, but wrong arity
                if (value.Arity == arity)
                    return value;
                else
                    throw new NotImplementedException ();
            }
            // If we don't have the primitive in the table, fake one up with an
            // implementation that simply throws an error.  Saves time while
            // developing, but puts time bombs in the code!
            else if (arity == 0) {
                AddPrimitive (name, (PrimitiveMethod0) MissingPrimitive0);
                return Find (name, arity);
            }
            else if (arity == 1) {
                AddPrimitive (name, (PrimitiveMethod1) MissingPrimitive1);
                return Find (name, arity);
            }
            else if (arity == 2) {
                AddPrimitive (name, (PrimitiveMethod2) MissingPrimitive2);
                return Find (name, arity);
            }
            else if (arity == 3) {
                AddPrimitive (name, (PrimitiveMethod3) MissingPrimitive3);
                return Find (name, arity);
            }
            else {
                AddPrimitive (name, arity, (PrimitiveMethod) MissingPrimitive);
                return Find (name, arity);
            }
        }

        static bool MissingPrimitive (out object answer, object [] arglist)
        {
            throw new NotImplementedException ();
        }

        static bool MissingPrimitive0 (out object answer)
        {
            throw new NotImplementedException ();
        }

        static bool MissingPrimitive1 (out object answer, object arg)
        {
            throw new NotImplementedException ();
        }

        static bool MissingPrimitive2 (out object answer, object arg0, object arg1)
        {
            throw new NotImplementedException ();
        }

        static bool MissingPrimitive3 (out object answer, object arg0, object arg1, object arg2)
        {
            throw new NotImplementedException ();
        }

        [SchemePrimitive ("GET-PRIMITIVE-ADDRESS", 2, false)]
        public static bool GetPrimitiveAddress (out object answer, object arg0, object arg1)
        {
            answer = arg1 is int
                ? Find ((string) arg0, (int) arg1)
                : Find ((string) arg0);
            return false;
        }

        [SchemePrimitive ("GET-PRIMITIVE-NAME", 1, false)]
        public static bool GetPrimitiveName (out object answer, object arg)
        {
            answer = ((Primitive) arg).name.ToCharArray ();
            return false;
        }

        [SchemePrimitive ("PRIMITIVE?", 1, true)]
        public static bool IsPrimitive (out object answer, object arg)
        {
            answer = arg is Primitive;
            return false;
        }

        [SchemePrimitive ("PRIMITIVE-PROCEDURE-ARITY", 1, false)]
        public static bool PrimitiveProcedureArity (out object answer, object arg)
        {
            answer = ((Primitive) arg).Arity;
            return false;
        }

    }

    [Serializable]
    sealed class Primitive0 : Primitive, IApplicable, ISerializable
    {
        [DebuggerBrowsable (DebuggerBrowsableState.Never)]
        readonly PrimitiveMethod0 method;

        public Primitive0 (string name, PrimitiveMethod0 method)
            : base (name, 0)
        {
            this.method = method;
        }

        public PrimitiveMethod0 Method
        {
            [DebuggerStepThrough]
            get
            {
                return this.method;
            }
        }

        [SecurityPermissionAttribute (SecurityAction.LinkDemand, Flags = SecurityPermissionFlag.SerializationFormatter)]
        void ISerializable.GetObjectData (SerializationInfo info, StreamingContext context)
        {
            info.SetType (typeof (PrimitiveDeserializer));
            info.AddValue ("varname", this.Name);
            info.AddValue ("arity", 0);
        }

        #region IApplicable Members

        public bool Apply (out object answer, ref Control expression, ref Environment environment, object [] args)
        {
            if (args.Length != 0)
                throw new NotImplementedException ("Wrong number of args to primitive.");
            return this.Call (out answer, ref expression, ref environment);
        }

        public bool Call (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Debug.WriteLineIf (Primitive.Noisy, this.Name);
            Primitive.hotPrimitives.Note (this);
#endif
            if (this.method (out answer)) {
                TailCallInterpreter tci = answer as TailCallInterpreter;
                if (tci == null) throw new NotImplementedException ();
                answer = null;      
                expression = tci.Expression;
                environment = tci.Environment;
                return true;
            }

            return false; // no problems
        }

        public bool Call (out object answer, ref Control expression, ref Environment environment, object arg0)
        {
            throw new NotImplementedException ();
        }

        public bool Call (out object answer, ref Control expression, ref Environment environment, object arg0, object arg1)
        {
            throw new NotImplementedException ();
        }

        #endregion

        #region IApplicable Members


        public bool Call (out object answer, ref Control expression, ref Environment environment, object arg0, object arg1, object arg2)
        {
            throw new NotImplementedException ();
        }

        public bool Call (out object answer, ref Control expression, ref Environment environment, object arg0, object arg1, object arg2, object arg3)
        {
            throw new NotImplementedException ();
        }

        public bool Call (out object answer, ref Control expression, ref Environment environment, object arg0, object arg1, object arg2, object arg3, object arg4)
        {
            throw new NotImplementedException ();
        }

        public bool Call (out object answer, ref Control expression, ref Environment environment, object arg0, object arg1, object arg2, object arg3, object arg4, object arg5)
        {
            throw new NotImplementedException ();
        }

        #endregion
    }

    [Serializable]
    sealed class Primitive1 : Primitive, IApplicable, ISerializable
    {
        [DebuggerBrowsable (DebuggerBrowsableState.Never)]
        readonly PrimitiveMethod1 method;

        public Primitive1 (string name, PrimitiveMethod1 method)
            : base (name, 1)
        {
            this.method = method;
        }


        public PrimitiveMethod1 Method
        {
            [DebuggerStepThrough]
            get
            {
                return this.method;
            }
        }

        [SecurityPermissionAttribute (SecurityAction.LinkDemand, Flags = SecurityPermissionFlag.SerializationFormatter)]
        void ISerializable.GetObjectData (SerializationInfo info, StreamingContext context)
        {
            info.SetType (typeof (PrimitiveDeserializer));
            info.AddValue ("varname", this.Name);
            info.AddValue ("arity", 1);
        }

        #region IApplicable Members

        public bool Apply (out object answer, ref Control expression, ref Environment environment, object [] args)
        {
            throw new NotImplementedException ();
        }

        public bool Call (out object answer, ref Control expression, ref Environment environment)
        {
            throw new NotImplementedException ();
        }

        public bool Call (out object answer, ref Control expression, ref Environment environment, object arg0)
        {
#if DEBUG
            Debug.WriteLineIf (Primitive.Noisy, this.Name);
            hotPrimitives.Note (this);
            SCode.location = this.Name;
#endif
            if (this.method (out answer, arg0))
                throw new NotImplementedException ();
            return false; // no problems
        }

        public bool Call (out object answer, ref Control expression, ref Environment environment, object arg0, object arg1)
        {
            throw new NotImplementedException ();
        }

        #endregion

        #region IApplicable Members


        public bool Call (out object answer, ref Control expression, ref Environment environment, object arg0, object arg1, object arg2)
        {
            throw new NotImplementedException ();
        }

        public bool Call (out object answer, ref Control expression, ref Environment environment, object arg0, object arg1, object arg2, object arg3)
        {
            throw new NotImplementedException ();
        }

        public bool Call (out object answer, ref Control expression, ref Environment environment, object arg0, object arg1, object arg2, object arg3, object arg4)
        {
            throw new NotImplementedException ();
        }

        public bool Call (out object answer, ref Control expression, ref Environment environment, object arg0, object arg1, object arg2, object arg3, object arg4, object arg5)
        {
            throw new NotImplementedException ();
        }

        #endregion
    }

    [Serializable]
    sealed class Primitive2 : Primitive, IApplicable, ISerializable
    {
        [DebuggerBrowsable (DebuggerBrowsableState.Never)]
        readonly PrimitiveMethod2 method;

        public Primitive2 (string name, PrimitiveMethod2 method)
            : base (name, 2)
        {
            this.method = method;
        }

        public PrimitiveMethod2 Method
        {
            [DebuggerStepThrough]
            get
            {
                return this.method;
            }
        }

        [SecurityPermissionAttribute (SecurityAction.LinkDemand, Flags = SecurityPermissionFlag.SerializationFormatter)]
        void ISerializable.GetObjectData (SerializationInfo info, StreamingContext context)
        {
            info.SetType (typeof (PrimitiveDeserializer));
            info.AddValue ("varname", this.Name);
            info.AddValue ("arity", 2);
        }

        #region IApplicable Members

        public bool Apply (out object answer, ref Control expression, ref Environment environment,object [] args)
        {
            throw new NotImplementedException ();
        }

        public bool Call (out object answer, ref Control expression, ref Environment environment)
        {
            throw new NotImplementedException ();
        }

        public bool Call (out object answer, ref Control expression, ref Environment environment, object arg0)
        {
            throw new NotImplementedException ();
        }

        public bool Call (out object answer, ref Control expression, ref Environment environment, object arg0, object arg1)
        {
#if DEBUG
            Debug.WriteLineIf (Primitive.Noisy, this.Name);
            hotPrimitives.Note (this);
#endif
            if (this.method (out answer, arg0, arg1)) {
                TailCallInterpreter tci = answer as TailCallInterpreter;
                if (tci == null) throw new NotImplementedException ();
                answer = null;
                expression = tci.Expression;
                environment = tci.Environment;
                return true;
            }

            return false;
        }

        #endregion

        #region IApplicable Members


        public bool Call (out object answer, ref Control expression, ref Environment environment, object arg0, object arg1, object arg2)
        {
            throw new NotImplementedException ();
        }

        public bool Call (out object answer, ref Control expression, ref Environment environment, object arg0, object arg1, object arg2, object arg3)
        {
            throw new NotImplementedException ();
        }

        public bool Call (out object answer, ref Control expression, ref Environment environment, object arg0, object arg1, object arg2, object arg3, object arg4)
        {
            throw new NotImplementedException ();
        }

        public bool Call (out object answer, ref Control expression, ref Environment environment, object arg0, object arg1, object arg2, object arg3, object arg4, object arg5)
        {
            throw new NotImplementedException ();
        }

        #endregion
    }

    [Serializable]
    sealed class Primitive3 : Primitive, IApplicable, ISerializable
    {
        [DebuggerBrowsable (DebuggerBrowsableState.Never)]
        readonly PrimitiveMethod3 method;

        public Primitive3 (string name, PrimitiveMethod3 method)
            : base (name, 3)
        {
            this.method = method;
        }

        public PrimitiveMethod3 Method
        {
            [DebuggerStepThrough]
            get
            {
                return this.method;
            }
        }

        [SecurityPermissionAttribute (SecurityAction.LinkDemand, Flags = SecurityPermissionFlag.SerializationFormatter)]
        void ISerializable.GetObjectData (SerializationInfo info, StreamingContext context)
        {
            info.SetType (typeof (PrimitiveDeserializer));
            info.AddValue ("varname", this.Name);
            info.AddValue ("arity", 3);
        }

        #region IApplicable Members

        public bool Apply (out object answer, ref Control expression, ref Environment environment, object [] args)
        {
            throw new NotImplementedException ();
        }

        public bool Call (out object anwswer, ref Control expression, ref Environment environment)
        {
            throw new NotImplementedException ();
        }

        public bool Call (out object answer, ref Control expression, ref Environment environment, object arg0)
        {
            throw new NotImplementedException ();
        }

        public bool Call (out object answer, ref Control expression, ref Environment environment, object arg0, object arg1)
        {
            throw new NotImplementedException ();
        }

        public bool Call (out object answer, ref Control expression, ref Environment environment, object arg0, object arg1, object arg2)
        {
#if DEBUG
            Debug.WriteLineIf (Primitive.Noisy, this.Name);
            hotPrimitives.Note (this);
#endif
            if (this.method (out answer, arg0, arg1, arg2)) {
                TailCallInterpreter tci = answer as TailCallInterpreter;
                if (tci == null) throw new NotImplementedException ();
                answer = null;
                expression = tci.Expression;
                environment = tci.Environment;
                return true;
            }

            return false;
        }

        public bool Call (out object answer, ref Control expression, ref Environment environment, object arg0, object arg1, object arg2, object arg3)
        {
            throw new NotImplementedException ();
        }

        public bool Call (out object answer, ref Control expression, ref Environment environment, object arg0, object arg1, object arg2, object arg3, object arg4)
        {
            throw new NotImplementedException ();
        }

        public bool Call (out object answer, ref Control expression, ref Environment environment, object arg0, object arg1, object arg2, object arg3, object arg4, object arg5)
        {
            throw new NotImplementedException ();
        }

        #endregion
    }

    [Serializable]
    sealed class PrimitiveN : Primitive, IApplicable, ISerializable
    {
        [DebuggerBrowsable (DebuggerBrowsableState.Never)]
        readonly PrimitiveMethod method;

        public PrimitiveN (string name, int arity, PrimitiveMethod method)
            : base (name, arity)
        {
            this.method = method;
        }

        public PrimitiveMethod Method
        {
            [DebuggerStepThrough]
            get
            {
                return this.method;
            }
        }

        [SecurityPermissionAttribute (SecurityAction.LinkDemand, Flags = SecurityPermissionFlag.SerializationFormatter)]
        void ISerializable.GetObjectData (SerializationInfo info, StreamingContext context)
        {
            info.SetType (typeof (PrimitiveDeserializer));
            info.AddValue ("varname", this.Name);
            info.AddValue ("arity", this.Arity);
        }

        #region IApplicable members

        public bool Apply (out object answer, ref Control expression, ref Environment environment, object [] args)
        {
#if DEBUG
            Debug.WriteLineIf (Primitive.Noisy, this.Name);
            Primitive.hotPrimitives.Note (this);
#endif
            //// gotta remove the procedure from the front of the arglist.
            //object [] args1 = new object [args.Length - 1];
            //Array.Copy (args, 1, args1, 0, args1.Length);
            if (args != null && args.Length > 0 && args [0] == this)
                throw new NotImplementedException ();

            if (this.method (out answer, args))
                throw new NotImplementedException ();
            return false; // no problems
        }

        public bool Call (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Debug.WriteLineIf (Primitive.Noisy, this.Name);
            hotPrimitives.Note (this);
#endif
            object [] arguments = new object [] { };
            if (this.method (out answer, arguments))
                throw new NotImplementedException ();
            return false; // no problems
        }

        public bool Call (out object answer, ref Control expression, ref Environment environment, object arg0)
        {
#if DEBUG
            Debug.WriteLineIf (Primitive.Noisy, this.Name);
            hotPrimitives.Note (this);
            SCode.location = this.Name;
#endif
            object [] arguments = new object [] { arg0 };
            if (this.method (out answer, arguments))
                throw new NotImplementedException ();
            return false; // no problems
        }

        public bool Call (out object answer, ref Control expression, ref Environment environment, object arg0, object arg1)
        {
#if DEBUG
            Debug.WriteLineIf (Primitive.Noisy, this.Name);
            hotPrimitives.Note (this);
#endif
            object [] arguments = new object [] { arg0, arg1 };
            if (this.method (out answer, arguments))
                throw new NotImplementedException ();
            return false; // no problems
        }

        public bool Call (out object answer, ref Control expression, ref Environment environment, object arg0, object arg1, object arg2)
        {
#if DEBUG
            Debug.WriteLineIf (Primitive.Noisy, this.Name);
            hotPrimitives.Note (this);
#endif
            object [] arguments = new object [] { arg0, arg1, arg2 };
            if (this.method (out answer, arguments))
                throw new NotImplementedException ();
            return false; // no problems
        }

        public bool Call (out object answer, ref Control expression, ref Environment environment, object arg0, object arg1, object arg2, object arg3)
        {
#if DEBUG
            SCode.location = "PrimitiveN.Call.4";
            Debug.WriteLineIf (Primitive.Noisy, this.Name);
            hotPrimitives.Note (this);
#endif
            object [] arguments = new object [] { arg0, arg1, arg2, arg3};
#if DEBUG
            SCode.location = this.Name;
#endif
            if (this.method (out answer, arguments))
                throw new NotImplementedException ();
            return false; // no problems   
        }

        public bool Call (out object answer, ref Control expression, ref Environment environment, object arg0, object arg1, object arg2, object arg3, object arg4)
        {
            throw new NotImplementedException ();
        }

        public bool Call (out object answer, ref Control expression, ref Environment environment, object arg0, object arg1, object arg2, object arg3, object arg4, object arg5)
        {
            throw new NotImplementedException ();
        }


        #endregion

        #region IApplicable Members



        #endregion
    }

    [Serializable]
    internal sealed class PrimitiveDeserializer : IObjectReference
    {
        // This object has no fields (although it could).
        string name;
        int arity;

        // GetRealObject is called after this object is deserialized.
        public Object GetRealObject (StreamingContext context)
        {
            return Primitive.Find (this.name, this.arity);
        }

        public void SetName (string value) { this.name = value; }
        public void SetArity (int value) { this.arity = value; }
    }

}
