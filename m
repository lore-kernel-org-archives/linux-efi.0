From: Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] efi_stub: update documentation on dtb= parameter
Date: Wed, 5 Sep 2018 14:57:46 -0700
Message-ID: <CAOesGMjzEKsa1rx-kHemcSyT2PudLeCd7OrogrVdn99efTXg8g@mail.gmail.com>
References: <20180905190750.4566-1-grant.likely@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180905190750.4566-1-grant.likely@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Grant Likely <grant.likely@arm.com>
Cc: linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux ARM Mailing List <linux-arm-kernel@lists.infradead.org>, Scott Branden <scott.branden@broadcom.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Leif Lindholm <leif.lindholm@linaro.org>, Alexander Graf <agraf@suse.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-efi@vger.kernel.org

On Wed, Sep 5, 2018 at 12:07 PM, Grant Likely <grant.likely@arm.com> wrote:
> The dtb= parameter is no longer the primary mechanism for providing a
> devicetree to the kernel. Now either firmware or the boot selector (ex.
> Grub) should provide the devicetree and dtb= should only be used for
> debug or when using firmware that doesn't understand DT.
> Update the EFI stub documentation to reflect the current usage.
>
> Signed-off-by: Grant Likely <grant.likely@arm.com>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Jonathan Corbet <corbet@lwn.net>

Acked-by: Olof Johansson <olof@lixom.net>


-Olof
