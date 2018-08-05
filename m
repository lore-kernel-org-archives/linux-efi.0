From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 0/6][RFC] Add EFI secure key to key retention service
Date: Sun, 5 Aug 2018 09:25:56 +0200
Message-ID: <CAKv+Gu81vEGNggcWv1NyPJsMeK0HRi_DanH2+Z_4metoNG=txA@mail.gmail.com>
References: <20180805032119.20485-1-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180805032119.20485-1-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, keyrings@vger.kernel.org, linux-integrity <linux-integrity@vger.kernel.org>, "Lee, Chun-Yi" <jlee@suse.com>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Pavel Machek <pavel@ucw.cz>, Chen Yu <yu.c.chen@intel.com>, Oliver Neukum <oneukum@suse.com>, Ryan Chen <yu.chen.surf@gmail.com>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>
List-Id: linux-efi@vger.kernel.org

Hello Chun,yi,

On 5 August 2018 at 05:21, Lee, Chun-Yi <joeyli.kernel@gmail.com> wrote:
> When secure boot is enabled, only signed EFI binary can access
> EFI boot service variable before ExitBootService. Which means that
> the EFI boot service variable is secure.
>

No it, isn't, and this is a very dangerous assumption to make.

'Secure' means different things to different people. 'Secure boot' is
a misnomer, since it is too vague: it should be called 'authenticated
boot', and the catch is that authentication using public-key crypto
does not involve secrets at all. The UEFI variable store was not
designed with confidentiality in mind, and assuming [given the
reputation of EFI on the implementation side] that you can use it to
keep secrets is rather unwise imho.

> This patch set add functions to EFI boot stub to generate a 512-bit
> random number that it can be used as a root key for encryption and
> authentication. This root key will be kept in EFI boot service variable.
> EFI boot stub will read and transfer ERK (efi root key) to kernel.
>
> At runtime, the ERK can be used to encrypted/authentication other
> random number to generate EFI secure key. The EFI secure key can be
> a new master key type for encrypted key. It's useful for hibernation
> or evm.
>
> Here is the proof of concept for using EFI secure key in hibernation:
>   https://github.com/joeyli/linux-s4sign/commit/6311e97038974bc5de8121769fb4d34470009566
>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Chen Yu <yu.c.chen@intel.com>
> Cc: Oliver Neukum <oneukum@suse.com>
> Cc: Ryan Chen <yu.chen.surf@gmail.com>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
> Signed-off-by: "Lee, Chun-Yi" <jlee@suse.com>
>
> Lee, Chun-Yi (6):
>   x86/KASLR: make getting random long number function public
>   efi: the function transfers status to string
>   efi: generate efi root key in EFI boot stub
>   key: add EFI secure key type
>   key: add EFI secure key as a master key type
>   key: enforce the secure boot checking when loading efi root key
>
>  Documentation/admin-guide/kernel-parameters.txt |   6 +
>  arch/x86/boot/compressed/Makefile               |   1 +
>  arch/x86/boot/compressed/cpuflags.c             |   2 +-
>  arch/x86/boot/compressed/eboot.c                |   2 +
>  arch/x86/boot/compressed/efi_root_key.c         | 212 +++++++
>  arch/x86/boot/compressed/kaslr.c                |  21 -
>  arch/x86/boot/compressed/misc.c                 |  17 +
>  arch/x86/boot/compressed/misc.h                 |  12 +-
>  arch/x86/include/asm/efi.h                      |  13 +
>  arch/x86/include/uapi/asm/bootparam.h           |   1 +
>  arch/x86/kernel/setup.c                         |   3 +
>  arch/x86/lib/kaslr.c                            |  61 +-
>  arch/x86/lib/random.c                           |  68 +++
>  drivers/firmware/efi/Kconfig                    |  31 +
>  drivers/firmware/efi/Makefile                   |   1 +
>  drivers/firmware/efi/efi-secure-key.c           | 748 ++++++++++++++++++++++++
>  include/keys/efi-type.h                         |  57 ++
>  include/linux/efi.h                             |  40 ++
>  include/linux/kernel.h                          |   3 +-
>  kernel/panic.c                                  |   1 +
>  security/keys/encrypted-keys/encrypted.c        |  10 +
>  21 files changed, 1226 insertions(+), 84 deletions(-)
>  create mode 100644 arch/x86/boot/compressed/efi_root_key.c
>  create mode 100644 arch/x86/lib/random.c
>  create mode 100644 drivers/firmware/efi/efi-secure-key.c
>  create mode 100644 include/keys/efi-type.h
>
> --
> 2.13.6
>
