From: Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] arm64/efi: move arm64 specific stub C code to libstub
Date: Fri, 30 Oct 2015 10:40:28 -0500
Message-ID: <56338F6C.8040207@arm.com>
References: <1445611694-31838-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445611694-31838-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, Suzuki.Poulose-5wv7dgnIgG8@public.gmane.org
Cc: ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 10/23/2015 09:48 AM, Ard Biesheuvel wrote:
> Now that we added special handling to the C files in libstub, move
> the one remaining arm64 specific EFI stub C file to libstub as
> well, so that it gets the same treatment. This should prevent future
> changes from resulting in binaries that may execute incorrectly in
> UEFI context.
>
> With efi-entry.S the only remaining EFI stub source file under
> arch/arm64, we can also simplify the Makefile logic somewhat.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

I'm a little late here, but I've been running this for a few days in an 
EFI/ACPI environment without any issues.

So if there are any further merges..

Tested-by: Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>

Thanks,
