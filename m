From: Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH 2/4] efi/x86: move efi bgrt init code to early init code
Date: Fri, 13 Jan 2017 05:39:39 +0800
Message-ID: <20170112213939.GD2709@dhcp-128-65.nay.redhat.com>
References: <20170112094118.815108042@redhat.com>
 <20170112094214.909117564@redhat.com>
 <871sw8pk73.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <871sw8pk73.fsf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicolai Stange <nicstange@gmail.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, hpa@zytor.com, Dan Williams <dan.j.williams@intel.com>, mika.penttila@nextfour.com, bhsharma@redhat.com
List-Id: linux-efi@vger.kernel.org

On 01/12/17 at 12:54pm, Nicolai Stange wrote:
> On Thu, Jan 12 2017, Dave Young wrote:
> 
> > -void __init efi_bgrt_init(void)
> > +void __init efi_bgrt_init(struct acpi_table_header *table)
> >  {
> > -	acpi_status status;
> >  	void *image;
> >  	struct bmp_header bmp_header;
> >  
> >  	if (acpi_disabled)
> >  		return;
> >  
> > -	status = acpi_get_table("BGRT", 0,
> > -	                        (struct acpi_table_header **)&bgrt_tab);
> > -	if (ACPI_FAILURE(status))
> > -		return;
> 
> 
> Not sure, but wouldn't it be safer to reverse the order of this assignment
> 
> > +	bgrt_tab = *(struct acpi_table_bgrt *)table;

Nicolai, sorry, I'm not sure I understand the comment, is it about above line?
Could you elaborate a bit?

> 
> and this length check
> 

I also do not get this :(

> > -	if (bgrt_tab->header.length < sizeof(*bgrt_tab)) {
> > +	if (bgrt_tab.header.length < sizeof(bgrt_tab)) {
> >  		pr_notice("Ignoring BGRT: invalid length %u (expected %zu)\n",
> > -		       bgrt_tab->header.length, sizeof(*bgrt_tab));
> > +		       bgrt_tab.header.length, sizeof(bgrt_tab));
> >  		return;
> >  	}
> 
> ?
> 
> Also, from here on, all error paths should zero out
> bgrt_tab.image_address (or so) to signal failure to bgrt_init():
> bgrt_init() now checks for !bgrt_tab.image_address whereas before it had
> tested bgrt_image and the latter used to be set at the very end of
> efi_bgrt_init().
> 

Will do, thanks!

> 
> > -	if (bgrt_tab->version != 1) {
> > +	if (bgrt_tab.version != 1) {
> >  		pr_notice("Ignoring BGRT: invalid version %u (expected 1)\n",
> > -		       bgrt_tab->version);
> > +		       bgrt_tab.version);
> >  		return;
> >  	}
> > -	if (bgrt_tab->status & 0xfe) {
> > +	if (bgrt_tab.status & 0xfe) {
> >  		pr_notice("Ignoring BGRT: reserved status bits are non-zero %u\n",
> > -		       bgrt_tab->status);
> > +		       bgrt_tab.status);
> >  		return;
> >  	}
> > -	if (bgrt_tab->image_type != 0) {
> > +	if (bgrt_tab.image_type != 0) {
> >  		pr_notice("Ignoring BGRT: invalid image type %u (expected 0)\n",
> > -		       bgrt_tab->image_type);
> > +		       bgrt_tab.image_type);
> >  		return;
> >  	}
> > -	if (!bgrt_tab->image_address) {
> > +	if (!bgrt_tab.image_address) {
> >  		pr_notice("Ignoring BGRT: null image address\n");
> >  		return;
> >  	}
> >  
> > -	image = memremap(bgrt_tab->image_address, sizeof(bmp_header), MEMREMAP_WB);
> > +	image = early_memremap(bgrt_tab.image_address, sizeof(bmp_header));
> >  	if (!image) {
> >  		pr_notice("Ignoring BGRT: failed to map image header memory\n");
> >  		return;
> >  	}
> >  
> >  	memcpy(&bmp_header, image, sizeof(bmp_header));
> > -	memunmap(image);
> > +	early_memunmap(image, sizeof(bmp_header));
> >  	if (bmp_header.id != 0x4d42) {
> >  		pr_notice("Ignoring BGRT: Incorrect BMP magic number 0x%x (expected 0x4d42)\n",
> >  			bmp_header.id);
> > @@ -82,12 +77,5 @@ void __init efi_bgrt_init(void)
> >  	}
> >  	bgrt_image_size = bmp_header.size;
> >  
> > -	bgrt_image = memremap(bgrt_tab->image_address, bmp_header.size, MEMREMAP_WB);
> > -	if (!bgrt_image) {
> > -		pr_notice("Ignoring BGRT: failed to map image memory\n");
> > -		bgrt_image = NULL;
> > -		return;
> > -	}
> > -
> > -	efi_mem_reserve(bgrt_tab->image_address, bgrt_image_size);
> > +	efi_mem_reserve(bgrt_tab.image_address, bgrt_image_size);
> >  }
> > --- linux-x86.orig/drivers/acpi/bgrt.c
> > +++ linux-x86/drivers/acpi/bgrt.c
> > @@ -15,40 +15,41 @@
> >  #include <linux/sysfs.h>
> >  #include <linux/efi-bgrt.h>
> >  
> > +static void *bgrt_image;
> 
> [...]
> 
> > @@ -84,9 +85,17 @@ static int __init bgrt_init(void)
> >  {
> >  	int ret;
> >  
> > -	if (!bgrt_image)
> > +	if (!bgrt_tab.image_address)
> >  		return -ENODEV;
> >  
> > +	bgrt_image = memremap(bgrt_tab.image_address, bgrt_image_size,
> > +			      MEMREMAP_WB);
> > +	if (!bgrt_image) {
> > +		pr_notice("Ignoring BGRT: failed to map image memory\n");
> > +		bgrt_image = NULL;
> > +		return -ENOMEM;
> > +	}
> > +
> >  	bin_attr_image.private = bgrt_image;
> >  	bin_attr_image.size = bgrt_image_size;
> >  
> 
> Thanks,
> 
> Nicolai

Thanks
Dave
