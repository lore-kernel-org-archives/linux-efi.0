From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode
Date: Thu, 18 Apr 2013 16:44:49 -0700
Message-ID: <51708571.8080805@zytor.com>
References: <1366127886-31460-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie> <516EAC4A.6040202@console-pimps.org> <516F1B90.9040508@nexus-software.ie> <516FD24A.3070502@console-pimps.org> <51706E8A.7030909@nexus-software.ie> <20130418230120.GA7078@jtriplet-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130418230120.GA7078@jtriplet-mobl1>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: Bryan O'Donoghue <bryan.odonoghue.lkml-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Darren Hart <darren.hart-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 04/18/2013 04:01 PM, Josh Triplett wrote:
> 
> I'd much rather see the code do the right thing automatically, rather
> than requiring an "unbreak me" command-line parameter.
> 
> But in any case, since BGRT is a "make my system look prettier" feature
> rather than core functionality, giving up on it on 32-bit EFI seems
> fairly reasonable, especially since it may still work if stored
> sufficiently low in memory.
> 

No, it really isn't.  Quite frankly, I don't understand why HIGHMEM
makes it any harder... in a lot of ways HIGHMEM memory is easier to deal
with because it is touched much later in the process.  Sure, it has to
be mapped before you can copy it out, but that usually isn't a big deal.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
