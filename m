From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v3 4/7] x86, kaslr: Access the correct kaslr_enabled variable
Date: Mon, 9 Mar 2015 17:55:35 -0700
Message-ID: <CAGXu5jJna+ZcRpHvqmH=hzFVN+MwbvNUfYvTaiAzZD4NvH570Q@mail.gmail.com>
References: <1425766041-6551-1-git-send-email-yinghai@kernel.org>
	<1425766041-6551-5-git-send-email-yinghai@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1425766041-6551-5-git-send-email-yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, Mar 7, 2015 at 2:07 PM, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Commit
>
>   f47233c2d34f ("x86/mm/ASLR: Propagate base load address calculation")
>
> started passing KASLR status to kernel proper, but it uses a physical
> address as the vaule, leading to parsing bogus KASLR status in kernel
> proper.
>
> The setup_data linked list and thus the element which contains
> kaslr_enabled is chained together using physical addresses. At the time
> when we access it in the kernel proper, we're already running with
> paging enabled and therefore must access it through its virtual address.
>
> This patch changes the code to use early_memmap() and access the value.
>
> -v3: add checking return from early_memmap according to Boris.
> -v4: add description about setup_data accessing from Boris to change log.

Nit for next version: revision change notes usually go below the "---"
in a separate section, and end with "---", above the "files changed"
report, and below the main changelog.

-Kees

>
> Fixes: f47233c2d34f ("x86/mm/ASLR: Propagate base load address calculation")
> Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> Cc: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
> Acked-by: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
> Signed-off-by: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  arch/x86/kernel/setup.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 98dc931..912f124 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -429,7 +429,18 @@ static void __init reserve_initrd(void)
>
>  static void __init parse_kaslr_setup(u64 pa_data, u32 data_len)
>  {
> -       kaslr_enabled = (bool)(pa_data + sizeof(struct setup_data));
> +       /* kaslr_setup_data is defined in aslr.c */
> +       unsigned char *data;
> +       unsigned long offset = sizeof(struct setup_data);
> +
> +       data = early_memremap(pa_data, offset + 1);
> +       if (!data) {
> +               kaslr_enabled = true;
> +               return;
> +       }
> +
> +       kaslr_enabled = *(data + offset);
> +       early_memunmap(data, offset + 1);
>  }
>
>  static void __init parse_setup_data(void)
> --
> 1.8.4.5
>



-- 
Kees Cook
Chrome OS Security
