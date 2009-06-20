﻿using System;
using System.Diagnostics;
using System.Runtime.Serialization;
using System.Security.Permissions;

namespace Microcode
{
    [Serializable]
    public sealed class Constant : SchemeObject, ISerializable
    {
        [DebuggerBrowsable (DebuggerBrowsableState.Never)]
        public static object sharpT = true;
        [DebuggerBrowsable (DebuggerBrowsableState.Never)]
        public static Constant theDefaultObject;
        [DebuggerBrowsable (DebuggerBrowsableState.Never)]
        public static Constant theEofObject;
        [DebuggerBrowsable (DebuggerBrowsableState.Never)]
        public static Constant theAuxMarker;
        [DebuggerBrowsable (DebuggerBrowsableState.Never)]
        public static Constant theKeyMarker;
        [DebuggerBrowsable (DebuggerBrowsableState.Never)]
        public static Constant theOptionalMarker;
        [DebuggerBrowsable (DebuggerBrowsableState.Never)]
        public static Constant theRestMarker;
        [DebuggerBrowsable (DebuggerBrowsableState.Never)]
        public static Constant theExternalUnassignedObject;
        [DebuggerBrowsable (DebuggerBrowsableState.Never)]
        public static Constant theUnspecificObject;
        [DebuggerBrowsable (DebuggerBrowsableState.Never)]
        public static object sharpF = false;

        [DebuggerBrowsable (DebuggerBrowsableState.Never)]
        string name;

        private Constant (string name)
            : base (TC.CONSTANT)
        {
            this.name = name;
        }

        public override string ToString ()
        {
            return "#!" + this.name;
        }

        internal static object Decode (uint code)
        {
            switch (code)
            {
                case 0:
                    return sharpT;
                case 1:
                    return Unspecific;
                case 2:
                    return ExternalUnassigned;
                case 3:
                    return LambdaOptionalTag;
                case 4:
                    return LambdaRestTag;
                case 5:
                    return LambdaKeyTag;
                case 6:
                    return EofObject;
                case 7:
                    return DefaultObject;
                case 8:
                    return LambdaAuxTag;
                case 9:
                    return null;
                default:
                    throw new NotImplementedException ();
            }
        }

        public static Constant DefaultObject
        {
            [DebuggerStepThrough]
            get
            {
                if (theDefaultObject == null)
                    theDefaultObject = new Constant ("default");
                return theDefaultObject;
            }
        }

        public static Constant EofObject
        {
            [DebuggerStepThrough]
            get
            {
                if (theEofObject == null)
                    theEofObject = new Constant("eof");
                return theEofObject;
            }
        }

        public static Constant LambdaAuxTag
        {
            [DebuggerStepThrough]
            get
            {
                if (theAuxMarker == null)
                    theAuxMarker = new Constant ("theAuxMarker");
                return theAuxMarker;
            }
        }

        public static Constant LambdaKeyTag
        {
            [DebuggerStepThrough]
            get
            {
                if (theKeyMarker == null)
                    theKeyMarker = new Constant ("theKeyMarker");
                return theKeyMarker;
            }
        }


        public static Constant LambdaOptionalTag
        {
            [DebuggerStepThrough]
            get
            {
                if (theOptionalMarker == null)
                    theOptionalMarker = new Constant ("theOptionalMarker");
                return theOptionalMarker;
            }
        }

        public static Constant LambdaRestTag
        {
            [DebuggerStepThrough]
            get
            {
                if (theRestMarker == null)
                    theRestMarker = new Constant ("theRestMarker");
                return theRestMarker;
            }
        }

        public static Constant ExternalUnassigned
        {
            [DebuggerStepThrough]
            get
            {
                if (theExternalUnassignedObject == null)
                    theExternalUnassignedObject = new Constant ("Unassigned");
                return theExternalUnassignedObject;
            }
        }

        public static Constant Unspecific
        {
            [DebuggerStepThrough]
            get
            {
                if (theUnspecificObject == null)
                    theUnspecificObject = new Constant ("Unspecific");
                return theUnspecificObject;
            }
        }

        [SecurityPermissionAttribute (SecurityAction.LinkDemand, Flags = SecurityPermissionFlag.SerializationFormatter)]
        void ISerializable.GetObjectData (SerializationInfo info, StreamingContext context)
        {
            info.SetType (typeof (ConstantDeserializer));
            info.AddValue ("name", this.name);
        }
    }

    [Serializable]
    internal sealed class ConstantDeserializer : IObjectReference
    {
        String name;

        Object BadConstant ()
        {
            throw new NotImplementedException ();
        }

        public Object GetRealObject (StreamingContext context)
        {
            return
                this.name == "default" ? Constant.DefaultObject :
                this.name == "eof" ? Constant.EofObject :
                this.name == "theAuxMarker" ? Constant.LambdaAuxTag :
                this.name == "theKeyMarker" ? Constant.LambdaKeyTag :
                this.name == "theOptionalMarker" ? Constant.LambdaOptionalTag :
                this.name == "theRestMarker" ? Constant.LambdaRestTag :
                this.name == "Unassigned" ? Constant.ExternalUnassigned :
                this.name == "Unspecific" ? Constant.Unspecific :
                BadConstant ();
        }

        // shut up compiler
        public void SetName (String name) { this.name = name; }
    }
}
