From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH 08/18] Generalize relocate_kernel() for use by other
 architectures.
Date: Wed, 25 Sep 2013 13:01:24 +0100
Message-ID: <20130925120124.GF21381@console-pimps.org>
References: <1379889942-3135-1-git-send-email-roy.franz@linaro.org>
 <1379889942-3135-9-git-send-email-roy.franz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1379889942-3135-9-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, matt.fleming@intel.com, leif.lindholm@linaro.org, grant.likely@linaro.org, msalter@redhat.com
List-Id: linux-efi@vger.kernel.org

On Sun, 22 Sep, at 03:45:32PM, Roy Franz wrote:
> Rename relocate_kernel() to efi_relocate_kernel(), and take
> parameters rather than x86 specific structure.  Add max_addr
> argument as for ARM we have some address constraints that we
> need to enforce when relocating the kernel.  Add alloc_size
> parameter for use by ARM64 which uses an uncompressed kernel,
> and needs to allocate space for BSS.
> 
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> ---
>  arch/x86/boot/compressed/eboot.c       |   10 ++++-
>  drivers/firmware/efi/efi-stub-helper.c |   72 ++++++++++++++++++++++----------
>  2 files changed, 59 insertions(+), 23 deletions(-)

[...]

I fixed up these multi-line comments too.

-- 
Matt Fleming, Intel Open Source Technology Center
