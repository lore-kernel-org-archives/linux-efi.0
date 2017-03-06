From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [RFC PATCH v4 18/28] x86: DMA support for memory encryption
Date: Mon, 6 Mar 2017 11:47:15 -0600
Message-ID: <65461175-6b79-fd79-8c4b-3e7f28e707ae@amd.com>
References: <20170216154158.19244.66630.stgit@tlendack-t1.amdoffice.net>
	<20170216154604.19244.69522.stgit@tlendack-t1.amdoffice.net>
	<20170225171024.xzlfox56rbbflxfo@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20170225171024.xzlfox56rbbflxfo-fF5Pk5pvG8Y@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter
	Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, "Michael S.
	Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 2/25/2017 11:10 AM, Borislav Petkov wrote:
> On Thu, Feb 16, 2017 at 09:46:04AM -0600, Tom Lendacky wrote:
>> Since DMA addresses will effectively look like 48-bit addresses when the
>> memory encryption mask is set, SWIOTLB is needed if the DMA mask of the
>> device performing the DMA does not support 48-bits. SWIOTLB will be
>> initialized to create decrypted bounce buffers for use by these devices.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
>> ---
>
> Just nitpicks below...
>
>> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
>> index ec548e9..a46bcf4 100644
>> --- a/arch/x86/mm/mem_encrypt.c
>> +++ b/arch/x86/mm/mem_encrypt.c
>> @@ -13,11 +13,14 @@
>>  #include <linux/linkage.h>
>>  #include <linux/init.h>
>>  #include <linux/mm.h>
>> +#include <linux/dma-mapping.h>
>> +#include <linux/swiotlb.h>
>>
>>  #include <asm/tlbflush.h>
>>  #include <asm/fixmap.h>
>>  #include <asm/setup.h>
>>  #include <asm/bootparam.h>
>> +#include <asm/cacheflush.h>
>>
>>  extern pmdval_t early_pmd_flags;
>>  int __init __early_make_pgtable(unsigned long, pmdval_t);
>> @@ -192,3 +195,22 @@ void __init sme_early_init(void)
>>  	for (i = 0; i < ARRAY_SIZE(protection_map); i++)
>>  		protection_map[i] = pgprot_encrypted(protection_map[i]);
>>  }
>> +
>> +/* Architecture __weak replacement functions */
>> +void __init mem_encrypt_init(void)
>> +{
>> +	if (!sme_me_mask)
>
> 	    !sme_active()
>
> no?

I was probably looking ahead to SEV on this one. Basically if the
sme_me_mask is non-zero we will want to make SWIOTLB decrypted.

>
> Unless we're going to be switching SME dynamically at run time?
>
>> +		return;
>> +
>> +	/* Call into SWIOTLB to update the SWIOTLB DMA buffers */
>> +	swiotlb_update_mem_attributes();
>> +}
>> +
>> +void swiotlb_set_mem_attributes(void *vaddr, unsigned long size)
>> +{
>> +	WARN(PAGE_ALIGN(size) != size,
>> +	     "size is not page aligned (%#lx)\n", size);
>
> "page-aligned" I guess.

Ok.

>
>> +
>> +	/* Make the SWIOTLB buffer area decrypted */
>> +	set_memory_decrypted((unsigned long)vaddr, size >> PAGE_SHIFT);
>> +}
>> diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
>> index 4ee479f..15e7160 100644
>> --- a/include/linux/swiotlb.h
>> +++ b/include/linux/swiotlb.h
>> @@ -35,6 +35,7 @@ enum swiotlb_force {
>>  extern unsigned long swiotlb_nr_tbl(void);
>>  unsigned long swiotlb_size_or_default(void);
>>  extern int swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs);
>> +extern void __init swiotlb_update_mem_attributes(void);
>>
>>  /*
>>   * Enumeration for sync targets
>> diff --git a/init/main.c b/init/main.c
>> index 8222caa..ba13f8f 100644
>> --- a/init/main.c
>> +++ b/init/main.c
>> @@ -466,6 +466,10 @@ void __init __weak thread_stack_cache_init(void)
>>  }
>>  #endif
>>
>> +void __init __weak mem_encrypt_init(void)
>> +{
>> +}
>> +
>>  /*
>>   * Set up kernel memory allocators
>>   */
>> @@ -614,6 +618,15 @@ asmlinkage __visible void __init start_kernel(void)
>>  	 */
>>  	locking_selftest();
>>
>> +	/*
>> +	 * This needs to be called before any devices perform DMA
>> +	 * operations that might use the swiotlb bounce buffers.
>
> 					 SWIOTLB

Ok.

>
>> +	 * This call will mark the bounce buffers as decrypted so
>> +	 * that their usage will not cause "plain-text" data to be
>> +	 * decrypted when accessed.
>> +	 */
>> +	mem_encrypt_init();
>> +
>>  #ifdef CONFIG_BLK_DEV_INITRD
>>  	if (initrd_start && !initrd_below_start_ok &&
>>  	    page_to_pfn(virt_to_page((void *)initrd_start)) < min_low_pfn) {
>> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
>> index a8d74a7..c463067 100644
>> --- a/lib/swiotlb.c
>> +++ b/lib/swiotlb.c
>> @@ -30,6 +30,7 @@
>>  #include <linux/highmem.h>
>>  #include <linux/gfp.h>
>>  #include <linux/scatterlist.h>
>> +#include <linux/mem_encrypt.h>
>>
>>  #include <asm/io.h>
>>  #include <asm/dma.h>
>> @@ -155,6 +156,17 @@ unsigned long swiotlb_size_or_default(void)
>>  	return size ? size : (IO_TLB_DEFAULT_SIZE);
>>  }
>>
>> +void __weak swiotlb_set_mem_attributes(void *vaddr, unsigned long size)
>> +{
>> +}
>> +
>> +/* For swiotlb, clear memory encryption mask from dma addresses */
>> +static dma_addr_t swiotlb_phys_to_dma(struct device *hwdev,
>> +				      phys_addr_t address)
>> +{
>> +	return phys_to_dma(hwdev, address) & ~sme_me_mask;
>> +}
>> +
>>  /* Note that this doesn't work with highmem page */
>>  static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
>>  				      volatile void *address)
>> @@ -183,6 +195,31 @@ void swiotlb_print_info(void)
>>  	       bytes >> 20, vstart, vend - 1);
>>  }
>>
>> +/*
>> + * Early SWIOTLB allocation may be to early to allow an architecture to
>
> 				      too

Yup.

>
>> + * perform the desired operations.  This function allows the architecture to
>> + * call SWIOTLB when the operations are possible.  This function needs to be
>
> s/This function/It/

Ok.

Thanks,
Tom

>
>> + * called before the SWIOTLB memory is used.
>> + */
>> +void __init swiotlb_update_mem_attributes(void)
>> +{
>> +	void *vaddr;
>> +	unsigned long bytes;
>> +
>> +	if (no_iotlb_memory || late_alloc)
>> +		return;
>> +
>> +	vaddr = phys_to_virt(io_tlb_start);
>> +	bytes = PAGE_ALIGN(io_tlb_nslabs << IO_TLB_SHIFT);
>> +	swiotlb_set_mem_attributes(vaddr, bytes);
>> +	memset(vaddr, 0, bytes);
>> +
>> +	vaddr = phys_to_virt(io_tlb_overflow_buffer);
>> +	bytes = PAGE_ALIGN(io_tlb_overflow);
>> +	swiotlb_set_mem_attributes(vaddr, bytes);
>> +	memset(vaddr, 0, bytes);
>> +}
>> +
>>  int __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
>>  {
>>  	void *v_overflow_buffer;
>
