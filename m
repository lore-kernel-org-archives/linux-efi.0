From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] efi/arm64: efistub: remove local copy of linux_banner
Date: Wed, 18 Jun 2014 09:50:59 +0100
Message-ID: <20140618085059.GB24049@console-pimps.org>
References: <1402657911-7779-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1402657911-7779-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 13 Jun, at 01:11:51PM, Ard Biesheuvel wrote:
> The shared efistub code for ARM and arm64 contains a local copy of linux_banner,
> allowing it to be referenced from separate executables such as the ARM
> decompressor. However, this introduces a dependency on generated header files,
> causing unnecessary rebuilds of the stub itself and, in case of arm64, vmlinux
> which contains it.
> 
> On arm64, the copy is not actually needed since we can reference the original
> symbol directly, and as it turns out, there may be better ways to deal with this
> for ARM as well, so let's remove it from the shared code. If it still needs to
> be reintroduced for ARM later, it should live under arch/arm anyway and not in
> shared code.

I remember making some similar arguments when this patch was first
introduced. From looking at my notes, the patch rationale was based on
some DT binding discussion where people wanted an explicit way to
identify the kernel they were booting and everyone agreed upon this
string - I don't know which discussion, I don't have that data.

I'm more than happy to delete this from the shared code, I never wanted
it to go in in the first place. But could someone please give me some
details as to why this change is safe and isn't going to break
ARM/ARM64? How does this affect DT bindings?

-- 
Matt Fleming, Intel Open Source Technology Center
