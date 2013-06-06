From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH 3/4] x86, efi: Add an efi= kernel command line parameter
Date: Thu, 6 Jun 2013 23:02:18 +0200
Message-ID: <20130606210218.GR20972@pd.tnic>
References: <20130606185140.GK20972@pd.tnic>
 <20130606193548.GA2946@srcf.ucam.org>
 <20130606194134.GN20972@pd.tnic>
 <20130606195450.GA3252@srcf.ucam.org>
 <20130606200705.GO20972@pd.tnic>
 <20130606201828.GA3950@srcf.ucam.org>
 <20130606202717.GP20972@pd.tnic>
 <20130606203057.GA4237@srcf.ucam.org>
 <20130606204410.GQ20972@pd.tnic>
 <20130606205057.GA4363@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130606205057.GA4363-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, X86-ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 06, 2013 at 09:50:57PM +0100, Matthew Garrett wrote:
> What do you mean by "call them"? I don't think we ever want to call by
> physical address, other than maybe in the kexec case. The only reason
> we really care about the physical addresses being mapped 1:1 is that
> some pointers may not have been updated.

I want to be able to call the runtime services in the kexec kernel.
Which means, the kexec kernel would simply map the runtime code/data
regions 1:1 and then use the physical addresses to call the runtime
services.

Question is: would that work even if SetVirtualAddressMap has already
run in the original kernel and with virtual addresses?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
