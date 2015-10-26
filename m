From: Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v4 3/3] arm64/efi: isolate EFI stub from the kernel proper
Date: Mon, 26 Oct 2015 17:26:28 -0500
Message-ID: <562EA894.8070505@arm.com>
References: <1444330924-17830-1-git-send-email-ard.biesheuvel@linaro.org>
 <1444330924-17830-4-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444330924-17830-4-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 10/08/2015 02:02 PM, Ard Biesheuvel wrote:
> Since arm64 does not use a builtin decompressor, the EFI stub is built
> into the kernel proper. So far, this has been working fine, but actually,
> since the stub is in fact a PE/COFF relocatable binary that is executed
> at an unknown offset in the 1:1 mapping provided by the UEFI firmware, we
> should not be seamlessly sharing code with the kernel proper, which is a
> position dependent executable linked at a high virtual offset.

This patch appears to be causing a build break

  STUBCPY drivers/firmware/efi/libstub/lib-sort.stub.o
0000000000000000 R_AARCH64_ABS64   __efistub___crc_sort
drivers/firmware/efi/libstub/lib-sort.stub.o: absolute symbol references 
not allowed in the EFI stub

__kcrctab_sort:
	.xword	__crc_sort
	.weak	__crc_sort
	.text


Which is the EXPORT_SYMBOL() in sort.c combined with !CONFIG_MODVERSIONS.
