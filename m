From: Borislav Petkov <bp@suse.de>
Subject: Re: [RFC Part1 PATCH v3 16/17] X86/KVM: Provide support to create
 Guest and HV shared per-CPU variables
Date: Wed, 30 Aug 2017 19:46:55 +0200
Message-ID: <20170830174655.ehrnmynotmp7laka@pd.tnic>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
 <20170724190757.11278-17-brijesh.singh@amd.com>
 <20170829102258.gxk227js4yw47qi3@pd.tnic>
 <0810a732-9c77-a543-ffeb-7fd2d8f46266@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0810a732-9c77-a543-ffeb-7fd2d8f46266@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Tony Luck <tony.luck@intel.com>, Piotr Luc <piotr.luc@intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, Fenghua Yu <fenghua.yu@intel.com>, Lu Baolu <baolu.lu@linux.intel.com>, Reza Arbab <arbab@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Laura Abbott <labbott@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, Eric
List-Id: linux-efi@vger.kernel.org

On Wed, Aug 30, 2017 at 11:18:42AM -0500, Brijesh Singh wrote:
> I was trying to avoid mixing early and no-early set_memory_decrypted() but if
> feedback is: use early_set_memory_decrypted() only if its required otherwise
> use set_memory_decrypted() then I can improve the logic in next rev. thanks

Yes, I think you should use the early versions when you're, well,
*early* :-) But get rid of that for_each_possible_cpu() and do it only
on the current CPU, as this is a per-CPU path anyway. If you need to
do it on *every* CPU and very early, then you need a separate function
which is called in kvm_smp_prepare_boot_cpu() as there you're pre-SMP.

Thx.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
