From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2] x86/mm/KASLR: EFI region is mistakenly included into
 KASLR VA space for randomization
Date: Fri, 24 Mar 2017 10:42:47 +0000
Message-ID: <CAKv+Gu-d3M6-T1HbZYjFnPA_KYtdQyCx36fRSXD5vNurjAqXuw@mail.gmail.com>
References: <1490331592-31860-1-git-send-email-bhe@redhat.com>
 <20170324080833.GA15200@gmail.com> <20170324083451.GC30442@x1>
 <20170324084609.GA6807@dhcp-128-65.nay.redhat.com> <20170324092433.GA3237@gmail.com>
 <CAKv+Gu_V_VAWuDtKyOY9RS+cdhi+c5z2a7n2kcXVybvvdmPYBw@mail.gmail.com> <20170324103624.GA6231@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170324103624.GA6231@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Dave Young <dyoung@redhat.com>, Baoquan He <bhe@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Thomas Garnier <thgarnie@google.com>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Bhupesh Sharma <bhsharma@redhat.com>
List-Id: linux-efi@vger.kernel.org

On 24 March 2017 at 10:36, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
>> No. It is the firmware's EFI code, and the virtual translation applied by the OS
>> is made known to the firmware by means of a call into the runtime service
>> SetVirtualAddressMap(). This service can only be called once after each boot,
>> and so kexec kernels are forced to use the same VA mapping for runtime services
>> as the first kernel. This is the whole point of having a VA region reserved for
>> this, so that kexec kernels are guaranteed to be able to use the same VA
>> mapping.
>
> Yes, but it's the kernel's EFI code that determines the area!

Indeed. It seems I misunderstood you there.

There are some known limitations, though, which prevent us from using
userland mappings on x86 like we do on ARM (Macs don't support it),
but I don't think randomizing the mappings inside this 64 GB window is
going to trigger any latent firmware bugs.

> So my suggestion:
>
>> > Preserving virtual addresses for kexec is a red herring: the randomized offset
>> > could be passed to the kexec-ed kernel just fine.
>
> Would solve the kexec problem, right?
>
> I.e. the first kernel that boots randomizes the address range - and passes that
> offset off to any subsequent kernels.
>

Yes, that sounds feasible to me.

> Turning KASLR off actively degrades that randomization of the kernel virtual
> addresses.
>
> Am I missing anything?
>

No, I think you are right. UEFI runtime services region are likely to
consist of R+W+X mappings for the foreseeable future on x86, and the
more we tighten down security in other places, the more appealing the
UEFI regions become for exploitation (even if they are only mapped
while runtime services calls are in progress).
