From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [patch 2/6] x86 efi: reserve boot service fix
Date: Mon, 28 Oct 2013 09:44:41 +0100
Message-ID: <20131028084440.GA4314@pd.tnic>
References: <20131027034713.481920209@dhcp-16-126.nay.redhat.com>
 <20131027035922.924386710@dhcp-16-126.nay.redhat.com>
 <20131027105009.GA21868@pd.tnic>
 <20131027203058.GE1982@console-pimps.org>
 <20131028011824.GD4397@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131028011824.GD4397-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Oct 28, 2013 at 09:18:24AM +0800, Dave Young wrote:
> There should be some people see below message with non-kexec kernel:
> "Could not reserve boot range ..."

I can find one other report like that: https://lkml.org/lkml/2013/7/16/309

[    0.000000] efi: Could not reserve boot range [0x0000000000-0x0000000fff]

for

efi: mem00: type=3, attr=0xf, range=[0x0000000000000000-0x0000000000001000) (0MB)

which is EFI_BOOT_SERVICES_CODE and

efi: Could not reserve boot range [0x000005f000-0x000009ffff]

for

efi: mem06: type=3, attr=0xf, range=[0x000000000005f000-0x00000000000a0000) (0MB)

which is of the same type.

> But it's hard for them to notice the bad functionality because
> it's only one mem range which might be not the boot range what
> SetVirtualAddressMap need

Right.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
