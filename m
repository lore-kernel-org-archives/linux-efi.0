From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 1/2] efi: use correct type for struct
 efi_memory_map::phys_map
Date: Tue, 27 Oct 2015 21:09:34 +0000
Message-ID: <20151027210934.GC8973@codeblueprint.co.uk>
References: <20151023085011.GB21631@gmail.com>
 <1445593697-1342-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1445593697-1342-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, izumi.taku@jp.fujitsu.com, linux-kernel@vger.kernel.org, mingo@kernel.org, kamezawa.hiroyu@jp.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On Fri, 23 Oct, at 11:48:16AM, Ard Biesheuvel wrote:
> We have been getting away with using a void* for the physical
> address of the UEFI memory map, since, even on 32-bit platforms
> with 64-bit physical addresses, no truncation takes place if the
> memory map has been allocated by the firmware (which only uses
> 1:1 virtually addressable memory), which is usually the case.
> 
> However, commit 0f96a99dab36 ("efi: Add "efi_fake_mem" boot option")
> adds code that clones and modifies the UEFI memory map, and the
> clone may live above 4 GB on 32-bit platforms. This means our use
> of void* for struct efi_memory_map::phys_map has graduated from
> 'incorrect but working' to 'incorrect and broken', and we need to
> fix it.
> 
> So redefine struct efi_memory_map::phys_map as phys_addr_t, and
> get rid of a bunch of casts that are now unneeded.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm64/kernel/efi.c     | 4 ++--
>  arch/x86/platform/efi/efi.c | 4 ++--
>  drivers/firmware/efi/efi.c  | 8 ++++----
>  include/linux/efi.h         | 2 +-
>  4 files changed, 9 insertions(+), 9 deletions(-)

Reviewed-by: Matt Fleming <matt@codeblueprint.co.uk>
