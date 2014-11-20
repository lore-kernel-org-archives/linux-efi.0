From: Geoff Levand <geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 00/13] arm64: stable UEFI mappings for kexec
Date: Thu, 20 Nov 2014 14:05:32 -0800
Message-ID: <1416521132.23886.108.camel@smoke>
References: <1416315432-8534-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1416315432-8534-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi Ard,

On Tue, 2014-11-18 at 13:56 +0100, Ard Biesheuvel wrote:
> This is v3 of the series to update the UEFI memory map handling for the arm64
> architecture so that:

I merged in your EFI patches into my master branch [1] and was able
to do a successful chain of (four) kexec re-boots of the same kernel
image on the ARM base model running LEG 14.10 EFI binaries [2].  EFI
showed:

  UEFI v2.40 (ARM Fixed Virtual Platform EFI Oct 23 2014 15:53:09, 0x00000000)

I only verified that all CPU's came up and that /proc/meminfo and the
/proc/iomem 'System RAM' entries looked ok. 

[1] https://git.linaro.org/people/geoff.levand/linux-kexec.git
[2] https://releases.linaro.org/14.10/components/kernel/uefi-linaro/release/fvp_minimal

-Geoff
