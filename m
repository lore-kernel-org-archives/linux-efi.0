From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [RFC PATCH v1 10/18] x86/efi: Access EFI related tables in the
	clear
Date: Wed, 15 Jun 2016 08:17:21 -0500
Message-ID: <57615561.4090502@amd.com>
References: <20160426225553.13567.19459.stgit@tlendack-t1.amdoffice.net>
	<20160426225740.13567.85438.stgit@tlendack-t1.amdoffice.net>
	<20160608111844.GV2658@codeblueprint.co.uk> <5759B67A.4000800@amd.com>
	<20160613135110.GC2658@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20160613135110.GC2658-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 06/13/2016 08:51 AM, Matt Fleming wrote:
> On Thu, 09 Jun, at 01:33:30PM, Tom Lendacky wrote:
>>
>> I was trying to play it safe here, but as you say, the firmware should
>> be using our page tables so we can get rid of this call. The problem
>> will actually be if we transition to a 32-bit efi. The encryption bit
>> will be lost in cr3 and so the pgd table will have to be un-encrypted.
>> The entries in the pgd can have the encryption bit set so I would only
>> need to worry about the pgd itself. I'll have to update the
>> efi_alloc_page_tables routine.
>  
> Interesting, I hadn't expected 32-bit EFI to be an option for
> platforms with the SME technology. I'd assumed we could just ignore
> that.

We may be able to do that.

> 
> Are you saying that the encryption bit isn't supported in 32-bit
> compatibility mode? We don't do a "full" switch to 32-bit protected
> mode when in mixed mode, just load a 32-bit code segment descriptor.
> The page tables are not modified at all.

The encryption bit is supported in 32-bit compatibility mode and since
we're not doing the "full" switch the cr3 register will remain as a
64-bit register so we can leave the pgd table encrypted.

> 
>> The encryption bit in the cr3 register will indicate if the pgd table
>> is encrypted or not. Based on my comment above about the pgd having
>> to be un-encrypted in case we have to transition to 32-bit efi, this
>> can be removed.
>  
> I'm not (yet) sure that the pgd needs to be unencrypted for 32-bit EFI
> when running a 64-bit kernel. In the AMD Programmer's Manual, Section
> 7.10.3 Operating Modes seems to indicate that running encrypted should
> work fine.
> 
>> I'll look into this a bit more. From looking at it I don't want the
>> _PAGE_ENC bit set for the memmap unless it gets re-allocated (which
>> I missed in these patches). Let me see what I can do with this.
>  
> I don't understand your comment about re-allocating the memmap.
> 
> The kernel builds its own EFI memory map at runtime, initially based
> on the memory map provided by the firmware. We always allocate a new
> memory map.

Sorry, I mis-interpreted the efi_map_regions function/loop and see
that the memmap is always allocated by the kernel.

> 
> In efi_setup_page_tables() we're building our own page tables, which
> should be encrypted, and mapping EFI regions described by the memmap
> into those page tables.
> 
> So unless we're mapping an MMIO region (in which case _PAGE_PCD is set
> in @flags for kernel_map_pages_in_pgd()) I would expect _PAGE_ENC to
> be set.
> 
>> I'll look further into this, but I saw that this area of virtual memory
>> was mapped un-encrypted and after freeing the boot services the
>> mappings were somehow reused as un-encrypted for DMA which assumes
>> (unless using swiotlb) encrypted. This resulted in DMA data being
>> transferred in as encrypted and then accessed un-encrypted.
> 
> That the mappings were re-used isn't a surprise.
> 
> efi_free_boot_services() lifts the reservation that was put in place
> during efi_reserve_boot_services() and releases the pages to the
> kernel's memory allocators.
> 
> What is surprising is that they were marked unencrypted at all.
> There's nothing special about these pages as far as the __va() region
> is concerned.

Right, let me keep looking into this to see if I can pin down what
was (or is) happening.

Thanks,
Tom

> 
