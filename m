From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v2 0/3] efi: add support for seeding the kernel RNG from UEFI
Date: Thu, 20 Oct 2016 11:34:13 -0700
Message-ID: <CAGXu5jLo=UX+Rw8kLZdd+iz+aS2JtwpqoxL=-ZMNXAeLE=Ac5w@mail.gmail.com>
References: <1476962486-18368-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476962486-18368-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Oct 20, 2016 at 4:21 AM, Ard Biesheuvel
<ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> This implements generic EFI core kernel code to seed the kernel entropy
> pool from a Linux specific UEFI configuration table containing a random seed
> supplied by the firmware. (#1)
>
> In addition, it wires it up for ARM and arm64, by invoking the EFI_RNG_PROTOCOL
> UEFI protocol from the stub, and populating such a UEFI config table using its
> output.

Looks good to me! Now that I understand it. ;)

Reviewed-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

-Kees

-- 
Kees Cook
Nexus Security
