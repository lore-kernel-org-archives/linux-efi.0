From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [patch] x86/efi: use GFP_ATOMIC under spin_lock
Date: Sun, 9 Mar 2014 18:50:28 +0000
Message-ID: <20140309185028.GB10262@console-pimps.org>
References: <20140307112055.GE2351@elgon.mountain>
 <20140307121022.GA32575@gmail.com>
 <20140307122103.GM4774@mwanda>
 <20140309161946.GA10262@console-pimps.org>
 <20140309163141.GA18824@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140309163141.GA18824-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Nathan Zimmer <nzimmer-sJ/iWh9BUns@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, 09 Mar, at 04:31:41PM, Matthew Garrett wrote:
> On Sun, Mar 09, 2014 at 04:20:20PM +0000, Matt Fleming wrote:
> 
> > We have tried to use the time functions before, with little success
> > because of various bugs in the runtime implementations, e.g. see commit
> > bacef661acdb ("x86-64/efi: Use EFI to deal with platform wall clock")
> > and commit bd52276fa1d4 ("x86-64/efi: Use EFI to deal with platform wall
> > clock (again)").
> 
> I'd naively expected that these would be more reliable after the 1:1 
> mapping patches, so it might actually be time to give them another go.

Is there any value in that? Do machines exist where we absolutely must
have access to the EFI time services? Either because there's no other
method or no other working one?

I can check again, but I'm pretty sure this ASUS machine under my desk
always returns a vendor-specific error code when invoked, even with
Borislav's 1:1 patches. Enabling EFI services just because they exist
hasn't worked out well for us in the past.

So enabling them is fine, but we certainly need some kind of priority
mechanism so they're used as a last resort and some ironclad use case of
why we absolutely must have this.

And of course, the GPF_KERNEL alloc under spinlock bug that started this
thread needs to be fixed.

-- 
Matt Fleming, Intel Open Source Technology Center
