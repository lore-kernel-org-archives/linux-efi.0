From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH v2 1/4] x86/efi: show actual ending addresses in
 efi_print_memmap
Date: Fri, 8 Jan 2016 12:04:48 +0000
Message-ID: <20160108120448.GH2532@codeblueprint.co.uk>
References: <20151223124711.GB2471@codeblueprint.co.uk>
 <1450919243-5314-1-git-send-email-elliott@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1450919243-5314-1-git-send-email-elliott@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Robert Elliott <elliott@hpe.com>
Cc: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org, leif.lindholm@linaro.org
List-Id: linux-efi@vger.kernel.org

On Wed, 23 Dec, at 07:07:23PM, Robert Elliott wrote:
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
> ---
> Changes in v2:
>  - Expanded rationale in the commit message
> ---
>  arch/x86/platform/efi/efi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Thanks Robert, I've queued this up for v4.6.
