From: Dave Young <hidave.darkstar@gmail.com>
Subject: Re: [PATCH 10/15] acpi: Ignore acpi_rsdp kernel parameter in a secure
 boot environment
Date: Sun, 17 Feb 2013 17:00:23 +0800
Message-ID: <CABqxG0cJGp7UEREvMW49QA0BfDXPsyEbAuMMLZwcHPdUAKT+Dw@mail.gmail.com>
References: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
	<1359391359-25783-11-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1359391359-25783-11-git-send-email-matthew.garrett@nebula.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org, Josh Boyer <jwboyer@redhat.com>, lxiang@redhat.com, Vivek Goyal <vgoyal@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Tue, Jan 29, 2013 at 12:42 AM, Matthew Garrett
<matthew.garrett@nebula.com> wrote:
> From: Josh Boyer <jwboyer@redhat.com>
>
> This option allows userspace to pass the RSDP address to the kernel.  This
> could potentially be used to circumvent the secure boot trust model.
> We ignore the setting if we don't have the CAP_COMPROMISE_KERNEL capability.
>
> Signed-off-by: Josh Boyer <jwboyer@redhat.com>
> ---
>  drivers/acpi/osl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index bd22f86..88251d2 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -246,7 +246,7 @@ early_param("acpi_rsdp", setup_acpi_rsdp);
>  acpi_physical_address __init acpi_os_get_root_pointer(void)
>  {
>  #ifdef CONFIG_KEXEC
> -       if (acpi_rsdp)
> +       if (acpi_rsdp && capable(CAP_COMPROMISE_KERNEL))


This caused an issue in a kdump test even without secure boot enabled.
Looks like security subsystem init is not initialized yet at this
point.

See redhat bug 906225:
https://bugzilla.redhat.com/show_bug.cgi?id=906225


>                 return acpi_rsdp;
>  #endif
>
> --
> 1.8.0.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Regards
Dave
