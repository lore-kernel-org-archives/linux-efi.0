From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 1/2] x86: Fix kernel panic when booting with XD disabled
 in uEFI firmware
Date: Tue, 8 Dec 2015 12:25:57 +0000
Message-ID: <20151208122557.GA2518@codeblueprint.co.uk>
References: <20151204164057.GE2514@codeblueprint.co.uk>
 <17EC94B0A072C34B8DCF0D30AD16044A0288EFC7@BPXM09GP.gisp.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <17EC94B0A072C34B8DCF0D30AD16044A0288EFC7-9lrffkYxhwTt6d3pZDjeaEtBU8KWyXPq@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kosuke Tatsukawa <tatsu-zZGIbrA41Td8UrSeD/g0lQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 07 Dec, at 11:10:43PM, Kosuke Tatsukawa wrote:
> 
> Thank you pointing that out.
> 
> linux-4.4-rc3 booted without a problem on a real server even with XD
> turned off by the firmware.  I didn't notice this before because I was
> using an older version of the kernel on the real server, and doing
> investigation on a KVM guest.
> 
> The "noexec=off" kernel parameter still seems to come up with EFI
> runtime service disabled though.  Do you think this should be left alone
> as an disadvantage for using a bad option?

Good question.

I couldn't find any other examples of code that returns an error if
PAGE_NX isn't supported either by the hardware or via the noexec
command line option. Things like set_memory_x() and set_memory_nx()
return success without actually doing anything.

While I'm all for using hardware security features wherever possible,
such as force-enabling it in commit 04633df0c43d ("x86/cpu: Call
verify_cpu() after having entered long mode too"), if the user has
explicitly turned it off on the kernel command line, we should still
try and provide EFI services.

Borislav, what do you think about stripping PAGE_NX from 'page_flags'
in kernel_map_pages_in_pgd() if NX isn't supported, rather than
returning EINVAL? At least that way EFI runtime services would still
work.
