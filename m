From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] efi_stub: update documentation on dtb= parameter
Date: Thu, 6 Sep 2018 09:51:11 -0600
Message-ID: <20180906095111.1a74dfcd@lwn.net>
References: <20180905190750.4566-1-grant.likely@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180905190750.4566-1-grant.likely@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Grant Likely <grant.likely@arm.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, olof@lixom.net, scott.branden@broadcom.com, catalin.marinas@arm.com, will.deacon@arm.com, arnd@arndb.de, leif.lindholm@linaro.org, agraf@suse.de, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Wed,  5 Sep 2018 20:07:50 +0100
Grant Likely <grant.likely@arm.com> wrote:

> The dtb= parameter is no longer the primary mechanism for providing a
> devicetree to the kernel. Now either firmware or the boot selector (ex.
> Grub) should provide the devicetree and dtb= should only be used for
> debug or when using firmware that doesn't understand DT.
> Update the EFI stub documentation to reflect the current usage.

So I hate to be obnoxious, but...

> IMPORTANT NOTICE: The contents of this email and any attachments are
> confidential and may also be privileged. If you are not the intended
> recipient, please notify the sender immediately and do not disclose the
> contents to any other person, use it for any purpose, or store or copy
> the information in any medium. Thank you.

Can I get a version of the patch without this language?  Then I'll be glad
to apply it.

Thanks,

jon
