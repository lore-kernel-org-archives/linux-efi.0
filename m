From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH] x86/efi: Access EFI MMIO data as unencrypted when SEV is
 active
Date: Tue, 3 Jul 2018 16:16:57 -0500
Message-ID: <e17f101d-8509-17bc-f099-92cd7e817f49@amd.com>
References: <1530624720-32004-1-git-send-email-brijesh.singh@amd.com>
 <CAKv+Gu8MZ1O2U=OiONCdaFQjNGVPjqASMP7ubKCg-9ULdk7Whw@mail.gmail.com>
 <20180703154418.GC4643@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180703154418.GC4643@zn.tnic>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@suse.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: brijesh.singh@amd.com, the arch/x86 maintainers <x86@kernel.org>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, Thomas Gleixner <tglx@linutronix.de>, KVM devel mailing list <kvm@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-efi@vger.kernel.org



On 7/3/18 10:44 AM, Borislav Petkov wrote:
> (dropping stable@ as this is not how you send patches to stable).
>
> On Tue, Jul 03, 2018 at 05:37:18PM +0200, Ard Biesheuvel wrote:
>> On 3 July 2018 at 15:32, Brijesh Singh <brijesh.singh@amd.com> wrote:
>>> SEV guest fails to update the UEFI runtime variables stored in the
>>> flash. commit 1379edd59673 ("x86/efi: Access EFI data as encrypted
>>> when SEV is active") unconditionally maps all the UEFI runtime data
>>> as 'encrypted' (C=1). When SEV is active the UEFI runtime data marked
>>> as EFI_MEMORY_MAPPED_IO should be mapped as 'unencrypted' so that both
>>> guest and hypervisor can access the data.
>>>
>> I'm uncomfortable having to carry these heuristics in the kernel. The
>> UEFI memory map should be the definitive source of information
>> regarding how the OS should map the regions it describes, and if we
>> need to guess the encryption status, we are likely to get it wrong at
>> least some of the times.

I agree with Ard,  it may be good idea to extend the UEFI spec to
include encryption information. Having this information may be helpful
in some cases, e.g if we ever need to map a specific non IO memory as
unencrypted. So far we have not seen the need for it. But I will ask AMD
folks working closely with UEFI committee to float this and submit it as
enhancement in Tianocore BZ.

> I think the problem here is that IO memory can't be encrypted, at least
> at the moment. Thus this patch. I believe future versions will be able
> to handle encrypted IO but that's something Brijesh can correct me on.

Yes you are right, IO memory can't be encrypted. We map all IO memory
ranges as unencrypted everywhere else in the kernel. The
EFI_MEMORY_MAPPED_IO type should also be mapped as unencrypted.


> So it is not really about the UEFI spec but about what the hardware
> does/supports currently.
>
> And I don't think that change matters on anything else besides AMD with
> SEV enabled...
>
> Thx.
>
