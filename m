From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [PATCH v6 10/34] x86, x86/mm, x86/xen, olpc: Use __va() against
	just the physical address in cr3
Date: Thu, 8 Jun 2017 08:42:51 -0500
Message-ID: <4a7376fb-abfc-8edd-42b7-38de461ac65e@amd.com>
References: <20170607191309.28645.15241.stgit@tlendack-t1.amdoffice.net>
	<20170607191453.28645.92256.stgit@tlendack-t1.amdoffice.net>
	<b15e8924-4069-b5fa-adb2-86c164b1dd36@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <b15e8924-4069-b5fa-adb2-86c164b1dd36-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Cc: Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, xen-devel <xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 6/7/2017 5:06 PM, Boris Ostrovsky wrote:
> On 06/07/2017 03:14 PM, Tom Lendacky wrote:
>> The cr3 register entry can contain the SME encryption bit that indicates
>> the PGD is encrypted.  The encryption bit should not be used when creating
>> a virtual address for the PGD table.
>>
>> Create a new function, read_cr3_pa(), that will extract the physical
>> address from the cr3 register. This function is then used where a virtual
>> address of the PGD needs to be created/used from the cr3 register.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
>> ---
>>   arch/x86/include/asm/special_insns.h |    9 +++++++++
>>   arch/x86/kernel/head64.c             |    2 +-
>>   arch/x86/mm/fault.c                  |   10 +++++-----
>>   arch/x86/mm/ioremap.c                |    2 +-
>>   arch/x86/platform/olpc/olpc-xo1-pm.c |    2 +-
>>   arch/x86/power/hibernate_64.c        |    2 +-
>>   arch/x86/xen/mmu_pv.c                |    6 +++---
>>   7 files changed, 21 insertions(+), 12 deletions(-)
>>

...

>> diff --git a/arch/x86/xen/mmu_pv.c b/arch/x86/xen/mmu_pv.c
>> index 1f386d7..2dc5243 100644
>> --- a/arch/x86/xen/mmu_pv.c
>> +++ b/arch/x86/xen/mmu_pv.c
>> @@ -2022,7 +2022,7 @@ static phys_addr_t __init xen_early_virt_to_phys(unsigned long vaddr)
>>   	pmd_t pmd;
>>   	pte_t pte;
>>   
>> -	pa = read_cr3();
>> +	pa = read_cr3_pa();
>>   	pgd = native_make_pgd(xen_read_phys_ulong(pa + pgd_index(vaddr) *
>>   						       sizeof(pgd)));
>>   	if (!pgd_present(pgd))
>> @@ -2102,7 +2102,7 @@ void __init xen_relocate_p2m(void)
>>   	pt_phys = pmd_phys + PFN_PHYS(n_pmd);
>>   	p2m_pfn = PFN_DOWN(pt_phys) + n_pt;
>>   
>> -	pgd = __va(read_cr3());
>> +	pgd = __va(read_cr3_pa());
>>   	new_p2m = (unsigned long *)(2 * PGDIR_SIZE);
>>   	idx_p4d = 0;
>>   	save_pud = n_pud;
>> @@ -2209,7 +2209,7 @@ static void __init xen_write_cr3_init(unsigned long cr3)
>>   {
>>   	unsigned long pfn = PFN_DOWN(__pa(swapper_pg_dir));
>>   
>> -	BUG_ON(read_cr3() != __pa(initial_page_table));
>> +	BUG_ON(read_cr3_pa() != __pa(initial_page_table));
>>   	BUG_ON(cr3 != __pa(swapper_pg_dir));
>>   
>>   	/*
> 
> 
> (Please copy Xen maintainers when modifying xen-related files.)

Sorry about that, missed adding the Xen maintainers when I added this
change.

> 
> Given that page tables for Xen PV guests are controlled by the
> hypervisor I don't think this change (although harmless) is necessary.

I can back this change out if the Xen maintainers think that's best.

> What may be needed is making sure X86_FEATURE_SME is not set for PV guests.

And that may be something that Xen will need to control through either
CPUID or MSR support for the PV guests.

Thanks,
Tom

> 
> -boris
> 
