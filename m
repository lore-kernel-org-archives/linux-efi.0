From: Christopher Li <sparse-55XgFHCVCFZAfugRpC6u6w@public.gmane.org>
Subject: Re: [efi:next 2/3] arch/x86/boot/compressed/eboot.c:26:16: sparse:
 incorrect type in return expression (different modifiers)
Date: Wed, 19 Nov 2014 00:09:37 +0800
Message-ID: <CANeU7Q=tQOotWvG+LcrWBqgDYMANaB71Gr_nv15jS9_0EiUetg@mail.gmail.com>
References: <201411120724.PdeIjimc%fengguang.wu@intel.com>
	<CAKv+Gu8Jk4z6Q+8ZstNrA5e0ictYnzq9XOeq8zbr8ADo5DyWow@mail.gmail.com>
	<1415799312.14686.332.camel@mfleming-mobl1.ger.corp.intel.com>
	<CANeU7Qn8J2dn4V5Mx1WzUM9q+m=K66yUuEkN39bH_djRoBzqNA@mail.gmail.com>
	<CAKv+Gu-L2EoqioZamh9arLSkXzQF4y=FDykk0YK1XvNkRGC-xg@mail.gmail.com>
	<CANeU7Q=6mB2yoSy9PpnNjeYcvvzD8DEUyyeXQhW2YE2aSGq_gg@mail.gmail.com>
	<CAKv+Gu8DB6tCrpTqiCSWDGU4cRO1u3hqO9-K-cON5ODDMgsx1Q@mail.gmail.com>
	<CANeU7Qmo4t42N6A7ktB9GL2Ho0K9RqkJq3g0jn7s-qb5V2Ly9Q@mail.gmail.com>
	<CANeU7QkZKv+c1y-_9DsvV-EqKnmm+NjUEGxhZBqSF_5AJ+XT1g@mail.gmail.com>
	<CAKv+Gu-c4qk-Snkc6Vs=LKwCnxVTMeBmgGjWT4qxapi-nTYX+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu-c4qk-Snkc6Vs=LKwCnxVTMeBmgGjWT4qxapi-nTYX+w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-Sparse <linux-sparse-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "fengguang.wu" <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 18, 2014 at 12:24 AM, Ard Biesheuvel
<ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>
> No, the test case looks correct now. You may want to add a conflicting
> definition, for completeness, as that is an important case for sparse
> to verify.
> So you could just add
>
> static void *pure1(void); // conflicting declaration

Just to confirm. If function declare as non pure then second time
declare as pure, that  is a conflict error. That is very different from other
C attributes. C allow function declare attribute incrementally.

If what you said is true, then pure attribute is actually acting like a modifier
which don't fix not other non pure attribute.

> at the bottom, and ensure it is flagged by sparse as an error after
> you make your changes.

I am curios how does GCC behave on this incremental declare of pure
attribute. I just test it. GCC does not warn on the conflicting declare.

GCC seems warn on some thing shouldn't warn on the test case:

function "f2_ok" and "f5" shouldn't been warned. Strange.

validation/pure-function.c:14:1: warning: '__pure__' attribute ignored
[-Wattributes]
 static __attribute__((__pure__)) void*(*f2_ok)(void) = pure1;
 ^
validation/pure-function.c:15:1: warning: '__pure__' attribute ignored
[-Wattributes]
 static __attribute__((__pure__)) void*(*f3_error)(void) = non_pure1;
 ^
validation/pure-function.c:29:1: warning: '__pure__' attribute ignored
[-Wattributes]
 static __attribute__((__pure__)) int(*f5)(void) = pure2;
 ^
validation/pure-function.c:30:1: warning: '__pure__' attribute ignored
[-Wattributes]
 static __attribute__((__pure__)) int(*f6_error)(void) = non_pure2;


Chris
