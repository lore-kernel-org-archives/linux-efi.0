From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [efi:next 2/3] arch/x86/boot/compressed/eboot.c:26:16: sparse:
 incorrect type in return expression (different modifiers)
Date: Sun, 16 Nov 2014 18:58:44 +0100
Message-ID: <CAKv+Gu8DB6tCrpTqiCSWDGU4cRO1u3hqO9-K-cON5ODDMgsx1Q@mail.gmail.com>
References: <201411120724.PdeIjimc%fengguang.wu@intel.com>
	<CAKv+Gu8Jk4z6Q+8ZstNrA5e0ictYnzq9XOeq8zbr8ADo5DyWow@mail.gmail.com>
	<1415799312.14686.332.camel@mfleming-mobl1.ger.corp.intel.com>
	<CANeU7Qn8J2dn4V5Mx1WzUM9q+m=K66yUuEkN39bH_djRoBzqNA@mail.gmail.com>
	<CAKv+Gu-L2EoqioZamh9arLSkXzQF4y=FDykk0YK1XvNkRGC-xg@mail.gmail.com>
	<CANeU7Q=6mB2yoSy9PpnNjeYcvvzD8DEUyyeXQhW2YE2aSGq_gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-sparse-owner@vger.kernel.org>
In-Reply-To: <CANeU7Q=6mB2yoSy9PpnNjeYcvvzD8DEUyyeXQhW2YE2aSGq_gg@mail.gmail.com>
Sender: linux-sparse-owner@vger.kernel.org
To: Christopher Li <sparse@chrisli.org>
Cc: Matt Fleming <matt.fleming@intel.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux-Sparse <linux-sparse@vger.kernel.org>, "fengguang.wu" <fengguang.wu@intel.com>
List-Id: linux-efi@vger.kernel.org

On 16 November 2014 11:13, Christopher Li <sparse@chrisli.org> wrote:
> On Wed, Nov 12, 2014 at 11:34 PM, Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
>>
>> Well, I spent some time playing around with this:
>>
>> This one is accepted:
>>
>> static __attribute__((__pure__)) int pure1(void)
>> {
>>     int i = 0;
>>     return i;
>> }
>>
>> This one is not accepted:
>>
>> static __attribute__((__pure__)) void *pure2(void)
>> {
>>     void *i = (void *)0;
>>     return i;
>> }
>>
>
> Thanks for the test case. I have commit your test case with a bit more
> test case regarding function pointer assign.
>
> The change is in chrisl repository reveiw-pure-attr branch:
> https://git.kernel.org/cgit/devel/sparse/chrisl/sparse.git/log/?h=review-pure-attr
>
> I purpose this fix for it. It can pass your test case.
> This patch limit the pure attribute to functions.
> The pure bit should not be a modifier in the first place.
> But that is a much bigger change.
>
> Can you please help me test and review the change?
>

Sure!

I can confirm that this patch removes the incorrect warning during the
kernel build that triggered all of this.
However, I think your testcase is not quite correct: in particular,
this assignment

static void*(*f1_err)(void) = pure1;

is perfectly ok: it is fine to call a pure function through a non-pure
function pointer, but not the other way around. For instance, looking
at the efi example

arch/x86/boot/compressed/eboot.h:

__pure const struct efi_config *__efi_early(void);

#define efi_call_early(f, ...)                                         \
       __efi_early()->call(__efi_early()->f, __VA_ARGS__);

Note the 2 calls to __efi_early(). The purpose of __pure here is to
instruct GCC to emit only a single call to __efi_early(), because it
will return the same value both times.

In other words, GCC is allowed emit fewer calls to a __pure function
than there are calls in the source, and the same applies to calls
through a pure function pointer. However, if the pure pointer points
to a function that is not pure, i.e., back-to-back invocations may
legally return different results, then calling it through a pure
pointer is a bug, and needs to be flagged.

Regards,
Ard.




> diff --git a/evaluate.c b/evaluate.c
> index 035e448..4c8b64a 100644
> --- a/evaluate.c
> +++ b/evaluate.c
> @@ -632,6 +632,8 @@ const char *type_difference(struct ctype *c1,
> struct ctype *c2,
>         struct symbol *t1 = c1->base_type;
>         struct symbol *t2 = c2->base_type;
>         int move1 = 1, move2 = 1;
> +       unsigned long ignore = ~MOD_PURE;
> +
>         mod1 |= c1->modifiers;
>         mod2 |= c2->modifiers;
>         for (;;) {
> @@ -728,6 +730,7 @@ const char *type_difference(struct ctype *c1,
> struct ctype *c2,
>                         as1 = t1->ctype.as;
>                         mod2 = t2->ctype.modifiers;
>                         as2 = t2->ctype.as;
> +                       ignore = ~0;
>
>                         if (base1->variadic != base2->variadic)
>                                 return "incompatible variadic arguments";
> @@ -778,7 +781,7 @@ const char *type_difference(struct ctype *c1,
> struct ctype *c2,
>         }
>         if (as1 != as2)
>                 return "different address spaces";
> -       if ((mod1 ^ mod2) & ~MOD_IGNORE & ~MOD_SIGNEDNESS)
> +       if ((mod1 ^ mod2) & ~MOD_IGNORE & ~MOD_SIGNEDNESS & ignore)
>                 return "different modifiers";
>         return NULL;
>  }
> diff --git a/show-parse.c b/show-parse.c
> index fb54375..f274431 100644
> --- a/show-parse.c
> +++ b/show-parse.c
> @@ -326,6 +326,7 @@ deeper:
>                         was_ptr = 0;
>                 }
>                 append(name, "( ... )");
> +               mod = sym->ctype.modifiers;
>                 break;
>
>         case SYM_STRUCT:
