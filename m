From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH v3 0/4] x86/efi: use binary units when printing
Date: Sat, 23 Jan 2016 08:34:37 -0800
Message-ID: <1453566877.2470.15.camel@HansenPartnership.com>
References: <1453560913-134672-1-git-send-email-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453560913-134672-1-git-send-email-andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel @ vger . kernel . org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, 2016-01-23 at 16:55 +0200, Andy Shevchenko wrote:
> The patch series exports the arrays of binary and decimal units as
> it's
> described by IEC.
> 
> First user of it is EFI code which would print sizes and other values
> using
> binary prefix.
> 
> James, is this now okay to you?

Patch 2 is still pointless. I happen to like the <tab><space>label:
convention.  I realise others don't but an entire patch simply to
change my convention to your convention is a bit overkill.

I'll comment on the rest in the patches.

James

> Matt, I suppose we need to update the stuff in your tree.
> 
> Since v2:
> - address James comment (don't nail array size)
> - fix a title and commit message for patch 3 to be in align with the
> change
> 
> Andy Shevchenko (3):
>   lib/string_helpers: export string_units_{2,10} for others
>   lib/string_helpers: fix indentation in few places
>   x86/efi: Use proper units in efi_find_mirror()
> 
> Robert Elliott (1):
>   x86/efi: print size in binary units in efi_print_memmap
> 
>  arch/x86/platform/efi/efi.c    | 27 ++++++++++++++++++---------
>  include/linux/string_helpers.h |  3 +++
>  lib/string_helpers.c           | 26 ++++++++++++++------------
>  3 files changed, 35 insertions(+), 21 deletions(-)
> 
