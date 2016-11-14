From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [RFC PATCH v3 10/20] Add support to access boot related data in
	the clear
Date: Mon, 14 Nov 2016 10:24:14 -0600
Message-ID: <d25de4d7-ae6f-b701-8ae1-0a39fa02a9b0@amd.com>
References: <20161110003426.3280.2999.stgit@tlendack-t1.amdoffice.net>
	<20161110003631.3280.73292.stgit@tlendack-t1.amdoffice.net>
	<1478880929.20881.148.camel@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1478880929.20881.148.camel-ZPxbGqLxI0U@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Kani, Toshimitsu" <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, "kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "arnd-r2nGTMty4D4@public.gmane.org" <arnd-r2nGTMty4D4@public.gmane.org>, "pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org" <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "corbet-T1hC0tSOHrs@public.gmane.org" <corbet-T1hC0tSOHrs@public.gmane.org>, "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org" <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org" <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 11/11/2016 10:17 AM, Kani, Toshimitsu wrote:
> On Wed, 2016-11-09 at 18:36 -0600, Tom Lendacky wrote:
>> Boot data (such as EFI related data) is not encrypted when the system
>> is booted and needs to be accessed unencrypted.  Add support to apply
>> the proper attributes to the EFI page tables and to the
>> early_memremap and memremap APIs to identify the type of data being
>> accessed so that the proper encryption attribute can be applied.
>  :
>> +static bool memremap_apply_encryption(resource_size_t phys_addr,
>> +				      unsigned long size)
>> +{
>> +	/* SME is not active, just return true */
>> +	if (!sme_me_mask)
>> +		return true;
>> +
>> +	/* Check if the address is part of the setup data */
>> +	if (memremap_setup_data(phys_addr, size))
>> +		return false;
>> +
>> +	/* Check if the address is part of EFI boot/runtime data */
>> +	switch (efi_mem_type(phys_addr)) {
>> +	case EFI_BOOT_SERVICES_DATA:
>> +	case EFI_RUNTIME_SERVICES_DATA:
>> +		return false;
>> +	}
>> +
>> +	/* Check if the address is outside kernel usable area */
>> +	switch (e820_get_entry_type(phys_addr, phys_addr + size -
>> 1)) {
>> +	case E820_RESERVED:
>> +	case E820_ACPI:
>> +	case E820_NVS:
>> +	case E820_UNUSABLE:
>> +		return false;
>> +	}
>> +
>> +	return true;
>> +}
> 
> Are you supporting encryption for E820_PMEM ranges?  If so, this
> encryption will persist across a reboot and does not need to be
> encrypted again, right?  Also, how do you keep a same key across a
> reboot?

The key will change across a reboot... so I need to look into this
more for memory that isn't used as traditional system ram.

Thanks,
Tom

> 
> Thanks,
> -Toshi
> 
