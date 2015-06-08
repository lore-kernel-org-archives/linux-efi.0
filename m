From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH] efi: rtc-efi: use correct EFI 'epoch'
Date: Mon, 08 Jun 2015 12:26:32 -0700
Message-ID: <1433791592.2291.83.camel@HansenPartnership.com>
References: <1433762834-17961-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433762834-17961-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 2015-06-08 at 13:27 +0200, Ard Biesheuvel wrote:
> The rtc-efi driver declares that the EFI 'epoch' is 1/1/1998, but
> the UEFI spec does not define it at all. It does define a minimum
> of 1900 for the 'Year' member of the EFI_TIME struct, so let's use
> 1900 as the minimum year and not 1998.
> 
> This prevents rtc_read_time() failures when the RTC that backs the
> EFI time services is set to a date before 1998.
> 
> Cc: Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>
> Cc: Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
> Cc: rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/rtc/rtc-efi.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-efi.c b/drivers/rtc/rtc-efi.c
> index cb989cd00b14..4a93b0bbf22c 100644
> --- a/drivers/rtc/rtc-efi.c
> +++ b/drivers/rtc/rtc-efi.c
> @@ -25,9 +25,12 @@
>  
>  #define EFI_ISDST (EFI_TIME_ADJUST_DAYLIGHT|EFI_TIME_IN_DAYLIGHT)
>  /*
> - * EFI Epoch is 1/1/1998
> + * The UEFI spec does not literally define an epoch, but it does
> + * define EFI_TIME::Year as having a value between 1900 and 9999.
> + * (UEFI spec v2.5 paragraph 7.3)
> + * So let's use 1900 as the EFI epoch year.
>   */
> -#define EFI_RTC_EPOCH		1998
> +#define EFI_RTC_EPOCH		1900
>  
>  /*
>   * returns day of the year [0-365]
> @@ -40,8 +43,6 @@ compute_yday(efi_time_t *eft)
>  }
>  /*
>   * returns day of the week [0-6] 0=Sunday
> - *
> - * Don't try to provide a year that's before 1998, please !
>   */
>  static int
>  compute_wday(efi_time_t *eft)
> @@ -60,9 +61,9 @@ compute_wday(efi_time_t *eft)
>  	ndays += compute_yday(eft);
>  
>  	/*
> -	 * 4=1/1/1998 was a Thursday
> +	 * 1=1/1/1900 was a Monday
>  	 */
> -	return (ndays + 4) % 7;
> +	return (ndays + 1) % 7;
>  }

This is a bit nuts: increasing the for loop by a huge amount every time
we call the date just so we can cope with the odd early date.  Why not
just count backwards for the exception case?  That way the epoch becomes
an optimisation point, every year actually works, but years far before
the epoch get penalised in the loop, while our current "efficiency"
remains ... perhaps plus points if we want to move the epoch to 2015?

James

---

diff --git a/drivers/rtc/rtc-efi.c b/drivers/rtc/rtc-efi.c
index cb989cd..73f1ba6 100644
--- a/drivers/rtc/rtc-efi.c
+++ b/drivers/rtc/rtc-efi.c
@@ -40,8 +40,6 @@ compute_yday(efi_time_t *eft)
 }
 /*
  * returns day of the week [0-6] 0=Sunday
- *
- * Don't try to provide a year that's before 1998, please !
  */
 static int
 compute_wday(efi_time_t *eft)
@@ -49,16 +47,25 @@ compute_wday(efi_time_t *eft)
 	int y;
 	int ndays = 0;
 
-	if (eft->year < EFI_RTC_EPOCH) {
-		pr_err("EFI year < " __stringify(EFI_RTC_EPOCH) ", invalid date\n");
-		return -1;
+	if (unlikely(eft->year < EFI_RTC_EPOCH)) {
+		/* unlikely event, just count backwards */
+		for (y = eft->year; y < EFI_RTC_EPOCH; y++)
+			ndays -= 365 + (is_leap_year(y) ? 1 : 0);
+	} else {
+		for (y = EFI_RTC_EPOCH; y < eft->year; y++)
+			ndays += 365 + (is_leap_year(y) ? 1 : 0);
 	}
 
-	for (y = EFI_RTC_EPOCH; y < eft->year; y++)
-		ndays += 365 + (is_leap_year(y) ? 1 : 0);
-
 	ndays += compute_yday(eft);
 
+	if (ndays < 0)
+		/* 
+		 * make ndays positive by adding a multiple of seven because
+		 * clock arithmetic using % doesn't work with negative
+		 * numbers
+		 */
+		ndays += ((-ndays)/7 + 1)*7;
+
 	/*
 	 * 4=1/1/1998 was a Thursday
 	 */
