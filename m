From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH V2] x86/efi: Add EFI_PGT_DUMP support for x86_32, kexec
Date: Mon, 15 May 2017 15:27:29 +0100
Message-ID: <20170515142729.GE2935@codeblueprint.co.uk>
References: <1494530433-19503-1-git-send-email-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1494530433-19503-1-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Ricardo Neri <ricardo.neri@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Ravi Shankar <ravi.v.shankar@intel.com>
List-Id: linux-efi@vger.kernel.org

On Thu, 11 May, at 12:20:33PM, Sai Praneeth Prakhya wrote:
> From: Sai Praneeth <sai.praneeth.prakhya@intel.com>
> 
> EFI_PGT_DUMP, as the name suggests dumps efi page tables to dmesg during
> kernel boot. This feature is very useful while debugging page
> faults/null pointer dereferences to efi related addresses. Presently,
> this feature is limited only to x86_64, so let's extend it to other efi
> configurations like kexec kernel, efi=old_map and to x86_32 as well.
> This doesn't effect normal boot path because this config option should
> be used only for debug purposes.
> 
> Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Ricardo Neri <ricardo.neri@intel.com>
> Cc: Matt Fleming <matt@codeblueprint.co.uk>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Ravi Shankar <ravi.v.shankar@intel.com>
> 
> Changes since v1:
> 1. Call efi_dump_pagetable() only once from efi_enter_virtual_mode() -
> as suggested by Boris
> 
> ---
>  arch/x86/platform/efi/efi.c    | 3 ++-
>  arch/x86/platform/efi/efi_32.c | 9 ++++++++-
>  arch/x86/platform/efi/efi_64.c | 5 ++++-
>  3 files changed, 14 insertions(+), 3 deletions(-)

Thanks Sai, applied.
