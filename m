From: Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v2] efi: rtc-efi: use correct EFI 'epoch'
Date: Sat, 13 Jun 2015 14:57:53 +0200
Message-ID: <20150613125753.GJ3890@piout.net>
References: <1433762834-17961-1-git-send-email-ard.biesheuvel@linaro.org>
 <1433841335-10453-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1433841335-10453-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 09/06/2015 at 11:15:35 +0200, Ard Biesheuvel wrote :
> The rtc-efi driver declares that the EFI 'epoch' is 1/1/1998, but
> the UEFI spec does not define it at all. It does define a range of
> [1900, 9999] for the 'Year' member of the EFI_TIME struct, so let's
> use 1900 as the minimum year and not 1998.
> Also, move the validation of the year to the convert_from_efi_time()
> routine where all other EFI_TIME fields are validated as well.
> 
> This prevents rtc_read_time() failures when the RTC that backs the
> EFI time services is set to a date before 1998, e.g., when it has
> lost power.
> 
> This also optimizes the compute_wday() routine, by replacing the for
> loop with a simple arithmetic expression, and by reusing the yearday
> value that we need to compute anyway when populating the
> rtc_time::tm_yday field.
> 
> Cc: Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>
> Cc: Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
> Cc: rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Applied, thanks.


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
