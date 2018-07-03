From: Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] x86/efi: Access EFI MMIO data as unencrypted when SEV is
 active
Date: Tue, 3 Jul 2018 23:46:05 +0200
Message-ID: <20180703214604.GA15516@zn.tnic>
References: <1530624720-32004-1-git-send-email-brijesh.singh@amd.com>
 <CAKv+Gu8MZ1O2U=OiONCdaFQjNGVPjqASMP7ubKCg-9ULdk7Whw@mail.gmail.com>
 <20180703154418.GC4643@zn.tnic>
 <e17f101d-8509-17bc-f099-92cd7e817f49@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e17f101d-8509-17bc-f099-92cd7e817f49@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, the arch/x86 maintainers <x86@kernel.org>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, Thomas Gleixner <tglx@linutronix.de>, KVM devel mailing list <kvm@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Jul 03, 2018 at 04:16:57PM -0500, Brijesh Singh wrote:
> I agree with Ard,  it may be good idea to extend the UEFI spec to
> include encryption information. Having this information may be helpful
> in some cases, e.g if we ever need to map a specific non IO memory as
> unencrypted. So far we have not seen the need for it. But I will ask AMD
> folks working closely with UEFI committee to float this and submit it as
> enhancement in Tianocore BZ.

Except that if the IO memory handling unencrypted changes in future
incarnations, the changes to the spec become moot. I'm just saying...

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
