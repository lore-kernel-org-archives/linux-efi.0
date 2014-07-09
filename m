From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] x86/efi: autoload efivars
Date: Wed, 9 Jul 2014 14:40:50 +0800
Message-ID: <20140709064050.GI18225@linux-rxt1.site>
References: <1404788458-32105-1-git-send-email-jlee@suse.com>
 <20140708101434.GF27474@console-pimps.org>
 <1404821982.2489.8.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1404821982.2489.8.camel-nDn/Rdv9kqW9Jme8/bJn5UCKIB8iOfG2tUK59QYPAWc@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Jul 08, 2014 at 01:19:42PM +0100, Ben Hutchings wrote:
> On Tue, 2014-07-08 at 11:14 +0100, Matt Fleming wrote:
> > On Tue, 08 Jul, at 11:00:58AM, Lee, Chun-Yi wrote:
> [...]
> > > --- a/arch/x86/platform/efi/efi.c
> > > +++ b/arch/x86/platform/efi/efi.c
> > > @@ -44,6 +44,7 @@
> > >  #include <linux/io.h>
> > >  #include <linux/reboot.h>
> > >  #include <linux/bcd.h>
> > > +#include <linux/platform_device.h>
> > >  
> > >  #include <asm/setup.h>
> > >  #include <asm/efi.h>
> > > @@ -780,6 +781,20 @@ void __init efi_late_init(void)
> > >  	efi_bgrt_init();
> > >  }
> > >  
> > > +#ifdef CONFIG_EFI_VARS_MODULE
> > > +static int __init efi_load_efivars(void)
> > > +{
> > > +	struct platform_device *pdev;
> > > +
> > > +	if (!efi_enabled(EFI_RUNTIME_SERVICES))
> > > +		return 0;
> > > +
> > > +	pdev = platform_device_register_simple("efivars", 0, NULL, 0);
> > > +	return IS_ERR(pdev) ? PTR_ERR(pdev) : 0;
> > > +}
> > > +device_initcall(efi_load_efivars);
> > > +#endif
> > > +
> > 
> > Could this be moved to drivers/firmware/efi/efi.c? That way the arm64
> > folks could benefit from it too.
> 
> It seems like that should work now that efi_enabled() is not specific to
> x86.
> 
> Ben.
> 

Thanks for Matt and Ban's review, I will move platform device register code to
drivers/firmware/efi/efi.c and send version 2 patch.

Joey Lee

> > >  void __init efi_set_executable(efi_memory_desc_t *md, bool executable)
> > >  {
> > >  	u64 addr, npages;
> > > diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
> > > index 463c565..f256ecd 100644
> > > --- a/drivers/firmware/efi/efivars.c
> > > +++ b/drivers/firmware/efi/efivars.c
> > > @@ -78,6 +78,7 @@ MODULE_AUTHOR("Matt Domsch <Matt_Domsch-DYMqY+WieiM@public.gmane.org>");
> > >  MODULE_DESCRIPTION("sysfs interface to EFI Variables");
> > >  MODULE_LICENSE("GPL");
> > >  MODULE_VERSION(EFIVARS_VERSION);
> > > +MODULE_ALIAS("platform:efivars");
> > >  
> > >  LIST_HEAD(efivar_sysfs_list);
> > >  EXPORT_SYMBOL_GPL(efivar_sysfs_list);
> > > -- 
> > > 1.8.4.5
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> -- 
> Ben Hutchings
> Any smoothly functioning technology is indistinguishable from a rigged demo.
