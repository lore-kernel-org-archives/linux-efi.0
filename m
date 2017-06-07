From: Dave Young <dyoung@redhat.com>
Subject: Re: PROBLEM: Kernel panic on EFI BGRT early init code (kernel
 4.11/4.12rc2) [regression]
Date: Wed, 7 Jun 2017 16:57:16 +0800
Message-ID: <20170607085716.GA24648@dhcp-128-65.nay.redhat.com>
References: <86c36f9b-f633-3354-d676-7693f35dae0d@gmail.com>
 <20170526012342.GA3096@dhcp-128-65.nay.redhat.com>
 <a32eea98-9576-1ee7-c27a-b165204d825f@gmail.com>
 <20170527051427.GA3492@dhcp-128-65.nay.redhat.com>
 <20170527053457.GB3492@dhcp-128-65.nay.redhat.com>
 <df8e83f9-9362-b5b5-462d-b11980baac01@gmail.com>
 <20170601015621.GA4306@dhcp-128-65.nay.redhat.com>
 <e6d656c0-c76b-42c3-8413-0198efb8a33a@gmail.com>
 <20170602025155.GA3637@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170602025155.GA3637@dhcp-128-65.nay.redhat.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Maniaxx <tripleshiftone@gmail.com>
Cc: linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 06/02/17 at 10:51am, Dave Young wrote:
> On 06/01/17 at 09:13pm, Maniaxx wrote:
> > On 01.06.2017 at 03:57 wrote Dave Young:
> > > This means the efi_bgrt_init failed out originally before the early init BGRT
> > > patch. Checking the code the only difference is current code we have no
> > > below code:
> > > 
> > >         status = acpi_get_table("BGRT", 0,
> > >                                 (struct acpi_table_header **)&bgrt_tab);
> > >         if (ACPI_FAILURE(status))
> > >                 return;
> > > 
> > > So probably acpi_get_table has some more sanity checking and it failed
> > > early. Can you add a printk before above return to confirm it? Just test
> > > the old kernel without early init BGRT patch.
> > 
> > Doesn't fail early. I can see the printk.
> 
> Since you do not see /sys/firmware/acpi/bgrt, that means there must be
> somewhere failed early so bgrt image sysfs files are not created.
> for old kernel arch/x86/platform/efi/efi-bgrt.c copy the bgrt image
> then drivers/acpi/bgrt.c will populate the image in sysfs.
> 
> Can you do more debugging ie. adding more printk see why bgrt image
> sysfs dir is not created?
> 
> If we get the reason then we can start to see what we missed in new
> code.

Please ignore the request, I observed in your old kernel boot log there
is a ioremap error message about invalid physical address, so that is
clear since ioremap failed then efi_bgrt_init bails out.

In new code we use early_memremap, it seems lacks of checking invalid
physical address, The firmware provides garbage in efi bgrt image
addresses, I will work on a fix for this. 

Thanks
Dave
