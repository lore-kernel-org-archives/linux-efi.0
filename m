From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH 2/2] efi: add firmware version information to sysfs
Date: Wed, 24 Aug 2016 12:30:21 +0200
Message-ID: <20160824103021.GA22888@wunner.de>
References: <1471968832-19847-1-git-send-email-pjones@redhat.com>
 <1471968832-19847-2-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1471968832-19847-2-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Aug 23, 2016 at 12:13:52PM -0400, Peter Jones wrote:
> This adds the EFI Spec version from the system table to sysfs as
> /sys/firmware/efi/spec_version .
> 
> Userland tools need this information in order to work around
> specification deficiencies in 2.4 and earlier firmwares.

Some details or examples on the nature of those specification
deficiencies would help an uninitiated reader understand the
necessity of this patch.

> 
> Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  Documentation/ABI/testing/sysfs-firmware-efi |  6 +++
>  arch/ia64/kernel/efi.c                       |  3 ++
>  drivers/firmware/efi/arm-init.c              |  2 +
>  drivers/firmware/efi/efi.c                   | 71 ++++++++++++++++++++++++++++
>  4 files changed, 82 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-firmware-efi b/Documentation/ABI/testing/sysfs-firmware-efi
> index e794eac..4eec7c2 100644
> --- a/Documentation/ABI/testing/sysfs-firmware-efi
> +++ b/Documentation/ABI/testing/sysfs-firmware-efi
> @@ -28,3 +28,9 @@ Description:	Displays the physical addresses of all EFI Configuration
>  		versions are always printed first, i.e. ACPI20 comes
>  		before ACPI.
>  Users:		dmidecode
> +
> +What:		/sys/firmware/efi/spec_version
> +Date:		August 2016
> +Contact:	linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> +Description:	Displays the UEFI Specification revision the firmware claims to
> +		be based upon.
> diff --git a/arch/ia64/kernel/efi.c b/arch/ia64/kernel/efi.c
> index 1212956..a48377f 100644
> --- a/arch/ia64/kernel/efi.c
> +++ b/arch/ia64/kernel/efi.c
> @@ -475,6 +475,7 @@ efi_init (void)
>  	u64 efi_desc_size;
>  	char *cp, vendor[100] = "unknown";
>  	int i;
> +	efi_table_hdr_t *hdr;

Unused new variable?

>  
>  	set_bit(EFI_BOOT, &efi.flags);
>  	set_bit(EFI_64BIT, &efi.flags);
> @@ -531,6 +532,8 @@ efi_init (void)
>  	       efi.systab->hdr.revision >> 16,
>  	       efi.systab->hdr.revision & 0xffff, vendor);
>  
> +	efi.spec_version = efi.systab->hdr.version;
> +

I think this deserves a mention in the commit message that the
spec_version struct field was previously not filled for ia64 arch
and that you're fixing that while you're at it. Alternatively,
move this to a separate commit.

>  	palo_phys      = EFI_INVALID_TABLE_ADDR;
>  
>  	if (efi_config_init(arch_tables) != 0)
> diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
> index b89fc23..8e8cb8c 100644
> --- a/drivers/firmware/efi/arm-init.c
> +++ b/drivers/firmware/efi/arm-init.c
> @@ -133,6 +133,8 @@ static int __init uefi_init(void)
>  
>  	efi.spec_version = (u32)efi.systab->hdr.revision;
>  
> +	early_memunmap(tmp, sizeof(efi_table_hdr_t));
> +

What is the connection of this change to exposing the spec_version
in sysfs? Seems like a fix that should be moved to a separate commit.

