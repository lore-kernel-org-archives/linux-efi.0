From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi: make EFI a menuconfig to ease disabling it all
Date: Fri, 15 Dec 2017 15:19:10 +0000
Message-ID: <20171215151910.GC3204@codeblueprint.co.uk>
References: <20171209155252.6403-1-vincent.legoll@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171209155252.6403-1-vincent.legoll-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vincent Legoll <vincent.legoll-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sat, 09 Dec, at 04:52:52PM, Vincent Legoll wrote:
> No need to get into the submenu to disable all related
> config entries.
> 
> This makes it easier to disable all EFI config options
> without entering the submenu. It will also enable one
> to see that en/dis-abled state from the outside menu.
> 
> This is only intended to change menuconfig UI, not change
> the config dependencies.
> 
> Signed-off-by: Vincent Legoll <vincent.legoll-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/firmware/efi/Kconfig | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)

This looks fine to me. Ard?
