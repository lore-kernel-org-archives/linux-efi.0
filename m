From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC PATCH 05/16] x86/efi: Get entropy through EFI random number
 generator protocol
Date: Tue, 28 Jul 2015 14:28:53 +0200
Message-ID: <20150728122853.GB12681@amd>
References: <1437056730-15247-1-git-send-email-jlee@suse.com>
 <1437056730-15247-6-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1437056730-15247-6-git-send-email-jlee@suse.com>
Sender: linux-pm-owner@vger.kernel.org
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>, "Lee, Chun-Yi" <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

On Thu 2015-07-16 22:25:19, Lee, Chun-Yi wrote:
> To grab random numbers through EFI protocol as one of the entropies
> source of swsusp key, this patch adds the logic for accessing EFI RNG
> (random number generator) protocol that's introduced since UEFI 2.4.
> 
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> ---
>  arch/x86/boot/compressed/efi_random.c | 193 ++++++++++++++++++++++++++++++++++
>  include/linux/efi.h                   |  46 ++++++++
>  2 files changed, 239 insertions(+)
> 
> diff --git a/arch/x86/boot/compressed/efi_random.c b/arch/x86/boot/compressed/efi_random.c
> index bdb2d46..1f5c63d 100644
> --- a/arch/x86/boot/compressed/efi_random.c
> +++ b/arch/x86/boot/compressed/efi_random.c
> @@ -2,6 +2,191 @@
>  
>  #include <linux/efi.h>
>  #include <asm/archrandom.h>
> +#include <asm/efi.h>
> +
> +static efi_status_t efi_locate_rng(efi_system_table_t *sys_table,
> +				   void ***rng_handle)
> +{
> +	efi_guid_t rng_proto = EFI_RNG_PROTOCOL_GUID;
> +	unsigned long size = 0;
> +	efi_status_t status;
> +
> +	status = efi_call_early(locate_handle,
> +				EFI_LOCATE_BY_PROTOCOL,
> +				&rng_proto, NULL, &size, *rng_handle);
> +
> +	if (status == EFI_BUFFER_TOO_SMALL) {
> +		status = efi_call_early(allocate_pool,
> +					EFI_LOADER_DATA,
> +					size, (void **)rng_handle);
> +
> +		if (status != EFI_SUCCESS) {
> +			efi_printk(sys_table, " Failed to alloc mem for rng_handle");
> +			return status;
> +		}
> +
> +		status = efi_call_early(locate_handle,
> +					EFI_LOCATE_BY_PROTOCOL, &rng_proto,
> +					NULL, &size, *rng_handle);
> +	}
> +
> +	if (status != EFI_SUCCESS) {
> +		efi_printk(sys_table, " Failed to locateEFI_RNG_PROTOCOL");

missing \n?

> +		goto free_handle;

You use that label exactly once, no need for goto

> +static bool efi_rng_supported32(efi_system_table_t *sys_table, void **rng_handle)
> +{
> +	const struct efi_config *efi_early = __efi_early();
> +	efi_rng_protocol_32 *rng = NULL;
...> +static bool efi_rng_supported64(efi_system_table_t *sys_table, void **rng_handle)
> +{
> +	const struct efi_config *efi_early = __efi_early();
> +	efi_rng_protocol_64 *rng = NULL;
> +	efi_guid_t rng_proto = EFI_RNG_PROTOCOL_GUID;
...
> +static unsigned long efi_get_rng32(efi_system_table_t *sys_table,
> +				   void **rng_handle)
> +{
> +	const struct efi_config *efi_early = __efi_early();
> +	efi_rng_protocol_32 *rng = NULL;
> +	efi_guid_t rng_proto = EFI_RNG_PROTOCOL_GUID;
...
> +static unsigned long efi_get_rng64(efi_system_table_t *sys_table,
> +				   void **rng_handle)
> +{
> +	const struct efi_config *efi_early = __efi_early();
> +	efi_rng_protocol_64 *rng = NULL;
> +	efi_guid_t rng_proto = EFI_RNG_PROTOCOL_GUID;

Can you do something to avoid each function having two very similar
versions of these functions?

> +		if (status != EFI_SUCCESS) {
> +			efi_printk(sys_table, " Failed to get RNG value ");
> +			efi_printk(sys_table, efi_status_to_str(status));

Yep. You definitely have \n problems here.

> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -427,6 +427,16 @@ typedef struct {
>  #define EFI_PCI_IO_ATTRIBUTE_VGA_PALETTE_IO_16 0x20000
>  #define EFI_PCI_IO_ATTRIBUTE_VGA_IO_16 0x40000
>  
> +typedef struct {
> +	u32 get_info;
> +	u32 get_rng;
> +} efi_rng_protocol_32;
> +
> +typedef struct {
> +	u64 get_info;
> +	u64 get_rng;
> +} efi_rng_protocol_64;

We don't typedef structs usually...

Make it union so you can have just one

> +static inline char *efi_status_to_str(efi_status_t status)
> +{
> +	char *str;
> +

Are you sure you want this inlined?

> +	switch (status) {
> +	case EFI_SUCCESS:
> +		str = "EFI_SUCCESS";
> +		break;

Can you use macros to reduce code duplication here?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
