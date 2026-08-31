Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B830E421A17
	for <linux-efi@vger.kernel.org>; Mon, 31 Aug 2026 13:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183281; cv=none; b=vAsMFzxw0kfFSYifUzbIIz9Qimbi3/ObS7nZhhYX/bXYEYSUYMnHv6PB6H4PXtJKOiOr4YttcFKonZdiKqvAQ3LHHWXxK5uMgAzinhU8bJB1tXUUSizLNLqmGl6akS+83uXY6tKYtasAjQJsJpL5Q/NrY0xh19JFWlAhtO4O724=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183281; c=relaxed/simple;
	bh=5F/28CBtoWeDbOeVIIehAei65A9TKcBP3KBpVd24mLs=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=j1KWR8lYreoWEGoI9Ef/n+/SrpgmrRtixrEagZovpnCRlRNC5c8ADhnNadxjcRZDLkdC9ro1/vMVsLNN0olwNJlHnpwumiYp5S1HQVPfX+YIirMRxDnj2Hb8qhiV5QWVEudlZsNOLApVh5kmT148GyO1kSt4bnCYoxm+LAEPFro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nq95q1k2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nq95q1k2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5311F00A3D;
	Mon, 31 Aug 2026 13:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183279;
	bh=FC6Vpaegr1fiuKn9JpYMGlkhWhMi5cxOIlFOscXdraU=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=Nq95q1k2M8aAlNmVv4HWwfEgFjkcnObCeR7Ud1vyynsZgPixQouRCSlsYIIgKCUZz
	 /9V43m5gU0Vkn2uKvs/vfPBHq7F/lnGFOyvLY0XreR20IJperHgol7wuNzQ02OnL8p
	 O9kU0G1QUWOWsV72+nnJ8onC7+4Xbk7RN15QQGzkuSmGzrnuJipf+W961Xnqt307M/
	 iseVzLWWxb8B7hteFyWsNyUl0xUEQdNTmWGR7Dnyj+GzsEjA78iSG0PyX/iwEg+ykq
	 eVvaBIgub4AdOtvTSNZ0glhiYHXCKYZkOLO95mpGteCJVsFcsP+hgGL/WZGKpqdzP2
	 nWLdFv5d2nDXg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id AC0C01980064;
	Mon, 31 Aug 2026 09:34:37 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Mon, 31 Aug 2026 09:34:37 -0400
X-ME-Sender: <xms:64KVaswQVclmmlGKr7OYPKTzBh8z52vhMXTi0Z-JCdWS6YNv48IvUA>
    <xme:64KVarFC7mVyP5rx0DefWclOOy5Q01XSLt3Nf5O7XnRSR1B3twM0pdmnrlm63-11q
    I7p9ZBwk1ypUwtktXJN-6gep8HZu8_oAgOPg0eqgXyjQgMK1mVuza82>
X-ME-Proxy-Cause: dmFkZTFKSj5VjNu6I5UH5Dj3298TU96FVwF9e6j2hFa+9qc2yQO1j/Q85mpW6v6G38SFzZ
    53LClh82P7VZhD+/vXxSSEUUZyjDgN4fZh3zynP+7k3rxivAOHPb7tGsZn12XbL3EW7GZN
    mjvyLwoyS3BgtJHvn1f1lCUMwbOshOMiCDhLeENe0YKsSMCRKs/wyWZPhgA7/vmYku4p3i
    AQ92NCO/ci5k6npBaN/99229q5U34E3u/xBo7Qkya5Z0fbkSu8b/Atspe8AKBOQFg54qfx
    +64ZR101a/hR6I+pnvZb5Y9ZN5UiTu3wB8xuJMxkmG3kY0FVPBR/LOqZu9U5NXtjTQh+ZF
    GyNtGYCm4gGuln8PXgm2x737ZRQBmqm41q9ufmVn9+Qd4CO2HWlZHQjCJAxcMbjyKOuJv4
    ac1x9o43+SAg8Og4C/97oIeqQss7K/io9IhLf55SB8DsBn00AHRwdGBdkA8XJC8cm7/xEy
    biPCuNqLRjIIlwMYrFyE5eY6fZqhPCVaVGgk0441D7PZJcvaSZhpGUEdYUpCGgDiPcetlH
    S0zrRrpsR3o+F3ykXr+Cmuphs4as5aeIceRrAY5tSuuMHgnMX+xdkV49CaAvw6SXdl5OJu
    4bGCdLg25hiZuOIcR70rgnqsJzz+cJSfBlCrU/8eNc3jV65oUSVqShUtL0Aw
X-ME-Proxy: <xmx:7YKVaoTgBqenVhtgpAuekz0QlrlLlL-G81-zyx_pzbEQJCD8poKJAg>
    <xmx:7YKVao0xye3PMa0r-wo--_bjZk4U-mKbLnWlhUbo3bOtJdsDlb8uaA>
    <xmx:7YKVagefSFEPePTGEjSLctOsnEgUzOBtvONX3SO2GtM2O4smko0w1g>
    <xmx:7YKVaoN3QmD7XxdfCAE3cf61l4ht47lCh4Nt6IRPt5USgTuQSvr5bg>
    <xmx:7YKVasX9MA7YeviHNNlRMNOMsvi-HFVVZ5JoC1B1hX0w1vBIpm-BgsbY>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id B48A3F8007A; Mon, 31 Aug 2026 09:34:35 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 31 Aug 2026 15:34:15 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Johnny.Fan" <johnny.fan@cixtech.com>,
 "Alexandre Belloni" <alexandre.belloni@bootlin.com>,
 linux-rtc@vger.kernel.org
