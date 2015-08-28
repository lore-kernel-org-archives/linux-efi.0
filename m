From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 2/3] arm64: use core efi=debug instead of uefi_debug
 command line parameter
Date: Fri, 28 Aug 2015 14:32:04 +0100
Message-ID: <20150828133204.GG2759@codeblueprint.co.uk>
References: <1440595498-30630-1-git-send-email-leif.lindholm@linaro.org>
 <1440595498-30630-3-git-send-email-leif.lindholm@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1440595498-30630-3-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, matt.fleming@intel.com, ard.biesheuvel@linaro.org, msalter@redhat.com
List-Id: linux-efi@vger.kernel.org

On Wed, 26 Aug, at 02:24:57PM, Leif Lindholm wrote:
> Now that we have an efi=debug command line option in the core code, use
> this instead of the arm64-specific uefi_debug option.
> 
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> ---
>  Documentation/arm/uefi.txt |  2 --
>  arch/arm64/kernel/efi.c    | 19 +++++--------------
>  2 files changed, 5 insertions(+), 16 deletions(-)

Thanks Leif, applied.

-- 
Matt Fleming, Intel Open Source Technology Center
