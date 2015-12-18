From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v3 3/7] efi: runtime-wrappers: add a nonblocking version
 of QueryVariableInfo
Date: Fri, 18 Dec 2015 13:08:29 +0000
Message-ID: <20151218130829.GB2638@codeblueprint.co.uk>
References: <1450089631-26791-1-git-send-email-ard.biesheuvel@linaro.org>
 <1450089631-26791-4-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1450089631-26791-4-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ard <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 14 Dec, at 11:40:27AM, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> 
> This introduces a new runtime wrapper for the QueryVariableInfo() UEFI
> Runtime Service, which gives up immediately rather than spins on failure
> to grab the efi_runtime spinlock.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/runtime-wrappers.c | 22 ++++++++++++++++++++
>  include/linux/efi.h                     |  1 +
>  2 files changed, 23 insertions(+)

Thanks Ard, applied with this additional piece in the commit log, 

  This is required in the non-blocking path of the efi-pstore code.

so that we don't have to wonder in 6 months why we introduced this
wrapper.
