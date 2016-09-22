From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [RFC PATCH 0/3] efi: MMC proxy support for the UEFI varstore
Date: Thu, 22 Sep 2016 13:58:54 +0100
Message-ID: <20160922125854.GC26596@leverpostej>
References: <1474543806-19210-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1474543806-19210-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, glikely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org, haojian.zhuang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, andrew-h+KGxgPPiopAfugRpC6u6w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi Ard,

On Thu, Sep 22, 2016 at 12:30:03PM +0100, Ard Biesheuvel wrote:
> ================================================================================
> NOTE: this is a work in progress, and not fully functional yet. In particular,
> the actual MMC host protocol methods are stubbed out at the moment, and need to
> be wired up to the Linux device drivers.
> ================================================================================
> 
> On mobile and embedded systems, there is usually only a single MMC device for
> non-volatile storage, which sits behind a controller that is owned by the OS at
> runtime. This makes it difficult to host the UEFI variable store on MMC as well,
> since the UEFI runtime services routines expect ownership of the underlying
> device as well.
> 
> This series proposes an approach to work around this. It implements the UEFI
> MMC host protocol in the kernel, in a way that makes it possible to expose it
> to the firmware. At the same time, the firmware needs be set up for this, i.e.,
> it needs to expose its MMC host protocol pointer via a UEFI configuration table,
> so that the kernel can override it if it decides to expose this functionality
> to the firmware.

At a high level, and assuming a number of details from previous
discussions, I think the general approach of having the kernel mediate
access to the MMC makes sense.

However, I don't think that this series has enough detail for critical
review, even at the interface level. e.g. there is no mention of how
this caters for replay attacks and so on (which the current spec
sidesteps). I'm under the impression that there are mechanisms which
have been discussed for this, and I hope this is simply an oversight.

I also think that this needs to go via the USWG (and to the UEFI spec),
before we can consider using it. I say this because:

* This is critical to correct operation of variable storage as required
  for the standard boot flow. This is a major change to the way variable
  storage works today, with a number of (security) implications.

* There are others in this space trying to use the same class of
  hardware, e.g. FreeBSD. We don't want a Linux-specific interface, nor
  do we want a proliferation of interfaces for this purpose.

I have a few other general concerns:

* Identification of the relevant MMC device(s).
 
  Patch 3 suggests a devicetree property. I don't think that the
  'linux,' prefix makes sense, and it's not clear what we would do with
  ACPI.
 
  Does the MMC device not have some identifier we can query, so that we
  can match this up without requiring additional info in ACPI/DT?

* Lifetime guarantees
 
  When is it valid for EFI to call the MMC proxy? Can other services
  (e.g. ACPI) call this?

  How do we handle kexec/kdump? e.g. how do we teardown the interface
  before branching to a new kernel, how do we safely tear down a crashed
  kernel's interface, what can we call before doing so?

  How do we handle suspend/resume? e.g. is it necessary to re-register
  upon resume?

Thanks,
Mark.

> Note that these patches are based on patches in the EFI tree that are queued
> for v4.9, which replace the runtime wrappers spinlock with a semaphore. This
> allows us to sleep in the firmware callbacks.
> 
> Prerequisites for using these patches:
> 
> * qemu-system-aarch64 built from this branch:
>   https://git.linaro.org/people/ard.biesheuvel/qemu.git/shortlog/refs/heads/mach-virt-pl181
>   which adds a PL181 SD/MMC controller to the mach-virt model, and exposes it
>   via the device tree. It also sets the 'linux,uefi-varstore' property on this
>   node.
> 
> * UEFI firmware built from this branch:
>   https://git.linaro.org/people/ard.biesheuvel/uefi-next.git/shortlog/refs/heads/mmc-proxy
>   
>   Build using the following command
>   build -a AARCH64 -t GCC5 -p ArmVirtPkg/ArmVirtQemuMmcVars.dsc
> 
>   Run using 
>   qemu-system-aarch64 \
>     -M virt -cpu cortex-a57 -m 2048 \
>     -device virtio-blk-device,drive=boot \
>     -drive if=none,id=boot,file=fat:<path-of-Image>,format=raw \
>     -kernel <edk2-dir>/Build/ArmVirtQemuMmcVars-AARCH64/DEBUG_GCC5/FV/QEMU_EFI.fd \
>     -sd <edk2-dir>/build/edk2/Build/ArmVirtQemuMmcVars-AARCH64/DEBUG_GCC5/FV/QEMU_VARS.fd \
>     -nographic $@
> 
>   This will give you an UEFI environment which keeps its UEFI variables in the
>   emulated MMC volume, and exposes its MMC host protocol in a way that allows
>   these patches to hook into it.
> 
> Patches #1 and #2 implement the arch specific hooks to preserve/restore the NEON
> registers that the firmware may expect to be preserved across function calls.
> 
> Patch #3 implements the plumbing to call back into the kernel from the firmware.
> 
> Please comment on whether this approach seems feasible, and in particular, how
> on earth I should wire this up to the actual MMC code.
> 
> Thanks,
> Ard.
> 
> Ard Biesheuvel (3):
>   efi/arm64: add SIMD stash/unstash operations
>   efi/arm: add SIMD stash/unstash operations
>   efi: implement MMC proxy support for the UEFI variable store
> 
>  arch/arm/include/asm/efi.h       |  11 +
>  arch/arm64/include/asm/efi.h     |  33 +++
>  drivers/firmware/efi/Kconfig     |   9 +
>  drivers/firmware/efi/Makefile    |   1 +
>  drivers/firmware/efi/arm-init.c  |   2 +
>  drivers/firmware/efi/mmc-proxy.c | 222 ++++++++++++++++++++
>  include/linux/efi.h              |   1 +
>  7 files changed, 279 insertions(+)
>  create mode 100644 drivers/firmware/efi/mmc-proxy.c
> 
> -- 
> 2.7.4
> 
