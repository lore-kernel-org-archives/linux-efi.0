From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] x86/efi: remove unused variable efi
Date: Wed, 8 Jun 2016 13:41:10 +0100
Message-ID: <20160608124110.GX2658@codeblueprint.co.uk>
References: <1465223531-15661-1-git-send-email-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1465223531-15661-1-git-send-email-colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: "H . Peter Anvi" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 06 Jun, at 03:32:11PM, Colin Ian King wrote:
> From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> 
> Remove unused variable efi, it is never used. Fixes clang build
> warning:
> 
> arch/x86/boot/compressed/eboot.c:803:2: warning: Value stored to
>   'efi' is never read
> 
> Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> ---
>  arch/x86/boot/compressed/eboot.c | 2 --
>  1 file changed, 2 deletions(-)

Thanks Colin, applied to 'next'.
