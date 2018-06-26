From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] efi: Free existing memory map before installing new
 memory map
Date: Tue, 26 Jun 2018 11:38:10 +0200
Message-ID: <CAKv+Gu-_tQsYMUMp4NGrEkRrbFGJvE=vJVciaO6TEAC_u5bmfQ@mail.gmail.com>
References: <1529980892-11833-1-git-send-email-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1529980892-11833-1-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lee Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, Dave Young <dyoung@redhat.com>, Laszlo Ersek <lersek@redhat.com>, Bhupesh Sharma <bhsharma@redhat.com>, Ricardo Neri <ricardo.neri@intel.com>, Ravi Shankar <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

On 26 June 2018 at 04:41, Sai Praneeth Prakhya
<sai.praneeth.prakhya@intel.com> wrote:
> From: Sai Praneeth <sai.praneeth.prakhya@intel.com>
>
> efi_memmap_install(), unmaps the existing memory map and installs the
> new memory map but doesn't free the memory allocated to the existing
> memory map. Fortunately, the details about the existing memory map are
> stored in efi.memmap. Hence, use them to free the memory.
>
> Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
> Reported-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Lee Chun-Yi <jlee@suse.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Young <dyoung@redhat.com>
> Cc: Laszlo Ersek <lersek@redhat.com>
> Cc: Bhupesh Sharma <bhsharma@redhat.com>
> Cc: Ricardo Neri <ricardo.neri@intel.com>
> Cc: Ravi Shankar <ravi.v.shankar@intel.com>
> Cc: Matt Fleming <matt@codeblueprint.co.uk>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>
> Note: Patch based on efi tree @https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git
>
>  drivers/firmware/efi/memmap.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/firmware/efi/memmap.c b/drivers/firmware/efi/memmap.c
> index 678e85704054..68b27b14fe94 100644
> --- a/drivers/firmware/efi/memmap.c
> +++ b/drivers/firmware/efi/memmap.c
> @@ -229,6 +229,9 @@ int __init efi_memmap_install(phys_addr_t addr, unsigned int nr_map)
>
>         efi_memmap_unmap();
>
> +       /* Free the memory allocated to the existing memory map */
> +       efi_memmap_free(efi.memmap.phys_map, efi.memmap.nr_map, efi.memmap.late);
> +
>         data.phys_map = addr;
>         data.size = efi.memmap.desc_size * nr_map;
>         data.desc_version = efi.memmap.desc_version;
> --
> 2.7.4
>

If only it were so simple :-)

At this point, efi.memmap.phys_map could point to memory that was
allocated early, allocated late or simply passed to the OS at boot
time by the stub (in which case it was memblock_reserve()d but not
memblock_alloc()d, and it should not be freed)

So only allocations made with efi_memmap_alloc() should be freed here.
I'm not sure /how/ we should keep track of that: perhaps it is simply
a matter of replacing the boolean 'late' with an enum that describes
where the memory came from that phys_map points to.
