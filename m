From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Store upper bits of command line buffer address
 in ext_cmd_line_ptr
Date: Fri, 17 Apr 2015 15:40:47 +0100
Message-ID: <20150417144047.GC3671@codeblueprint.co.uk>
References: <1429140744-25768-1-git-send-email-roy.franz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1429140744-25768-1-git-send-email-roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 15 Apr, at 04:32:24PM, Roy Franz wrote:
> Until now, the EFI stub was only setting the 32 bit cmd_line_ptr in
> the setup_header structure, so on 64 bit platforms this could be truncated.
> This patch adds setting the upper bits of the buffer address in
> ext_cmd_line_ptr.  This case was likely never hit, as the allocation
> for this buffer is done at the lowest available address.  Only
> x86_64 kernels have this problem, as the 1-1 mapping mandated
> by EFI ensures that all memory is 32 bit addressable on 32 bit
> platforms.  The EFI stub does not support mixed mode, so the
> 32 bit kernel on 64 bit firmware case does not need to be handled.
> 
> Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
> This is a follow-up to "x86_64/efi: enforce 32 bit address for command line buffer",
> which had the wrong fix to the truncation of address.
> 
>  arch/x86/boot/compressed/eboot.c | 2 ++
>  1 file changed, 2 insertions(+)
 
Looks good to me Roy, thanks applied!

-- 
Matt Fleming, Intel Open Source Technology Center
