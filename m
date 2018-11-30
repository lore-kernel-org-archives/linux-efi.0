From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 10/11] efi: reduce the amount of memblock reservations
 for persistent allocations
Date: Fri, 30 Nov 2018 09:38:23 +0100
Message-ID: <20181130083823.GB97998@gmail.com>
References: <20181129171230.18699-1-ard.biesheuvel@linaro.org>
 <20181129171230.18699-11-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181129171230.18699-11-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, Arend van Spriel <arend.vanspriel@broadcom.com>, Bhupesh Sharma <bhsharma@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>, Eric Snowberg <eric.snowberg@oracle.com>, Hans de Goede <hdegoede@redhat.com>, Joe Perches <joe@perches.com>, Jon Hunter <jonathanh@nvidia.com>, Julien Thierry <julien.thierry@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Nathan Chancellor <natechancellor@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Sedat Dilek <sedat.dilek@gmail.com>, YiFei Zhu <zhuyifei1999@gmail.com>
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> The current implementation of efi_mem_reserve_persistent() is rather
> naive, in the sense that for each invocation, it creates a separate
> linked list entry to describe the reservation. Since the linked list
> entries themselves need to persist across subsequent kexec reboots,
> every reservation created this way results in two memblock_reserve()
> calls at the next boot.
> 
> On arm64 systems with 100s of CPUs, this may result in a excessive
> number of memblock reservations, and needless fragmentation.
> 
> So instead, make use of the newly updated struct linux_efi_memreserve
> layout to put multiple reservations into a single linked list entry.
> This should get rid of the numerous tiny memblock reservations, and
> effectively cut the total number of reservations in half on arm64
> systems with many CPUs.
> 
> Tested-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  drivers/firmware/efi/efi.c | 20 +++++++++++++++++---
>  include/linux/efi.h        |  3 +++
>  2 files changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 80b11521627a..e90bc32c2670 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -998,7 +998,8 @@ int __ref efi_mem_reserve_persistent(phys_addr_t addr, u64 size)
>  {
>  	struct linux_efi_memreserve *rsv;
>  	int rsvsize = EFI_MEMRESERVE_SIZE(1);
> -	int rc;
> +	unsigned long prsv;
> +	int rc, index;
>  
>  	if (efi_memreserve_root == (void *)ULONG_MAX)
>  		return -ENODEV;
> @@ -1009,11 +1010,24 @@ int __ref efi_mem_reserve_persistent(phys_addr_t addr, u64 size)
>  			return rc;
>  	}
>  
> -	rsv = kmalloc(rsvsize, GFP_ATOMIC);

I fixed the following build warning in this patch:

  drivers/firmware/efi/efi.c:1000:6: warning: unused variable ‘rsvsize’ [-Wunused-variable]

'rsvsize' got entirely orphaned by the patch, so it can be removed.

Thanks,

	Ingo
