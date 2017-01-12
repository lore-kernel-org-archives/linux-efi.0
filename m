From: Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/4] efi/x86: move efi bgrt init code to early init code
Date: Fri, 13 Jan 2017 00:11:53 +0100
Message-ID: <87shonooue.fsf@gmail.com>
References: <20170112094118.815108042@redhat.com>
        <20170112094214.909117564@redhat.com> <871sw8pk73.fsf@gmail.com>
        <20170112213939.GD2709@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170112213939.GD2709-0VdLhd/A9Pl+NNSt+8eSiB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org> (Dave Young's
        message of "Fri, 13 Jan 2017 05:39:39 +0800")
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, mika.penttila-MRsr7dthA9VWk0Htik3J/w@public.gmane.org, bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, Jan 13 2017, Dave Young wrote:

> On 01/12/17 at 12:54pm, Nicolai Stange wrote:
>> On Thu, Jan 12 2017, Dave Young wrote:
>> 
>> > -void __init efi_bgrt_init(void)
>> > +void __init efi_bgrt_init(struct acpi_table_header *table)
>> >  {
>> > -	acpi_status status;
>> >  	void *image;
>> >  	struct bmp_header bmp_header;
>> >  
>> >  	if (acpi_disabled)
>> >  		return;
>> >  
>> > -	status = acpi_get_table("BGRT", 0,
>> > -	                        (struct acpi_table_header **)&bgrt_tab);
>> > -	if (ACPI_FAILURE(status))
>> > -		return;
>> 
>> 
>> Not sure, but wouldn't it be safer to reverse the order of this assignment
>> 
>> > +	bgrt_tab = *(struct acpi_table_bgrt *)table;
>
> Nicolai, sorry, I'm not sure I understand the comment, is it about above line?
> Could you elaborate a bit?
>
>> 
>> and this length check
>> 
>
> I also do not get this :(

Ah sorry, my point is this: the length check should perhaps be made
before doing the assignment to bgrt_tab because otherwise, we might end
up reading from invalid memory.

I.e. if (struct acpi_table_bgrt *)table->length < sizeof(bgrt_tab), then

  bgrt_tab = *(struct acpi_table_bgrt *)table;

would read past the table's end.

I'm not sure whether this is a real problem though -- that is, whether
this read could ever hit some unmapped memory.


>> > -	if (bgrt_tab->header.length < sizeof(*bgrt_tab)) {
>> > +	if (bgrt_tab.header.length < sizeof(bgrt_tab)) {
>> >  		pr_notice("Ignoring BGRT: invalid length %u (expected %zu)\n",
>> > -		       bgrt_tab->header.length, sizeof(*bgrt_tab));
>> > +		       bgrt_tab.header.length, sizeof(bgrt_tab));
>> >  		return;
>> >  	}
>> 
>> ?

Thanks,

Nicolai
