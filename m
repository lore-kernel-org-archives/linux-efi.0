From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi: don't issue error message when booted under xen
Date: Mon, 15 May 2017 13:52:58 +0100
Message-ID: <20170515125258.GA2935@codeblueprint.co.uk>
References: <20170508125633.1762-1-jgross@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170508125633.1762-1-jgross-IBi9RG/b67k@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 08 May, at 02:56:33PM, Juergen Gross wrote:
> When booted as Xen dom0 there won't be an EFI memmap allocated. Avoid
> issuing an error message in this case:
> 
> [    0.144079] efi: Failed to allocate new EFI memmap
> 
> Signed-off-by: Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>
> ---
>  arch/x86/platform/efi/quirks.c | 3 +++
>  1 file changed, 3 insertions(+)

Thanks. I've applied this for the urgent branch because it's trivial
and we've had issues before where these kinds of error messages mess
up an otherwise clean boot screen.
