﻿using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;

namespace Microcode
{
    [Serializable]
    class PrimitiveIsEq : PrimitiveCombination2
    {
#if DEBUG
        static Histogram<Type> rand0TypeHistogram = new Histogram<Type> ();
        static Histogram<Type> rand1TypeHistogram = new Histogram<Type> ();
#endif
        protected PrimitiveIsEq (Primitive2 rator, SCode rand0, SCode rand1)
            : base (rator, rand0, rand1)
        {
        }

        public static new SCode Make (Primitive2 rator, SCode rand0, SCode rand1)
        {
            return
                (rand0 is PrimitiveCar) ? PrimitiveIsEqCar.Make (rator, (PrimitiveCar) rand0, rand1) :
                //(rand0 is PrimitiveCaar) ? PrimitiveIsEqCaar.Make (rator, (PrimitiveCaar) rand0, rand1) :
                //(rand0 is PrimitiveRecordRef) ? PrimitiveIsEqRecordRef.Make (rator, (PrimitiveRecordRef) rand0, rand1) :
                (rand0 is Argument) ? PrimitiveIsEqA.Make (rator, (Argument) rand0, rand1) :
                (rand0 is StaticVariable) ? PrimitiveIsEqS.Make (rator, (StaticVariable) rand0, rand1) :
                (rand0 is Quotation) ? PrimitiveIsEqQ.Make (rator, (Quotation) rand0, rand1) :
                (rand1 is Quotation) ? PrimitiveIsEqXQ.Make (rator, rand0, (Quotation) rand1) :
                new PrimitiveIsEq (rator, rand0, rand1);
        }

        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm ("-");
            NoteCalls (this.rand0);
            NoteCalls (this.rand1);

            rand0TypeHistogram.Note (this.rand0Type);
            rand1TypeHistogram.Note (this.rand1Type);
            SCode.location = "PrimitiveIsEq.EvalStep";   
#endif
            // Eval argument1
            object ev1;

            Control unev = this.rand1;
            Environment env = environment;
            while (unev.EvalStep (out ev1, ref unev, ref env)) { };
#if DEBUG
            SCode.location = "PrimitiveIsEq.EvalStep";
#endif
            if (ev1 == Interpreter.UnwindStack) {
                throw new NotImplementedException ();
                //((UnwinderState) env).AddFrame (new PrimitiveCombination2Frame0 (this, environment));
                //answer = Interpreter.UnwindStack;
                //environment = env;
                //return false;
            }

            // Eval argument0
            object ev0;

            unev = this.rand0;
            env = environment;
            while (unev.EvalStep (out ev0, ref unev, ref env)) { };
#if DEBUG
            SCode.location = "PrimitiveIsEq.EvalStep";
#endif
            if (ev0 == Interpreter.UnwindStack) {
                throw new NotImplementedException ();
                //((UnwinderState) env).AddFrame (new PrimitiveCombination2Frame0 (this, environment));
                //answer = Interpreter.UnwindStack;
                //environment = env;
                //return false;
            }

