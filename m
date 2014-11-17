From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [efi:next 2/3] arch/x86/boot/compressed/eboot.c:26:16: sparse:
 incorrect type in return expression (different modifiers)
Date: Mon, 17 Nov 2014 17:24:44 +0100
Message-ID: <CAKv+Gu-c4qk-Snkc6Vs=LKwCnxVTMeBmgGjWT4qxapi-nTYX+w@mail.gmail.com>
References: <201411120724.PdeIjimc%fengguang.wu@intel.com>
	<CAKv+Gu8Jk4z6Q+8ZstNrA5e0ictYnzq9XOeq8zbr8ADo5DyWow@mail.gmail.com>
	<1415799312.14686.332.camel@mfleming-mobl1.ger.corp.intel.com>
	<CANeU7Qn8J2dn4V5Mx1WzUM9q+m=K66yUuEkN39bH_djRoBzqNA@mail.gmail.com>
	<CAKv+Gu-L2EoqioZamh9arLSkXzQF4y=FDykk0YK1XvNkRGC-xg@mail.gmail.com>
	<CANeU7Q=6mB2yoSy9PpnNjeYcvvzD8DEUyyeXQhW2YE2aSGq_gg@mail.gmail.com>
	<CAKv+Gu8DB6tCrpTqiCSWDGU4cRO1u3hqO9-K-cON5ODDMgsx1Q@mail.gmail.com>
	<CANeU7Qmo4t42N6A7ktB9GL2Ho0K9RqkJq3g0jn7s-qb5V2Ly9Q@mail.gmail.com>
	<CANeU7QkZKv+c1y-_9DsvV-EqKnmm+NjUEGxhZBqSF_5AJ+XT1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANeU7QkZKv+c1y-_9DsvV-EqKnmm+NjUEGxhZBqSF_5AJ+XT1g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christopher Li <sparse-55XgFHCVCFZAfugRpC6u6w@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-Sparse <linux-sparse-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "fengguang.wu" <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 17 November 2014 16:35, Christopher Li <sparse-55XgFHCVCFZAfugRpC6u6w@public.gmane.org> wrote:
> On Mon, Nov 17, 2014 at 8:38 AM, Christopher Li <sparse-55XgFHCVCFZAfugRpC6u6w@public.gmane.org> wrote:
>> I see. Thanks for the review. So the above case should not raise
>> error. However, the following one should:
>>
>> static __pure void *(*f3_err) = non_pure_func;
>>
>> I got it the other way around. I will add that to the test case
>> and send out the second round review.
>
> I send push out the v2 version of the test case at
> https://git.kernel.org/cgit/devel/sparse/chrisl/sparse.git/log/?h=review-pure-attr2
>
> I haven't include the fix part yet. Do you see any thing wrong with the test
> case?
>

No, the test case looks correct now. You may want to add a conflicting
definition, for completeness, as that is an important case for sparse
to verify.
So you could just add

static void *pure1(void); // conflicting declaration

at the bottom, and ensure it is flagged by sparse as an error after
you make your changes.

-- 
Ard.
