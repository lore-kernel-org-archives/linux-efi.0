From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC PATCH v1 00/18] x86: Secure Memory Encryption (AMD)
Date: Wed, 27 Apr 2016 09:21:27 -0500
Message-ID: <5720CAE7.10005@amd.com>
References: <20160426225553.13567.19459.stgit@tlendack-t1.amdoffice.net>
 <20160322130058.GA16528@xo-6d-61-c0.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20160322130058.GA16528@xo-6d-61-c0.localdomain>
Sender: linux-doc-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, iommu@lists.linux-foundation.org, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Joerg Roedel <joro@8bytes.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Thomas Gleixner <tglx@linutronix.de>, Dmitry Vyukov <dvyukov@google.com>
List-Id: linux-efi@vger.kernel.org

On 03/22/2016 08:00 AM, Pavel Machek wrote:
> Hi!
> 
>> This RFC patch series provides support for AMD's new Secure Memory
>> Encryption (SME) feature.
>>
>> SME can be used to mark individual pages of memory as encrypted through the
>> page tables. A page of memory that is marked encrypted will be automatically
>> decrypted when read from DRAM and will be automatically encrypted when
>> written to DRAM. Details on SME can found in the links below.
> 
> Well, actually brief summary should go to changelog and probably to the documentation,
> too...
> 
> Why would I want SME on my system? My system seems to work without it.

The whitepaper explains the technologies and the value they provide.
It's up to you to decide if you'd want to use it.

> 
> Does it protect against cold boot attacks? Rowhammer (I guess not?)

It does protect well against cold boot attacks. It might offer some
protection against Rowhammer since if a bit got flipped the entire
16B chunk would be decrypted differently.

> 
> Does it cost some performance?

The whitepaper talks about this a little, but it has a minimal impact
on system performance when accessing an encrypted page.

> 
> Does it break debugging over JTAG?
> 
>> The approach that this patch series takes is to encrypt everything possible
>> starting early in the boot where the kernel is encrypted. Using the page
>> table macros the encryption mask can be incorporated into all page table
>> entries and page allocations. By updating the protection map, userspace
>> allocations are also marked encrypted. Certain data must be accounted for
>> as having been placed in memory before SME was enabled (EFI, initrd, etc.)
>> and accessed accordingly.
> 
> Do you also need to do something special for device DMA?

DMA should function normally unless the device does not support the
addressing requirements when SME is active. When the encryption mask is
applied (bit 47 of the physical address in this case), if the device
doesn't support 48 bit or higher DMA then swiotlb bounce buffers will
be used.

Thanks,
Tom

> 
> Thanks,
> 
> 									Pavel
> 
