From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode
Date: Thu, 18 Apr 2013 17:19:58 +0100
Message-ID: <51701D2E.6060903@console-pimps.org>
References: <1366127886-31460-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie> <516EAC4A.6040202@console-pimps.org> <516F1B90.9040508@nexus-software.ie> <516FD24A.3070502@console-pimps.org> <51700876.1000305@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51700876.1000305-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Darren Hart <darren.hart-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Bryan O'Donoghue <bryan.odonoghue.lkml-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 18/04/13 15:51, Darren Hart wrote:
> I don't believe I have seen a 32-bit EFI system with a BGRT, but then
> again, I had to look it up today! That said, I suspect the MinnowBoard
> would benefit from such a thing, so we should have an example of it
> there in the near future.
 
That's fine and things will work as-is provided that the BGRT image is
not in highmem.

> Is this in anyway related to the following patch from Josh Boyer? We're
> carrying this in the Yocto Project trees currently.
> 
>      commit 6f3e186bc7721c5b24ad90d4a751cccfccd445e6
>      Author: Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>      Date:   Fri Aug 5 08:47:23 2011 -0400
> 
>         Add patch to fix 32bit EFI service mapping (rhbz 726701)
> 
>     Signed-off-by: Tom Zanussi <tom.zanussi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>     Signed-off-by: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Yep, it's basically the same fix. My patch just avoids the #ifdef and
prints an error message if we have EFI Boot services regions we can't
access directly. The error message will at least be useful if we do
start seeing BGRT pointers in highmem.

Could you give it a spin on your MinnowBoard?

-- 
Matt Fleming, Intel Open Source Technology Center
