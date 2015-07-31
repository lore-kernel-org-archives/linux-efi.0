From: joeyli <jlee@suse.com>
Subject: Re: [RFC PATCH 05/16] x86/efi: Get entropy through EFI random number
 generator protocol
Date: Fri, 31 Jul 2015 17:58:54 +0800
Message-ID: <20150731095854.GC13113@linux-rxt1.site>
References: <1437056730-15247-1-git-send-email-jlee@suse.com>
 <1437056730-15247-6-git-send-email-jlee@suse.com>
 <20150728122853.GB12681@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150728122853.GB12681@amd>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-efi@vger.kernel.org

On Tue, Jul 28, 2015 at 02:28:53PM +0200, Pavel Machek wrote:
> On Thu 2015-07-16 22:25:19, Lee, Chun-Yi wrote:
> > To grab random numbers through EFI protocol as one of the entropies
> > source of swsusp key, this patch adds the logic for accessing EFI RNG
> > (random number generator) protocol that's introduced since UEFI 2.4.
> > 
> > Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> > ---
> >  arch/x86/boot/compressed/efi_random.c | 193 ++++++++++++++++++++++++++++++++++
> >  include/linux/efi.h                   |  46 ++++++++
> >  2 files changed, 239 insertions(+)
> > 
> > diff --git a/arch/x86/boot/compressed/efi_random.c b/arch/x86/boot/compressed/efi_random.c
> > index bdb2d46..1f5c63d 100644
> > --- a/arch/x86/boot/compressed/efi_random.c
> > +++ b/arch/x86/boot/compressed/efi_random.c
> > @@ -2,6 +2,191 @@
> >  
> >  #include <linux/efi.h>
> >  #include <asm/archrandom.h>
> > +#include <asm/efi.h>
> > +
> > +static efi_status_t efi_locate_rng(efi_system_table_t *sys_table,
> > +				   void ***rng_handle)
> > +{
> > +	efi_guid_t rng_proto = EFI_RNG_PROTOCOL_GUID;
> > +	unsigned long size = 0;
> > +	efi_status_t status;
> > +
> > +	status = efi_call_early(locate_handle,
> > +				EFI_LOCATE_BY_PROTOCOL,
> > +				&rng_proto, NULL, &size, *rng_handle);
> > +
> > +	if (status == EFI_BUFFER_TOO_SMALL) {
> > +		status = efi_call_early(allocate_pool,
> > +					EFI_LOADER_DATA,
> > +					size, (void **)rng_handle);
> > +
> > +		if (status != EFI_SUCCESS) {
> > +			efi_printk(sys_table, " Failed to alloc mem for rng_handle");
> > +			return status;
> > +		}
> > +
> > +		status = efi_call_early(locate_handle,
> > +					EFI_LOCATE_BY_PROTOCOL, &rng_proto,
> > +					NULL, &size, *rng_handle);
> > +	}
> > +
> > +	if (status != EFI_SUCCESS) {
> > +		efi_printk(sys_table, " Failed to locateEFI_RNG_PROTOCOL");
> 
> missing \n?
>

Originally those logs just follow a "EFI random" as a complete line. After
removed "EFI random", I will add "\n" back to those log.
 
> > +		goto free_handle;
> 
> You use that label exactly once, no need for goto
> 

OK, I will remove free_handle label.

> > +static bool efi_rng_supported32(efi_system_table_t *sys_table, void **rng_handle)
> > +{
> > +	const struct efi_config *efi_early = __efi_early();
> > +	efi_rng_protocol_32 *rng = NULL;
> ...> +static bool efi_rng_supported64(efi_system_table_t *sys_table, void **rng_handle)
> > +{
> > +	const struct efi_config *efi_early = __efi_early();
> > +	efi_rng_protocol_64 *rng = NULL;
> > +	efi_guid_t rng_proto = EFI_RNG_PROTOCOL_GUID;
> ...
> > +static unsigned long efi_get_rng32(efi_system_table_t *sys_table,
> > +				   void **rng_handle)
> > +{
> > +	const struct efi_config *efi_early = __efi_early();
> > +	efi_rng_protocol_32 *rng = NULL;
> > +	efi_guid_t rng_proto = EFI_RNG_PROTOCOL_GUID;
> ...
> > +static unsigned long efi_get_rng64(efi_system_table_t *sys_table,
> > +				   void **rng_handle)
> > +{
> > +	const struct efi_config *efi_early = __efi_early();
> > +	efi_rng_protocol_64 *rng = NULL;
> > +	efi_guid_t rng_proto = EFI_RNG_PROTOCOL_GUID;
> 
> Can you do something to avoid each function having two very similar
> versions of these functions?
>

They are similar but I want follow the style in eboot.c.
On the other hand, it's earlier to locate problem on 32-bit or 64-bit EFI.

So, I will keep the above codes.
 
> > +		if (status != EFI_SUCCESS) {
> > +			efi_printk(sys_table, " Failed to get RNG value ");
> > +			efi_printk(sys_table, efi_status_to_str(status));
> 
> Yep. You definitely have \n problems here.

Thanks, I will add \n here also.

> 
> > --- a/include/linux/efi.h
> > +++ b/include/linux/efi.h
> > @@ -427,6 +427,16 @@ typedef struct {
> >  #define EFI_PCI_IO_ATTRIBUTE_VGA_PALETTE_IO_16 0x20000
> >  #define EFI_PCI_IO_ATTRIBUTE_VGA_IO_16 0x40000
> >  
> > +typedef struct {
> > +	u32 get_info;
> > +	u32 get_rng;
> > +} efi_rng_protocol_32;
> > +
> > +typedef struct {
> > +	u64 get_info;
> > +	u64 get_rng;
> > +} efi_rng_protocol_64;
> 
> We don't typedef structs usually...
> 
> Make it union so you can have just one
>

I want to follow the style as efi_pci_io_protocolxxx in efi.h.
So I will keep it.
 
> > +static inline char *efi_status_to_str(efi_status_t status)
> > +{
> > +	char *str;
> > +
> 
> Are you sure you want this inlined?
>

It's inlined because in header file.
Currently it's only used by efi_random.c, I will move it to efi_random.
 
> > +	switch (status) {
> > +	case EFI_SUCCESS:
> > +		str = "EFI_SUCCESS";
> > +		break;
> 
> Can you use macros to reduce code duplication here?
> 									Pavel
I will try to reduce duplicate code.


Thanks
Joey Lee
