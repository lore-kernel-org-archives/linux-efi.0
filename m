From: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [RFC PATCH] arm64/efi: isolate EFI stub from the kernel proper
Date: Tue, 15 Sep 2015 15:46:29 +0100
Message-ID: <20150915144629.GG31157@arm.com>
References: <1442311903-19213-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1442311903-19213-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Rutland <Mark.Rutland-5wv7dgnIgG8@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Sep 15, 2015 at 11:11:43AM +0100, Ard Biesheuvel wrote:
> Since arm64 does not use a builtin decompressor, the EFI stub is built
> into the kernel proper. So far, this has been working fine, but actually,
> since the stub is in fact a PE/COFF relocatable binary that is executed
> at an unknown offset in the 1:1 mapping provided by the UEFI firmware, we
> should not be seamlessly sharing code with the kernel proper, which is a
> position dependent executable linked at a high virtual offset.
> 
> So instead, separate the contents of libstub and its dependencies, by
> putting them into their own namespace by prefixing all of its symbols
> with __efistub. This way, we have tight control over what parts of the
> kernel proper are referenced by the stub.

Could we add an __efistub annotation to spit out warnings if the stub
calls into unexpected kernel code, like we do for __init/__ref?

Will
