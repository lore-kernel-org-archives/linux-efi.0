From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [GIT PULL 00/13] First batch of EFI updates for v4.13
Date: Mon, 5 Jun 2017 08:15:02 +0000
Message-ID: <CAKv+Gu8RCwmwifH5nONSi4BkkA0d5oNZP9uX0iBagXOOXe7tpA@mail.gmail.com>
References: <20170602135207.21708-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170602135207.21708-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
List-Id: linux-efi@vger.kernel.org

(trim cc)

On 2 June 2017 at 13:51, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> The following changes since commit 5ed02dbb497422bf225783f46e6eadd237d23d6b:
>
>   Linux 4.12-rc3 (2017-05-28 17:20:53 -0700)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next
>
> for you to fetch changes up to 3acbd5a24ab9d9a82c56d9018f4d340fa574b91d:
>
>   efi: arm: enable DMI/SMBIOS (2017-06-02 13:38:56 +0000)
>
> ----------------------------------------------------------------
> First batch of EFI changes for v4.13:
> - rework the EFI capsule loader to allow for workarounds for non-compliant
>   firmware to be implemented more easily and in a more self contained
>   manner (Ard)
> - implement a capsule loader quirk for Quark X102x, which prepends a
>   security header in a non-compliant way (Jan Kiszka)
> - enable SMBIOS/DMI support for the ARM architecture (Ard)
> - add EFI_PGT_DUMP support for x86_32 and kexec (Sai Praneeth)
> - some other cleanups
>
> ----------------------------------------------------------------
> Andy Lutomirski (1):
>       x86/efi: Clean up efi CR3 save/restore
>
> Ard Biesheuvel (4):
>       efi/capsule-loader: Use a cached copy of the capsule header
>       efi/capsule-loader: Redirect calls to efi_capsule_setup_info via weak alias
>       efi/capsule-loader: Use page addresses rather than struct page pointers
>       efi: arm: enable DMI/SMBIOS
>
> Fabian Frederick (1):
>       efi/capsule: Remove NULL test on kmap()
>
> Geliang Tang (1):
>       efi/efi_test: Use memdup_user() helper
>
> Jan Kiszka (5):
>       efi/capsule: Fix return code on failing kmap/vmap
>       efi/capsule: Remove pr_debug on ENOMEM or EFAULT
>       efi/capsule: Clean up pr_err/info messages
>       efi/capsule: Adjust return type of efi_capsule_setup_info
>       efi/capsule: Add support for Quark security header
>
> Sai Praneeth (1):
>       x86/efi: Add EFI_PGT_DUMP support for x86_32 and kexec
>

All,

I just noticed that this patch lacks my signoff. This is due to the
fact that Matt queued this particular patch, and I didn't update the
branch to add my sob, so it is only signed off by Matt not me.

How should we handle this now, and in the future? Matt and I share
maintainership responsibilities, and so everything that gets queued
into the EFI tree may be treated as signed off by either and/or the
both of us. For multi-maintainer trees that get pulled directly, this
is usually not an issue AFAIK, but given that Ingo is the one that
deals with EFI usually, and prefers to apply the patches individually,
this may  get flagged as a missing signoff.

In any case, I am happy to respin the patches, re-sign the tag etc if
this is deemed necessary.

Thanks,
Ard.
