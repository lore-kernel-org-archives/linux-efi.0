From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC Part1 PATCH v3 02/17] x86/CPU/AMD: Add the Secure Encrypted
 Virtualization CPU feature
Date: Tue, 25 Jul 2017 10:29:40 -0500
Message-ID: <d6fdba78-034b-d9e2-15ae-00547821a855@amd.com>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
 <20170724190757.11278-3-brijesh.singh@amd.com>
 <20170725102657.GD21822@nazgul.tnic>
 <7236d267-ebcb-8b45-b8d3-5955903e395f@amd.com>
 <20170725143615.GA26029@nazgul.tnic>
 <47ccc32e-e113-48e0-d2e0-2f23b37cc452@amd.com>
 <20170725151301.GC26029@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170725151301.GC26029@nazgul.tnic>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@suse.de>
Cc: Brijesh Singh <brijesh.singh@amd.com>, linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Tony Luck <tony.luck@intel.com>, Piotr Luc <piotr.luc@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Lu Baolu <baolu.lu@linux.intel.com>, Reza Arbab <arbab@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Laura Abbott <labbott@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, Eric
List-Id: linux-efi@vger.kernel.org

On 7/25/2017 10:13 AM, Borislav Petkov wrote:
> On Tue, Jul 25, 2017 at 09:58:54AM -0500, Tom Lendacky wrote:
>> True, but it is more about being accurate and making sure the value is
>> correct where ever it may be used.
> 
> So early_identify_cpu() initializes phys_bits to 32 on 32-bit.
> Subtracting it there would actually make actively it wrong, AFAICT.

But early_identify_cpu() calls get_cpu_cap() which will check for cpuid
leaf 0x80000008 support and set x86_phys_bits.  I'll try to build and
run a 32-bit kernel and see how this all flows.

Thanks,
Tom

> 
