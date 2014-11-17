From: Christopher Li <sparse-55XgFHCVCFZAfugRpC6u6w@public.gmane.org>
Subject: Re: [efi:next 2/3] arch/x86/boot/compressed/eboot.c:26:16: sparse:
 incorrect type in return expression (different modifiers)
Date: Mon, 17 Nov 2014 08:38:06 +0800
Message-ID: <CANeU7Qmo4t42N6A7ktB9GL2Ho0K9RqkJq3g0jn7s-qb5V2Ly9Q@mail.gmail.com>
References: <201411120724.PdeIjimc%fengguang.wu@intel.com>
	<CAKv+Gu8Jk4z6Q+8ZstNrA5e0ictYnzq9XOeq8zbr8ADo5DyWow@mail.gmail.com>
	<1415799312.14686.332.camel@mfleming-mobl1.ger.corp.intel.com>
	<CANeU7Qn8J2dn4V5Mx1WzUM9q+m=K66yUuEkN39bH_djRoBzqNA@mail.gmail.com>
	<CAKv+Gu-L2EoqioZamh9arLSkXzQF4y=FDykk0YK1XvNkRGC-xg@mail.gmail.com>
	<CANeU7Q=6mB2yoSy9PpnNjeYcvvzD8DEUyyeXQhW2YE2aSGq_gg@mail.gmail.com>
	<CAKv+Gu8DB6tCrpTqiCSWDGU4cRO1u3hqO9-K-cON5ODDMgsx1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu8DB6tCrpTqiCSWDGU4cRO1u3hqO9-K-cON5ODDMgsx1Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-Sparse <linux-sparse-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "fengguang.wu" <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Nov 17, 2014 at 1:58 AM, Ard Biesheuvel
<ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> I can confirm that this patch removes the incorrect warning during the
> kernel build that triggered all of this.
> However, I think your testcase is not quite correct: in particular,
> this assignment
>
> static void*(*f1_err)(void) = pure1;

I see. Thanks for the review. So the above case should not raise
error. However, the following one should:

static __pure void *(*f3_err) = non_pure_func;

I got it the other way around. I will add that to the test case
and send out the second round review.

> Note the 2 calls to __efi_early(). The purpose of __pure here is to
> instruct GCC to emit only a single call to __efi_early(), because it
> will return the same value both times.

That is good to know.

> In other words, GCC is allowed emit fewer calls to a __pure function
> than there are calls in the source, and the same applies to calls
> through a pure function pointer. However, if the pure pointer points
> to a function that is not pure, i.e., back-to-back invocations may
> legally return different results, then calling it through a pure
> pointer is a bug, and needs to be flagged.

I am convinced :-)

Chris
