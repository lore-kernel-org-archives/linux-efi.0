From: Christopher Li <sparse-55XgFHCVCFZAfugRpC6u6w@public.gmane.org>
Subject: Re: [efi:next 2/3] arch/x86/boot/compressed/eboot.c:26:16: sparse:
 incorrect type in return expression (different modifiers)
Date: Sun, 16 Nov 2014 18:13:28 +0800
Message-ID: <CANeU7Q=6mB2yoSy9PpnNjeYcvvzD8DEUyyeXQhW2YE2aSGq_gg@mail.gmail.com>
References: <201411120724.PdeIjimc%fengguang.wu@intel.com>
	<CAKv+Gu8Jk4z6Q+8ZstNrA5e0ictYnzq9XOeq8zbr8ADo5DyWow@mail.gmail.com>
	<1415799312.14686.332.camel@mfleming-mobl1.ger.corp.intel.com>
	<CANeU7Qn8J2dn4V5Mx1WzUM9q+m=K66yUuEkN39bH_djRoBzqNA@mail.gmail.com>
	<CAKv+Gu-L2EoqioZamh9arLSkXzQF4y=FDykk0YK1XvNkRGC-xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu-L2EoqioZamh9arLSkXzQF4y=FDykk0YK1XvNkRGC-xg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-Sparse <linux-sparse-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "fengguang.wu" <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Nov 12, 2014 at 11:34 PM, Ard Biesheuvel
<ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>
> Well, I spent some time playing around with this:
>
> This one is accepted:
>
> static __attribute__((__pure__)) int pure1(void)
> {
>     int i = 0;
>     return i;
> }
>
> This one is not accepted:
>
> static __attribute__((__pure__)) void *pure2(void)
> {
>     void *i = (void *)0;
>     return i;
> }
>

Thanks for the test case. I have commit your test case with a bit more
test case regarding function pointer assign.

The change is in chrisl repository reveiw-pure-attr branch:
https://git.kernel.org/cgit/devel/sparse/chrisl/sparse.git/log/?h=review-pure-attr

I purpose this fix for it. It can pass your test case.
This patch limit the pure attribute to functions.
The pure bit should not be a modifier in the first place.
But that is a much bigger change.

Can you please help me test and review the change?

Chris


diff --git a/evaluate.c b/evaluate.c
index 035e448..4c8b64a 100644
--- a/evaluate.c
+++ b/evaluate.c
@@ -632,6 +632,8 @@ const char *type_difference(struct ctype *c1,
struct ctype *c2,
        struct symbol *t1 = c1->base_type;
        struct symbol *t2 = c2->base_type;
        int move1 = 1, move2 = 1;
+       unsigned long ignore = ~MOD_PURE;
+
        mod1 |= c1->modifiers;
        mod2 |= c2->modifiers;
        for (;;) {
@@ -728,6 +730,7 @@ const char *type_difference(struct ctype *c1,
struct ctype *c2,
                        as1 = t1->ctype.as;
                        mod2 = t2->ctype.modifiers;
                        as2 = t2->ctype.as;
+                       ignore = ~0;

                        if (base1->variadic != base2->variadic)
                                return "incompatible variadic arguments";
@@ -778,7 +781,7 @@ const char *type_difference(struct ctype *c1,
struct ctype *c2,
        }
        if (as1 != as2)
                return "different address spaces";
-       if ((mod1 ^ mod2) & ~MOD_IGNORE & ~MOD_SIGNEDNESS)
+       if ((mod1 ^ mod2) & ~MOD_IGNORE & ~MOD_SIGNEDNESS & ignore)
                return "different modifiers";
        return NULL;
 }
diff --git a/show-parse.c b/show-parse.c
index fb54375..f274431 100644
--- a/show-parse.c
+++ b/show-parse.c
@@ -326,6 +326,7 @@ deeper:
                        was_ptr = 0;
                }
                append(name, "( ... )");
+               mod = sym->ctype.modifiers;
                break;

        case SYM_STRUCT:
