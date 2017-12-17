From: Bhupesh Sharma <bhsharma@redhat.com>
Subject: Re: [PATCH 0/3] Use mm_struct and switch_mm() instead of manually
Date: Mon, 18 Dec 2017 02:39:55 +0530
Message-ID: <CACi5LpOHm_xWodv6qd+b9nk1ivpZyR9rvicmR3UgvxuLSRmuew@mail.gmail.com>
References: <1513469158-5638-1-git-send-email-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1513469158-5638-1-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>, Andy Lutomirski <luto@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Ricardo Neri <ricardo.neri@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Ravi Shankar <ravi.v.shankar@intel.com>
List-Id: linux-efi@vger.kernel.org

Hi Sai,

On Sun, Dec 17, 2017 at 5:35 AM, Sai Praneeth Prakhya
<sai.praneeth.prakhya@intel.com> wrote:
> From: Sai Praneeth <sai.praneeth.prakhya@intel.com>
>
> Presently, in x86, to invoke any efi function like
> efi_set_virtual_address_map() or any efi_runtime_service() the code path
> typically involves read_cr3() (save previous pgd), write_cr3()
> (write efi_pgd) and calling efi function. Likewise after returning from
> efi function the code path typically involves read_cr3() (save efi_pgd),
> write_cr3() (write previous pgd). We do this couple of times in efi
> subsystem of Linux kernel, instead we can use helper function
> efi_switch_mm() to do this. This improves readability and maintainability.
> Also, instead of maintaining a separate struct "efi_scratch" to store/restore
> efi_pgd, we can use mm_struct to do this.
>
> I have tested this patch set against LUV (Linux UEFI Validation), so I
> think I didn't break any existing configurations. I have tested this
> patch set for
> 1. x86_64,
> 2. x86_32,
> 3. Mixed mode
> with efi=old_map and for kexec kernel. Please let me know if I have
> missed any other configurations.
>
> Changes in V2:
> 1. Resolve mm_dropping() issue by not mm_dropping()/mm_grabbing() any mm,
> as we are not losing/creating any references.
>
> Changes in V3:
> 1. When CPUMASK_OFFSTACK is enabled, switch_mm_irqs_off() sets cpumask
> by calling cpumask_set_cpu(). This panics kernel as efi_mm is not
> initialized, therefore initialize efi_mm in efi_alloc_page_tables().

Thanks for the v3.

I confirmed that the issue I saw with the v2 when I enabled
'efi=debug' on the sgi-uv 300 machine (i.e the NULL pointer access
while accessing mm_cpumask(next), in the function call
'switch_mm_irqs_off') is fixed in the v3.

Also as I noted during the v2 review, introducing the 'efi_switch_mm()
' helper instead of manually
twiddling with %cr3 seems more cleaner (having personally debugged
this leg several times on the underlying x86 EFI machines).

So in addition to me testing this on the sgi-uv300 and Dell Optiplex
EFI enabled machine, please feel free to add:

Reviewed-by: Bhupesh Sharma <bhsharma@redhat.com>

Thanks,
Bhupesh


> Note:
> This patch set is based on Linus's tree v4.15-rc3
>
> Sai Praneeth (3):
>   efi: Use efi_mm in x86 as well as ARM
>   x86/efi: Replace efi_pgd with efi_mm.pgd
>   x86/efi: Use efi_switch_mm() rather than manually twiddling with %cr3
>
>  arch/x86/include/asm/efi.h           | 29 +++++++++---------
>  arch/x86/platform/efi/efi_64.c       | 59 +++++++++++++++++++-----------------
>  arch/x86/platform/efi/efi_thunk_64.S |  2 +-
>  drivers/firmware/efi/arm-runtime.c   |  9 ------
>  drivers/firmware/efi/efi.c           |  9 ++++++
>  include/linux/efi.h                  |  2 ++
>  6 files changed, 57 insertions(+), 53 deletions(-)
>
> Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
> Cc: Lee, Chun-Yi <jlee@suse.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Ricardo Neri <ricardo.neri@intel.com>
> Cc: Matt Fleming <matt@codeblueprint.co.uk>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Ravi Shankar <ravi.v.shankar@intel.com>
> Tested-by: Bhupesh Sharma <bhsharma@redhat.com>
>
> --
> 2.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
