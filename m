From: Darren Hart <darren.hart-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode
Date: Thu, 12 Sep 2013 15:30:52 -0700
Message-ID: <1379025052.1285.52.camel@dvhart-mobl4.amr.corp.intel.com>
References: <1366127886-31460-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie>
	 <516EAC4A.6040202@console-pimps.org> <516F1B90.9040508@nexus-software.ie>
	 <516FD24A.3070502@console-pimps.org> <51700876.1000305@intel.com>
	 <51701D2E.6060903@console-pimps.org> <51708D3D.9010707@intel.com>
	 <5170F736.2060803@console-pimps.org>
	 <1378835007.19978.125.camel@dvhart-mobl4.amr.corp.intel.com>
	 <20130912075500.GC895@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130912075500.GC895-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Bryan O'Donoghue <bryan.odonoghue.lkml-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 2013-09-12 at 08:55 +0100, Matt Fleming wrote:
> On Tue, 10 Sep, at 10:43:27AM, Darren Hart wrote:
> > Josh OK'd this, but as far as I can tell, it hasn't made it upstream
> > yet. Matt was there an alternate fixed pushed?
> 
> Nope, this one slipped through the cracks. Thanks for following up!
> 
> Here's the patch I just applied on the 'urgent' branch.
> 

Excellent, thank you Matt.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
