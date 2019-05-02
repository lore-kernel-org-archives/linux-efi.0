From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 1/2 v2] efi: add a function to convert the status value to string
Date: Thu, 2 May 2019 10:53:31 +0200
Message-ID: <CAKv+Gu9mjtNEWN-w4ix7VJMZ_kk-Qf6FfYFRu2mCosaAjMA4Vg@mail.gmail.com>
References: <20190502040441.30372-1-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190502040441.30372-1-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: James Morris <jmorris@namei.org>, "Serge E . Hallyn" <serge@hallyn.com>, David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@fedoraproject.org>, Nayna Jain <nayna@linux.ibm.com>, Mimi Zohar <zohar@linux.ibm.com>, linux-efi <linux-efi@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Lee, Chun-Yi" <jlee@suse.com>, Kees Cook <keescook@chromium.org>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>
List-Id: linux-efi@vger.kernel.org

On Thu, 2 May 2019 at 06:04, Lee, Chun-Yi <joeyli.kernel@gmail.com> wrote:
>
> This function can be used to convert EFI status value to string
> for printing out debug message. Using this function can improve
> the readability of log.
>
> v2.

Please move the changelog out of the commit log (move it below the ---
further down)

> - Changed the wording in subject and description.
> - Moved the marco immediately after the status value definitions.
> - Turned into a proper function instead of inline.
>

You missed my point here. A proper function means the function in a .c
file, and only the declaration in a .h file. This way, you are still
duplicating the literal strings into every object file that references
this function.

> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Anton Vorontsov <anton@enomsg.org>
> Cc: Colin Cross <ccross@android.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Signed-off-by: "Lee, Chun-Yi" <jlee@suse.com>
> ---
>  include/linux/efi.h | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
>
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 54357a258b35..6f3f89a32eef 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -42,6 +42,34 @@
>  #define EFI_ABORTED            (21 | (1UL << (BITS_PER_LONG-1)))
>  #define EFI_SECURITY_VIOLATION (26 | (1UL << (BITS_PER_LONG-1)))
>
> +#define EFI_STATUS_STR(_status) \
> +case EFI_##_status: \
> +       return "EFI_" __stringify(_status);
> +
> +static __attribute__((unused)) char *
> +efi_status_to_str(unsigned long status)
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
> +       default:
> +               pr_warn("Unknown efi status: 0x%lx", status);
> +       }
> +
> +       return "Unknown efi status";
> +}
> +
>  typedef unsigned long efi_status_t;
>  typedef u8 efi_bool_t;
>  typedef u16 efi_char16_t;              /* UNICODE character */
> --
> 2.16.4
>
