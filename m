From: Daniel Vacek <neelx.g-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] efi: Build EFI stub with EFI-appropriate options
Date: Thu, 18 Oct 2012 20:18:51 +0200
Message-ID: <CAA7rmPGL827cgT6hM8h_xhokEbTbTnrptoRekVByM7AcMdRUdw@mail.gmail.com>
References: <1343340000-7587-1-git-send-email-mjg@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343340000-7587-1-git-send-email-mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, Jul 27, 2012 at 12:00 AM, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> We can't assume the presence of the red zone while we're still in a boot
> services environment, so we should build with -fno-red-zone to avoid
> problems. Change the size of wchar at the same time to make string handling
> simpler.
>
> Signed-off-by: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/boot/compressed/Makefile |    3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
> index e398bb5..8a84501 100644
> --- a/arch/x86/boot/compressed/Makefile
> +++ b/arch/x86/boot/compressed/Makefile
> @@ -28,6 +28,9 @@ VMLINUX_OBJS = $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
>         $(obj)/string.o $(obj)/cmdline.o $(obj)/early_serial_console.o \
>         $(obj)/piggy.o
>
> +$(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone
> +$(obj)/efi_stub_$(BITS).o: KBUILD_CLFAGS += -fshort-wchar -mno-red-zone
> +
>  ifeq ($(CONFIG_EFI_STUB), y)
>         VMLINUX_OBJS += $(obj)/eboot.o $(obj)/efi_stub_$(BITS).o
>  endif

s/CLFAGS/CFLAGS/

should go to stable too?

--nX
--
To unsubscribe from this list: send the line "unsubscribe linux-efi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
