From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 10/11] EFI: Runtime services virtual mapping
Date: Mon, 4 Nov 2013 09:18:00 +0000
Message-ID: <20131104091800.GB21688@console-pimps.org>
References: <1383236709-19716-1-git-send-email-bp@alien8.de>
 <1383236709-19716-11-git-send-email-bp@alien8.de>
 <20131101032551.GC4378@dhcp-16-126.nay.redhat.com>
 <20131103123115.GA5313@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131103123115.GA5313-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, 03 Nov, at 08:31:15PM, Dave Young wrote:
> Hi, Matt
> 
> How should I handle this problem, would you take above commit or rebase efi
> next branch?

Dave, could you base your patches against the EFI 'master' branch? I've
rebased that branch on v3.12, which includes commit 700870119f49 ("x86,
efi: Don't map Boot Services on i386"), and merged everything from
'next'. Just note in the patch description which branch you've based
your work on and why in case I forget ;-)

Let me know if this causes any issues.

-- 
Matt Fleming, Intel Open Source Technology Center
