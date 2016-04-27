From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC PATCH v1 00/18] x86: Secure Memory Encryption (AMD)
Date: Wed, 27 Apr 2016 15:10:19 -0500
Message-ID: <57211CAB.9040902@amd.com>
References: <20160426225553.13567.19459.stgit@tlendack-t1.amdoffice.net>
 <CALCETrUdrMAmE6Vgj6_PALdmRZVVKa3QDwJtO=YDTOQdox=rhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <CALCETrUdrMAmE6Vgj6_PALdmRZVVKa3QDwJtO=YDTOQdox=rhQ@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-arch <linux-arch@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, kvm list <kvm@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kasan-dev <kasan-dev@googlegroups.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, iommu@lists.linux-foundation.org, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Joerg Roedel <joro@8bytes.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Paolo
 Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Thomas
 Gleixner <tglx@l>
List-Id: linux-efi@vger.kernel.org

On 04/27/2016 09:39 AM, Andy Lutomirski wrote:
> On Tue, Apr 26, 2016 at 3:55 PM, Tom Lendacky <thomas.lendacky@amd.com> wrote:
>> This RFC patch series provides support for AMD's new Secure Memory
>> Encryption (SME) feature.
>>
>> SME can be used to mark individual pages of memory as encrypted through the
>> page tables. A page of memory that is marked encrypted will be automatically
>> decrypted when read from DRAM and will be automatically encrypted when
>> written to DRAM. Details on SME can found in the links below.
> 
> Having read through the docs briefly, some questions:
> 
> 1. How does the crypto work?  Is it straight AES-ECB?  Is it a
> tweakable mode?  If so, what does into the tweak?  For example, if I
> swap the ciphertext of two pages, does the plaintext of the pages get
> swapped?  If not, why not?

The AES crypto uses a tweak such that two identical plaintexts at
different locations will have different ciphertext. So swapping the
ciphertext of two pages will not result in the plaintext being swapped.

> 
> 2. In SEV mode, how does the hypervisor relocate a physical backing
> page?  Does it simple move it and update the 2nd-level page tables?
> If so, is the result of decryption guaranteed to be garbage if it
> relocates a page and re-inserts it at the wrong guest physical
> address?

For SEV mode, relocating a physical backing page takes extra steps.
There are APIs that are used to have the AMD Secure Processor create a
transportable encrypted page that can then be moved to a new location
in memory. After moving it to the new location the APIs are used to
haves the AMD Secure Processor re-encrypt the page for use with the
guests SEV key. Based on #1 above, just moving a page without invoking
the necessary APIs will result in the decryption returning garbage.

> 
> 3. In SEV mode, does anything prevent the hypervisor from resuming a
> guest with the wrong ASID, or is this all relying on the resulting
> corruption of the guest code and data to cause a crash?

There is nothing that prevents resuming a guest with the wrong ASID.
This relies on the resulting corruption of the guest code/data to
cause a crash.

> 
> 4. As I understand it, the caches are all unencrypted, and they're
> tagged with the physical address, *including* the SME bit (bit 47).
> In SEV mode, are they also tagged with the ASID?  I.e. if I have a
> page in cache for ASID 1 and I try to read it with ASID 2, will I get
> a fresh copy decrypted with ASID 2's key?  If so, will the old ASID 1
> copy be evicted, or will it stay in cache and be non-coherent?

In SEV mode, the caches are tagged with the ASID. So if you try to read
a cached page with a different ASID, it would result in a cache miss
for that ASID and will instead fetch from memory and decrypt using
the that ASID's key.

Thanks,
Tom

> 
> --Andy
> 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
