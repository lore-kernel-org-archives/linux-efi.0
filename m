From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH 1/6] efi: Retrieve Apple device properties
Date: Fri, 5 Aug 2016 13:42:19 +0200
Message-ID: <20160805114219.GA4952@wunner.de>
References: <cover.1469616641.git.lukas@wunner.de>
 <833d193b8a18b0afe168c515e9e56a857ece4bd1.1469616641.git.lukas@wunner.de>
 <20160804151345.GM3636@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160804151345.GM3636-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pierre Moreau <pierre.morrow-GANU6spQydw@public.gmane.org>, reverser-P1ImLx+pFc0@public.gmane.org, grub-devel-mXXj517/zsQ@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Aug 04, 2016 at 04:13:45PM +0100, Matt Fleming wrote:
> On Thu, 28 Jul, at 02:25:41AM, Lukas Wunner wrote:
> > diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> > index ff574da..7262ee4 100644
> > --- a/arch/x86/boot/compressed/eboot.c
> > +++ b/arch/x86/boot/compressed/eboot.c
> > @@ -571,6 +571,55 @@ free_handle:
> >  	efi_call_early(free_pool, pci_handle);
> >  }
> >  
> > +static void retrieve_apple_device_properties(struct boot_params *params)
> > +{
> > +	efi_guid_t guid = APPLE_PROPERTIES_PROTOCOL_GUID;
> > +	struct setup_data *data, *new;
> > +	efi_status_t status;
> > +	void *properties;
> > +	u32 size = 0;
> > +
> > +	status = efi_early->call(
> > +			(unsigned long)sys_table->boottime->locate_protocol,
> > +			&guid, NULL, &properties);
> > +	if (status != EFI_SUCCESS)
> > +		return;
> > +
> > +	do {
> > +		status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
> > +			size + sizeof(struct setup_data), &new);
> > +		if (status != EFI_SUCCESS) {
> > +			efi_printk(sys_table,
> > +				   "Failed to alloc mem for properties\n");
> > +			return;
> > +		}
> > +		status = efi_early->call(efi_early->is64 ?
> > +			((apple_properties_protocol_64 *)properties)->get_all :
> > +			((apple_properties_protocol_32 *)properties)->get_all,
> > +			properties, new->data, &size);
> > +		if (status == EFI_BUFFER_TOO_SMALL)
> > +			efi_call_early(free_pool, new);
> > +	} while (status == EFI_BUFFER_TOO_SMALL);
> 
> Is this looping really required? Do we not know ahead of time what we
> expect the size to be? Writing this as a potentially infinite loop (if
> broken firmware always returns EFI_BUFFER_TOO_SMALL) is a bad idea.

macOS' bootloader does exactly the same. So if the firmware was broken
in this way, macOS wouldn't boot and it's unlikely that Apple would
ship it. The code is not executed on non-Macs (due to the memcmp for
sys_table->fw_vendor[] == u"Apple" in efi_main()).

Looks like this in /usr/standalone/i386/boot.efi:
58b9         mov        rbx, 0x8000000000000005		; EFI_BUFFER_TOO_SMALL
...
58e6         mov        rcx, qword [ss:rbp+var_38]	; properties protocol
58ea         mov        rdx, rdi			; properties buffer
58ed         mov        r8, rsi				; buffer len
58f0         call       qword [ds:rcx+0x20]		; properties->get_all
58f3         cmp        rax, rbx
58f6         je         0x58c5				; infinite loop

And the code in the corresponding ->get_all function in the EFI driver
is such that it only returns either EFI_SUCCESS or EFI_BUFFER_TOO_SMALL.

So I could cap the number of loop iterations but it would be pointless.

I also checked the bootloader they shipped with OS X 10.6 (2009), they
used Universal EFI binaries back then (x86_64 + i386) in order to support
the very first Intel Macs of 2006. Found the same infinite loop there.

The reason for the loop is that the number of device properties is
dynamic. E.g. each attached Thunderbolt device is assigned 3 properties.
If a Thunderbolt device is plugged in between a first loop iteration
(to obtain the size) and a second loop iteration (to fill the buffer),
EFI_BUFFER_TOO_SMALL is returned and a third loop iteration is needed.

Thanks,

Lukas
