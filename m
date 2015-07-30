From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v3] x86_64/efi: Use all 64 bit of efi_memmap in
 setup_e820()
Date: Thu, 30 Jul 2015 11:13:08 +0100
Message-ID: <20150730101308.GC2725@codeblueprint.co.uk>
References: <1438094312-12833-1-git-send-email-sdmitry@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1438094312-12833-1-git-send-email-sdmitry-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dmitry Skorodumov <sdmitry-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Denis V. Lunev" <den-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 28 Jul, at 06:38:32PM, Dmitry Skorodumov wrote:
> The efi_info structure stores low 32 bits of memory map
> in efi_memmap and high 32 bits in efi_memmap_hi.
> 
> While constructing pointer in the setup_e820(), need
> to take into account all 64 bit of the pointer.
> 
> It is because on 64bit machine the function
> efi_get_memory_map() may return full 64bit pointer and before
> the patch that pointer was truncated.
> 
> Signed-off-by: Dmitry Skorodumov <sdmitry-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> CC: Denis V. Lunev <den-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> 
> The issue is triggered on Parallles virtual machine and
> fixed with this patch
> ---
>  arch/x86/boot/compressed/eboot.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)

Applied to the EFI urgent queue, thanks!

-- 
Matt Fleming, Intel Open Source Technology Center
