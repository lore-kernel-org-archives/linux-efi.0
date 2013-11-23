From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [patch 5/9 v3] efi: export more efi table variable to sysfs
Date: Sat, 23 Nov 2013 14:15:18 +0100
Message-ID: <20131123131518.GC24148@pd.tnic>
References: <20131121061704.363730447@dhcp-16-126.nay.redhat.com>
 <20131121061754.887381332@dhcp-16-126.nay.redhat.com>
 <20131121165742.GN26009@pd.tnic>
 <20131122024850.GC3874@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131122024850.GC3874-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, Nov 22, 2013 at 10:48:50AM +0800, Dave Young wrote:
> > 	efi.config_table = (unsigned long)efi.systab->tables;
> > 	efi.fw_vendor	 = (unsigned long)efi.systab->fw_vendor;
> > 	efi.runtime	 = (unsigned long)efi.systab->runtime;
> 
> Hmm, UEFI spec mentions the them like below so I use the order:

I'm sure by now you know you should not really trust the UEFI spec, or
any other spec for that matter :)

> Several fields of the EFI System Table must be converted from
> physical pointers to virtual pointers using the ConvertPointer()
> service. These fields include FirmwareVendor, RuntimeServices,
> and ConfigurationTable.
> 
> But since you like the reverse I can change it in next version.

The reverse was simply a suggestion. The vertical alignment was more
what I aimed at because it makes this chunk much more readable IMO.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
