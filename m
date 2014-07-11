From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] x86/efi: autoload efivars
Date: Fri, 11 Jul 2014 09:47:23 +0200
Message-ID: <CAKv+Gu94e6Xay-m7YAPCA_frMiYWFWpsjaK1k6EwFSEhTL=-6g@mail.gmail.com>
References: <1404788458-32105-1-git-send-email-jlee@suse.com>
	<20140708101434.GF27474@console-pimps.org>
	<1404821982.2489.8.camel@deadeye.wl.decadent.org.uk>
	<20140709064050.GI18225@linux-rxt1.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140709064050.GI18225-empE8CJ7fzk2xCFIczX1Fw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 9 July 2014 08:40, joeyli <jlee-IBi9RG/b67k@public.gmane.org> wrote:
> On Tue, Jul 08, 2014 at 01:19:42PM +0100, Ben Hutchings wrote:
>> On Tue, 2014-07-08 at 11:14 +0100, Matt Fleming wrote:
>> > On Tue, 08 Jul, at 11:00:58AM, Lee, Chun-Yi wrote:
>> [...]
>> > > --- a/arch/x86/platform/efi/efi.c
>> > > +++ b/arch/x86/platform/efi/efi.c
>> > > @@ -44,6 +44,7 @@
>> > >  #include <linux/io.h>
>> > >  #include <linux/reboot.h>
>> > >  #include <linux/bcd.h>
>> > > +#include <linux/platform_device.h>
>> > >
>> > >  #include <asm/setup.h>
>> > >  #include <asm/efi.h>
>> > > @@ -780,6 +781,20 @@ void __init efi_late_init(void)
>> > >   efi_bgrt_init();
>> > >  }
>> > >
>> > > +#ifdef CONFIG_EFI_VARS_MODULE
>> > > +static int __init efi_load_efivars(void)
>> > > +{
>> > > + struct platform_device *pdev;
>> > > +
>> > > + if (!efi_enabled(EFI_RUNTIME_SERVICES))
>> > > +         return 0;
>> > > +
>> > > + pdev = platform_device_register_simple("efivars", 0, NULL, 0);
>> > > + return IS_ERR(pdev) ? PTR_ERR(pdev) : 0;
>> > > +}
>> > > +device_initcall(efi_load_efivars);
>> > > +#endif
>> > > +
>> >
>> > Could this be moved to drivers/firmware/efi/efi.c? That way the arm64
>> > folks could benefit from it too.
>>
>> It seems like that should work now that efi_enabled() is not specific to
>> x86.
>>
>> Ben.
>>
>
> Thanks for Matt and Ban's review, I will move platform device register code to
> drivers/firmware/efi/efi.c and send version 2 patch.
>

Hi all,

I tested the version that is in Matt's -next now and it works fine on arm64.

-- 
Ard.
