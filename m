From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC Part1 PATCH v3 02/17] x86/CPU/AMD: Add the Secure Encrypted
 Virtualization CPU feature
Date: Tue, 25 Jul 2017 09:58:54 -0500
Message-ID: <47ccc32e-e113-48e0-d2e0-2f23b37cc452@amd.com>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
 <20170724190757.11278-3-brijesh.singh@amd.com>
 <20170725102657.GD21822@nazgul.tnic>
 <7236d267-ebcb-8b45-b8d3-5955903e395f@amd.com>
 <20170725143615.GA26029@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170725143615.GA26029@nazgul.tnic>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@suse.de>
Cc: Brijesh Singh <brijesh.singh@amd.com>, linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Tony Luck <tony.luck@intel.com>, Piotr Luc <piotr.luc@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Lu Baolu <baolu.lu@linux.intel.com>, Reza Arbab <arbab@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Laura Abbott <labbott@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, Eric
List-Id: linux-efi@vger.kernel.org

On 7/25/2017 9:36 AM, Borislav Petkov wrote:
> On Tue, Jul 25, 2017 at 09:29:40AM -0500, Tom Lendacky wrote:
>> Yup, we can do something like that.  I believe the only change that
>> would be needed to your patch would be to move the IS_ENABLED() check
>> to after the physical address space reduction check.
> 
> Yeah, I wasn't sure about that. The logic is that if BIOS has enabled
> SME and thus reduction is in place, we need to update x86_phys_bits on
> 32-bit regardless, right?
> 
> But, come to think of it, that reduction won't have any effect since we
> have 32-bit addresses and the reduction is above 32-bits, right? And
> thus it is moot.


True, but it is more about being accurate and making sure the value is
correct where ever it may be used.

Thanks,
Tom

> 
> Or?
> 
