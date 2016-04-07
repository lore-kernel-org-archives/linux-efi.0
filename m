From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v10 00/17] Add ACPI support for Xen Dom0 on ARM64
Date: Thu, 7 Apr 2016 11:34:02 +0100
Message-ID: <5706379A.2000503@arm.com>
References: <1459525755-36968-1-git-send-email-shannon.zhao@linaro.org>
 <5704F3E1.7020508@arm.com> <5705BA61.7000205@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5705BA61.7000205@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>, Shannon Zhao <shannon.zhao@linaro.org>, linux-arm-kernel@lists.infradead.org, stefano.stabellini@citrix.com
Cc: david.vrabel@citrix.com, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, peter.huangpeng@huawei.com, xen-devel@lists.xen.org
List-Id: linux-efi@vger.kernel.org

On 07/04/16 02:39, Shannon Zhao wrote:
> Hi Julien,

Hi Shannon,

> On 2016/4/6 19:32, Julien Grall wrote:
>> Hi Shannon,
>>
>> On 01/04/2016 16:48, Shannon Zhao wrote:
>>> This patch set adds ACPI support for Xen Dom0 on ARM64. The relevant Xen
>>> ACPI on ARM64 design document could be found from [1].
>>>
>>> This patch set adds a new FDT node "uefi" under /hypervisor to pass UEFI
>>> information. Introduce a bus notifier of AMBA and Platform bus to map
>>> the new added device's MMIO space. Make Xen domain use
>>> xlated_setup_gnttab_pages to setup grant table and a new hypercall to
>>> get event-channel irq.
>>>
>>> Regarding the initialization flow of Linux kernel, it needs to move
>>> xen_early_init() before efi_init(). Then xen_early_init() will check
>>> whether it runs on Xen through the /hypervisor node and efi_init() will
>>> call a new function fdt_find_xen_uefi_params(), to parse those
>>> xen,uefi-* parameters just like the existing efi_get_fdt_params().
>>>
>>> And in arm64_enable_runtime_services() it will check whether it runs on
>>> Xen and call another new function xen_efi_runtime_setup() to setup
>>> runtime service instead of efi_native_runtime_setup(). The
>>> xen_efi_runtime_setup() will assign the runtime function pointers with
>>> the functions of driver/xen/efi.c.
>>>
>>> And since we pass a /hypervisor node and a /chosen node to Dom0, it
>>> needs to check whether the DTS only contains a /hypervisor node and a
>>> /chosen node in acpi_boot_table_init().
>>>
>>> Patches are tested on FVP base model. They can be fetched from[2].
>>
>> I have tested this series and Linux is booting up to the prompt:
>>
>> Tested-by: Julien Grall <julien.grall@arm.com>
> Thanks a lot. There are several patches which you didn't give your
> comments. So I assume you will review them. If so, I'll wait and update
> this series later.

I don't have any comments on those patches. You can go ahead to update 
the patch series.

Regards,

-- 
Julien Grall
