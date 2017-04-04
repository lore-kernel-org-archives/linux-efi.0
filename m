From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi/libstub: skip GOP with PIXEL_BLT_ONLY format
Date: Tue, 4 Apr 2017 14:18:32 +0100
Message-ID: <CAKv+Gu_0rxQX07WW9WEorz97qbC8027mBYJ+wXV1U6iB30i9Cg@mail.gmail.com>
References: <1489650662-3598-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489650662-3598-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "Cohen, Eugene" <eugene-VXdhtT5mjnY@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 16 March 2017 at 07:51, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> From: "Cohen, Eugene" <eugene-VXdhtT5mjnY@public.gmane.org>
>
> The UEFI Specification permits Graphics Output Protocol (GOP) instances
> without direct framebuffer access. This is indicated in the Mode structure
> with a PixelFormat enumeration value of PIXEL_BLT_ONLY. Given that the
> kernel does not know how to drive a Blt() only framebuffer (which is only
> permitted before ExitBootServices() anyway), we should disregard such
> framebuffers when looking for a GOP instance that is suitable for use as
> the boot console.
>
> So modify the EFI GOP initialization to not use a PIXEL_BLT_ONLY instance,
> preventing attempts later in boot to use an invalid screen_info.lfb_base
> address.
>
> Signed-off-by: Eugene Cohen <eugene-VXdhtT5mjnY@public.gmane.org>
> [ardb: clarify that Blt() only GOPs are unusable by the kernel]
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/libstub/gop.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/drivers/firmware/efi/libstub/gop.c b/drivers/firmware/efi/libstub/gop.c
> index 932742e4cf23..b05b282b470d 100644
> --- a/drivers/firmware/efi/libstub/gop.c
> +++ b/drivers/firmware/efi/libstub/gop.c
> @@ -178,6 +178,10 @@ setup_gop32(efi_system_table_t *sys_table_arg, struct screen_info *si,
>         if (!first_gop)
>                 goto out;
>
> +       /* Does the GOP implement a BLT-only framebuffer? */
> +       if (pixel_format == PIXEL_BLT_ONLY)
> +               goto out;
> +
>         /* EFI framebuffer */
>         si->orig_video_isVGA = VIDEO_TYPE_EFI;
>
> @@ -295,6 +299,10 @@ setup_gop64(efi_system_table_t *sys_table_arg, struct screen_info *si,
>         if (!first_gop)
>                 goto out;
>
> +       /* Does the GOP implement a BLT-only framebuffer? */
> +       if (pixel_format == PIXEL_BLT_ONLY)
> +               goto out;
> +
>         /* EFI framebuffer */
>         si->orig_video_isVGA = VIDEO_TYPE_EFI;
>

As it turns out, the patch in its current form triggers a GCC
diagnostic regarding potential uninitialized use of the variables
pixel_format, fb_base, height, width, etc. While the diagnostic
appears to be inaccurate, introducing compiler warnings is frowned
upon and as it turns out, it may actually be more appropriate to move
the BLT-only check into the loop that iterates over the GOP handles,
since that way, there may still be other GOP candidates if we
disregard the ones that are BLT-only.

So the version that is going upstream will be updated in this regard.
