From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 1/2] efi: Export boot-services code and data as
 debugfs-blobs
Date: Sat, 31 Mar 2018 18:57:29 +0200
Message-ID: <646d64dc-0c14-a96a-f91b-787a74f7ca35@redhat.com>
References: <20180331121944.8618-1-hdegoede@redhat.com>
 <20180331141030.GB1074@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180331141030.GB1074@kroah.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, Peter Jones <pjones@redhat.com>, Dave Olsthoorn <dave@bewaar.me>, x86@kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Hi,

On 03/31/2018 04:10 PM, Greg Kroah-Hartman wrote:
> On Sat, Mar 31, 2018 at 02:19:43PM +0200, Hans de Goede wrote:
>> Sometimes it is useful to be able to dump the efi boot-services code and
>> data. This commit adds these as debugfs-blobs to /sys/kernel/debug/efi,
>> but only if efi=debug is passed on the kernel-commandline as this requires
>> not freeing those memory-regions, which costs 20+ MB of RAM.
>>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>>   arch/x86/platform/efi/quirks.c |  4 +++
>>   drivers/firmware/efi/efi.c     | 57 ++++++++++++++++++++++++++++++++++
>>   2 files changed, 61 insertions(+)
>>
>> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
>> index 5b513ccffde4..0f968c7bcfec 100644
>> --- a/arch/x86/platform/efi/quirks.c
>> +++ b/arch/x86/platform/efi/quirks.c
>> @@ -374,6 +374,10 @@ void __init efi_free_boot_services(void)
>>   	int num_entries = 0;
>>   	void *new, *new_md;
>>   
>> +	/* Keep all regions for /sys/kernel/debug/efi */
>> +	if (efi_enabled(EFI_DBG))
>> +		return;
>> +
>>   	for_each_efi_memory_desc(md) {
>>   		unsigned long long start = md->phys_addr;
>>   		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
>> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
>> index cd42f66a7c85..fddc5f706fd2 100644
>> --- a/drivers/firmware/efi/efi.c
>> +++ b/drivers/firmware/efi/efi.c
>> @@ -18,6 +18,7 @@
>>   #include <linux/kobject.h>
>>   #include <linux/module.h>
>>   #include <linux/init.h>
>> +#include <linux/debugfs.h>
>>   #include <linux/device.h>
>>   #include <linux/efi.h>
>>   #include <linux/of.h>
>> @@ -316,6 +317,59 @@ static __init int efivar_ssdt_load(void)
>>   static inline int efivar_ssdt_load(void) { return 0; }
>>   #endif
>>   
>> +#ifdef CONFIG_DEBUG_FS
>> +
>> +#define EFI_DEBUGFS_MAX_BLOBS 32
>> +
>> +struct debugfs_blob_wrapper debugfs_blob[EFI_DEBUGFS_MAX_BLOBS];
>> +
>> +static void __init efi_debugfs_init(void)
>> +{
>> +	struct dentry *efi_debugfs;
>> +	efi_memory_desc_t *md;
>> +	char name[32];
>> +	int type_count[EFI_BOOT_SERVICES_DATA + 1] = {};
>> +	int i = 0;
>> +
>> +	efi_debugfs = debugfs_create_dir("efi", NULL);
>> +	if (IS_ERR_OR_NULL(efi_debugfs)) {
>> +		pr_warn("Could not create efi debugfs entry\n");
>> +		return;
>> +	}
> 
> {sigh}
> 
> No, don't warn, or complain, or do anything else if a debugfs call
> fails.  Just keep on moving, you can always use the return value
> properly in any future call if you need it, and no code flow should ever
> care if a debugfs call succeeded or failed.

Ok.

>>   /*
>>    * We register the efi subsystem with the firmware subsystem and the
>>    * efivars subsystem with the efi subsystem, if the system was booted with
>> @@ -360,6 +414,9 @@ static int __init efisubsys_init(void)
>>   		goto err_remove_group;
>>   	}
>>   
>> +	if (efi_enabled(EFI_DBG))
>> +		efi_debugfs_init();
> 
> You never remove the directory?

Correct, this is happening from a subsys_initcall as such there is no
efi_cleanup() counterpart.

Note the "if (efi_enabled(EFI_DBG))" check checks for efi=debug on the
kernel cmdline, so this only happens if the user asked for it.

Regards,

Hans
