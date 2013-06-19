From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
Date: Wed, 19 Jun 2013 14:52:43 +0200
Message-ID: <20130619125243.GD11209@gmail.com>
References: <1371491416-11037-1-git-send-email-bp@alien8.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1371491416-11037-1-git-send-email-bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org> wrote:

> From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> 
> Hi all,
> 
> this is just a snapshot of the current state of affairs. The patchset
> starts to boot successfully on real hardware now but we're far away from
> the coverage we'd like to have before we even consider upstreaming it.

Looks pretty clean.

> And yes, considering the sick f*ck EFI is, we're keeping the 1:1 mapping
> optional and off by default (you need to boot with "efi=1:1_map" to
> enable it).

I hope making it a weird boot option is not the end plan, there's little 
point in _not_ enabling 1:1 mappings by default eventually: the 1:1 
mapping is supposed to emulate a "Windows compatible" EFI environment 
better and is expected to work around certain EFI runtime crashes.

Thanks,

	Ingo
