From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 08/14] arm64: efi: split Image code and data into
 separate PE/COFF sections
Date: Fri, 10 Feb 2017 14:28:34 +0000
Message-ID: <CAKv+Gu8b-8jrr341gg9E9QzbEtRtMhZy9xE2rM8TvQTb+1aJdQ@mail.gmail.com>
References: <1486554947-3964-1-git-send-email-ard.biesheuvel@linaro.org>
 <1486554947-3964-9-git-send-email-ard.biesheuvel@linaro.org> <20170210104942.GF28753@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-hardening-return-6462-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170210104942.GF28753@leverpostej>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Leif Lindholm <leif.lindholm@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Russell King <linux@armlinux.org.uk>, kernel-hardening@lists.openwall.com, Laura Abbott <labbott@fedoraproject.org>
List-Id: linux-efi@vger.kernel.org

On 10 February 2017 at 10:49, Mark Rutland <mark.rutland@arm.com> wrote:
> On Wed, Feb 08, 2017 at 11:55:41AM +0000, Ard Biesheuvel wrote:
>> To prevent unintended modifications to the kernel text (malicious or
>> otherwise) while running the EFI stub, describe the kernel image as
>> two separate sections: a .text section with read-execute permissions,
>> covering .text, .rodata and .init.text, and a .data section with
>> read-write permissions, covering .init.data, .data and .bss.
>>
>> This relies on the firmware to actually take the section permission
>> flags into account, but this is something that is currently being
>> implemented in EDK2, which means we will likely start seeing it in
>> the wild between one and two years from now.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
>> diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
>> index b8deffa9e1bf..a93cc2b6f50b 100644
>> --- a/arch/arm64/kernel/vmlinux.lds.S
>> +++ b/arch/arm64/kernel/vmlinux.lds.S
>> @@ -149,6 +149,9 @@ SECTIONS
>>               ARM_EXIT_KEEP(EXIT_TEXT)
>>       }
>>
>> +     . = ALIGN(SZ_4K);
>> +     __pecoff_data_start = .;
>> +
>
> I understand that the stub needs to split the init text/data since
> unlike the kernel it'll map those with separate permissions, but it
> feels odd to do this specifically for the EFI stub.
>

While the init code executes in a *much* more controlled environment
than the stub (which invokes various UEFI boot services to load
initrds/dtb from block storage, and may do god knows what during
ExitBootServices()), I think it is not unreasonable to split the init
mapping into rx/rw segments, given that it is the only place where we
have a good chunk of memory that is both writable and executable.

> Yould it perhaps make more sense to always use separate segments for
> init/exit text/data, and also apply the permission split in the kernel?
>
> With that, I don't think we'd need additional stub-specific linker
> script changes.
>

I will prototype this
