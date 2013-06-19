From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
Date: Wed, 19 Jun 2013 15:02:25 +0200
Message-ID: <20130619130225.GA28311@pd.tnic>
References: <1371491416-11037-1-git-send-email-bp@alien8.de>
 <20130619125243.GD11209@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130619125243.GD11209-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Jun 19, 2013 at 02:52:43PM +0200, Ingo Molnar wrote:
> I hope making it a weird boot option is not the end plan, there's
> little point in _not_ enabling 1:1 mappings by default eventually:
> the 1:1 mapping is supposed to emulate a "Windows compatible" EFI
> environment better and is expected to work around certain EFI runtime
> crashes.

And yet there are the Macs which reportedly cannot stomach this.

And then there's the issue where some boxes cannot boot through the EFI
stub with those patches even without "efi=1:1_map" on the command line.
The issue has something to do with the "cmpb $0, efi_use_11_map" in the
efi_callX stubs.

And then again, other boxes have no problem with it and boot perfectly
fine.

So I don't know - it all looks like a weird boot, opt-in option for now.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
