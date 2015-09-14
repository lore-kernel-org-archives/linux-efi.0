From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH] efi/libstub/fdt: Standardize the names of
	EFI stub parameters
Date: Mon, 14 Sep 2015 16:42:21 +0800
Message-ID: <55F6886D.1090900@huawei.com>
References: <20150910112418.GC29293@leverpostej>
	<alpine.DEB.2.02.1509101223580.2672@kaball.uk.xensource.com>
	<20150910121514.GE29293@leverpostej>
	<alpine.DEB.2.02.1509101429480.2672@kaball.uk.xensource.com>
	<20150910144938.GI29293@leverpostej>
	<alpine.DEB.2.02.1509101655020.2672@kaball.uk.xensource.com>
	<20150910162302.GN29293@leverpostej>
	<20150911124643.GB4530@olila.local.net-space.pl>
	<alpine.DEB.2.02.1509111410180.2672@kaball.uk.xensource.com>
	<CAKv+Gu9rN7_mxk0huX+34HSCC_aTWVTkUZKQMB1+9U56fRnwsA@mail.gmail.com>
	<20150911154534.GD4530@olila.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <20150911154534.GD4530@olila.local.net-space.pl>
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Sender: xen-devel-bounces@lists.xen.org
Errors-To: xen-devel-bounces@lists.xen.org
To: Daniel Kiper <daniel.kiper@oracle.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>, Stefano Stabellini <stefano.stabellini@eu.citrix.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>, "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>, "julien.grall@citrix.com" <julien.grall@citrix.com>, "freebsd-arm@freebsd.org" <freebsd-arm@freebsd.org>, "matt.fleming@intel.com" <matt.fleming@intel.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "jbeulich@suse.com" <jbeulich@suse.com>, "peter.huangpeng@huawei.com" <peter.huangpeng@huawei.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.>
List-Id: linux-efi@vger.kernel.org



On 2015/9/11 23:45, Daniel Kiper wrote:
> On Fri, Sep 11, 2015 at 03:30:15PM +0200, Ard Biesheuvel wrote:
>> On 11 September 2015 at 15:14, Stefano Stabellini
>> <stefano.stabellini@eu.citrix.com> wrote:
>>> On Fri, 11 Sep 2015, Daniel Kiper wrote:
>>>> On Thu, Sep 10, 2015 at 05:23:02PM +0100, Mark Rutland wrote:
>>>>>>> C) When you could go:
>>>>>>>
>>>>>>>    DT -> Discover Xen -> Xen-specific stuff -> Xen-specific EFI/ACPI discovery
>>>>>>
>>>>>> I take you mean discovering Xen with the usual Xen hypervisor node on
>>>>>> device tree. I think that C) is a good option actually. I like it. Not
>>>>>> sure why we didn't think about this earlier. Is there anything EFI or
>>>>>> ACPI which is needed before Xen support is discovered by
>>>>>> arch/arm64/kernel/setup.c:setup_arch -> xen_early_init()?
>>>>>
>>>>> Currently lots (including the memory map). With the stuff to support
>>>>> SPCR, the ACPI discovery would be moved before xen_early_init().
>>>>>
>>>>>> If not, we could just go for this. A lot of complexity would go away.
>>>>>
>>>>> I suspect this would still be fairly complex, but would at least prevent
>>>>> the Xen-specific EFI handling from adversely affecting the native case.
>>>>>
>>>>>>> D) If you want to be generic:
>>>>>>>    EFI -> EFI application -> EFI tables -> ACPI tables -> Xen-specific stuff
>>>>>>>           \------------------------------------------/
>>>>>>>            (virtualize these, provide shims to Dom0, but handle
>>>>>>>             everything in Xen itself)
>>>>>>
>>>>>> I think that this is good in theory but could turn out to be a lot of
>>>>>> work in practice. We could probably virtualize the RuntimeServices but
>>>>>> the BootServices are troublesome.
>>>>>
>>>>> What's troublesome with the boot services?
>>>>>
>>>>> What can't be simulated?
>>>>
>>>> How do you want to access bare metal EFI boot services from dom0 if they
>>>> were shutdown long time ago before loading dom0 image? What do you need
>>>> from EFI boot services in dom0?
>>>
>>> That's right. Trying to emulate BootServices after the real
>>> ExitBootServices has already been called seems like a very bad plan.
>>>
>>> I think that whatever interface we come up with, would need to be past
>>> ExitBootServices.
>>
>> It feels like this discussion is going in circles.
>>
>> When we discussed this six months ago, we already concluded that,
>> since UEFI is the only specified way that the presence of ACPI is
>> advertised on an ARM system, we need to emulate UEFI to some extent.
>>
>> So we need the EFI system table to expose the UEFI configuration table
>> that carries the ACPI root pointer.
>>
>> Since ACPI support also relies on the UEFI memory map (I think?), we
>> need that as well.
>>
>> These two items are exactly what we pass via the UEFI DT properties,
>> so we should indeed promote the current de-facto binding to a proper
>> binding, and renaming the properties makes sense in that context.
>>
>> I agree that this should also include a description of the expected
>> state of the firmware, i.e., that ExitBootServices() has been called,
>> and that the memory map has been populated with virtual address, which
>> have been installed using SetVirtualAddressMap() if they differ from
>> the physical addresses. (The current implementation on the kernel side
>> is perfectly capable of dealing with a 1:1 mapping).
>>
>> Beyond that, there is no point in pretending to be a full UEFI
>> implementation, imo. Boot services are not required, nor are runtime
>> services (only the current EFI init code on arm needs to be modified
>> to deal with a NULL runtime services pointer)
> 
> Taking into account above I think that you have most of the code in place.
> Please take a look at linux/arch/x86/xen/efi.c, linux/drivers/acpi/osl.c
> and linux/drivers/xen/efi.c (maybe somewhere else). In general you should
> create ARM version of xen_efi_init() (x86 version you can find in
> linux/drivers/xen/efi.c; it is very simple thing), maybe add some
> code in a few places and voila.
> 

It only needs to apply following patch to fix a bug in Linux kernel when
mapping EFI_MEMORY_RUNTIME memory.

Author: Shannon Zhao <shannon.zhao@linaro.org>
Date:   Thu Aug 20 14:54:58 2015 +0800

    arm64/efi: Fix a bug when no EFI_MEMORY_RUNTIME memory found

    Currently if the attribute type of all the EFI Memory Descriptors are
    not EFI_MEMORY_RUNTIME, efi_virtmap_init will return true. But at this
    case, it expect false as there are no EFI memory for RUNTIME. Fix it by
    introducing a status to show whether it finds EFI_MEMORY_RUNTIME.

    Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index e8ca6ea..bad7f87 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -233,6 +233,7 @@ void __init efi_init(void)
 static bool __init efi_virtmap_init(void)
 {
        efi_memory_desc_t *md;
+       bool status = false;

        for_each_efi_memory_desc(&memmap, md) {
                u64 paddr, npages, size;
@@ -264,8 +265,11 @@ static bool __init efi_virtmap_init(void)
                        prot = PAGE_KERNEL;

                create_pgd_mapping(&efi_mm, paddr, md->virt_addr, size,
prot);
+               status = true;
        }
-       return true;
+       if (status)
+               return true;
+       return false;
 }

-- 
Shannon
