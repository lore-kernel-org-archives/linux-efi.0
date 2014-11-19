From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [efi:next 2/3] arch/x86/boot/compressed/eboot.c:26:16: sparse:
 incorrect type in return expression (different modifiers)
Date: Wed, 19 Nov 2014 12:31:08 +0100
Message-ID: <CAKv+Gu93S6bRjAoOnWdvkAmqRtaSK2z3mzP0czdttVQPuC0sSQ@mail.gmail.com>
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
	<CAKv+Gu_2uwTdDT=7ghM6e2-=TpH652Q-JOOwF6oFsGFLxeKueg@mail.gmail.com>
	<CANeU7Q=uCR6P41F72J0X6c2=fgU5eefPj1NrzfnoYRtCuzYxYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANeU7Q=uCR6P41F72J0X6c2=fgU5eefPj1NrzfnoYRtCuzYxYg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christopher Li <sparse-55XgFHCVCFZAfugRpC6u6w@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-Sparse <linux-sparse-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "fengguang.wu" <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 19 November 2014 03:53, Christopher Li <sparse-55XgFHCVCFZAfugRpC6u6w@public.gmane.org> wrote:
> On Wed, Nov 19, 2014 at 12:38 AM, Ard Biesheuvel
> <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> Well, that is how sparse currently treats it, and I think that is correct.
>> If an extern declaration in a .h file specifies  __pure, then GCC may
>> legally emit fewer calls to that function than appear in the source.
>> So if the actual implementation in the .c file is not __pure, then you
>> have an error.
>
> OK. I just want to figure out what is the right thing to do here.
> It is ambiguous when the second time function declare without pure attribute,
> weather it should follow the incremental declare rule or conflicting error.
>
> If follow the C incremental declare rule, there is no error there.
> It just an incomplete declare, compiler will internally merge all the
> declare in the same scope and apply that to the final function.
>
> e.g.
> static __attribute__((noreturn)) void deadloop(void);
>
> static void deadloop(void)
> {
> }
>
> gcc will treat the second deadloop() function has noreturn attribute,
> even though it does not have one in the second time declare.
> That is why Gcc warns the function does return:
>  /tmp/noreturn.c: In function 'deadloop':
> /tmp/noreturn.c:6:1: warning: 'noreturn' function does return [enabled
> by default]
>  }
>
> I try it on gcc, gcc does not emit error for the pure attribute conflicting.
> That seems indicate gcc follow the incremental declare rule rather than
> conflicting error.
>

That may be the case, but GCC also does not warn if you are violating
the pureness rules.
For example, this function

__attribute__((__pure__)) int foo(void)
{
  static int i = 0;
  return ++i;
}

is obviously not pure, but GCC does not warn about that. But yes, GCC
follows the incremental rule, so if you mark a function as 'pure' only
in the header file, but not in the definition, then it will still be
considered pure.

> Sparse has the symbol->same_symbol chain for that reason as well.
> It can be used for merging different declare of the same function.
> Some declare provide more detail specification, some did not.
>
>> """
>> static __attribute__((__pure__)) int pure2(void)
>> {
>> int i = 0;
>> return i;
>> }
>> static int pure2(void); // error here
>> """
>
> See above. I am not sure that is an error here if we follow
> the incremental declare rule.
>

I think you are right. It is fairly common practice to define
attributes for a function /definition/ by preceding it with a
definition. e.g.,

int foo(void) __attribute__((__pure__));
int foo(void)
{
  static int i = 0;
  return ++i;
}

so this is obviously not an error.

So bottom line is that GCC does not warn about violating pureness
rules, and using the incremental declare rule seems appropriate, so
perhaps sparse should ignore pure altogether?

-- 
Ard.
