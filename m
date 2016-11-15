From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH v3 13/20] x86: DMA support for memory encryption
Date: Tue, 15 Nov 2016 19:17:36 +0100
Message-ID: <20161115181736.GA14060@potion>
References: <20161110003426.3280.2999.stgit@tlendack-t1.amdoffice.net>
 <20161110003723.3280.62636.stgit@tlendack-t1.amdoffice.net>
 <20161115143943.GC2185@potion>
 <d5ebd13d-1278-8714-3f03-8ee7f04a2b38@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <d5ebd13d-1278-8714-3f03-8ee7f04a2b38-5C7GfCeVMHo@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tgl>
List-Id: linux-efi@vger.kernel.org

2016-11-15 11:02-0600, Tom Lendacky:
> On 11/15/2016 8:39 AM, Radim Krčmář wrote:
>> 2016-11-09 18:37-0600, Tom Lendacky:
>>> Since DMA addresses will effectively look like 48-bit addresses when the
>>> memory encryption mask is set, SWIOTLB is needed if the DMA mask of the
>>> device performing the DMA does not support 48-bits. SWIOTLB will be
>>> initialized to create un-encrypted bounce buffers for use by these devices.
>>>
>>> Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
>>> ---
>>> diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
>>> @@ -64,13 +66,15 @@ static struct dma_map_ops swiotlb_dma_ops = {
>>>   * pci_swiotlb_detect_override - set swiotlb to 1 if necessary
>>>   *
>>>   * This returns non-zero if we are forced to use swiotlb (by the boot
>>> - * option).
>>> + * option). If memory encryption is enabled then swiotlb will be set
>>> + * to 1 so that bounce buffers are allocated and used for devices that
>>> + * do not support the addressing range required for the encryption mask.
>>>   */
>>>  int __init pci_swiotlb_detect_override(void)
>>>  {
>>>  	int use_swiotlb = swiotlb | swiotlb_force;
>>>  
>>> -	if (swiotlb_force)
>>> +	if (swiotlb_force || sme_me_mask)
>>>  		swiotlb = 1;
>>>  
>>>  	return use_swiotlb;
>> 
>> We want to return 1 even if only sme_me_mask is 1, because the return
>> value is used for detection.  The following would be less obscure, IMO:
>> 
>> 	if (swiotlb_force || sme_me_mask)
>> 		swiotlb = 1;
>> 
>> 	return swiotlb;
> 
> If we do that then all DMA would go through the swiotlb bounce buffers.

No, that is decided for example in swiotlb_map_page() and we need to
call pci_swiotlb_init() to register that function.

> By setting swiotlb to 1 we indicate that the bounce buffers will be
> needed for those devices that can't support the addressing range when
> the encryption bit is set (48 bit DMA). But if the device can support
> the addressing range we won't use the bounce buffers.

If we return 0 here, then pci_swiotlb_init() will not be called =>
dma_ops won't be set to swiotlb_dma_ops => we won't use bounce buffers.

>> We setup encrypted swiotlb and then decrypt it, but sometimes set it up
>> decrypted (late_alloc) ... why isn't the swiotlb set up decrypted
>> directly?
> 
> When swiotlb is allocated in swiotlb_init(), it is too early to make
> use of the api to the change the page attributes. Because of this,
> the callback to make those changes is needed.

Thanks. (I don't know page table setup enough to see a lesser evil. :])

>>> @@ -541,7 +583,7 @@ static phys_addr_t
>>>  map_single(struct device *hwdev, phys_addr_t phys, size_t size,
>>>  	   enum dma_data_direction dir)
>>>  {
>>> -	dma_addr_t start_dma_addr = phys_to_dma(hwdev, io_tlb_start);
>>> +	dma_addr_t start_dma_addr = swiotlb_phys_to_dma(hwdev, io_tlb_start);
>> 
>> We have decrypted io_tlb_start before, so shouldn't its physical address
>> be saved without the sme bit?  (Which changes a lot ...)
> 
> I'm not sure what you mean here, can you elaborate a bit more?

The C-bit (sme bit) is a part of the physical address.
If we know that a certain physical page should be accessed as
unencrypted (the bounce buffer) then the C-bit is 0.
I'm wondering why we save the physical address with the C-bit set when
we know that it can't be accessed that way (because we remove it every
time).

The naming is a bit confusing, because physical addresses are actually
virtualized by SME -- maybe we should be calling them SME addresses?