            if (ObjectModel.Eq (out answer, ev0, ev1))
                throw new NotImplementedException();
            return false;
        }
    }

    [Serializable]
    class PrimitiveIsEqCar : PrimitiveIsEq
    {
#if DEBUG
        static Histogram<Type> rand0TypeHistogram = new Histogram<Type>();
        static Histogram<Type> rand1TypeHistogram = new Histogram<Type>();
        public readonly Type rand0ArgType;
#endif
        public readonly SCode rand0Arg;

        protected PrimitiveIsEqCar (Primitive2 rator, PrimitiveCar rand0, SCode rand1)
            : base (rator, rand0, rand1)
        {
            this.rand0Arg = rand0.Operand;
#if DEBUG
            this.rand0ArgType = rand0.Operand.GetType();
#endif
        }

        public static SCode Make(Primitive2 rator, PrimitiveCar rand0, SCode rand1)
        {

            return 
                (rand0 is PrimitiveCarA) ? PrimitiveIsEqCarA.Make (rator, (PrimitiveCarA) rand0, rand1) :
                (rand1 is StaticVariable) ? PrimitiveIsEqCarXS.Make (rator, rand0, (StaticVariable) rand1) :
                new PrimitiveIsEqCar(rator, rand0, rand1);
        }

        public override bool EvalStep(out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm("-");
            NoteCalls(this.rand0Arg);
            NoteCalls(this.rand1);

            rand0TypeHistogram.Note(this.rand0ArgType);
            rand1TypeHistogram.Note(this.rand1Type);
            SCode.location = "PrimitiveIsEqCar.EvalStep";
#endif
            // Eval argument1
            object ev1;

            Control unev = this.rand1;
            Environment env = environment;
            while (unev.EvalStep(out ev1, ref unev, ref env)) { };
#if DEBUG
            SCode.location = "PrimitiveIsEqCar.EvalStep";
#endif
            if (ev1 == Interpreter.UnwindStack)
            {
                throw new NotImplementedException();
                //((UnwinderState) env).AddFrame (new PrimitiveCombination2Frame0 (this, environment));
                //answer = Interpreter.UnwindStack;
                //environment = env;
                //return false;
            }

            // Eval argument0
            object ev0;

            unev = this.rand0Arg;
            env = environment;
            while (unev.EvalStep(out ev0, ref unev, ref env)) { };
#if DEBUG
            SCode.location = "PrimitiveIsEqCar.EvalStep";
#endif
            if (ev0 == Interpreter.UnwindStack)
            {
                throw new NotImplementedException();
                //((UnwinderState) env).AddFrame (new PrimitiveCombination2Frame0 (this, environment));
                //answer = Interpreter.UnwindStack;
                //environment = env;
                //return false;
            }

            Cons ev0Pair = ev0 as Cons;
            if (ev0Pair == null) throw new NotImplementedException();

            if (ObjectModel.Eq(out answer, ev0Pair.Car, ev1))
                throw new NotImplementedException();
            return false;
        }
    }

    [Serializable]
    class PrimitiveIsEqCarA : PrimitiveIsEqCar
    {
#if DEBUG
        static Histogram<Type> rand1TypeHistogram = new Histogram<Type>();
#endif
        public readonly int rand0ArgOffset;

        protected PrimitiveIsEqCarA(Primitive2 rator, PrimitiveCarA rand0, SCode rand1)
            : base(rator, rand0, rand1)
        {
            this.rand0ArgOffset = rand0.offset;
        }

        public static SCode Make(Primitive2 rator, PrimitiveCarA rand0, SCode rand1)
        {
            return
                (rand0 is PrimitiveCarA0) ? PrimitiveIsEqCarA0.Make(rator, (PrimitiveCarA0)rand0, rand1) :
                new PrimitiveIsEqCarA(rator, rand0, rand1);
        }

        public override bool EvalStep(out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm("-");
            NoteCalls(this.rand1);

            rand1TypeHistogram.Note(this.rand1Type);
            SCode.location = "PrimitiveIsEqCarA";
#endif
            // Eval argument1
            object ev1;

            Control unev = this.rand1;
            Environment env = environment;
            while (unev.EvalStep(out ev1, ref unev, ref env)) { };
#if DEBUG
            SCode.location = "PrimitiveIsEqCarA";
#endif
            if (ev1 == Interpreter.UnwindStack)
            {
                throw new NotImplementedException();
                //((UnwinderState) env).AddFrame (new PrimitiveCombination2Frame0 (this, environment));
                //answer = Interpreter.UnwindStack;
                //environment = env;
                //return false;
            }

            // Eval argument0
            Cons ev0Pair = environment.ArgumentValue(this.rand0ArgOffset) as Cons;
            if (ev0Pair == null) throw new NotImplementedException();

            if (ObjectModel.Eq(out answer, ev0Pair.Car, ev1))
                throw new NotImplementedException();
            return false;
        }
    }

    [Serializable]
    class PrimitiveIsEqCarA0 : PrimitiveIsEqCarA
    {
#if DEBUG
        static Histogram<Type> rand1TypeHistogram = new Histogram<Type>();
#endif
        protected PrimitiveIsEqCarA0(Primitive2 rator, PrimitiveCarA0 rand0, SCode rand1)
            : base(rator, rand0, rand1)
        {
        }

        public static SCode Make(Primitive2 rator, PrimitiveCarA0 rand0, SCode rand1)
        {
            return
                (rand1 is PrimitiveCar) ? PrimitiveIsEqCarA0Car.Make (rator, rand0, (PrimitiveCar) rand1) :
                new PrimitiveIsEqCarA0(rator, rand0, rand1);
        }

        public override bool EvalStep(out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm("-");
            NoteCalls(this.rand1);

            rand1TypeHistogram.Note(this.rand1Type);
            SCode.location = "PrimitiveIsEqCarA0";
#endif
            // Eval argument1
            object ev1;

            Control unev = this.rand1;
            Environment env = environment;
            while (unev.EvalStep(out ev1, ref unev, ref env)) { };
#if DEBUG
            SCode.location = "PrimitiveIsEqCarA0";
#endif
            if (ev1 == Interpreter.UnwindStack)
            {
                throw new NotImplementedException();
                //((UnwinderState) env).AddFrame (new PrimitiveCombination2Frame0 (this, environment));
                //answer = Interpreter.UnwindStack;
                //environment = env;
                //return false;
            }

            // Eval argument0
            Cons ev0Pair = environment.Argument0Value as Cons;
            if (ev0Pair == null) throw new NotImplementedException();

            if (ObjectModel.Eq(out answer, ev0Pair.Car, ev1))
                throw new NotImplementedException();
            return false;
        }
    }

    [Serializable]
    class PrimitiveIsEqCarA0Car : PrimitiveIsEqCarA0
    {
#if DEBUG
        static Histogram<Type> rand1ArgTypeHistogram = new Histogram<Type> ();
        readonly Type rand1ArgType;
#endif
        public readonly SCode rand1Arg;
        protected PrimitiveIsEqCarA0Car (Primitive2 rator, PrimitiveCarA0 rand0, PrimitiveCar rand1)
            : base (rator, rand0, rand1)
        {
            this.rand1Arg = rand1.Operand;
#if DEBUG
            this.rand1ArgType = rand1.Operand.GetType();
#endif
        }

        public static SCode Make (Primitive2 rator, PrimitiveCarA0 rand0, PrimitiveCar rand1)
        {
            return
                (rand1 is PrimitiveCarA) ? PrimitiveIsEqCarA0CarA.Make (rator, rand0, (PrimitiveCarA) rand1) :
                new PrimitiveIsEqCarA0Car(rator, rand0, rand1);
        }

        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm ("-");
            NoteCalls (this.rand1Arg);

            rand1ArgTypeHistogram.Note (this.rand1ArgType);
            SCode.location = "PrimitiveIsEqCarA0Car";
#endif
            // Eval argument1
            object ev1;

            Control unev = this.rand1Arg;
            Environment env = environment;
            while (unev.EvalStep (out ev1, ref unev, ref env)) { };
#if DEBUG
            SCode.location = "PrimitiveIsEqCarA0Car";
#endif
            if (ev1 == Interpreter.UnwindStack)
            {
                throw new NotImplementedException ();
                //((UnwinderState) env).AddFrame (new PrimitiveCombination2Frame0 (this, environment));
                //answer = Interpreter.UnwindStack;
                //environment = env;
                //return false;
            }

            Cons ev1Pair = ev1 as Cons;
            if (ev1Pair == null) throw new NotImplementedException ();

            // Eval argument0
            Cons ev0Pair = environment.Argument0Value as Cons;
            if (ev0Pair == null) throw new NotImplementedException ();

            if (ObjectModel.Eq (out answer, ev0Pair.Car, ev1Pair.Car))
                throw new NotImplementedException ();
            return false;
        }
    }

    [Serializable]
    class PrimitiveIsEqCarA0CarA : PrimitiveIsEqCarA0Car
    {
        public readonly int rand1Offset;
        protected PrimitiveIsEqCarA0CarA (Primitive2 rator, PrimitiveCarA0 rand0, PrimitiveCarA rand1)
            : base (rator, rand0, rand1)
        {
            this.rand1Offset = rand1.offset;
        }

        public static SCode Make (Primitive2 rator, PrimitiveCarA0 rand0, PrimitiveCarA rand1)
        {
            return
                new PrimitiveIsEqCarA0CarA(rator, rand0, rand1);
        }

        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm ("PrimitiveIsEqCarA0CarA");
#endif
            Cons ev1Pair = environment.ArgumentValue(this.rand1Offset) as Cons;
            if (ev1Pair == null) throw new NotImplementedException ();

            // Eval argument0
            Cons ev0Pair = environment.Argument0Value as Cons;
            if (ev0Pair == null) throw new NotImplementedException ();

            if (ObjectModel.Eq (out answer, ev0Pair.Car, ev1Pair.Car))
                throw new NotImplementedException ();
            return false;
        }
    }

    [Serializable]
    class PrimitiveIsEqCarXS : PrimitiveIsEqCar
    {
#if DEBUG
        static Histogram<Type> rand0TypeHistogram = new Histogram<Type> ();
#endif

        public readonly Symbol rand1Name;
        public readonly int rand1Offset;

        protected PrimitiveIsEqCarXS (Primitive2 rator, PrimitiveCar rand0, StaticVariable rand1)
            : base (rator, rand0, rand1)
        {
            this.rand1Name = rand1.Name;
            this.rand1Offset = rand1.Offset;
        }

        public static SCode Make (Primitive2 rator, PrimitiveCar rand0, StaticVariable rand1)
        {

            return
                new PrimitiveIsEqCarXS (rator, rand0, rand1);
        }

        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm ("-");
            NoteCalls (this.rand0Arg);

            rand0TypeHistogram.Note (this.rand0ArgType);
            SCode.location = "PrimitiveIsEqCarXS";
#endif
            // Eval argument1
            object ev1;
            if (environment.StaticValue (out ev1, this.rand1Name, this.rand1Offset)) {
                throw new NotImplementedException ();
            }

            // Eval argument0
            object ev0;

            Control unev = this.rand0Arg;
            Environment env = environment;
            while (unev.EvalStep (out ev0, ref unev, ref env)) { };
#if DEBUG
            SCode.location = "PrimitiveIsEqCarXS";
#endif
            if (ev0 == Interpreter.UnwindStack) {
                throw new NotImplementedException ();
                //((UnwinderState) env).AddFrame (new PrimitiveCombination2Frame0 (this, environment));
                //answer = Interpreter.UnwindStack;
                //environment = env;
                //return false;
            }

            Cons ev0Pair = ev0 as Cons;
            if (ev0Pair == null) throw new NotImplementedException ();

            if (ObjectModel.Eq (out answer, ev0Pair.Car, ev1))
                throw new NotImplementedException ();
            return false;
        }
    }


    [Serializable]
    class PrimitiveIsEqA : PrimitiveIsEq
    {
#if DEBUG
        static Histogram<Type> rand1TypeHistogram = new Histogram<Type>();
#endif
        public readonly int rand0Offset;
        protected PrimitiveIsEqA (Primitive2 rator, Argument rand0, SCode rand1)
            : base (rator, rand0, rand1)
        {
            this.rand0Offset = rand0.Offset;
        }

        public static SCode Make (Primitive2 rator, Argument rand0, SCode rand1)
        {
            return
                (rand0 is Argument0) ? PrimitiveIsEqA0.Make (rator, (Argument0) rand0, rand1) :
                //(rand0 is Argument1) ? PrimitiveIsEqA1.Make (rator, (Argument1) rand0, rand1) :
                //(rand1 is Quotation) ? PrimitiveIsEqAQ.Make (rator, rand0, (Quotation) rand1) :
                new PrimitiveIsEqA (rator, rand0, rand1);
        }

        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm ("-");
            NoteCalls (this.rand1);
            rand1TypeHistogram.Note(this.rand1Type);
            SCode.location = "PrimitiveIsEqA";
#endif
            // Eval argument1
            object ev1;

            Control unev = this.rand1;
            Environment env = environment;
            while (unev.EvalStep (out ev1, ref unev, ref env)) { };
#if DEBUG
            SCode.location = "PrimitiveIsEqA";
#endif
            if (ev1 == Interpreter.UnwindStack) {
                throw new NotImplementedException ();
                //((UnwinderState) env).AddFrame (new PrimitiveCombination2Frame0 (this, environment));
                //answer = Interpreter.UnwindStack;
                //environment = env;
                //return false;
            }

            // Eval argument0
            if (ObjectModel.Eq (out answer, environment.ArgumentValue(this.rand0Offset), ev1))
                throw new NotImplementedException();
            return false;
        }
    }

    [Serializable]
    class PrimitiveIsEqA0 : PrimitiveIsEqA
    {
#if DEBUG
        static Histogram<Type> rand1TypeHistogram = new Histogram<Type>();
#endif
        protected PrimitiveIsEqA0 (Primitive2 rator, Argument0 rand0, SCode rand1)
            : base (rator, rand0, rand1)
        {
        }

        public static SCode Make (Primitive2 rator, Argument0 rand0, SCode rand1)
        {
            return
                (rand1 is PrimitiveCar) ? PrimitiveIsEqA0Car.Make (rator, rand0, (PrimitiveCar) rand1) :
                (rand1 is Quotation) ? PrimitiveIsEqA0Q.Make (rator, rand0, (Quotation) rand1) :
                new PrimitiveIsEqA0 (rator, rand0, rand1);
        }

        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm ("-");
            NoteCalls (this.rand1);
            rand1TypeHistogram.Note(this.rand1Type);
            SCode.location = "PrimitiveIsEqA0";
#endif
            // Eval argument1
            object ev1;

            Control unev = this.rand1;
            Environment env = environment;
            while (unev.EvalStep (out ev1, ref unev, ref env)) { };
#if DEBUG
            SCode.location = "PrimitiveIsEqA0";
#endif
            if (ev1 == Interpreter.UnwindStack) {
                throw new NotImplementedException ();
                //((UnwinderState) env).AddFrame (new PrimitiveCombination2Frame0 (this, environment));
                //answer = Interpreter.UnwindStack;
                //environment = env;
                //return false;
            }

            if (ObjectModel.Eq (out answer, environment.Argument0Value, ev1))
                throw new NotImplementedException();
            return false;
        }
    }

    [Serializable]
    class PrimitiveIsEqA0Car : PrimitiveIsEqA0
    {
#if DEBUG
        static Histogram<Type> rand1ArgTypeHistogram = new Histogram<Type>();
        readonly Type rand1ArgType;
#endif

        public readonly SCode rand1Arg;
        protected PrimitiveIsEqA0Car (Primitive2 rator, Argument0 rand0, PrimitiveCar rand1)
            : base (rator, rand0, rand1)
        {
            this.rand1Arg = rand1.Operand;
#if DEBUG
            this.rand1ArgType = rand1.Operand.GetType();
#endif
        }

        public static SCode Make (Primitive2 rator, Argument0 rand0, PrimitiveCar rand1)
        {
            return
                (rand1 is PrimitiveCarA) ? PrimitiveIsEqA0CarA.Make (rator, rand0, (PrimitiveCarA) rand1) :
                new PrimitiveIsEqA0Car (rator, rand0, rand1);
        }

        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm("-");
            NoteCalls(this.rand1);

            rand1ArgTypeHistogram.Note(this.rand1ArgType);
            SCode.location = "PrimitiveIsEqCarA0Car";
#endif
            // Eval argument1
            object ev1;

            Control unev = this.rand1Arg;
            Environment env = environment;
            while (unev.EvalStep(out ev1, ref unev, ref env)) { };
#if DEBUG
            SCode.location = "PrimitiveIsEqCarA0Car";
#endif
            if (ev1 == Interpreter.UnwindStack)
            {
                throw new NotImplementedException();
                //((UnwinderState) env).AddFrame (new PrimitiveCombination2Frame0 (this, environment));
                //answer = Interpreter.UnwindStack;
                //environment = env;
                //return false;
            }

            // Eval argument0
            Cons ev1Pair = ev1 as Cons;
            if (ev1Pair == null) throw new NotImplementedException();

            if (ObjectModel.Eq(out answer, environment.Argument0Value, ev1Pair.Car))
                throw new NotImplementedException();
            return false;
        }
    }

    [Serializable]
    class PrimitiveIsEqA0CarA : PrimitiveIsEqA0Car
    {
        public readonly int rand1Offset;
        protected PrimitiveIsEqA0CarA(Primitive2 rator, Argument0 rand0, PrimitiveCarA rand1)
            : base(rator, rand0, rand1)
        {
            this.rand1Offset = rand1.offset;
        }

        public static SCode Make(Primitive2 rator, Argument0 rand0, PrimitiveCarA rand1)
        {
            return
                new PrimitiveIsEqA0CarA(rator, rand0, rand1);
        }

        public override bool EvalStep(out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm("PrimitiveIsEqA0CarA");
#endif
            // Eval argument1
            Cons ev1Pair = environment.ArgumentValue(this.rand1Offset) as Cons;
            if (ev1Pair == null) throw new NotImplementedException();

            if (ObjectModel.Eq(out answer, environment.Argument0Value, ev1Pair))
                throw new NotImplementedException();
            return false;
        }
    }

    [Serializable]
    class PrimitiveIsEqA0Q : PrimitiveIsEqA0
    {
        public readonly object rand1Value;
        protected PrimitiveIsEqA0Q (Primitive2 rator, Argument0 rand0, Quotation rand1)
            : base (rator, rand0, rand1)
        {
            this.rand1Value = rand1.Quoted;
        }

        public static SCode Make (Primitive2 rator, Argument0 rand0, Quotation rand1)
        {
            return
                new PrimitiveIsEqA0Q (rator, rand0, rand1);
        }

        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm ("PrimitiveIsEqA0Q");
#endif
            if (ObjectModel.Eq (out answer, environment.Argument0Value, this.rand1Value))
                throw new NotImplementedException ();
            return false;
        }
    }

