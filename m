From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 3/3] efi/arm64: clean up efi_get_fdt_params() interface
Date: Fri, 28 Aug 2015 14:32:18 +0100
Message-ID: <20150828133218.GH2759@codeblueprint.co.uk>
References: <1440595498-30630-1-git-send-email-leif.lindholm@linaro.org>
 <1440595498-30630-4-git-send-email-leif.lindholm@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1440595498-30630-4-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, matt.fleming@intel.com, ard.biesheuvel@linaro.org, msalter@redhat.com
List-Id: linux-efi@vger.kernel.org

On Wed, 26 Aug, at 02:24:58PM, Leif Lindholm wrote:
> As we now have a common debug infrastructure between core and arm64 efi,
> drop the bit of the interface passing verbose output flags around.
> 
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> ---
>  arch/arm64/kernel/efi.c    | 2 +-
>  drivers/firmware/efi/efi.c | 6 ++----
>  include/linux/efi.h        | 2 +-
>  3 files changed, 4 insertions(+), 6 deletions(-)

Thanks, applied.

-- 
Matt Fleming, Intel Open Source Technology Center
