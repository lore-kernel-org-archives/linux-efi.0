From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [patch] x86/efi: use GFP_ATOMIC under spin_lock
Date: Mon, 10 Mar 2014 09:10:18 +0000
Message-ID: <20140310091018.GE10262@console-pimps.org>
References: <20140307112055.GE2351@elgon.mountain>
 <20140307121022.GA32575@gmail.com>
 <20140307122103.GM4774@mwanda>
 <20140309161946.GA10262@console-pimps.org>
 <20140309163141.GA18824@srcf.ucam.org>
 <20140309185028.GB10262@console-pimps.org>
 <20140309190053.GA29555@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140309190053.GA29555-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Nathan Zimmer <nzimmer-sJ/iWh9BUns@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, 09 Mar, at 07:00:53PM, Matthew Garrett wrote:
> On Sun, Mar 09, 2014 at 06:50:28PM +0000, Matt Fleming wrote:
> 
> > Is there any value in that? Do machines exist where we absolutely must
> > have access to the EFI time services? Either because there's no other
> > method or no other working one?
> 
> In theory we get timezones, which we otherwise only get if we have an 
> ACPI TAD device.
 
We'd previously discussed grabbing this in the EFI stub, before
ExitBootServices(), assuming that we only want to get the timezone as
opposed to setting it. We don't need phys_* and virt_* functions in the
kernel proper for that.

> > I can check again, but I'm pretty sure this ASUS machine under my desk
> > always returns a vendor-specific error code when invoked, even with
> > Borislav's 1:1 patches. Enabling EFI services just because they exist
> > hasn't worked out well for us in the past.
> 
> Returning an error doesn't seem like a problem, as long as it's not 
> actually killing the machine in the process...
 
True, but I don't think that's a good enough justificaton for letting
those functions live.

If someone can show me a platform where they're needed/advantageous,
then that's a different story.

-- 
Matt Fleming, Intel Open Source Technology Center
