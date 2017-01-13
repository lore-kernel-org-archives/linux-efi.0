From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/4] efi/x86: move efi bgrt init code to early init code
Date: Fri, 13 Jan 2017 11:04:04 +0800
Message-ID: <20170113030404.GA14023@dhcp-128-65.nay.redhat.com>
References: <20170112094118.815108042@redhat.com>
 <20170112094214.909117564@redhat.com>
 <871sw8pk73.fsf@gmail.com>
 <20170112213939.GD2709@dhcp-128-65.nay.redhat.com>
 <87shonooue.fsf@gmail.com>
 <20170113022106.GA3266@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170113022106.GA3266-0VdLhd/A9Pl+NNSt+8eSiB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, mika.penttila-MRsr7dthA9VWk0Htik3J/w@public.gmane.org, bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 01/13/17 at 10:21am, Dave Young wrote:
> On 01/13/17 at 12:11am, Nicolai Stange wrote:
> > On Fri, Jan 13 2017, Dave Young wrote:
> > 
> > > On 01/12/17 at 12:54pm, Nicolai Stange wrote:
> > >> On Thu, Jan 12 2017, Dave Young wrote:
> > >> 
> > >> > -void __init efi_bgrt_init(void)
> > >> > +void __init efi_bgrt_init(struct acpi_table_header *table)
> > >> >  {
> > >> > -	acpi_status status;
> > >> >  	void *image;
> > >> >  	struct bmp_header bmp_header;
> > >> >  
> > >> >  	if (acpi_disabled)
> > >> >  		return;
> > >> >  
> > >> > -	status = acpi_get_table("BGRT", 0,
> > >> > -	                        (struct acpi_table_header **)&bgrt_tab);
> > >> > -	if (ACPI_FAILURE(status))
> > >> > -		return;
> > >> 
> > >> 
> > >> Not sure, but wouldn't it be safer to reverse the order of this assignment
> > >> 
> > >> > +	bgrt_tab = *(struct acpi_table_bgrt *)table;
> > >
> > > Nicolai, sorry, I'm not sure I understand the comment, is it about above line?
> > > Could you elaborate a bit?
> > >
> > >> 
> > >> and this length check
> > >> 
> > >
> > > I also do not get this :(
> > 
> > Ah sorry, my point is this: the length check should perhaps be made
> > before doing the assignment to bgrt_tab because otherwise, we might end
> > up reading from invalid memory.
> > 
> > I.e. if (struct acpi_table_bgrt *)table->length < sizeof(bgrt_tab), then
> > 
> >   bgrt_tab = *(struct acpi_table_bgrt *)table;
> > 
> > would read past the table's end.
> > 
> > I'm not sure whether this is a real problem though -- that is, whether
> > this read could ever hit some unmapped memory.
> 
> Nicolai, thanks for the explanation. It make sense to move it to even later
> at the end of the function.

Indeed assignment should be after the length checking, but with another
tmp variable the assignment to global var can be moved to the end to
avoid clear the image_address field..

> 
> Thanks
> Dave
