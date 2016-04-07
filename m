From: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v10 00/17] Add ACPI support for Xen Dom0 on ARM64
Date: Thu, 7 Apr 2016 09:39:45 +0800
Message-ID: <5705BA61.7000205@huawei.com>
References: <1459525755-36968-1-git-send-email-shannon.zhao@linaro.org> <5704F3E1.7020508@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5704F3E1.7020508-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Julien Grall <julien.grall-5wv7dgnIgG8@public.gmane.org>, Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org
Cc: david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi Julien,

On 2016/4/6 19:32, Julien Grall wrote:
> Hi Shannon,
> 
> On 01/04/2016 16:48, Shannon Zhao wrote:
>> This patch set adds ACPI support for Xen Dom0 on ARM64. The relevant Xen
>> ACPI on ARM64 design document could be found from [1].
>>
>> This patch set adds a new FDT node "uefi" under /hypervisor to pass UEFI
>> information. Introduce a bus notifier of AMBA and Platform bus to map
>> the new added device's MMIO space. Make Xen domain use
>> xlated_setup_gnttab_pages to setup grant table and a new hypercall to
>> get event-channel irq.
>>
>> Regarding the initialization flow of Linux kernel, it needs to move
>> xen_early_init() before efi_init(). Then xen_early_init() will check
>> whether it runs on Xen through the /hypervisor node and efi_init() will
>> call a new function fdt_find_xen_uefi_params(), to parse those
>> xen,uefi-* parameters just like the existing efi_get_fdt_params().
>>
>> And in arm64_enable_runtime_services() it will check whether it runs on
>> Xen and call another new function xen_efi_runtime_setup() to setup
>> runtime service instead of efi_native_runtime_setup(). The
>> xen_efi_runtime_setup() will assign the runtime function pointers with
>> the functions of driver/xen/efi.c.
>>
>> And since we pass a /hypervisor node and a /chosen node to Dom0, it
>> needs to check whether the DTS only contains a /hypervisor node and a
>> /chosen node in acpi_boot_table_init().
>>
>> Patches are tested on FVP base model. They can be fetched from[2].
> 
> I have tested this series and Linux is booting up to the prompt:
> 
> Tested-by: Julien Grall <julien.grall-5wv7dgnIgG8@public.gmane.org>
Thanks a lot. There are several patches which you didn't give your
comments. So I assume you will review them. If so, I'll wait and update
this series later.

Thanks,
-- 
Shannon

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
