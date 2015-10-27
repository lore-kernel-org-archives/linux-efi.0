From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 2/2] efi: Fix warning of int-to-pointer-cast on x86
 32-bit builds
Date: Tue, 27 Oct 2015 21:11:13 +0000
Message-ID: <20151027211113.GD8973@codeblueprint.co.uk>
References: <20151023085011.GB21631@gmail.com>
 <1445593697-1342-1-git-send-email-ard.biesheuvel@linaro.org>
 <1445593697-1342-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1445593697-1342-2-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, izumi.taku@jp.fujitsu.com, linux-kernel@vger.kernel.org, mingo@kernel.org, kamezawa.hiroyu@jp.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On Fri, 23 Oct, at 11:48:17AM, Ard Biesheuvel wrote:
> From: Taku Izumi <izumi.taku@jp.fujitsu.com>
> 
> Commit 0f96a99dab36 ("efi: Add "efi_fake_mem" boot option")
> introduces the following warning message:
> 
>   drivers/firmware/efi/fake_mem.c:186:20: warning: cast to pointer
>   from integer of different size [-Wint-to-pointer-cast]
> 
> new_memmap_phy was defined as a u64 value and cast to void*, causing
> a int-to-pointer-cast warning on x86 32-bit builds.
> However, since the void* type is inappropriate for a physical
> address, the definition of struct efi_memory_map::phys_map has been
> changed to phys_addr_t in the previous patch, and so the cast can be
> dropped entirely.
> 
> This patch also changes the type of the "new_memmap_phy" variable
> from "u64" to "phys_addr_t" to align with the types of
> memblock_alloc() and struct efi_memory_map::phys_map.
> 
> Reported-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Taku Izumi <izumi.taku@jp.fujitsu.com>
> [ard.biesheuvel: removed void* cast, updated commit log]
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  drivers/firmware/efi/fake_mem.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Matt Fleming <matt@codeblueprint.co.uk>
