From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Add EFI framebuffer earlyprintk support
Date: Fri, 11 Oct 2013 08:21:59 +0200
Message-ID: <20131011062159.GD4975@gmail.com>
References: <1381423261-30566-1-git-send-email-matt@console-pimps.org>
 <20131010172844.GA26430@gmail.com>
 <20131010173710.GA18821@fenchurch.internal.datastacks.com>
 <20131010174521.GA27218@gmail.com>
 <20131010175828.GA9065@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131010175828.GA9065-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org> wrote:

> On Thu, Oct 10, 2013 at 07:45:21PM +0200, Ingo Molnar wrote:
> 
> > Also, the main question would be, what is the typical value for 
> > si->lfb_depth. 32 on almost all EFI systems? All around the map? Depends 
> > on what graphics state the EFI bootloader passes us?
> 
> Microsoft require that it be 32, so in practice I suspect it'll always 
> be 32. [...]

Ok, cool - and it's a rare sight: Microsoft standing up against bloat and 
complexity.

> [...] It's possible that Itanium decides to be different.

That would be a feature!

Thanks,

	Ingo
