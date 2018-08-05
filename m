From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 2/6] efi: the function transfers status to string
Date: Sun, 5 Aug 2018 10:17:36 +0200
Message-ID: <CAKv+Gu9tE2KZNXTqtOi9qg3a861NQc-rQYxUQbioj04DzAkXbQ@mail.gmail.com>
References: <20180805032119.20485-1-jlee@suse.com> <20180805032119.20485-3-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180805032119.20485-3-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, keyrings@vger.kernel.org, linux-integrity <linux-integrity@vger.kernel.org>, "Lee, Chun-Yi" <jlee@suse.com>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Pavel Machek <pavel@ucw.cz>, Chen Yu <yu.c.chen@intel.com>, Oliver Neukum <oneukum@suse.com>, Ryan Chen <yu.chen.surf@gmail.com>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>
List-Id: linux-efi@vger.kernel.org

On 5 August 2018 at 05:21, Lee, Chun-Yi <joeyli.kernel@gmail.com> wrote:
> This function can be used to transfer EFI status code to string
> for printing out debug message.
>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Chen Yu <yu.c.chen@intel.com>
> Cc: Oliver Neukum <oneukum@suse.com>
> Cc: Ryan Chen <yu.chen.surf@gmail.com>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
> Signed-off-by: "Lee, Chun-Yi" <jlee@suse.com>

Very useful.

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  include/linux/efi.h | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 56add823f190..744cf92fe18e 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -1651,4 +1651,30 @@ struct linux_efi_tpm_eventlog {
>
>  extern int efi_tpm_eventlog_init(void);
>
> +#define EFI_STATUS_STR(_status) \
> +case EFI_##_status: \
> +       return "EFI_" __stringify(_status);
> +
> +static inline char *
> +efi_status_to_str(efi_status_t status)
> +{
> +       switch (status) {
> +       EFI_STATUS_STR(SUCCESS)
> +       EFI_STATUS_STR(LOAD_ERROR)
> +       EFI_STATUS_STR(INVALID_PARAMETER)
> +       EFI_STATUS_STR(UNSUPPORTED)
> +       EFI_STATUS_STR(BAD_BUFFER_SIZE)
> +       EFI_STATUS_STR(BUFFER_TOO_SMALL)
> +       EFI_STATUS_STR(NOT_READY)
> +       EFI_STATUS_STR(DEVICE_ERROR)
> +       EFI_STATUS_STR(WRITE_PROTECTED)
> +       EFI_STATUS_STR(OUT_OF_RESOURCES)
> +       EFI_STATUS_STR(NOT_FOUND)
> +       EFI_STATUS_STR(ABORTED)
> +       EFI_STATUS_STR(SECURITY_VIOLATION)
> +       }
> +
> +       return "";
> +}
> +
>  #endif /* _LINUX_EFI_H */
> --
> 2.13.6
>
