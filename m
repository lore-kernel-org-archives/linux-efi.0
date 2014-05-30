From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH]x86 efi: do not export efi runtime map in case old map
Date: Fri, 30 May 2014 09:52:19 +0200
Message-ID: <20140530075219.GC28131@pd.tnic>
References: <20140530032010.GA29906@dhcp-16-198.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140530032010.GA29906-je1gSBvt1Tc/CGXRbJeUwh/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, May 30, 2014 at 11:20:10AM +0800, Dave Young wrote:
> 
> For ioremapped efi memory aka old_map the virt addresses are not persistant
> across kexec reboot. kexec-tools will read the runtime maps from sysfs then
> pass them to 2nd kernel and assuming kexec efi boot is ok. This will cause
> kexec boot failure.
> 
> To address this issue do not export runtime maps in case efi old_map so
> userspace can use no efi boot instead.
> 
> Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Acked-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
