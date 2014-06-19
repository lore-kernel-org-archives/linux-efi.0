From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH] efi: fix build warning about of_get_flat_dt_prop
Date: Thu, 19 Jun 2014 15:06:59 +0100
Message-ID: <20140619140659.GS24049@console-pimps.org>
References: <1403180552-9272-1-git-send-email-wangkefeng.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1403180552-9272-1-git-send-email-wangkefeng.wang@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matt Fleming <matt.fleming@intel.com>, Leif Lindholm <leif.lindholm@linaro.org>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 19 Jun, at 08:22:32PM, Kefeng Wang wrote:
> commit 9d0c4dfed(of/fdt: update of_get_flat_dt_prop in prep for libfdt)
> change the of_get_flat_dt_prop, so update related variable to fix build
> warning. Btw, remove unused variable 'name'.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  drivers/firmware/efi/efi.c |    5 ++---
>  drivers/firmware/efi/fdt.c |    2 +-
>  2 files changed, 3 insertions(+), 4 deletions(-)

Thanks for this, but I've already queued up a fix from Catalin that
addresses these issues,

  http://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/commit/?h=urgent

I've been pretty slack in getting this fix sent upstream, but I'll do
that asap.

-- 
Matt Fleming, Intel Open Source Technology Center
