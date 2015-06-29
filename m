From: Tom Yan <tom.ty89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] x86/efi-bgrt: Switch pr_err() to pr_debug() for invalid BGRT
Date: Tue, 30 Jun 2015 05:52:43 +0800
Message-ID: <CAGnHSEnO9BiCTgSOCJnJiwycpSMKtQzeYb1+S-2Cq7U_Xy+H1w@mail.gmail.com>
References: <1435579602-6612-1-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1435579602-6612-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Matt!

The patch works for me against linux 4.0.6. I no longer see the
message in dmesg with the BIOS option set to "Auto". I assume this is
expected? It will only be displayed if I build it with a debug flag,
right?
https://www.kernel.org/doc/local/pr_debug.txt

On 29 June 2015 at 20:06, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> It's totally legitimate, per the ACPI spec, for the firmware to set the
> BGRT 'status' field to zero to indicate that the BGRT image isn't being
> displayed, and we shouldn't be printing an error message in that case
> because it's just noise for users. So swap pr_err() for pr_debug().
>
> However, Josh points that out it still makes sense to test the validity
> of the upper 7 bits of the 'status' field, since they're marked as
> "reserved" in the spec and must be zero. If firmware violates this it
> really *is* an error.
>
> Reported-by: Tom Yan <tom.ty89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
> Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
> Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>
> Tom, if you could test out this patch that would be really helpful. I'll
> take this one through the EFI git repo.
>
>  arch/x86/platform/efi/efi-bgrt.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/efi-bgrt.c
> index d7f997f7c26d..ea48449b2e63 100644
> --- a/arch/x86/platform/efi/efi-bgrt.c
> +++ b/arch/x86/platform/efi/efi-bgrt.c
> @@ -50,11 +50,16 @@ void __init efi_bgrt_init(void)
>                        bgrt_tab->version);
>                 return;
>         }
> -       if (bgrt_tab->status != 1) {
> -               pr_err("Ignoring BGRT: invalid status %u (expected 1)\n",
> +       if (bgrt_tab->status & 0xfe) {
> +               pr_err("Ignoring BGRT: reserved status bits are non-zero %u\n",
>                        bgrt_tab->status);
>                 return;
>         }
> +       if (bgrt_tab->status != 1) {
> +               pr_debug("Ignoring BGRT: invalid status %u (expected 1)\n",
> +                        bgrt_tab->status);
> +               return;
> +       }
>         if (bgrt_tab->image_type != 0) {
>                 pr_err("Ignoring BGRT: invalid image type %u (expected 0)\n",
>                        bgrt_tab->image_type);
> --
> 2.1.0
>
