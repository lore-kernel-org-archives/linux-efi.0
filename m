From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [efi:next 2/3] arch/x86/boot/compressed/eboot.c:26:16: sparse:
 incorrect type in return expression (different modifiers)
Date: Wed, 12 Nov 2014 16:34:33 +0100
Message-ID: <CAKv+Gu-L2EoqioZamh9arLSkXzQF4y=FDykk0YK1XvNkRGC-xg@mail.gmail.com>
References: <201411120724.PdeIjimc%fengguang.wu@intel.com>
	<CAKv+Gu8Jk4z6Q+8ZstNrA5e0ictYnzq9XOeq8zbr8ADo5DyWow@mail.gmail.com>
	<1415799312.14686.332.camel@mfleming-mobl1.ger.corp.intel.com>
	<CANeU7Qn8J2dn4V5Mx1WzUM9q+m=K66yUuEkN39bH_djRoBzqNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANeU7Qn8J2dn4V5Mx1WzUM9q+m=K66yUuEkN39bH_djRoBzqNA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christopher Li <sparse-55XgFHCVCFZAfugRpC6u6w@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-Sparse <linux-sparse-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "fengguang.wu" <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 12 November 2014 16:22, Christopher Li <sparse-55XgFHCVCFZAfugRpC6u6w@public.gmane.org> wrote:
> On Wed, Nov 12, 2014 at 9:35 PM, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> (Pulling sparse list in)
>>
>> On Wed, 2014-11-12 at 11:31 +0100, Ard Biesheuvel wrote:
>>> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git next
>>> >>> arch/x86/boot/compressed/eboot.c:26:16: sparse: incorrect type in return expression (different modifiers)
>>> >    arch/x86/boot/compressed/eboot.c:26:16:    expected struct efi_config const [pure] *
>>> >    arch/x86/boot/compressed/eboot.c:26:16:    got struct efi_config *static [toplevel] efi_early
>>> >
>>>
>>> This smells like a sparse bug: __pure applies to functions only, so
>>> there is no way we could ever return something with the __pure
>>> modifier attached.
>
> That make sense.
>
>>
>> Yes, that warning does look a little strange.
>>
>> Christopher, Fengguang, what do you guys think?
>>
>
> Do you get me a small test function that reproduce the error with sparse?
>
> We can even add a test case for it.
>

Well, I spent some time playing around with this:

This one is accepted:

static __attribute__((__pure__)) int pure1(void)
{
    int i = 0;
    return i;
}

This one is not accepted:

static __attribute__((__pure__)) void *pure2(void)
{
    void *i = (void *)0;
    return i;
}

and produces

pure.c:11:16: warning: incorrect type in return expression (different modifiers)
pure.c:11:16:    expected void [pure] *
pure.c:11:16:    got void *i

I also noticed that the following triggers a warning as well:

static void*(*f)(void) = pure2;

(using the definition of pure2 as above)

pure.c:14:26: warning: incorrect type in initializer (different modifiers)
pure.c:14:26:    expected void *( *static [toplevel] f )( ... )
pure.c:14:26:    got void [pure] *( static [toplevel] *<noident> )( ... )

i.e., you are not allowed to assign a pointer to a pure function to a
non-pure function pointer, which is quite ok. The opposite should be
an error, though.

This patch

diff --git a/evaluate.c b/evaluate.c
index a5a830978bda..2e9ad8b7b31d 100644
--- a/evaluate.c
+++ b/evaluate.c
@@ -1375,7 +1375,7 @@ static int compatible_assignment_types(struct
expression *expr, struct symbol *t
                        goto Cast;
                }
                /* It's OK if the target is more volatile or const
than the source */
-               typediff = type_difference(&t->ctype, &s->ctype, 0, mod1);
+               typediff = type_difference(&t->ctype, &s->ctype, 0,
mod1 | MOD_PURE);
                if (typediff)
                        goto Err;
                return 1;

fixes the first issue, but I am not sure if it is an appropriate fix or not.

-- 
Ard.
