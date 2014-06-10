From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Subject: efi_call on SGI
Date: Tue, 10 Jun 2014 22:44:14 +0200
Message-ID: <20140610204414.GB29302@pd.tnic>
References: <20140609200017.GD2700@sgi.com>
 <20140610080300.GA28607@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140610080300.GA28607-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Cc: Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Btw,

while we're at it, I see uv_bios_call is sometimes done with preemption
disabled around it and sometimes it is not (at least I don't see it)...

In any case, if SGI uses the EFI pagetable now too, you probably would
want to do the efi calls like the rest of x86 does them - see the 64-bit
version of efi_call_virt() in arch/x86/include/asm/efi.h for an example
what I mean.

Now, you could either copy that macro or you could accomodate it to
serve everyone's needs - depends on what you'd prefer.

I'm just saying - I had stumbled across this while the debugging session
was going on and wanted to point that out but it wasn't too important at
the time so...

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
