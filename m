From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [RFC Part1 PATCH v3 16/17] X86/KVM: Provide support to create
 Guest and HV shared per-CPU variables
Date: Fri, 1 Sep 2017 17:52:13 -0500
Message-ID: <8155b5b2-b2b3-bc8f-33ae-b81b661a2e38@amd.com>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
 <20170724190757.11278-17-brijesh.singh@amd.com>
 <20170829102258.gxk227js4yw47qi3@pd.tnic>
 <0810a732-9c77-a543-ffeb-7fd2d8f46266@amd.com>
 <20170830174655.ehrnmynotmp7laka@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170830174655.ehrnmynotmp7laka@pd.tnic>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
To: Borislav Petkov <bp@suse.de>
Cc: brijesh.singh@amd.com, linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Tony Luck <tony.luck@intel.com>, Piotr Luc <piotr.luc@intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, Fenghua Yu <fenghua.yu@intel.com>, Lu Baolu <baolu.lu@linux.intel.com>, Reza Arbab <arbab@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Laura Abbott <labbott@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrew Morton <akpm@linux-foundat>
List-Id: linux-efi@vger.kernel.org

Hi Boris,

On 08/30/2017 12:46 PM, Borislav Petkov wrote:
> On Wed, Aug 30, 2017 at 11:18:42AM -0500, Brijesh Singh wrote:
>> I was trying to avoid mixing early and no-early set_memory_decrypted() but if
>> feedback is: use early_set_memory_decrypted() only if its required otherwise
>> use set_memory_decrypted() then I can improve the logic in next rev. thanks
> 
> Yes, I think you should use the early versions when you're, well,
> *early* :-) But get rid of that for_each_possible_cpu() and do it only
> on the current CPU, as this is a per-CPU path anyway. If you need to
> do it on *every* CPU and very early, then you need a separate function
> which is called in kvm_smp_prepare_boot_cpu() as there you're pre-SMP.
> 

I am trying to implement your feedback and now remember why I choose to
use early_set_memory_decrypted() and for_each_possible_cpu loop. These
percpu variables are static. Hence before clearing the C-bit we must
perform the in-place decryption so that original assignment is preserved
after we change the C-bit. Tom's SME patch [1] added sme_early_decrypt()
-- which can be used to perform the in-place decryption but we do not have
similar routine for non-early cases. In order to address your feedback,
we have to add similar functions. So far, we have not seen the need for
having such functions except this cases. The approach we have right now
works just fine and not sure if its worth adding new functions.

Thoughts ?

[1] Commit :7f8b7e7 x86/mm: Add support for early encryption/decryption of memory


-Brijesh
