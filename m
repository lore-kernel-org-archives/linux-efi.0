From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 1/4] efi: Make EFI_MEMORY_ATTRIBUTES_TABLE initialization
 common across all architectures
Date: Wed, 7 Dec 2016 13:28:24 +0000
Message-ID: <20161207132824.GA17720@codeblueprint.co.uk>
References: <1481051763-8705-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1481051763-8705-2-git-send-email-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1481051763-8705-2-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, jlee@suse.com, bp@alien8.de, ricardo.neri@intel.com, ard.biesheuvel@linaro.org, ravi.v.shankar@intel.com, fenghua.yu@intel.com
List-Id: linux-efi@vger.kernel.org

On Tue, 06 Dec, at 11:16:00AM, Sai Praneeth Prakhya wrote:
> From: Sai Praneeth <sai.praneeth.prakhya@intel.com>
> 
> Since EFI_PROPERTIES_TABLE and EFI_MEMORY_ATTRIBUTES_TABLE deal with
> updating memory region attributes, it makes sense to call
> EFI_MEMORY_ATTRIBUTES_TABLE initialization function from the same place
> as EFI_PROPERTIES_TABLE. This also moves the EFI_MEMORY_ATTRIBUTES_TABLE
> initialization code to a more generic efi initialization path rather
> than ARM specific efi initialization. This is important because
> EFI_MEMORY_ATTRIBUTES_TABLE will be supported by x86 as well.
> 
> Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
> Cc: Lee, Chun-Yi <jlee@suse.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Ricardo Neri <ricardo.neri@intel.com>
> Cc: Matt Fleming <matt@codeblueprint.co.uk>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Ravi Shankar <ravi.v.shankar@intel.com>
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  drivers/firmware/efi/arm-init.c | 1 -
>  drivers/firmware/efi/efi.c      | 2 ++
>  2 files changed, 2 insertions(+), 1 deletion(-)

You should have applied Joey's Reviewed-by tag when sending out this
version so that it doesn't get lost.

It's not a big deal, just something to watch out for with future
submissions.
