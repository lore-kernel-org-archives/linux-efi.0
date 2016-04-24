From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi/arm-init: reserve rather than unmap the memory map
 for ARM as well
Date: Sun, 24 Apr 2016 20:57:44 +0100
Message-ID: <20160424195744.GL2829@codeblueprint.co.uk>
References: <1461165635-8041-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1461165635-8041-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 20 Apr, at 05:20:35PM, Ard Biesheuvel wrote:
> Now that ARM has a fully functional memremap() implementation, there is
> no longer a need to remove the UEFI memory map from the linear mapping
> in order to be able to create a permanent mapping for it using generic
> code.
> 
> So remove the 'IS_ENABLED(CONFIG_ARM)' conditional we added in commit
> 7cc8cbcf82d1 ("efi/arm64: Don't apply MEMBLOCK_NOMAP to UEFI memory map
> mapping"), and revert to using memblock_reserve() for both ARM and arm64
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
> 
> This is the permanent fix I alluded to in the commit log for the patch
> mentioned above. Russell has pulled the memremap() patches so this is
> good to go for v4.7
> 
> Note that current efi-next already has a conflict with v4.6-rc4 (where
> that patch landed) which will get even worse with this on top, so it may
> make sense to rebase efi-next onto v4.6-rc4 before pulling this
> (but note that this patch depends on 'efi/arm*: Use memremap() to create
> the persistent memmap mapping', so please don't reorder them to maintain
> bisectability)

Good notes, thanks Ard.

I applied this for v4.7 but please check the result since there was a
conflict with the GOP framebuffer patches,

  https://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/commit/?h=next&id=b2757153ee7cfce23f760036b0c85bd0ec99cf50