#if NIL
    [Serializable]
    class PrimitiveIsEqA0A : PrimitiveIsEqA0
    {
        protected readonly int rand1Offset;

        protected PrimitiveIsEqA0A (Primitive2 rator, Argument0 rand0, Argument rand1)
            : base (rator, rand0, rand1)
        {
            this.rand1Offset = rand1.Offset;
        }

        public static SCode Make (Primitive2 rator, Argument0 rand0, Argument rand1)
        {
            return
                (rand1 is Argument0) ? PrimitiveIsEqA0A0.Make (rator, rand0, (Argument0) rand1) :
                (rand1 is Argument1) ? PrimitiveIsEqA0A1.Make (rator, rand0, (Argument1) rand1) :
                new PrimitiveIsEqA0A (rator, rand0, rand1);
        }

        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm ("PrimitiveIsEqA0A.EvalStep");
#endif
            if (ObjectModel.Eq (out answer, environment.Argument0Value, environment.ArgumentValue (this.rand1Offset)))
                throw new NotImplementedException ();
            return false;
        }
    }

    [Serializable]
    class PrimitiveIsEqA0A0 : PrimitiveIsEqA0A
    {
        protected PrimitiveIsEqA0A0 (Primitive2 rator, Argument0 rand0, Argument0 rand1)
            : base (rator, rand0, rand1)
        {
        }

        public static SCode Make (Primitive2 rator, Argument0 rand0, Argument0 rand1)
        {
            throw new NotImplementedException ();
        }

        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
            throw new NotImplementedException ();
        }
    }



    [Serializable]
    class PrimitiveIsEqA0A1 : PrimitiveIsEqA0A
    {
        protected PrimitiveIsEqA0A1 (Primitive2 rator, Argument0 rand0, Argument1 rand1)
            : base (rator, rand0, rand1)
        {
        }

        public static SCode Make (Primitive2 rator, Argument0 rand0, Argument1 rand1)
        {
            return
                new PrimitiveIsEqA0A1 (rator, rand0, rand1);
        }

        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm ("PrimitiveIsEqA0A1.EvalStep");
#endif
            if (ObjectModel.Eq (out answer, ( environment.Argument0Value), (environment.Argument1Value)))
                throw new NotImplementedException();
            return false;
        }
    }

    [Serializable]
    class PrimitiveIsEqA0Q : PrimitiveIsEqA0
    {
        public readonly object rand1Value;

        protected PrimitiveIsEqA0Q (Primitive2 rator, Argument0 rand0, Quotation rand1)
            : base (rator, rand0, rand1)
        {
            this.rand1Value =  rand1.Quoted;
        }

        public static SCode Make (Primitive2 rator, Argument0 rand0, Quotation rand1)
        {
            return
                new PrimitiveIsEqA0Q (rator, rand0, (Quotation) rand1);
        }

        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm ("PrimitiveIsEqA0Q.EvalStep");
#endif
            if (ObjectModel.Eq (out answer, environment.Argument0Value, this.rand1Value))
                throw new NotImplementedException();
            return false;
        }
    }
