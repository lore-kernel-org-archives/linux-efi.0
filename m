From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH RESEND] efi_stub: update documentation on dtb= parameter
Date: Sun, 9 Sep 2018 14:47:11 -0600
Message-ID: <20180909144711.12261570@lwn.net>
References: <20180906182927.22318-1-grant.likely@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180906182927.22318-1-grant.likely@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Grant Likely <grant.likely@arm.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, olof@lixom.net, scott.branden@broadcom.com, catalin.marinas@arm.com, will.deacon@arm.com, arnd@arndb.de, leif.lindholm@linaro.org, agraf@suse.de, nd@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Thu,  6 Sep 2018 19:29:27 +0100
Grant Likely <grant.likely@arm.com> wrote:

> The dtb= parameter is no longer the primary mechanism for providing a
> devicetree to the kernel. Now either firmware or the boot selector (ex.
> Grub) should provide the devicetree and dtb= should only be used for
> debug or when using firmware that doesn't understand DT.
> Update the EFI stub documentation to reflect the current usage.
> 
> Signed-off-by: Grant Likely <grant.likely@arm.com>
> Reviewed-by: Alexander Graf <agraf@suse.de>
> Acked-by: Leif Lindholm <leif.lindholm@linaro.org>
> Acked-by: Olof Johansson <olof@lixom.net>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Applied, thanks.

jon
