From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 1/3] efi/x86: move efi=debug option parsing to core
Date: Wed, 26 Aug 2015 18:25:41 +0100
Message-ID: <20150826172541.GC2837@codeblueprint.co.uk>
References: <1440595498-30630-1-git-send-email-leif.lindholm@linaro.org>
 <1440595498-30630-2-git-send-email-leif.lindholm@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1440595498-30630-2-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, matt.fleming@intel.com, ard.biesheuvel@linaro.org, msalter@redhat.com
List-Id: linux-efi@vger.kernel.org

On Wed, 26 Aug, at 02:24:56PM, Leif Lindholm wrote:
> fed6cefe3b6e ("x86/efi: Add a "debug" option to the efi= cmdline")
> adds the DBG flag, but does so for x86 only. Move this early param
> parsing to core code.
> 
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> ---
>  arch/x86/platform/efi/efi.c | 2 --
>  drivers/firmware/efi/efi.c  | 3 +++
>  2 files changed, 3 insertions(+), 2 deletions(-)

Nice clean up. Thanks Leif, applied.

-- 
Matt Fleming, Intel Open Source Technology Center
