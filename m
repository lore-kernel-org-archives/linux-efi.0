From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [Xen-devel] [PATCH v2 16/16] ARM64: XEN: Initialize Xen specific
 UEFI runtime services
Date: Tue, 19 Jan 2016 21:12:52 +0800
Message-ID: <569E3654.90100@linaro.org>
References: <1452840929-19612-1-git-send-email-zhaoshenglong@huawei.com> <1452840929-19612-17-git-send-email-zhaoshenglong@huawei.com> <alpine.DEB.2.02.1601181634070.9400@kaball.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.02.1601181634070.9400-7Z66fg9igcxYtxbxJUhB2Dgeux46jI+i@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>, Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org



On 2016/1/19 1:03, Stefano Stabellini wrote:
> On Fri, 15 Jan 2016, Shannon Zhao wrote:
>> From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>
>> When running on Xen hypervisor, runtime services are supported through
>> hypercall. So call Xen specific function to initialize runtime services.
>>
>> Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>
> Thanks Shannon, much much better!  Just a couple of questions.
>
>
>>   arch/arm/xen/enlighten.c |  5 +++++
>>   arch/arm64/xen/Makefile  |  1 +
>>   arch/arm64/xen/efi.c     | 36 ++++++++++++++++++++++++++++++++++++
>>   drivers/xen/Kconfig      |  2 +-
>>   include/xen/xen-ops.h    |  1 +
>>   5 files changed, 44 insertions(+), 1 deletion(-)
>>   create mode 100644 arch/arm64/xen/efi.c
>>
>> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
>> index 485e117..84f27ec 100644
>> --- a/arch/arm/xen/enlighten.c
>> +++ b/arch/arm/xen/enlighten.c
>> @@ -414,6 +414,11 @@ static int __init xen_guest_init(void)
>>   	if (xen_initial_domain())
>>   		pvclock_gtod_register_notifier(&xen_pvclock_gtod_notifier);
>>
>> +	if (IS_ENABLED(CONFIG_XEN_EFI)) {
>> +		if (efi_enabled(EFI_PARAVIRT))
>> +			xen_efi_runtime_setup();
>> +	}
>> +
>>   	return 0;
>>   }
>>   early_initcall(xen_guest_init);
>> diff --git a/arch/arm64/xen/Makefile b/arch/arm64/xen/Makefile
>> index 74a8d87..62e6fe2 100644
>> --- a/arch/arm64/xen/Makefile
>> +++ b/arch/arm64/xen/Makefile
>> @@ -1,2 +1,3 @@
>>   xen-arm-y	+= $(addprefix ../../arm/xen/, enlighten.o grant-table.o p2m.o mm.o)
>>   obj-y		:= xen-arm.o hypercall.o
>> +obj-$(CONFIG_XEN_EFI) += efi.o
>> diff --git a/arch/arm64/xen/efi.c b/arch/arm64/xen/efi.c
>> new file mode 100644
>> index 0000000..33046b0
>> --- /dev/null
>> +++ b/arch/arm64/xen/efi.c
>> @@ -0,0 +1,36 @@
>> +/*
>> + * Copyright (c) 2015, Linaro Limited, Shannon Zhao
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License along
>> + * with this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#include <linux/efi.h>
>> +#include <xen/xen-ops.h>
>> +
>> +void __init xen_efi_runtime_setup(void)
>> +{
>> +	efi.get_time                 = xen_efi_get_time;
>> +	efi.set_time                 = xen_efi_set_time;
>> +	efi.get_wakeup_time          = xen_efi_get_wakeup_time;
>> +	efi.set_wakeup_time          = xen_efi_set_wakeup_time;
>> +	efi.get_variable             = xen_efi_get_variable;
>> +	efi.get_next_variable        = xen_efi_get_next_variable;
>> +	efi.set_variable             = xen_efi_set_variable;
>> +	efi.query_variable_info      = xen_efi_query_variable_info;
>> +	efi.update_capsule           = xen_efi_update_capsule;
>> +	efi.query_capsule_caps       = xen_efi_query_capsule_caps;
>> +	efi.get_next_high_mono_count = xen_efi_get_next_high_mono_count;
>> +	efi.reset_system             = NULL;
>> +}
>> +EXPORT_SYMBOL_GPL(xen_efi_runtime_setup);
>
> This looks very similar to struct efi efi_xen previously in
> drivers/xen/efi.c.  Maybe it makes sense to leave struct efi efi_xen in
> drivers/xen/efi.c, export it in include/xen/xen-ops.h, then here just:
>
>    efi = efi_xen;
>
> Would that improve code readability?
>
Ok.
>
> Correct me if I am wrong, but on ARM64 (differently from x86) it is not
> necessary to set efi.systab because it is not used, right? If so, it
> would be best to add a comment here to remember.
>
Not set efi.systab here because it gets the system table through fdt and 
set efi.systab there. See uefi_init() in arch/arm64/kernel.efi.c

	efi.systab = early_memremap(efi_system_table,
				    sizeof(efi_system_table_t));
>
>> diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
>> index 73708ac..27d216a 100644
>> --- a/drivers/xen/Kconfig
>> +++ b/drivers/xen/Kconfig
>> @@ -268,7 +268,7 @@ config XEN_HAVE_PVMMU
>>
>>   config XEN_EFI
>>   	def_bool y
>> -	depends on X86_64 && EFI
>> +	depends on (ARM64 || X86_64) && EFI
>>
>>   config XEN_AUTO_XLATE
>>   	def_bool y
>> diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
>> index c83a338..36ff8e4 100644
>> --- a/include/xen/xen-ops.h
>> +++ b/include/xen/xen-ops.h
>> @@ -107,6 +107,7 @@ efi_status_t xen_efi_update_capsule(efi_capsule_header_t **capsules,
>>   efi_status_t xen_efi_query_capsule_caps(efi_capsule_header_t **capsules,
>>   					unsigned long count, u64 *max_size,
>>   					int *reset_type);
>> +void xen_efi_runtime_setup(void);
>
> xen_efi_runtime_setup is not defined on x86, but this header is not arch
> specific.
>

-- 
Shannon
