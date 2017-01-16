From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/4] efi/x86: move efi bgrt init code to early init code
Date: Mon, 16 Jan 2017 10:55:19 +0800
Message-ID: <20170116025519.GA3798@dhcp-128-65.nay.redhat.com>
References: <20170112094118.815108042@redhat.com>
 <20170112094214.909117564@redhat.com>
 <871sw8pk73.fsf@gmail.com>
 <20170112213939.GD2709@dhcp-128-65.nay.redhat.com>
 <87shonooue.fsf@gmail.com>
 <20170113022106.GA3266@dhcp-128-65.nay.redhat.com>
 <20170113030404.GA14023@dhcp-128-65.nay.redhat.com>
 <87o9zbno9r.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87o9zbno9r.fsf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, mika.penttila-MRsr7dthA9VWk0Htik3J/w@public.gmane.org, bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 01/13/17 at 01:21pm, Nicolai Stange wrote:
> On Fri, Jan 13 2017, Dave Young wrote:
> 
> > On 01/13/17 at 10:21am, Dave Young wrote:
> >> On 01/13/17 at 12:11am, Nicolai Stange wrote:
> >> > On Fri, Jan 13 2017, Dave Young wrote:
> >> > 
> >> > > On 01/12/17 at 12:54pm, Nicolai Stange wrote:
> >> > >> On Thu, Jan 12 2017, Dave Young wrote:
> >> > >> 
> >> > >> > -void __init efi_bgrt_init(void)
> >> > >> > +void __init efi_bgrt_init(struct acpi_table_header *table)
> >> > >> >  {
> >> > >> > -	acpi_status status;
> >> > >> >  	void *image;
> >> > >> >  	struct bmp_header bmp_header;
> >> > >> >  
> >> > >> >  	if (acpi_disabled)
> >> > >> >  		return;
> >> > >> >  
> >> > >> > -	status = acpi_get_table("BGRT", 0,
> >> > >> > -	                        (struct acpi_table_header **)&bgrt_tab);
> >> > >> > -	if (ACPI_FAILURE(status))
> >> > >> > -		return;
> >> > >> 
> >> > >> 
> >> > >> Not sure, but wouldn't it be safer to reverse the order of this
> >> > >> assignment
> >> > >> 
> >> > >> > +	bgrt_tab = *(struct acpi_table_bgrt *)table;
> >> > >
> >> > > Nicolai, sorry, I'm not sure I understand the comment, is it
> >> > > about above line?
> >> > > Could you elaborate a bit?
> >> > >
> >> > >> 
> >> > >> and this length check
> >> > >> 
> >> > >
> >> > > I also do not get this :(
> >> > 
> >> > Ah sorry, my point is this: the length check should perhaps be made
> >> > before doing the assignment to bgrt_tab because otherwise, we might end
> >> > up reading from invalid memory.
> >> > 
> >> > I.e. if (struct acpi_table_bgrt *)table->length < sizeof(bgrt_tab), then
> >> > 
> >> >   bgrt_tab = *(struct acpi_table_bgrt *)table;
> >> > 
> >> > would read past the table's end.
> >> > 
> >> > I'm not sure whether this is a real problem though -- that is, whether
> >> > this read could ever hit some unmapped memory.
> >> 
> >> Nicolai, thanks for the explanation. It make sense to move it to even later
> >> at the end of the function.
> >
> > Indeed assignment should be after the length checking, but with another
> > tmp variable the assignment to global var can be moved to the end to
> > avoid clear the image_address field..
> 
> I had a look at your updated patches at
> http://people.redhat.com/~ruyang/efi-bgrt/ and they look fine to me.

Many thanks~

> 
> One minor remark:
> 
> sizeof(acpi_table_bgrt) == 56 and it might be better to avoid the extra
> tmp copy in efi_bgrt_init() by
> - assigning directly to bgrt_tab
> - do a 'goto err' rather than a 'return' from all the error paths
> - do a memset(&bgrt_tab, 0, sizeof(bgrt_tab)) at 'err:'

Updated in V2, indeed text size shrunk from 1199 to 762.

> 
> 
> With the copy to the on-stack 'bgrt', gcc 6.2.0 emits this for each of
> the two copies:
> 
>   41:   8a 07                   mov    (%rdi),%al
>   43:   88 45 d7                mov    %al,-0x29(%rbp)
>   46:   8a 47 01                mov    0x1(%rdi),%al
>   49:   88 45 d6                mov    %al,-0x2a(%rbp)
>   4c:   8a 47 02                mov    0x2(%rdi),%al
>   4f:   88 45 d5                mov    %al,-0x2b(%rbp)
>   52:   8a 47 03                mov    0x3(%rdi),%al
>   55:   88 45 d4                mov    %al,-0x2c(%rbp)
>   58:   8a 47 08                mov    0x8(%rdi),%al
>   5b:   88 45 d3                mov    %al,-0x2d(%rbp)
>   5e:   8a 47 09                mov    0x9(%rdi),%al
>   61:   88 45 d2                mov    %al,-0x2e(%rbp)
>   64:   8a 47 0a                mov    0xa(%rdi),%al
>   67:   88 45 d1                mov    %al,-0x2f(%rbp)
>   6a:   8a 47 0b                mov    0xb(%rdi),%al
>   6d:   88 45 d0                mov    %al,-0x30(%rbp)
>   70:   8a 47 0c                mov    0xc(%rdi),%al
>   73:   88 45 cf                mov    %al,-0x31(%rbp)
>   76:   8a 47 0d                mov    0xd(%rdi),%al
>   79:   88 45 ce                mov    %al,-0x32(%rbp)
>   7c:   8a 47 0e                mov    0xe(%rdi),%al
>   7f:   88 45 cd                mov    %al,-0x33(%rbp)
>   82:   8a 47 0f                mov    0xf(%rdi),%al
>   85:   88 45 cc                mov    %al,-0x34(%rbp)
>   88:   8a 47 10                mov    0x10(%rdi),%al
>   8b:   88 45 cb                mov    %al,-0x35(%rbp)
>   8e:   8a 47 11                mov    0x11(%rdi),%al
>   91:   88 45 ca                mov    %al,-0x36(%rbp)
>   94:   8a 47 12                mov    0x12(%rdi),%al
>   97:   88 45 c9                mov    %al,-0x37(%rbp)
>   9a:   8a 47 13                mov    0x13(%rdi),%al
>   9d:   88 45 c8                mov    %al,-0x38(%rbp)
>   a0:   8a 47 14                mov    0x14(%rdi),%al
>   a3:   8a 5f 26                mov    0x26(%rdi),%bl
>   a6:   0f b6 77 27             movzbl 0x27(%rdi),%esi
>   aa:   4c 8b 67 28             mov    0x28(%rdi),%r12
>   ae:   88 45 c7                mov    %al,-0x39(%rbp)
>   b1:   8a 47 15                mov    0x15(%rdi),%al
>   b4:   44 8b 6f 30             mov    0x30(%rdi),%r13d
>   b8:   44 8b 7f 34             mov    0x34(%rdi),%r15d
>   bc:   88 45 c6                mov    %al,-0x3a(%rbp)
>   bf:   8a 47 16                mov    0x16(%rdi),%al
>   c2:   88 45 c5                mov    %al,-0x3b(%rbp)
>   c5:   8a 47 17                mov    0x17(%rdi),%al
>   c8:   88 45 c4                mov    %al,-0x3c(%rbp)
>   cb:   8b 47 18                mov    0x18(%rdi),%eax
>   ce:   89 45 c0                mov    %eax,-0x40(%rbp)
>   d1:   8a 47 1c                mov    0x1c(%rdi),%al
>   d4:   88 45 bf                mov    %al,-0x41(%rbp)
>   d7:   8a 47 1d                mov    0x1d(%rdi),%al
>   da:   88 45 be                mov    %al,-0x42(%rbp)
>   dd:   8a 47 1e                mov    0x1e(%rdi),%al
>   e0:   88 45 bd                mov    %al,-0x43(%rbp)
>   e3:   8a 47 1f                mov    0x1f(%rdi),%al
>   e6:   88 45 bc                mov    %al,-0x44(%rbp)
>   e9:   8b 47 20                mov    0x20(%rdi),%eax
>   ec:   89 45 b8                mov    %eax,-0x48(%rbp)
>   ef:   66 8b 47 24             mov    0x24(%rdi),%ax
> 
> Not sure why gcc would think that storing bgrt in reversed order on the
> stack might be a good idea, but well...

I have no idea about this..

> 
> Thanks,
> 
> Nicolai

Thanks
Dave
