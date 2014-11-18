From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [efi:next 2/3] arch/x86/boot/compressed/eboot.c:26:16: sparse:
 incorrect type in return expression (different modifiers)
Date: Tue, 18 Nov 2014 17:38:28 +0100
Message-ID: <CAKv+Gu_2uwTdDT=7ghM6e2-=TpH652Q-JOOwF6oFsGFLxeKueg@mail.gmail.com>
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
	<CANeU7Q=tQOotWvG+LcrWBqgDYMANaB71Gr_nv15jS9_0EiUetg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-sparse-owner@vger.kernel.org>
In-Reply-To: <CANeU7Q=tQOotWvG+LcrWBqgDYMANaB71Gr_nv15jS9_0EiUetg@mail.gmail.com>
Sender: linux-sparse-owner@vger.kernel.org
To: Christopher Li <sparse@chrisli.org>
Cc: Matt Fleming <matt.fleming@intel.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux-Sparse <linux-sparse@vger.kernel.org>, "fengguang.wu" <fengguang.wu@intel.com>
List-Id: linux-efi@vger.kernel.org

On 18 November 2014 17:09, Christopher Li <sparse@chrisli.org> wrote:
> On Tue, Nov 18, 2014 at 12:24 AM, Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
>>
>> No, the test case looks correct now. You may want to add a conflicting
>> definition, for completeness, as that is an important case for sparse
>> to verify.
>> So you could just add
>>
>> static void *pure1(void); // conflicting declaration
>
> Just to confirm. If function declare as non pure then second time
> declare as pure, that  is a conflict error. That is very different from other
> C attributes. C allow function declare attribute incrementally.
>
> If what you said is true, then pure attribute is actually acting like a modifier
> which don't fix not other non pure attribute.
>

Well, that is how sparse currently treats it, and I think that is correct.
If an extern declaration in a .h file specifies  __pure, then GCC may
legally emit fewer calls to that function than appear in the source.
So if the actual implementation in the .c file is not __pure, then you
have an error.

>> at the bottom, and ensure it is flagged by sparse as an error after
>> you make your changes.
>
> I am curios how does GCC behave on this incremental declare of pure
> attribute. I just test it. GCC does not warn on the conflicting declare.
>
> GCC seems warn on some thing shouldn't warn on the test case:
>
> function "f2_ok" and "f5" shouldn't been warned. Strange.
>
> validation/pure-function.c:14:1: warning: '__pure__' attribute ignored
> [-Wattributes]
>  static __attribute__((__pure__)) void*(*f2_ok)(void) = pure1;
>  ^
> validation/pure-function.c:15:1: warning: '__pure__' attribute ignored
> [-Wattributes]
>  static __attribute__((__pure__)) void*(*f3_error)(void) = non_pure1;
>  ^
> validation/pure-function.c:29:1: warning: '__pure__' attribute ignored
> [-Wattributes]
>  static __attribute__((__pure__)) int(*f5)(void) = pure2;
>  ^
> validation/pure-function.c:30:1: warning: '__pure__' attribute ignored
> [-Wattributes]
>  static __attribute__((__pure__)) int(*f6_error)(void) = non_pure2;
>

My apologies. It appears GCC ignores pure attributes on function
pointers, so the assignments are all legal. Sorry to have wasted your
time on this.

So what remains imo is

"""
static __attribute__((__pure__)) void *pure1(void)
{
void *i = (void *)0;
return i;
}

static __attribute__((__pure__)) int pure2(void)
{
int i = 0;
return i;
}
static int pure2(void); // error here
"""

and all the other stuff can be dropped.

Regards,
Ard.
