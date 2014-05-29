From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH] export efi.flags to sysfs
Date: Thu, 29 May 2014 14:50:38 +0200
Message-ID: <20140529125038.GC21718@pd.tnic>
References: <20140526083935.GA19682@dhcp-16-198.nay.redhat.com>
 <20140527133411.GG10994@redhat.com>
 <20140528021359.GC2820@darkstar.nay.redhat.com>
 <20140528124029.GF14863@redhat.com>
 <20140529020837.GB2068@darkstar.nay.redhat.com>
 <20140529124520.GC14570@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140529124520.GC14570-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, May 29, 2014 at 08:45:20AM -0400, Vivek Goyal wrote:
> I am curious that what's the meaning of 1:1 mapping here? So far I
> thought that means virt and physical addresses are same but that does
> not seem to be the case. So what does it mean?

1:1 mapping in the EFI's case (and maybe in any other case I'm aware of)
is taking the physical addresses of the EFI regions and mapping them at
the exact same addresses in the EFI page table.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