Cc: "Feng Tang" <feng.tang@linux.alibaba.com>, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org, cix-kernel-upstream@cixtech.com,
 bob.zhang@cixtech.com, jie.fu@cixtech.com
Message-Id: <b12dffdb-b8d9-4438-bc17-00127c3a1bba@app.fastmail.com>
In-Reply-To: <20260831113858.759210-1-johnny.fan@cixtech.com>
References: <20260828031519.2749354-1-johnny.fan@cixtech.com>
 <20260831113858.759210-1-johnny.fan@cixtech.com>
Subject: Re: [PATCH v2] rtc: efi: restore alarm support with runtime capability probe
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Mon, 31 Aug 2026, at 13:38, Johnny.Fan wrote:
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
> On CIX SoCs, the RTC is an I2C device owned by firmware, and in the
> ACPI boot configuration the I2C bus it sits on is not exposed to the
> OS, so the EFI runtime services are the only way Linux can access
> the RTC at all.  Both Linux and Windows use this same interface by
> design, so the RTC state is consistent across the operating systems
> installed on the machine, and Windows relies on the EFI wakeup
> services for its own RTC alarm support.
>
> With the alarm support removed from rtc-efi, Linux loses the
> equivalent capability entirely on these platforms: rtcwake fails
> for both suspend-to-RAM and power-off wakeup, as there is no other
> path to program the RTC alarm.  This is a real product requirement
> that CIX customers have explicitly requested, not a hypothetical
> use case.
>
> To avoid exposing a broken alarm on firmware that does not implement
> the wakeup runtime services, probe the capability at ->probe() time by
> actually calling GetWakeupTime() -- if it fails, clear RTC_FEATURE_ALARM
> and the device behaves as before the removal.
>
> Also set RTC_FEATURE_ALARM_WAKEUP_ONLY since EFI wakeup time is a
> wakeup-only alarm, not a periodic/update interrupt source.
>
> Reviewed-by: Feng Tang <feng.tang@linux.alibaba.com>
> Reviewed-by: Fugang Duan <fugang.duan@cixtech.com>
> Tested-by: Johnny.Fan <Johnny.Fan@cixtech.com>

Please drop this tested-by - it is implied.

With that fixed, and the tweak below,

Acked-by: Ard Biesheuvel <ardb@kernel.org>


> Signed-off-by: Johnny.Fan <Johnny.Fan@cixtech.com>
> ---
> v2:
>   - Expand the commit message with the actual product motivation,
>     as requested by Ard.
>   - Zero-initialize efi_time_t in convert_to_efi_time() to avoid
>     leaking stack garbage in pad1/pad2 fields to firmware.
>   - Zero-initialize the local eft in efi_read_alarm() so that
>     convert_from_efi_time() does not fail with -EIO on disabled
>     alarms, where the returned time is undefined per the UEFI spec.
>   - Normalize wkalrm->enabled to a strict boolean (!!) before
>     passing it to SetWakeupTime, as UEFI BOOLEAN must be 0 or 1.
>   - Use %d for the signed alm.timezone value in procfs output.
>
>  drivers/rtc/rtc-efi.c | 80 +++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 78 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/rtc/rtc-efi.c b/drivers/rtc/rtc-efi.c
> index b4f44999ef0f..5276870b410e 100644
> --- a/drivers/rtc/rtc-efi.c
> +++ b/drivers/rtc/rtc-efi.c
> @@ -52,6 +52,7 @@ compute_wday(efi_time_t *eft, int yday)
>  static void
>  convert_to_efi_time(struct rtc_time *wtime, efi_time_t *eft)
>  {
> +	memset(eft, 0, sizeof(*eft));
>  	eft->year	= wtime->tm_year + 1900;
>  	eft->month	= wtime->tm_mon + 1;
>  	eft->day	= wtime->tm_mday;
> @@ -112,6 +113,35 @@ convert_from_efi_time(efi_time_t *eft, struct 
> rtc_time *wtime)
>  	return true;
>  }
> 
> +static int efi_read_alarm(struct device *dev, struct rtc_wkalrm 
> *wkalrm)
> +{
> +	efi_time_t eft;
> +	efi_status_t status;
> +
> +	memset(&eft, 0, sizeof(eft));
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
> +	status = efi.set_wakeup_time((efi_bool_t)!!wkalrm->enabled, &eft);
> +
> +	return status == EFI_SUCCESS ? 0 : -EINVAL;
> +}
> +
>  static int efi_read_time(struct device *dev, struct rtc_time *tm)
>  {
>  	efi_status_t status;
> @@ -146,13 +176,21 @@ static int efi_set_time(struct device *dev, 
> struct rtc_time *tm)
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

Assign 0 here not false - efi_bool_t is a u8.
