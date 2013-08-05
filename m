From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH v2 3/5] efi: x86: use common code for (U)EFI
 configuration scanning
Date: Mon, 5 Aug 2013 13:18:08 +0100
Message-ID: <20130805121808.GQ2515@console-pimps.org>
References: <1375462582-16423-1-git-send-email-leif.lindholm@linaro.org>
 <1375462582-16423-4-git-send-email-leif.lindholm@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ia64-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1375462582-16423-4-git-send-email-leif.lindholm@linaro.org>
Sender: linux-ia64-owner@vger.kernel.org
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org, matt.fleming@intel.com, tony.luck@gmail.com, patches@linaro.org
List-Id: linux-efi@vger.kernel.org

On Fri, 02 Aug, at 05:56:20PM, Leif Lindholm wrote:
> This patch makes x86 use the new common code for configuration table
> scanning. It also removes the local definition of the global "efi"
> data structure.
> 
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> ---
>  arch/x86/platform/efi/efi.c |   96 ++++---------------------------------------
>  1 file changed, 8 insertions(+), 88 deletions(-)

Looks good to me.

-- 
Matt Fleming, Intel Open Source Technology Center
