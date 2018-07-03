From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] x86/efi: Access EFI MMIO data as unencrypted when SEV is active
Date: Wed, 4 Jul 2018 00:40:46 +0200
Message-ID: <CAKv+Gu-hWz4UUvvSyG5=RzCWmheva2-yUkSyuCM0_CDERCJihQ@mail.gmail.com>
References: <1530624720-32004-1-git-send-email-brijesh.singh@amd.com>
 <CAKv+Gu8MZ1O2U=OiONCdaFQjNGVPjqASMP7ubKCg-9ULdk7Whw@mail.gmail.com>
 <20180703154418.GC4643@zn.tnic> <e17f101d-8509-17bc-f099-92cd7e817f49@amd.com>
 <20180703214604.GA15516@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180703214604.GA15516@zn.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@suse.de>
Cc: Brijesh Singh <brijesh.singh@amd.com>, the arch/x86 maintainers <x86@kernel.org>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, Thomas Gleixner <tglx@linutronix.de>, KVM devel mailing list <kvm@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-efi@vger.kernel.org

On 3 July 2018 at 23:46, Borislav Petkov <bp@suse.de> wrote:
> On Tue, Jul 03, 2018 at 04:16:57PM -0500, Brijesh Singh wrote:
>> I agree with Ard,  it may be good idea to extend the UEFI spec to
>> include encryption information. Having this information may be helpful
>> in some cases, e.g if we ever need to map a specific non IO memory as
>> unencrypted. So far we have not seen the need for it. But I will ask AMD
>> folks working closely with UEFI committee to float this and submit it as
>> enhancement in Tianocore BZ.
>
> Except that if the IO memory handling unencrypted changes in future
> incarnations, the changes to the spec become moot. I'm just saying...
>

Quite the opposite. If we allocate a EFI_MEMORY_xx bit to signify that
a region should be mapped as encrypted, we no longer have to reason
about these things in the kernel but we can simply apply the
attributes that the UEFI memory map provides us. A platform could then
describe both encrypted and unencrypted MMIO regions at will.
