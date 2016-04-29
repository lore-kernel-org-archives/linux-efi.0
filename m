From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [RFC PATCH v1 13/18] x86: DMA support for memory encryption
Date: Fri, 29 Apr 2016 18:49:56 -0500
Message-ID: <5723F324.9040909@amd.com>
References: <20160426225553.13567.19459.stgit@tlendack-t1.amdoffice.net>
	<20160426225812.13567.91220.stgit@tlendack-t1.amdoffice.net>
	<20160429071743.GC11592@char.us.oracle.com> <572379ED.9050404@amd.com>
	<20160429162757.GA1191@char.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20160429162757.GA1191-he5eyhs8q0BAdwtm4QZOy9BPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 04/29/2016 11:27 AM, Konrad Rzeszutek Wilk wrote:
> On Fri, Apr 29, 2016 at 10:12:45AM -0500, Tom Lendacky wrote:
>> On 04/29/2016 02:17 AM, Konrad Rzeszutek Wilk wrote:
>>> On Tue, Apr 26, 2016 at 05:58:12PM -0500, Tom Lendacky wrote:
>>>> Since DMA addresses will effectively look like 48-bit addresses when the
>>>> memory encryption mask is set, SWIOTLB is needed if the DMA mask of the
>>>> device performing the DMA does not support 48-bits. SWIOTLB will be
>>>> initialized to create un-encrypted bounce buffers for use by these devices.
>>>>
>>>
>>>
>>> I presume the sme_me_mask does not use the lower 48 bits?
>>
>> The sme_me_mask will actually be bit 47. So, when applied, the address
>> will become a 48-bit address.
>>
>>>
>>>
>>> ..snip..
>>>> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
>>>> index 7d56d1b..594dc65 100644
>>>> --- a/arch/x86/mm/mem_encrypt.c
>>>> +++ b/arch/x86/mm/mem_encrypt.c
>>>> @@ -12,6 +12,8 @@
>>>>  
>>>>  #include <linux/init.h>
>>>>  #include <linux/mm.h>
>>>> +#include <linux/dma-mapping.h>
>>>> +#include <linux/swiotlb.h>
>>>>  
>>>>  #include <asm/mem_encrypt.h>
>>>>  #include <asm/cacheflush.h>
>>>> @@ -168,6 +170,25 @@ void __init sme_early_init(void)
>>>>  }
>>>>  
>>>>  /* Architecture __weak replacement functions */
>>>> +void __init mem_encrypt_init(void)
>>>> +{
>>>> +	if (!sme_me_mask)
>>>> +		return;
>>>> +
>>>> +	/* Make SWIOTLB use an unencrypted DMA area */
>>>> +	swiotlb_clear_encryption();
>>>> +}
>>>> +
>>>> +unsigned long swiotlb_get_me_mask(void)
>>>> +{
>>>> +	return sme_me_mask;
>>>> +}
>>>> +
>>>> +void swiotlb_set_mem_dec(void *vaddr, unsigned long size)
>>>> +{
>>>> +	sme_set_mem_dec(vaddr, size);
>>>> +}
>>>> +
>>>>  void __init *efi_me_early_memremap(resource_size_t paddr,
>>>>  				   unsigned long size)
>>>>  {
>>>> diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
>>>> index 017fced..121b9de 100644
>>>> --- a/include/linux/swiotlb.h
>>>> +++ b/include/linux/swiotlb.h
>>>> @@ -30,6 +30,7 @@ int swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose);
>>>>  extern unsigned long swiotlb_nr_tbl(void);
>>>>  unsigned long swiotlb_size_or_default(void);
>>>>  extern int swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs);
>>>> +extern void __init swiotlb_clear_encryption(void);
>>>>  
>>>>  /*
>>>>   * Enumeration for sync targets
>>>> diff --git a/init/main.c b/init/main.c
>>>> index b3c6e36..1013d1c 100644
>>>> --- a/init/main.c
>>>> +++ b/init/main.c
>>>> @@ -458,6 +458,10 @@ void __init __weak thread_info_cache_init(void)
>>>>  }
>>>>  #endif
>>>>  
>>>> +void __init __weak mem_encrypt_init(void)
>>>> +{
>>>> +}
>>>> +
>>>>  /*
>>>>   * Set up kernel memory allocators
>>>>   */
>>>> @@ -597,6 +601,8 @@ asmlinkage __visible void __init start_kernel(void)
>>>>  	 */
>>>>  	locking_selftest();
>>>>  
>>>> +	mem_encrypt_init();
>>>> +
>>>>  #ifdef CONFIG_BLK_DEV_INITRD
>>>>  	if (initrd_start && !initrd_below_start_ok &&
>>>>  	    page_to_pfn(virt_to_page((void *)initrd_start)) < min_low_pfn) {
>>>
>>> What happens if devices use the bounce buffer before mem_encrypt_init()?
>>
>> The call to mem_encrypt_init is early in the boot process, I may have
>> overlooked something, but what devices would be performing DMA before
>> this?
> 
> I am not saying that you overlooked. Merely wondering if somebody re-orders these
> calls what would happen. It maybe also good to have a comment right before
> mem_encrpyt_init stating what will happen if the device does DMA before the function
> is called.
> 

Ah, ok. Before mem_encrypt_init is called the bounce buffers will be
marked as encrypted in the page tables. The use of the bounce buffers
will not have the memory encryption bit as part of the DMA address so a
device will DMA into memory in the clear. When the bounce buffer is
copied to the original buffer it will be accessed by a virtual address
that has the memory encryption bit set in the page tables. So the
plaintext data that was DMA'd in will be decrypted resulting in invalid
data in the destination buffer.

I'll be sure to add a comment before the call.

Thanks,
Tom
