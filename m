From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 10/11] EFI: Runtime services virtual mapping
Date: Sun, 3 Nov 2013 20:35:08 +0800
Message-ID: <20131103123508.GB5313@dhcp-16-126.nay.redhat.com>
References: <1383236709-19716-1-git-send-email-bp@alien8.de>
 <1383236709-19716-11-git-send-email-bp@alien8.de>
 <20131101032551.GC4378@dhcp-16-126.nay.redhat.com>
 <20131101033508.GA13527@dhcp-16-126.nay.redhat.com>
 <20131101125057.GA21688@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131101125057.GA21688-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 11/01/13 at 12:50pm, Matt Fleming wrote:
> On Fri, 01 Nov, at 11:35:08AM, Dave Young wrote:
> > > The conflict is caused by missing one commit in matt's efi next tree:
> > > 
> > > commit 700870119f49084da004ab588ea2b799689efaf7
> > > Author: Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > Date:   Thu Apr 18 07:51:34 2013 -0700
> > > 
> > >     x86, efi: Don't map Boot Services on i386
> > >     
> > >     Add patch to fix 32bit EFI service mapping (rhbz 726701)
> > >     
> > >     Multiple people are reporting hitting the following WARNING on i386,
> > >     
> > >       WARNING: at arch/x86/mm/ioremap.c:102 __ioremap_caller+0x3d3/0x440()
> > >       Modules linked in:
> > >       Pid: 0, comm: swapper Not tainted 3.9.0-rc7+ #95
> > 
> > Rethinking about above commit, it is actually a workaround for
> > mapping boot service, I suspect the problem connect to the off-by-one
> > problem in boot service reserve function. Matt, idea?
> 
> No, it's not the same problem. And just to make absolutely sure I
> reverted the above commit and applied your patch, but I still see the
> WARN_ON() described above.

Ok, I'm wrong then, thanks for verifying..
