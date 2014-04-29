From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH v2 10/10] efi/arm64: ignore dtb= when UEFI SecureBoot is
 enabled
Date: Tue, 29 Apr 2014 12:28:49 +0100
Message-ID: <20140429112849.GJ26088@console-pimps.org>
References: <1398442154-19974-1-git-send-email-leif.lindholm@linaro.org>
 <1398442154-19974-11-git-send-email-leif.lindholm@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1398442154-19974-11-git-send-email-leif.lindholm@linaro.org>
Sender: linux-doc-owner@vger.kernel.org
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com, catalin.marinas@arm.com, msalter@redhat.com, grant.likely@linaro.org, roy.franz@linaro.org, ard.biesheuvel@linaro.org, mark.rutland@arm.com, linux-doc@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Fri, 25 Apr, at 05:09:14PM, Leif Lindholm wrote:
> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> Loading unauthenticated FDT blobs directly from storage is a security hazard,
> so this should only be allowed when running with UEFI Secure Boot disabled.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> ---
>  drivers/firmware/efi/arm-stub.c |   39 +++++++++++++++++++++++++++++++++++----
>  1 file changed, 35 insertions(+), 4 deletions(-)

Acked-by: Matt Fleming <matt.fleming@intel.com>

-- 
Matt Fleming, Intel Open Source Technology Center
