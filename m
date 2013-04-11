From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH V4 2/3] Revert "x86, efivars: firmware bug workarounds
 should be in platform code"
Date: Thu, 11 Apr 2013 14:24:11 +0100
Message-ID: <5166B97B.6080806@console-pimps.org>
References: <1365561717-12343-1-git-send-email-matthew.garrett@nebula.com> <1365615967-27346-1-git-send-email-matthew.garrett@nebula.com> <1365615967-27346-2-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1365615967-27346-2-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 10/04/13 18:46, Matthew Garrett wrote:
> This reverts commit a6e4d5a03e9e3587e88aba687d8f225f4f04c792. Doing this
> workaround properly requires us to work within the variable code.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi.c | 25 -------------------------
>  drivers/firmware/efivars.c  | 18 +++++++++++++++---
>  include/linux/efi.h         |  9 +--------
>  3 files changed, 16 insertions(+), 36 deletions(-)

Does it really? Why can't you just hook into the get_next_variable() and
set_variable() functions in arch/x86/platform/efi/efi.c?

-- 
Matt Fleming, Intel Open Source Technology Center
