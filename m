From: Daniel Walker <danielwa@cisco.com>
Subject: Re: [PATCH 0/8] add generic builtin command line
Date: Thu, 27 Sep 2018 11:08:51 -0700
Message-ID: <3320a561-2287-63f7-2162-84a639a22a8a@cisco.com>
References: <1538067309-5711-1-git-send-email-maksym.kokhan@globallogic.com>
 <CAKv+Gu-AxtOO04iwPSri12tkb9NRugXV9E2LGrfJT-LJjf4_ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu-AxtOO04iwPSri12tkb9NRugXV9E2LGrfJT-LJjf4_ow@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Maksym Kokhan <maksym.kokhan@globallogic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ralf Baechle <ralf@linux-mips.org>, Paul Burton <paul.burton@mips.com>, James Hogan <jhogan@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Daniel Walker <dwalker@fifo99.com>, Andrii Bordunov <aborduno@cisco.com>, Ruslan Bilovol <rbilovol@cisco.com>
List-Id: linux-efi@vger.kernel.org

On 09/27/2018 10:05 AM, Ard Biesheuvel wrote:
> On 27 September 2018 at 18:55, Maksym Kokhan
> <maksym.kokhan@globallogic.com> wrote:
>> There were series of patches [1] for 4.3.0-rc3, that allowed
>> architectures to use a generic builtin command line. I have rebased
>> these patches on kernel 4.19.0-rc4.
>>
> 
> Could you please elaborate on the purpose of this series? Is it simply
> to align between architectures? Does it solve an actual problem?

1) It removed a lot of code duplication between architecture

2) At Cisco we have issues where our bootloaders having default boot 
arguments. Some platforms we can't update the boot loader and it's 
helpful to be able to have boot arguments which are prepended to the 
bootloader arguments , and some parameters which are appended. These 
changes allow that.

Daniel
