From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [RFC PATCH v1 10/18] x86/efi: Access EFI related tables in the
 clear
Date: Mon, 13 Jun 2016 14:51:10 +0100
Message-ID: <20160613135110.GC2658@codeblueprint.co.uk>
References: <20160426225553.13567.19459.stgit@tlendack-t1.amdoffice.net>
 <20160426225740.13567.85438.stgit@tlendack-t1.amdoffice.net>
 <20160608111844.GV2658@codeblueprint.co.uk>
 <5759B67A.4000800@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5759B67A.4000800@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Joerg Roedel <joro@8bytes.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Thomas Gleixner <tglx@linutronix.de>, Dmitry Vyukov <dvyukov@google.com>
List-Id: linux-efi@vger.kernel.org

On Thu, 09 Jun, at 01:33:30PM, Tom Lendacky wrote:
> 
> I was trying to play it safe here, but as you say, the firmware should
> be using our page tables so we can get rid of this call. The problem
> will actually be if we transition to a 32-bit efi. The encryption bit
> will be lost in cr3 and so the pgd table will have to be un-encrypted.
> The entries in the pgd can have the encryption bit set so I would only
> need to worry about the pgd itself. I'll have to update the
> efi_alloc_page_tables routine.
 
Interesting, I hadn't expected 32-bit EFI to be an option for
platforms with the SME technology. I'd assumed we could just ignore
that.

Are you saying that the encryption bit isn't supported in 32-bit
compatibility mode? We don't do a "full" switch to 32-bit protected
mode when in mixed mode, just load a 32-bit code segment descriptor.
The page tables are not modified at all.

> The encryption bit in the cr3 register will indicate if the pgd table
> is encrypted or not. Based on my comment above about the pgd having
> to be un-encrypted in case we have to transition to 32-bit efi, this
> can be removed.
 
I'm not (yet) sure that the pgd needs to be unencrypted for 32-bit EFI
when running a 64-bit kernel. In the AMD Programmer's Manual, Section
7.10.3 Operating Modes seems to indicate that running encrypted should
work fine.

> I'll look into this a bit more. From looking at it I don't want the
> _PAGE_ENC bit set for the memmap unless it gets re-allocated (which
> I missed in these patches). Let me see what I can do with this.
 
I don't understand your comment about re-allocating the memmap.

The kernel builds its own EFI memory map at runtime, initially based
on the memory map provided by the firmware. We always allocate a new
memory map.

In efi_setup_page_tables() we're building our own page tables, which
should be encrypted, and mapping EFI regions described by the memmap
into those page tables.

So unless we're mapping an MMIO region (in which case _PAGE_PCD is set
in @flags for kernel_map_pages_in_pgd()) I would expect _PAGE_ENC to
be set.

> I'll look further into this, but I saw that this area of virtual memory
> was mapped un-encrypted and after freeing the boot services the
> mappings were somehow reused as un-encrypted for DMA which assumes
> (unless using swiotlb) encrypted. This resulted in DMA data being
> transferred in as encrypted and then accessed un-encrypted.

That the mappings were re-used isn't a surprise.

efi_free_boot_services() lifts the reservation that was put in place
during efi_reserve_boot_services() and releases the pages to the
kernel's memory allocators.

What is surprising is that they were marked unencrypted at all.
There's nothing special about these pages as far as the __va() region
is concerned.