>  	table_size = sizeof(efi_config_table_64_t) * efi.systab->nr_tables;
>  	config_tables = early_memremap_ro(efi_to_phys(efi.systab->tables),
>  					  table_size);
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 5a2631a..5947d19 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -27,6 +27,7 @@
>  #include <linux/slab.h>
>  #include <linux/acpi.h>
>  #include <linux/ucs2_string.h>
> +#include <linux/bcd.h>
>  
>  #include <asm/early_ioremap.h>
>  
> @@ -124,6 +125,74 @@ static struct kobj_attribute efi_attr_systab =
>  
>  #define EFI_FIELD(var) efi.var
>  
> +static ssize_t efi_version_show(struct kobject *kobj,
> +				struct kobj_attribute *attr,
> +				char *buf,
> +				u32 revision)
> +{
> +	char *str = buf;
> +	u16 major;
> +	u8 minor, tiny;
> +
> +	if (!kobj || !buf)
> +		return -EINVAL;
> +
> +	/* The spec says:
> +	 *  The revision of the EFI Specification to which this table
> +	 *  conforms. The upper 16 bits of this field contain the major
> +	 *  revision value, and the lower 16 bits contain the minor revision
> +	 *  value. The minor revision values are binary coded decimals and are
> +	 *  limited to the range of 00..99.
> +	 *
> +	 *  When printed or displayed UEFI spec revision is referred as (Major
> +	 *  revision).(Minor revision upper decimal).(Minor revision lower
> +	 *  decimal) or (Major revision).(Minor revision upper decimal) in
> +	 *  case Minor revision lower decimal is set to 0. For example:
> +	 *
> +	 *  A specification with the revision value ((2<<16) | (30)) would be
> +	 *  referred as 2.3;
> +	 *  A specification with the revision value ((2<<16) | (31)) would be
> +	 *  referred as 2.3.1
> +	 *
> +	 * Then later it says:
> +	 *  Related Definitions
> +	 *   #define EFI_SYSTEM_TABLE_SIGNATURE 0x5453595320494249
> +	 *   #define EFI_2_40_SYSTEM_TABLE_REVISION ((2<<16) | (40))
> +	 *   #define EFI_2_31_SYSTEM_TABLE_REVISION ((2<<16) | (31))
> +	 *   #define EFI_2_30_SYSTEM_TABLE_REVISION ((2<<16) | (30))
> +	 *   #define EFI_2_20_SYSTEM_TABLE_REVISION ((2<<16) | (20))
> +	 *   #define EFI_2_10_SYSTEM_TABLE_REVISION ((2<<16) | (10))
> +	 *   #define EFI_2_00_SYSTEM_TABLE_REVISION ((2<<16) | (00))
> +	 *   #define EFI_1_10_SYSTEM_TABLE_REVISION ((1<<16) | (10))
> +	 *   #define EFI_1_02_SYSTEM_TABLE_REVISION ((1<<16) | (02))
> +	 *   #define EFI_SPECIFICATION_VERSION EFI_SYSTEM_TABLE_REVISION
> +	 *   #define EFI_SYSTEM_TABLE_REVISION EFI_2_40_SYSTEM_TABLE_REVISION
> +	 *
> +	 * (Apparently this bit of the spec failed to get updated for 2.5
> +	 * and 2.6; UefiSpec.h in Tiano has been updated, though.)
> +	 */

I'd only include a 2-3 line summary of the spec and move this documentation
to the commit message in order to keep the code concise.

> +
> +	major = (revision & 0xffff0000) >> 16;
> +	minor = bcd2bin((revision & 0x0000ff00) >> 8);
> +	tiny = bcd2bin(revision & 0x000000ff);

You can improve readability by inserting a few blanks like this:

	major =         (revision & 0xffff0000) >> 16;
	minor = bcd2bin((revision & 0x0000ff00) >> 8);
	tiny  = bcd2bin( revision & 0x000000ff);

I'd also use minor_u and minor_l or somesuch instead of "tiny"
but that's just my preferred bikeshed color.

> +
> +	if (tiny == 0)
> +		str += sprintf(str, "%d.%d\n", major, minor);
> +	else
> +		str += sprintf(str, "%d.%d.%d\n", major, minor, tiny);
> +
> +	return str - buf;

Hm, why not return the result of sprintf directly (cast to ssize_t),
or if you want to handle negative return values properly, store the
result in an int?

> +}
> +
> +#define EFI_VERSION_ATTR_SHOW(name) \
> +static ssize_t name##_show(struct kobject *kobj, \
> +				struct kobj_attribute *attr, char *buf) \
> +{ \
> +	return efi_version_show(kobj, attr, buf, EFI_FIELD(name)); \
> +}
> +
> +EFI_VERSION_ATTR_SHOW(spec_version);
> +

Unless you plan to expose other versions like this, you can save on
code by not using a macro here.

Best regards,

Lukas

>  #define EFI_ATTR_SHOW(name) \
>  static ssize_t name##_show(struct kobject *kobj, \
>  				struct kobj_attribute *attr, char *buf) \
> @@ -146,6 +215,7 @@ static struct kobj_attribute efi_attr_runtime = __ATTR_RO(runtime);
>  static struct kobj_attribute efi_attr_config_table = __ATTR_RO(config_table);
>  static struct kobj_attribute efi_attr_fw_platform_size =
>  	__ATTR_RO(fw_platform_size);
> +static struct kobj_attribute efi_attr_spec_version = __ATTR_RO(spec_version);
>  
>  static struct attribute *efi_subsys_attrs[] = {
>  	&efi_attr_systab.attr,
> @@ -153,6 +223,7 @@ static struct attribute *efi_subsys_attrs[] = {
>  	&efi_attr_runtime.attr,
>  	&efi_attr_config_table.attr,
>  	&efi_attr_fw_platform_size.attr,
> +	&efi_attr_spec_version.attr,
>  	NULL,
>  };
>  
> -- 
> 2.7.4