#endif

    [Serializable]
    class PrimitiveIsEqA1 : PrimitiveIsEqA
    {
#if DEBUG
        static Histogram<Type> rand1TypeHistogram = new Histogram<Type>();
#endif
        protected PrimitiveIsEqA1 (Primitive2 rator, Argument1 rand0, SCode rand1)
            : base (rator, rand0, rand1)
        {
        }

        public static SCode Make (Primitive2 rator, Argument1 rand0, SCode rand1)
        {
            return
                //(rand1 is Quotation) ? PrimitiveIsEqA1Q.Make (rator, rand0, (Quotation) rand1) :
                new PrimitiveIsEqA1 (rator, rand0, rand1);
        }

        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm ("-");
            NoteCalls (this.rand1);
            rand1TypeHistogram.Note (this.rand1Type);
            SCode.location = "PrimitiveIsEqA1.EvalStep";
#endif
            // Eval argument1
            object ev1;

            Control unev = this.rand1;
            Environment env = environment;
            while (unev.EvalStep (out ev1, ref unev, ref env)) { };
#if DEBUG
            SCode.location = "PrimitiveIsEqA1.EvalStep";
#endif
            if (ev1 == Interpreter.UnwindStack) {
                throw new NotImplementedException ();
                //((UnwinderState) env).AddFrame (new PrimitiveCombination2Frame0 (this, environment));
                //answer = Interpreter.UnwindStack;
                //environment = env;
                //return false;
            }

            ObjectModel.Eq (out answer, environment.Argument1Value, ev1);
            return false;
        }
    }

    [Serializable]
    class PrimitiveIsEqA1A : PrimitiveIsEqA1
    {
        public readonly int rand1Offset;

        protected PrimitiveIsEqA1A (Primitive2 rator, Argument1 rand0, Argument rand1)
            : base (rator, rand0, rand1)
        {
            this.rand1Offset = rand1.Offset;
        }

        public static SCode Make (Primitive2 rator, Argument1 rand0, Argument rand1)
        {
            return
                (rand1 is Argument0) ? PrimitiveIsEqA1A0.Make (rator, rand0, (Argument0) rand1) :
                (rand1 is Argument1) ? Unimplemented () :
                new PrimitiveIsEqA1A (rator, rand0, rand1);
        }

        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm ("PrimitiveIsEqA1A.EvalStep");
#endif
            if (ObjectModel.Eq (out answer, environment.Argument1Value, environment.ArgumentValue(this.rand1Offset)))
                throw new NotImplementedException();
            return false;
        }
    }

    [Serializable]
    class PrimitiveIsEqA1A0 : PrimitiveIsEqA1A
    {
        protected PrimitiveIsEqA1A0 (Primitive2 rator, Argument1 rand0, Argument0 rand1)
            : base (rator, rand0, rand1)
        {
        }

        public static SCode Make (Primitive2 rator, Argument1 rand0, Argument0 rand1)
        {
            return
                 new PrimitiveIsEqA1A0 (rator, rand0, rand1);
        }

        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm ("PrimitiveIsEqA1A0");
#endif
            if (ObjectModel.Eq (out answer, environment.Argument1Value, environment.Argument0Value))
                throw new NotImplementedException();
            return false;
        }
    }

    [Serializable]
    class PrimitiveIsEqA1A1 : PrimitiveIsEqA1A
    {
        protected PrimitiveIsEqA1A1 (Primitive2 rator, Argument1 rand0, Argument1 rand1)
            : base (rator, rand0, rand1)
        {
        }

        public static SCode Make (Primitive2 rator, Argument0 rand0, Argument1 rand1)
        {
            throw new NotImplementedException ();
            //new PrimitiveIsEqA1A1 (rator, rand0, rand1);
        }

        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm ("PrimitiveIsEqA1A1");
#endif
            throw new NotImplementedException ();
        }
    }

    [Serializable]
    class PrimitiveIsEqA1Q : PrimitiveIsEqA1
    {
        public readonly object rand1Value;

        protected PrimitiveIsEqA1Q (Primitive2 rator, Argument1 rand0, Quotation rand1)
            : base (rator, rand0, rand1)
        {
            this.rand1Value =  rand1.Quoted;
        }

        public static SCode Make (Primitive2 rator, Argument1 rand0, Quotation rand1)
        {
            return
                new PrimitiveIsEqA1Q (rator, rand0, (Quotation) rand1);
        }

        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm ("PrimitiveIsEqA1Q.EvalStep");
#endif
            if (ObjectModel.Eq (out answer, environment.Argument1Value, this.rand1Value))
                throw new NotImplementedException();
            return false;
        }
    }

    [Serializable]
    class PrimitiveIsEqAA : PrimitiveIsEqA
    {
        public readonly int rand1Offset;
        protected PrimitiveIsEqAA (Primitive2 rator, Argument rand0, Argument rand1)
            : base (rator, rand0, rand1)
        {
            this.rand1Offset = rand1.Offset;
        }

        public static SCode Make (Primitive2 rator, Argument rand0, Argument rand1)
        {
            return
                (rand1 is Argument0) ? Unimplemented ()
                : (rand1 is Argument1) ? PrimitiveIsEqAA1.Make (rator, rand0, (Argument1) rand1)
                : new PrimitiveIsEqAA (rator, rand0, rand1);
        }

        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm ("PrimitiveIsEqAA");
#endif
            if (ObjectModel.Eq (out answer, environment.ArgumentValue (this.rand0Offset), environment.ArgumentValue(this.rand1Offset)))
                throw new NotImplementedException();
            return false;
        }
    }

    [Serializable]
    class PrimitiveIsEqAA0 : PrimitiveIsEqAA
    {
        protected PrimitiveIsEqAA0 (Primitive2 rator, Argument rand0, Argument0 rand1)
            : base (rator, rand0, rand1)
        {
        }

        public static SCode Make (Primitive2 rator, Argument rand0, Argument0 rand1)
        {
            return new PrimitiveIsEqAA0 (rator, rand0, rand1);
        }

        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm ("PrimitiveIsEqAA0");
#endif
            throw new NotImplementedException ();
        }
    }

    [Serializable]
    class PrimitiveIsEqAA1 : PrimitiveIsEqAA
    {
        protected PrimitiveIsEqAA1 (Primitive2 rator, Argument rand0, Argument1 rand1)
            : base (rator, rand0, rand1)
        {
        }

        public static SCode Make (Primitive2 rator, Argument rand0, Argument1 rand1)
        {
            return new PrimitiveIsEqAA1 (rator, rand0, rand1);
        }

        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm ("-");
#endif
            throw new NotImplementedException ();
        }
    }

    [Serializable]
    class PrimitiveIsEqAQ : PrimitiveIsEqA
    {
        public readonly object rand1Value;

        protected PrimitiveIsEqAQ (Primitive2 rator, Argument rand0, Quotation rand1)
            : base (rator, rand0, rand1)
        {
            this.rand1Value =  rand1.Quoted;
        }

        public static SCode Make (Primitive2 rator, Argument rand0, Quotation rand1)
        {
            return
                new PrimitiveIsEqAQ (rator, rand0, (Quotation) rand1);
        }

        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm ("PrimitiveIsEqAQ.EvalStep");
#endif
            if (ObjectModel.Eq (out answer, ( environment.ArgumentValue(this.rand0Offset)), this.rand1Value))
                throw new NotImplementedException();
            return false;
        }
    }

    [Serializable]
    class PrimitiveIsEqS : PrimitiveIsEq
    {
#if DEBUG
        static Histogram<Type> rand1TypeHistogram = new Histogram<Type> ();
#endif
        public readonly Symbol rand0Name;
        public readonly int rand0Offset;

        protected PrimitiveIsEqS (Primitive2 rator, StaticVariable rand0, SCode rand1)
            : base (rator, rand0, rand1)
        {
            this.rand0Name = rand0.Name;
            this.rand0Offset = rand0.Offset;
        }

        public static SCode Make (Primitive2 rator, StaticVariable rand0, SCode rand1)
        {
            return
                //(rand0 is Argument0) ? PrimitiveIsEqA0.Make (rator, (Argument0) rand0, rand1) :
                //(rand0 is Argument1) ? PrimitiveIsEqA1.Make (rator, (Argument1) rand0, rand1) :
                //(rand1 is Quotation) ? PrimitiveIsEqAQ.Make (rator, rand0, (Quotation) rand1) :
                new PrimitiveIsEqS (rator, rand0, rand1);
        }

        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm ("-");
            NoteCalls (this.rand1);
            rand1TypeHistogram.Note (this.rand1Type);
            SCode.location = "PrimitiveIsEqS";
#endif
            // Eval argument1
            object ev1;

            Control unev = this.rand1;
            Environment env = environment;
            while (unev.EvalStep (out ev1, ref unev, ref env)) { };
#if DEBUG
            SCode.location = "PrimitiveIsEqS";
#endif
            if (ev1 == Interpreter.UnwindStack) {
                throw new NotImplementedException ();
                //((UnwinderState) env).AddFrame (new PrimitiveCombination2Frame0 (this, environment));
                //answer = Interpreter.UnwindStack;
                //environment = env;
                //return false;
            }

            // Eval argument0
            object ev0;
            if (environment.StaticValue (out ev0, this.rand0Name, this.rand0Offset))
                throw new NotImplementedException ();

            return ObjectModel.Eq (out answer, ev0, ev1);
        }
    }


    [Serializable]
    class PrimitiveIsEqQ : PrimitiveIsEq
    {
#if DEBUG
        static Histogram<Type> rand1TypeHistogram = new Histogram<Type>();
#endif
        public readonly object rand0Value;

        protected PrimitiveIsEqQ (Primitive2 rator, Quotation rand0, SCode rand1)
            : base (rator, rand0, rand1)
        {
            this.rand0Value = rand0.Quoted;
        }

        public static SCode Make (Primitive2 rator, Quotation rand0, SCode rand1)
        {
            return
                (rand0.Quoted is char) ? PrimitiveIsCharEqQ.Make (rator, rand0, rand1) :
                (rand0.Quoted is int) ? PrimitiveIsIntEqQ.Make (rator, rand0, rand1) :
                (rand0.Quoted is Cons ||
                 rand0.Quoted is Symbol) ? PrimitiveIsObjectEqQ.Make (rator, rand0, rand1) :
                (rand1 is Quotation) ? PrimitiveIsEqQQ.Make (rator, rand0, (Quotation) rand1) :
                new PrimitiveIsEqQ (rator, rand0, rand1);
        }

        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm ("-");
            NoteCalls (this.rand1);
            rand1TypeHistogram.Note (this.rand1Type);
            SCode.location = "PrimitiveIsEqQ";
#endif
            // Eval argument1
            object ev1;

            Control unev = this.rand1;
            Environment env = environment;
            while (unev.EvalStep (out ev1, ref unev, ref env)) { };
            if (ev1 == Interpreter.UnwindStack) {
                throw new NotImplementedException ();
                //((UnwinderState) env).AddFrame (new PrimitiveCombination2Frame0 (this, environment));
                //answer = Interpreter.UnwindStack;
                //environment = env;
                //return false;
            }

            if (ObjectModel.Eq (out answer, this.rand0Value, (ev1)))
                throw new NotImplementedException();
            return false;
        }
    }

    [Serializable]
    class PrimitiveIsEqQA : PrimitiveIsEqQ
    {
        public readonly int rand1Offset;
        protected PrimitiveIsEqQA (Primitive2 rator, Quotation rand0, Argument rand1)
            : base (rator, rand0, rand1)
        {
            this.rand1Offset = rand1.Offset;
        }

        public static SCode Make (Primitive2 rator, Quotation rand0, Argument rand1)
        {
            return
                (rand1 is Argument0) ? PrimitiveIsEqQA0.Make (rator, rand0, (Argument0) rand1)
                : (rand1 is Argument1) ? PrimitiveIsEqQA1.Make (rator, rand0, (Argument1) rand1)
                : new PrimitiveIsEqQA (rator, rand0, rand1);
        }

        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm ("PrimitiveIsEqQA.EvalStep");
#endif
            if (ObjectModel.Eq (out answer, this.rand0Value , environment.ArgumentValue(this.rand1Offset)))
                throw new NotImplementedException();
            return false;
        }
    }

    [Serializable]
    class PrimitiveIsEqQA0 : PrimitiveIsEqQA
    {
        protected PrimitiveIsEqQA0 (Primitive2 rator, Quotation rand0, Argument0 rand1)
            : base (rator, rand0, rand1)
        {
        }

        public static SCode Make (Primitive2 rator, Quotation rand0, Argument0 rand1)
        {
            return
                 new PrimitiveIsEqQA0 (rator, rand0, rand1);
        }

        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm ("PrimitiveIsEqQA0.EvalStep");
#endif
            if (ObjectModel.Eq (out answer, this.rand0Value , (environment.Argument0Value)))
                throw new NotImplementedException();
            return false;
        }
    }

    [Serializable]
    class PrimitiveIsEqQA1 : PrimitiveIsEqQA
    {
        protected PrimitiveIsEqQA1 (Primitive2 rator, Quotation rand0, Argument1 rand1)
            : base (rator, rand0, rand1)
        {
        }

        public static SCode Make (Primitive2 rator, Quotation rand0, Argument1 rand1)
        {
            return
                 new PrimitiveIsEqQA1 (rator, rand0, rand1);
        }

        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm ("PrimitiveIsEqQA1.EvalStep");
#endif
            if (ObjectModel.Eq (out answer, this.rand0Value, environment.Argument1Value))
                throw new NotImplementedException();
            return false;
        }
    }

    [Serializable]
    class PrimitiveIsEqQQ : PrimitiveIsEqQ
    {
        public readonly object rand1Value;

        protected PrimitiveIsEqQQ (Primitive2 rator, Quotation rand0, Quotation rand1)
            : base (rator, rand0, rand1)
        {
            this.rand1Value =  rand1.Quoted;
        }

        public static SCode Make (Primitive2 rator, Quotation rand0, Quotation rand1)
        {
            return
                 new PrimitiveIsEqQQ (rator, rand0, rand1);
        }

        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm ("PrimitiveIsEqQQ");
#endif
            // refetch because vector may be mutable
            if (ObjectModel.Eq (out answer, this.rand0Value , (this.rand1Value)))
                throw new NotImplementedException();
            return false;
        }
    }


    [Serializable]
    class PrimitiveIsEqSA : PrimitiveIsEq
    {
        public readonly int rand1Offset;
        protected PrimitiveIsEqSA (Primitive2 rator, SCode rand0, Argument rand1)
            : base (rator, rand0, rand1)
        {
            this.rand1Offset = rand1.Offset;
        }

        public static SCode Make (Primitive2 rator, SCode rand0, Argument rand1)
        {
            return
                (rand1 is Argument0) ? PrimitiveIsEqSA0.Make (rator, rand0, (Argument0) rand1)
                : (rand1 is Argument1) ? PrimitiveIsEqSA1.Make (rator, rand0, (Argument1) rand1)
                : new PrimitiveIsEqSA (rator, rand0, rand1);
        }

        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm ("PrimitiveIsEqSA");
            NoteCalls (this.rand1);
#endif


            // Eval argument0
            object ev0;

            Control unev = this.rand0;
            Environment env = environment;
            while (unev.EvalStep (out ev0, ref unev, ref env)) { };
            if (ev0 == Interpreter.UnwindStack) {
                throw new NotImplementedException ();
                //((UnwinderState) env).AddFrame (new PrimitiveCombination2Frame0 (this, environment));
                //answer = Interpreter.UnwindStack;
                //environment = env;
                //return false;
            }

            if (ObjectModel.Eq (out answer, ( ev0), (environment.ArgumentValue(this.rand1Offset))))
                throw new NotImplementedException();
            return false;
        }

    }

    [Serializable]
    class PrimitiveIsEqSA0 : PrimitiveIsEqSA
    {
        protected PrimitiveIsEqSA0 (Primitive2 rator, SCode rand0, Argument0 rand1)
            : base (rator, rand0, rand1)
        {
        }

        public static SCode Make (Primitive2 rator, SCode rand0, Argument0 rand1)
        {
            return

                new PrimitiveIsEqSA0 (rator, rand0, rand1);
        }
        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm ("PrimitiveIsEqSA0.EvalStep");
            NoteCalls (this.rand0);
#endif
            // Eval argument0
            object ev0;

            Control unev = this.rand0;
            Environment env = environment;
            while (unev.EvalStep (out ev0, ref unev, ref env)) { };
            if (ev0 == Interpreter.UnwindStack) {
                throw new NotImplementedException ();
                //((UnwinderState) env).AddFrame (new PrimitiveCombination2Frame0 (this, environment));
                //answer = Interpreter.UnwindStack;
                //environment = env;
                //return false;
            }

            if (ObjectModel.Eq (out answer, ev0, environment.Argument0Value))
                throw new NotImplementedException();
            return false;
        }
    }

    [Serializable]
    class PrimitiveIsEqSA1 : PrimitiveIsEqSA
    {
        protected PrimitiveIsEqSA1 (Primitive2 rator, SCode rand0, Argument1 rand1)
            : base (rator, rand0, rand1)
        {
        }

        public static SCode Make (Primitive2 rator, SCode rand0, Argument1 rand1)
        {
            return

                new PrimitiveIsEqSA1 (rator, rand0, rand1);
        }
        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm ("-");
            NoteCalls (this.rand0);
            SCode.location = "PrimitiveIsEqSA1.EvalStep";
#endif

            // Eval argument0
            object ev0;

            Control unev = this.rand0;
            Environment env = environment;
            while (unev.EvalStep (out ev0, ref unev, ref env)) { };
            if (ev0 == Interpreter.UnwindStack) {
                throw new NotImplementedException ();
                //((UnwinderState) env).AddFrame (new PrimitiveCombination2Frame0 (this, environment));
                //answer = Interpreter.UnwindStack;
                //environment = env;
                //return false;
            }

            if (ObjectModel.Eq (out answer, ( ev0), (environment.Argument1Value)))
                throw new NotImplementedException();
            return false;
        }

    }

    [Serializable]
    class PrimitiveIsEqXQ : PrimitiveIsEq
    {
        public readonly object rand1Value;

        protected PrimitiveIsEqXQ (Primitive2 rator, SCode rand0, Quotation rand1)
            : base (rator, rand0, rand1)
        {
            this.rand1Value =  rand1.Quoted;
        }

        public static SCode Make (Primitive2 rator, SCode rand0, Quotation rand1)
        {
            return
                (rand1.Quoted is int) ? PrimitiveIsEqXFixnum.Make (rator, rand0, rand1) :
                (rand1.Quoted is Symbol ||
                 rand1.Quoted is Record) ? PrimitiveIsEqXObject.Make (rator, rand0, rand1) :
                new PrimitiveIsEqXQ (rator, rand0, rand1);
        }

        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm ("PrimitiveIsEqXQ.EvalStep");
            NoteCalls (this.rand0);
#endif
            // Eval argument0
            object ev0;

            Control unev = this.rand0;
            Environment env = environment;
            while (unev.EvalStep (out ev0, ref unev, ref env)) { };
            if (ev0 == Interpreter.UnwindStack) {
                throw new NotImplementedException ();
                //((UnwinderState) env).AddFrame (new PrimitiveCombination2Frame0 (this, environment));
                //answer = Interpreter.UnwindStack;
                //environment = env;
                //return false;
            }

            return ObjectModel.Eq (out answer, ev0, this.rand1Value);
        }
    }

    [Serializable]
    class PrimitiveIsEqXFixnum : PrimitiveIsEqXQ
    {
        public readonly int rand1Value;

        protected PrimitiveIsEqXFixnum (Primitive2 rator, SCode rand0, Quotation rand1)
            : base (rator, rand0, rand1)
        {
            this.rand1Value = (int) rand1.Quoted;
        }

        public static SCode Make (Primitive2 rator, SCode rand0, Quotation rand1)
        {
            return
                new PrimitiveIsEqXFixnum (rator, rand0, rand1);
        }

        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm ("PrimitiveIsEqXFixnum");
            NoteCalls (this.rand0);
#endif
            // Eval argument0
            object ev0;

            Control unev = this.rand0;
            Environment env = environment;
            while (unev.EvalStep (out ev0, ref unev, ref env)) { };
            if (ev0 == Interpreter.UnwindStack) {
                throw new NotImplementedException ();
                //((UnwinderState) env).AddFrame (new PrimitiveCombination2Frame0 (this, environment));
                //answer = Interpreter.UnwindStack;
                //environment = env;
                //return false;
            }
            answer = ev0 is int && (((int) ev0) == this.rand1Value);
            return false;
        }
    }

    [Serializable]
    class PrimitiveIsEqXObject : PrimitiveIsEqXQ
    {
        public readonly object rand1Value;

        protected PrimitiveIsEqXObject (Primitive2 rator, SCode rand0, Quotation rand1)
            : base (rator, rand0, rand1)
        {
            this.rand1Value = rand1.Quoted;
        }

        public static SCode Make (Primitive2 rator, SCode rand0, Quotation rand1)
        {
            return
                new PrimitiveIsEqXObject (rator, rand0, rand1);
        }

        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm ("-");
            NoteCalls (this.rand0);
            SCode.location = "PrimitiveIsEqXObject";
#endif
            // Eval argument0
            object ev0;

            Control unev = this.rand0;
            Environment env = environment;
            while (unev.EvalStep (out ev0, ref unev, ref env)) { };
            if (ev0 == Interpreter.UnwindStack) {
                throw new NotImplementedException ();
                //((UnwinderState) env).AddFrame (new PrimitiveCombination2Frame0 (this, environment));
                //answer = Interpreter.UnwindStack;
                //environment = env;
                //return false;
            }
            answer = ev0 == this.rand1Value;
            return false;
        }
    }

    [Serializable]
    class PrimitiveIsCharEqQ : PrimitiveIsEqQ
    {
#if DEBUG
        static Histogram<Type> rand1TypeHistogram = new Histogram<Type> ();
#endif
        public readonly char rand0Value;

        protected PrimitiveIsCharEqQ (Primitive2 rator, Quotation rand0, SCode rand1)
            : base (rator, rand0, rand1)
        {
            this.rand0Value = (char) rand0.Quoted;
        }

        public static SCode Make (Primitive2 rator, Quotation rand0, SCode rand1)
        {
            return
                new PrimitiveIsCharEqQ (rator, rand0, rand1);
        }


        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm ("-");
            NoteCalls (this.rand1);
            rand1TypeHistogram.Note (this.rand1Type);
            SCode.location = "PrimitiveIsCharEqQ";
#endif
            // Eval argument1
            object ev1;

            Control unev = this.rand1;
            Environment env = environment;
            while (unev.EvalStep (out ev1, ref unev, ref env)) { };
            if (ev1 == Interpreter.UnwindStack) {
                throw new NotImplementedException ();
                //((UnwinderState) env).AddFrame (new PrimitiveCombination2Frame0 (this, environment));
                //answer = Interpreter.UnwindStack;
                //environment = env;
                //return false;
            }

            answer = (ev1 is char) && (this.rand0Value == (char) ev1);
            return false;
        }
    }


    [Serializable]
    class PrimitiveIsIntEqQ : PrimitiveIsEqQ
    {
#if DEBUG
        static Histogram<Type> rand1TypeHistogram = new Histogram<Type> ();
#endif
        public readonly int rand0Value;

        protected PrimitiveIsIntEqQ (Primitive2 rator, Quotation rand0, SCode rand1)
            : base (rator, rand0, rand1)
        {
            this.rand0Value = (int) rand0.Quoted;
        }

        public static SCode Make (Primitive2 rator, Quotation rand0, SCode rand1)
        {
            return
                new PrimitiveIsIntEqQ (rator, rand0, rand1);
        }


        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm ("-");
            NoteCalls (this.rand1);
            rand1TypeHistogram.Note (this.rand1Type);
            SCode.location = "PrimitiveIsIntEqQ";
#endif
            // Eval argument1
            object ev1;

            Control unev = this.rand1;
            Environment env = environment;
            while (unev.EvalStep (out ev1, ref unev, ref env)) { };
            if (ev1 == Interpreter.UnwindStack) {
                throw new NotImplementedException ();
                //((UnwinderState) env).AddFrame (new PrimitiveCombination2Frame0 (this, environment));
                //answer = Interpreter.UnwindStack;
                //environment = env;
                //return false;
            }

            answer = (ev1 is int) && (this.rand0Value == (int)ev1);
            return false;
        }
    }


    [Serializable]
    class PrimitiveIsObjectEqQ : PrimitiveIsEqQ
    {
#if DEBUG
        static Histogram<Type> rand1TypeHistogram = new Histogram<Type> ();
#endif
        public readonly object rand0Value;

        protected PrimitiveIsObjectEqQ (Primitive2 rator, Quotation rand0, SCode rand1)
            : base (rator, rand0, rand1)
        {
            this.rand0Value = rand0.Quoted;
        }

        public static SCode Make (Primitive2 rator, Quotation rand0, SCode rand1)
        {
            return
                new PrimitiveIsObjectEqQ (rator, rand0, rand1);
        }


        public override bool EvalStep (out object answer, ref Control expression, ref Environment environment)
        {
#if DEBUG
            Warm ("-");
            NoteCalls (this.rand1);
            rand1TypeHistogram.Note (this.rand1Type);
            SCode.location = "PrimitiveIsObjectEqQ";
#endif
            // Eval argument1
            object ev1;

            Control unev = this.rand1;
            Environment env = environment;
            while (unev.EvalStep (out ev1, ref unev, ref env)) { };
            if (ev1 == Interpreter.UnwindStack) {
                //throw new NotImplementedException ();
                ((UnwinderState) env).AddFrame (new PrimitiveCombination2Frame0 (this, environment));
                answer = Interpreter.UnwindStack;
                environment = env;
                return false;
            }

            answer = (this.rand0Value == ev1);
            return false;
        }
    }

}
