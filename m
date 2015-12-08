From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH 1/2] x86: Fix kernel panic when booting with XD disabled
 in uEFI firmware
Date: Tue, 8 Dec 2015 21:56:05 +0100
Message-ID: <20151208205605.GB16417@pd.tnic>
References: <20151204164057.GE2514@codeblueprint.co.uk>
 <17EC94B0A072C34B8DCF0D30AD16044A0288EFC7@BPXM09GP.gisp.nec.co.jp>
 <20151208122557.GA2518@codeblueprint.co.uk>
 <20151208141946.GD27180@pd.tnic>
 <CAGXu5jKF3fVc5rsU=+jRcoBGB+ZkeHjF6mmSeJN0SoP-MpFGow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jKF3fVc5rsU=+jRcoBGB+ZkeHjF6mmSeJN0SoP-MpFGow-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Kosuke Tatsukawa <tatsu-zZGIbrA41Td8UrSeD/g0lQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Dec 08, 2015 at 12:30:06PM -0800, Kees Cook wrote:
> If we add this for not-nx, I would like to add it for not-rodata too.

The W+X thing?

I was under the impression we want to fix all those so that the ptdump
check doesn't fire anymore.

> I've never seen anyone actually use it. I was asked to include it out
> of fear of some kind of rogue imagined CPU configuration that mixed NX
> and non-NX capable CPUs in a single machine where the forced NX
> re-enablement code would cause problems. As you might imagine, I'm not
> aware of this case ever being an issue. ;)

Right. :)

Thanks.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
