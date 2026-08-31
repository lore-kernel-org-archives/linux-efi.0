Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A4B223DE5;
	Mon, 31 Aug 2026 01:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788139605; cv=none; b=sDISRi97n51QUJh0GIvoWngNzh1GjpDW2qKYXqeRK+9J+GKWhc9SUQ+2Acs+7oHKarBbRLgg2H1H/kovRh3eCvwXmsvQsKSvhfmpBQ6ZZCYlOwh68aN7olZP+hUbecv1zLyiiHB1jC3NFw3rSKOP2bbyyViC8RnTORjjlq3B6/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788139605; c=relaxed/simple;
	bh=du8GyQrS7/hANrJTyp86X9opSz8IDykUQxukJnpzFF8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sR6YxR8elOUfvDU1Bi8vt6eQyVC6z3a++80opI+c/pc5pr2qxXU8AMJkE02yYvIBZMZs+92IEk+uBlOSHE6FZtIUUkrsBm0zEqVVrTwLmQPr7fM4piM0ekSgEdazQUwIcm0sulKB4iJaZZMlCjrbyYoHg2AiYn7i19G7rrs2nmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=kBpTucjH; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="kBpTucjH"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788139592; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=lEH0zLOO60hggjTASVmar4Yca+lpiq/rLQRgzK6veOE=;
	b=kBpTucjHmxmbY+pYPmdY0Tw9AO261gj62ioohWyCPE6CnP5+AY4+5syuiufq5did3jG3aV6R/awkMWN9Xst26xSJXWMXmxkmuy+3xeql/kAsGhqOk27uEK0ODhlTPmSKZHblc/qCRSLJZ72lYRdvjXa/mPQIcXnTVck2G59E4zw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=feng.tang@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X9rgu47_1788138647;
