From: Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Date: Fri, 8 Feb 2013 16:14:07 -0500
Message-ID: <CA+5PVA4EbgBRgg+ZDa4+vG0Ngw8wJ3kH6NcmDvZ=+CP=kH82_A@mail.gmail.com>
References: <20130208191213.GA25081@www.outflux.net>
	<00780235-deac-4f80-b936-867834e05661@email.android.com>
	<CAGXu5jJnLY6Qp3J6HBpVg-AdUGdKYm-e4wErZO3=NuRo04ajvg@mail.gmail.com>
	<5115553A.5000708@zytor.com>
	<CAGXu5j+_mGzR+72YqORhErMUY1aF1H2urczZ8SwuJHZK-oZL6g@mail.gmail.com>
	<dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>
	<CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com>
	<1360355671.18083.18.camel@x230.lan>
	<CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com>
	<1360357636.18083.19.camel@x230.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1360357636.18083.19.camel-+5W/JHIUVxg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Feb 8, 2013 at 4:07 PM, Matthew Garrett
<matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org> wrote:
> On Fri, 2013-02-08 at 13:02 -0800, Kees Cook wrote:
>
>> I don't find it unreasonable to drop all caps and lose access to
>> sensitive things. :) That's sort of the point, really. I think a cap
>> is the best match. It seems like it should either be a cap or a
>> namespace flag, but the latter seems messy.
>
> Yeah, I think it's an expected outcome, but it means that if (say) qemu
> drops privileges, qemu can no longer access PCI resources - even on
> non-secure boot systems. That breaks existing userspace.

Right.  We've had a few reports in Fedora of things breaking on non-SB
systems because of this.  The qemu one is the latest, but the general
problem is people think dropping all caps blindly is making their apps
safer.  Then they find they can't do things they could do before the new
cap was added.  It's messy.

I've thought of treating CAP_COMPROMISE_KERNEL as a hidden cap, where
only the kernel can grant or drop it.  Peter Jones suggested it might
work to allow it to be dropped iff it is the only cap being changed.
Either way, it's a "special" cap and I have no idea how acceptable
something like that would be.

Really though, the main issue is that you cannot introduce new caps to
enforce finer grained access without breaking something.

josh
