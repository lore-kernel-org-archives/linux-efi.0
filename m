From: Laszlo Ersek <lersek@redhat.com>
Subject: Re: [PATCH 11/14] x86/efi: Show actual ending addresses in
 efi_print_memmap
Date: Tue, 2 Feb 2016 09:49:31 +0100
Message-ID: <56B06D9B.9010305@redhat.com>
References: <1454364428-494-1-git-send-email-matt@codeblueprint.co.uk>
 <1454364428-494-12-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454364428-494-12-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ingo Molnar <mingo@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Robert Elliott <elliott@hpe.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Leif Lindholm <leif.lindholm@linaro.org>
List-Id: linux-efi@vger.kernel.org

On 02/01/16 23:07, Matt Fleming wrote:
> From: Robert Elliott <elliott@hpe.com>
> 
> Adjust efi_print_memmap to print the real end address of each
> range, not 1 byte beyond. This matches other prints like those for
> SRAT and nosave memory.
> 
> While investigating grub persistent memory corruption issues, it
> was helpful to make this table match the ending address convention
> used by:
> * the kernel's e820 table prints
> 	BIOS-e820: [mem 0x0000001680000000-0x0000001c7fffffff] reserved
> * the kernel's nosave memory prints
> 	PM: Registered nosave memory: [mem 0x880000000-0xc7fffffff]
> * the kernel's ACPI System Resource Affinity Table prints
> 	SRAT: Node 1 PXM 1 [mem 0x480000000-0x87fffffff]
> * grub's lsmmap and lsefimmap commands
> 	reserved  0000001680000000-0000001c7fffffff 00600000     24GiB UC WC WT WB NV
> * the UEFI shell's memmap command
> 	Reserved   000000007FC00000-000000007FFFFFFF 0000000000000400 0000000000000001
> 
> For example, if you grep all the various logs for c7fffffff, you
> won't find the kernel's line if it uses c80000000.
> 
> Also, change the closing ) to ] to match the opening [.
> 
> old:
>     efi: mem61: [Persistent Memory  |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c80000000) (16384MB)
> 
> new:
>     efi: mem61: [Persistent Memory  |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff] (16384MB)
> 
> Signed-off-by: Robert Elliott <elliott@hpe.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Leif Lindholm <leif.lindholm@linaro.org>
> Cc: Laszlo Ersek <lersek@redhat.com>
> Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
> ---
>  arch/x86/platform/efi/efi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index bdd9477f937c..e80826e6f3a9 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -235,10 +235,10 @@ void __init efi_print_memmap(void)
>  		char buf[64];
>  
>  		md = p;
> -		pr_info("mem%02u: %s range=[0x%016llx-0x%016llx) (%lluMB)\n",
> +		pr_info("mem%02u: %s range=[0x%016llx-0x%016llx] (%lluMB)\n",
>  			i, efi_md_typeattr_format(buf, sizeof(buf), md),
>  			md->phys_addr,
> -			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
> +			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1,
>  			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
>  	}
>  #endif  /*  EFI_DEBUG  */
> 

For this patch:

Reviewed-by: Laszlo Ersek <lersek@redhat.com>

With regard to other arches:

- I think that "arch/arm64/kernel/efi.c" prints stuff like this
  already, in reserve_regions(). OK.

- However, I think "arch/ia64/kernel/efi.c" needs a similar patch.
  (Maybe your PULL includes such a patch already, but I'm not CC'd on
  it.) See in the function efi_init(), near efi_md_typeattr_format().

Thanks
Laszlo