Received: from localhost(mailfrom:feng.tang@linux.alibaba.com fp:SMTPD_---0X9rgu47_1788138647 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 31 Aug 2026 09:10:48 +0800
Date: Mon, 31 Aug 2026 09:10:47 +0800
From: Feng Tang <feng.tang@linux.alibaba.com>
To: "Johnny.Fan" <johnny.fan@cixtech.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>,
	linux-rtc@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
	cix-kernel-upstream@cixtech.com, bob.zhang@cixtech.com,
	jie.fu@cixtech.com
Subject: Re: [PATCH] rtc: efi: restore alarm support with runtime capability
 probe
Message-ID: <apTUlyX9XWyo018i@U-2FWC9VHC-2323.local>
References: <20260828031519.2749354-1-johnny.fan@cixtech.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260828031519.2749354-1-johnny.fan@cixtech.com>

On Fri, Aug 28, 2026 at 11:15:19AM +0800, Johnny.Fan wrote:
> From: "Johnny.Fan" <Johnny.Fan@cixtech.com>
> 
> Restore the EFI RTC alarm functionality (read_alarm/set_alarm and
> procfs output) that was removed by commit 18a3510bc87d ("rtc: efi:
> Remove wakeup functionality").
> 
> The removal was motivated by the observation that many EFI platforms
> lack RTC wakeup support while also omitting the RT_PROP table, causing
> the wakeup capability to be incorrectly advertised.  While that is
> true, removing the feature entirely also breaks platforms where the
> wakeup runtime service actually works.
> 
> On CIX SoCs with an I2C-connected RTC, the firmware owns the RTC and
> exposes it via EFI runtime services.  Using the native I2C RTC driver
> under Linux breaks Windows, which relies on EFI runtime services to
> access the RTC.  rtc-efi is therefore the only viable option for
> shared RTC access across operating systems, and it needs working
> alarm/wakeup support.
> 
> To avoid exposing a broken alarm on firmware that does not implement
> the wakeup runtime services, probe the capability at ->probe() time by
> actually calling GetWakeupTime() -- if it fails, clear RTC_FEATURE_ALARM
> and the device behaves as before the removal.
> 
> Also set RTC_FEATURE_ALARM_WAKEUP_ONLY since EFI wakeup time is a
> wakeup-only alarm, not a periodic/update interrupt source.

It covers the alarm selftest failure we met before, thanks!

Reviewed-by: Feng Tang <feng.tang@linux.alibaba.com>

> 
> Reviewed-by: Fugang Duan <fugang.duan@cixtech.com>
> Tested-by: Johnny.Fan <Johnny.Fan@cixtech.com>
> Signed-off-by: Johnny.Fan <Johnny.Fan@cixtech.com>
> ---
>  drivers/rtc/rtc-efi.c | 78 +++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 76 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-efi.c b/drivers/rtc/rtc-efi.c
> index b4f44999ef0f..708cba43435e 100644
> --- a/drivers/rtc/rtc-efi.c
> +++ b/drivers/rtc/rtc-efi.c
> @@ -112,6 +112,34 @@ convert_from_efi_time(efi_time_t *eft, struct rtc_time *wtime)
>  	return true;
>  }
>  
> +static int efi_read_alarm(struct device *dev, struct rtc_wkalrm *wkalrm)
> +{
> +	efi_time_t eft;
> +	efi_status_t status;
> +
> +	status = efi.get_wakeup_time((efi_bool_t *)&wkalrm->enabled,
> +				     (efi_bool_t *)&wkalrm->pending, &eft);
> +	if (status != EFI_SUCCESS)
> +		return -EINVAL;
> +
> +	if (!convert_from_efi_time(&eft, &wkalrm->time))
> +		return -EIO;
> +
> +	return rtc_valid_tm(&wkalrm->time);
> +}
> +
> +static int efi_set_alarm(struct device *dev, struct rtc_wkalrm *wkalrm)
> +{
> +	efi_time_t eft;
> +	efi_status_t status;
> +
> +	convert_to_efi_time(&wkalrm->time, &eft);
> +
> +	status = efi.set_wakeup_time((efi_bool_t)wkalrm->enabled, &eft);
> +
> +	return status == EFI_SUCCESS ? 0 : -EINVAL;
> +}
> +
>  static int efi_read_time(struct device *dev, struct rtc_time *tm)
>  {
>  	efi_status_t status;
> @@ -146,13 +174,21 @@ static int efi_set_time(struct device *dev, struct rtc_time *tm)
>  
>  static int efi_procfs(struct device *dev, struct seq_file *seq)
>  {
> -	efi_time_t        eft;
> +	efi_time_t        eft, alm;
>  	efi_time_cap_t    cap;
> +	efi_bool_t        enabled, pending;
> +	struct rtc_device *rtc = dev_get_drvdata(dev);
>  
>  	memset(&eft, 0, sizeof(eft));
> +	memset(&alm, 0, sizeof(alm));
>  	memset(&cap, 0, sizeof(cap));
>  
>  	efi.get_time(&eft, &cap);
> +	if (test_bit(RTC_FEATURE_ALARM, rtc->features) &&
> +	    efi.get_wakeup_time(&enabled, &pending, &alm) != EFI_SUCCESS) {
> +		enabled = false;
> +		pending = false;
> +	}
>  
>  	seq_printf(seq,
>  		   "Time\t\t: %u:%u:%u.%09u\n"
> @@ -168,6 +204,25 @@ static int efi_procfs(struct device *dev, struct seq_file *seq)
>  		/* XXX fixme: convert to string? */
>  		seq_printf(seq, "Timezone\t: %u\n", eft.timezone);
>  
> +	if (test_bit(RTC_FEATURE_ALARM, rtc->features)) {
> +		seq_printf(seq,
> +			   "Alarm Time\t: %u:%u:%u.%09u\n"
> +			   "Alarm Date\t: %u-%u-%u\n"
> +			   "Alarm Daylight\t: %u\n"
> +			   "Enabled\t\t: %s\n"
> +			   "Pending\t\t: %s\n",
> +			   alm.hour, alm.minute, alm.second, alm.nanosecond,
> +			   alm.year, alm.month, alm.day,
> +			   alm.daylight,
> +			   enabled == 1 ? "yes" : "no",
> +			   pending == 1 ? "yes" : "no");
> +
> +		if (alm.timezone == EFI_UNSPECIFIED_TIMEZONE)
> +			seq_puts(seq, "Alarm Timezone\t: unspecified\n");
> +		else
> +			seq_printf(seq, "Alarm Timezone\t: %u\n", alm.timezone);
> +	}
> +
>  	/*
>  	 * now prints the capabilities
>  	 */
> @@ -183,6 +238,8 @@ static int efi_procfs(struct device *dev, struct seq_file *seq)
>  static const struct rtc_class_ops efi_rtc_ops = {
>  	.read_time	= efi_read_time,
>  	.set_time	= efi_set_time,
> +	.read_alarm	= efi_read_alarm,
> +	.set_alarm	= efi_set_alarm,
>  	.proc		= efi_procfs,
>  };
>  
> @@ -191,6 +248,7 @@ static int __init efi_rtc_probe(struct platform_device *dev)
>  	struct rtc_device *rtc;
>  	efi_time_t eft;
>  	efi_time_cap_t cap;
> +	efi_bool_t enabled, pending;
>  
>  	/* First check if the RTC is usable */
>  	if (efi.get_time(&eft, &cap) != EFI_SUCCESS)
> @@ -203,7 +261,23 @@ static int __init efi_rtc_probe(struct platform_device *dev)
>  	platform_set_drvdata(dev, rtc);
>  
>  	rtc->ops = &efi_rtc_ops;
> -	clear_bit(RTC_FEATURE_ALARM, rtc->features);
> +	clear_bit(RTC_FEATURE_UPDATE_INTERRUPT, rtc->features);
> +
> +	/*
> +	 * The EFI_RT_SUPPORTED_WAKEUP_SERVICES bit defaults to enabled
> +	 * and only gets cleared when the RT_PROP table explicitly says
> +	 * wakeup is unsupported. Many platforms lack an RT_PROP table
> +	 * even though they don't implement the wakeup runtime service,
> +	 * so probe by actually calling GetWakeupTime() to avoid exposing
> +	 * a broken alarm to userspace.
> +	 */
> +	if (efi_rt_services_supported(EFI_RT_SUPPORTED_WAKEUP_SERVICES) &&
> +	    efi.get_wakeup_time(&enabled, &pending, &eft) == EFI_SUCCESS) {
> +		set_bit(RTC_FEATURE_ALARM, rtc->features);
> +		set_bit(RTC_FEATURE_ALARM_WAKEUP_ONLY, rtc->features);
> +	} else {
> +		clear_bit(RTC_FEATURE_ALARM, rtc->features);
> +	}
>  
>  	device_init_wakeup(&dev->dev, true);
>  
> -- 
> 2.55.0
