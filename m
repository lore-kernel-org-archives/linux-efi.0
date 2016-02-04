From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] x86/efi: skip bgrt init for kexec reboot
Date: Thu, 4 Feb 2016 10:03:29 +0000
Message-ID: <20160204100329.GA2586@codeblueprint.co.uk>
References: <20160127112044.GA2961@dhcp-128-65.nay.redhat.com>
 <20160203214200.GA15110@dhcp-128-65.nay.redhat.com>
 <20160203225333.GA31246@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160203225333.GA31246-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 03 Feb, at 10:53:33PM, Matt Fleming wrote:
> On Thu, 04 Feb, at 05:42:00AM, Dave Young wrote:
> > 
> > On 01/27/16 at 07:20pm, Dave Young wrote:
> > > For kexec reboot the bgrt image address could contains random data because
> > > we have freed boot service areas in 1st kernel boot phase. One possible
> > > result is kmalloc fail in efi_bgrt_init due to large random image size.
> > > 
> > > So change efi_late_init to avoid efi_bgrt_init in case kexec boot.
> > > 
> > > Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > ---
> > >  arch/x86/platform/efi/efi.c |    3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > --- linux-x86.orig/arch/x86/platform/efi/efi.c
> > > +++ linux-x86/arch/x86/platform/efi/efi.c
> > > @@ -531,7 +531,8 @@ void __init efi_init(void)
> > >  
> > >  void __init efi_late_init(void)
> > >  {
> > > -	efi_bgrt_init();
> > > +	if (!efi_setup)
> > > +		efi_bgrt_init();
> > >  }
> > >  
> > >  void __init efi_set_executable(efi_memory_desc_t *md, bool executable)
> > 
> > Matt, opinions about this patch?
> 
> Yeah, I'm not happy seeing efi_setup escaping into even more places,
> nor am I happy to see more code paths introduced where kexec boot is
> special-cased.
> 
> I'll reply with more details tomorrow.

OK, let me expand upon that rather terse feedback. 

This patch highlights a general problem I see in the EFI code which is
that we're continuously increasing the number of execution paths
through the boot code. This makes it increasingly difficult to modify
the code without introducing bugs and regressions.

I was bitten by this recently with the EFI separate page table rework,
which led to commit 753b11ef8e92 ("x86/efi: Setup separate EFI page
tables in kexec paths"), i.e I forgot to update the special kexec
virtual mapping function.

We should be reducing the use of 'efi_setup', not adding more uses.

As an aside, I've always had a problem with using 'efi_setup' to
indicate when we've been booted via kexec. If a developer with no
prior knowledge reads those if conditions they are going to have zero
clue what the code means. 

Now, specifically for the issue you've raised, would it not make more
sense for kexec to build its own ACPI tables and omit those entries
that are not valid, e.g. BGRT? I can imagine that the BGRT driver
won't be the only driver with this problem. Let's re-use the existing
error paths that handle missing/invalid tables.

Fundamentally I don't think there should be a discernible difference
between "Booted via kexec" and "That ACPI table does not exist".
