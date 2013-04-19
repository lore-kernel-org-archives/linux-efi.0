From: Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode
Date: Fri, 19 Apr 2013 08:01:19 -0400
Message-ID: <20130419120119.GL18383@hansolo.jdub.homelinux.org>
References: <1366127886-31460-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie>
 <516EAC4A.6040202@console-pimps.org>
 <516F1B90.9040508@nexus-software.ie>
 <516FD24A.3070502@console-pimps.org>
 <51700876.1000305@intel.com>
 <51701D2E.6060903@console-pimps.org>
 <51708D3D.9010707@intel.com>
 <5170F736.2060803@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5170F736.2060803-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Darren Hart <darren.hart-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bryan O'Donoghue <bryan.odonoghue.lkml-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Apr 19, 2013 at 08:50:14AM +0100, Matt Fleming wrote:
> On 04/19/2013 01:18 AM, Darren Hart wrote:
> > On 04/18/2013 09:19 AM, Matt Fleming wrote:
> >>
> >> Could you give it a spin on your MinnowBoard?
> > 
> > I've removed the patch I reference above and applied your patch to my
> > 3.8.4 MinnowBoard dev tree. It panics with:
> 
> D'oh. OK, at this point I'm inclined to apply Josh Boyer's patch on top
> of my urgent branch which will address the WARNING people are hitting on
> i386. I updated the commit message a little.
> 
> Josh (Boyer), are you guys still carrying this patch and have you seen
> any fallout? I notice your SoB isn't on the patch that Darren posted, am
> I OK to add it?

Yeah, we're still carrying it.  We've had it around since August of 2011
to cover the bug mentioned.  I'm not aware of any further fallout it
might have caused, but again we don't support 32-bit EFI in Fedora.
That's not to say Fedora won't work, we just don't focus on it.

I don't actually remember authoring the patch, but it's been a while so:

Signed-off-by: Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

josh
