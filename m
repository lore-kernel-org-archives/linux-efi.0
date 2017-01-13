From: Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH 2/4] efi/x86: move efi bgrt init code to early init code
Date: Fri, 13 Jan 2017 10:21:06 +0800
Message-ID: <20170113022106.GA3266@dhcp-128-65.nay.redhat.com>
References: <20170112094118.815108042@redhat.com>
 <20170112094214.909117564@redhat.com>
 <871sw8pk73.fsf@gmail.com>
 <20170112213939.GD2709@dhcp-128-65.nay.redhat.com>
 <87shonooue.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87shonooue.fsf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicolai Stange <nicstange@gmail.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, hpa@zytor.com, Dan Williams <dan.j.williams@intel.com>, mika.penttila@nextfour.com, bhsharma@redhat.com
List-Id: linux-efi@vger.kernel.org

On 01/13/17 at 12:11am, Nicolai Stange wrote:
> On Fri, Jan 13 2017, Dave Young wrote:
> 
> > On 01/12/17 at 12:54pm, Nicolai Stange wrote:
> >> On Thu, Jan 12 2017, Dave Young wrote:
> >> 
> >> > -void __init efi_bgrt_init(void)
> >> > +void __init efi_bgrt_init(struct acpi_table_header *table)
> >> >  {
> >> > -	acpi_status status;
> >> >  	void *image;
> >> >  	struct bmp_header bmp_header;
> >> >  
> >> >  	if (acpi_disabled)
> >> >  		return;
> >> >  
> >> > -	status = acpi_get_table("BGRT", 0,
> >> > -	                        (struct acpi_table_header **)&bgrt_tab);
> >> > -	if (ACPI_FAILURE(status))
> >> > -		return;
> >> 
> >> 
> >> Not sure, but wouldn't it be safer to reverse the order of this assignment
> >> 
> >> > +	bgrt_tab = *(struct acpi_table_bgrt *)table;
> >
> > Nicolai, sorry, I'm not sure I understand the comment, is it about above line?
> > Could you elaborate a bit?
> >
> >> 
> >> and this length check
> >> 
> >
> > I also do not get this :(
> 
> Ah sorry, my point is this: the length check should perhaps be made
> before doing the assignment to bgrt_tab because otherwise, we might end
> up reading from invalid memory.
> 
> I.e. if (struct acpi_table_bgrt *)table->length < sizeof(bgrt_tab), then
> 
>   bgrt_tab = *(struct acpi_table_bgrt *)table;
> 
> would read past the table's end.
> 
> I'm not sure whether this is a real problem though -- that is, whether
> this read could ever hit some unmapped memory.

Nicolai, thanks for the explanation. It make sense to move it to even later
at the end of the function.

Thanks
Dave
