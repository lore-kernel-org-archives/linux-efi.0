From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [PATCH v6 24/34] x86, swiotlb: Add memory encryption support
Date: Wed, 14 Jun 2017 14:38:48 -0500
Message-ID: <c1a59a06-2850-b215-5c08-27adff6fecde@amd.com>
References: <20170607191309.28645.15241.stgit@tlendack-t1.amdoffice.net>
	<20170607191721.28645.96519.stgit@tlendack-t1.amdoffice.net>
	<20170614164553.jwcfgugpizz5pc2e@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20170614164553.jwcfgugpizz5pc2e-fF5Pk5pvG8Y@public.gmane.org>
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
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, "Michael S. Tsirkin" <mst>
List-Id: linux-efi@vger.kernel.org

On 6/14/2017 11:45 AM, Borislav Petkov wrote:
> On Wed, Jun 07, 2017 at 02:17:21PM -0500, Tom Lendacky wrote:
>> Since DMA addresses will effectively look like 48-bit addresses when the
>> memory encryption mask is set, SWIOTLB is needed if the DMA mask of the
>> device performing the DMA does not support 48-bits. SWIOTLB will be
>> initialized to create decrypted bounce buffers for use by these devices.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
>> ---
> 
> ...
> 
> 
>> diff --git a/init/main.c b/init/main.c
>> index df58a41..7125b5f 100644
>> --- a/init/main.c
>> +++ b/init/main.c
>> @@ -488,6 +488,10 @@ void __init __weak thread_stack_cache_init(void)
>>   }
>>   #endif
>>   
>> +void __init __weak mem_encrypt_init(void)
>> +{
>> +}
> 
> void __init __weak mem_encrypt_init(void) { }
> 
> saves some real estate. Please do that for the rest of the stubs you're
> adding, for the next version.

Ok, will do.

Thanks,
Tom

> 
>> +
>>   /*
>>    * Set up kernel memory allocators
>>    */
>> @@ -640,6 +644,15 @@ asmlinkage __visible void __init start_kernel(void)
>>   	 */
>>   	locking_selftest();
>>   
>> +	/*
>> +	 * This needs to be called before any devices perform DMA
>> +	 * operations that might use the SWIOTLB bounce buffers.
>> +	 * This call will mark the bounce buffers as decrypted so
>> +	 * that their usage will not cause "plain-text" data to be
>> +	 * decrypted when accessed.
> 
> s/This call/It/
> 
>> +	 */
>> +	mem_encrypt_init();
>> +
>>   #ifdef CONFIG_BLK_DEV_INITRD
>>   	if (initrd_start && !initrd_below_start_ok &&
>>   	    page_to_pfn(virt_to_page((void *)initrd_start)) < min_low_pfn) {
>> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
>> index a8d74a7..74d6557 100644
>> --- a/lib/swiotlb.c
>> +++ b/lib/swiotlb.c
>> @@ -30,6 +30,7 @@
>>   #include <linux/highmem.h>
>>   #include <linux/gfp.h>
>>   #include <linux/scatterlist.h>
>> +#include <linux/mem_encrypt.h>
>>   
>>   #include <asm/io.h>
>>   #include <asm/dma.h>
>> @@ -155,6 +156,17 @@ unsigned long swiotlb_size_or_default(void)
>>   	return size ? size : (IO_TLB_DEFAULT_SIZE);
>>   }
>>   
>> +void __weak swiotlb_set_mem_attributes(void *vaddr, unsigned long size)
>> +{
>> +}
> 
> As above.
> 
