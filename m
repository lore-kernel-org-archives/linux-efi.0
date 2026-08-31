Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11022143.outbound.protection.outlook.com [52.101.126.143])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB653E833E;
	Mon, 31 Aug 2026 11:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.143
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788176352; cv=fail; b=j2SOvIHBA1b4YcFNiCMsG7lTNhq52KJE1v/t8SA7DYKfZsnj2B3lsDXZjNxfYjYPa8PJ2FS5nkJrD8rnSc9GjKIFNGi+cPkW6f2qtmXkbO3Xa7aPqunFAc7ApN9VmW95qUjkhTiDjIMWGyQXGoaPAYOwobCLQd3omfFTDgygETs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788176352; c=relaxed/simple;
	bh=jSnGqESvORhyiTnTeH36m+B1wxzS0ila0aysTfU1rkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XgtNcBBNlSK5POhQxkWbRD3ChNbtlpEdN0yz/We5RqSP7XTuC2ZWQdVll+nvNfhI7OUPhc02OcrwEMOQc8pyXZq01WBKEQsN+JWo64S7GiWe7j3jR1oeT9V5UEkypWBsThw07T/AkFQYUf2iXWSwrcBP0cztTKKWdEqR+JbAr94=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cixtech.com; spf=pass smtp.mailfrom=cixtech.com; arc=fail smtp.client-ip=52.101.126.143
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cixtech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cixtech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qrrPahO4vYVj+CaEn8JxKILzQj+d+bnVbp1begAvDe9C3Lkl/h3ROXjtki1dMpk0sogAhSHddOh0ZxoqinYh7S/p6rWGVw7CbRL5j4PV5H9B7X1UspnsTOdWeuWtIILvRByspdoUQec64/AOQ5BGZN6dnjiUYjVDqnWsJnqXhVpm2Pgl2S/W45uT+B6oZs73FJl9zzCzgJtpY0uEW0qCaBBVv8DGD9Rx1J01+DI4P6ByGfxx54jT9cN6WphdVyQtlsSJMv0n4cFkTyUyCOmHxubIqwklZ5e/Ur0i6B6PZ4LcFu0ExWTqzqXc1/zgbbXHi0MwesCE01/6ySxFwdyipQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pvujW59Rov9CFHgi0HfE5Zb5zAAUh00Zo6cQYZcEclk=;
 b=iwq6quJsLQtSbAbV5ApCaLNA4XoY4cjfOgH5wIwenVPxAOm90x/+EwsV+Q9+QG8nbrOdnrnTohvH/kfRN9gw4u3HP2RMNTQuVRxyDWycv4jG/WDRUtwkCmAQqysxzo5tIlZJW0ap/NNARpmygare5cl4UcTcOKMlMQ/jjEmZ/MSv1M0bPU4p1eDPecKzIuwEcFnFpKinsghfo+vpD1S7hPXEWzDUKIlC17OiE9QFdDZ+TigDuLNo6T3b3XN0rNsbN+IZZgviik7RXRUJx15SpM64/tzynBdthlaKhpBfkmMxFcDV4qmQsa64F5QAw0q/Lm0JvWohUBudDjZj9I7iVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 222.71.101.198) smtp.rcpttodomain=bootlin.com smtp.mailfrom=cixtech.com;
 dmarc=bestguesspass action=none header.from=cixtech.com; dkim=none (message
 not signed); arc=none (0)
Received: from SI1PR02CA0049.apcprd02.prod.outlook.com (2603:1096:4:1f5::18)
 by TY0PR06MB4981.apcprd06.prod.outlook.com (2603:1096:400:1af::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Mon, 31 Aug
 2026 11:39:04 +0000
Received: from OSA0EPF000000CD.apcprd02.prod.outlook.com
 (2603:1096:4:1f5:cafe::1e) by SI1PR02CA0049.outlook.office365.com
 (2603:1096:4:1f5::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.13 via Frontend Transport; Mon,
 31 Aug 2026 11:39:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 222.71.101.198)
 smtp.mailfrom=cixtech.com; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=cixtech.com;
Received-SPF: Pass (protection.outlook.com: domain of cixtech.com designates
 222.71.101.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=222.71.101.198; helo=smtprelay.cixcomputing.com; pr=C
Received: from smtprelay.cixcomputing.com (222.71.101.198) by
 OSA0EPF000000CD.mail.protection.outlook.com (10.167.240.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Mon, 31 Aug 2026 11:39:00 +0000
Received: from JohnnyFan (unknown [172.21.64.24])
	by smtprelay.cixcomputing.com (Postfix) with ESMTPSA id CFC404092107;
	Mon, 31 Aug 2026 19:38:58 +0800 (CST)
From: "Johnny.Fan" <johnny.fan@cixtech.com>
To: Alexandre Belloni <alexandre.belloni@bootlin.com>,
	linux-rtc@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cix-kernel-upstream@cixtech.com,
	bob.zhang@cixtech.com,
	jie.fu@cixtech.com
Subject: [PATCH v2] rtc: efi: restore alarm support with runtime capability probe
Date: Mon, 31 Aug 2026 19:38:58 +0800
Message-ID: <20260831113858.759210-1-johnny.fan@cixtech.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260828031519.2749354-1-johnny.fan@cixtech.com>
References: <20260828031519.2749354-1-johnny.fan@cixtech.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OSA0EPF000000CD:EE_|TY0PR06MB4981:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 1754aa58-0cc6-492d-58e9-08df07547367
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|82310400026|36860700016|10067099003|3023799007|6133799003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	x3kOzv2R2oK5nYh+ir905nABNUO54FjdbeEDcwpl8sAAiDhDuoGzHW9IwWvTO0gGC8AV5ME/zNdlKy5qFAxrtcSbybiMACLUOnBW7l8Qcw+Hb9SeWP355lo5rqGcqHXZz5fQ7GvvH5MpEG34DA0G3xeJXWiSrqJqIFSbajwAAsOOoGLWKDxPh6VphjdDpThH0a2rXu0s0NSiTDbnEghO5IJGDZ0wphb72EugADbx8GfepjXIsz0CU84vUNt9wV8j5c7UU9K3Ko468ftbExfHUuFYwSl/GhTbRuwI8BcBN8kiYQiPpyLvWmp+sV/WoqkzTYmtC78UeFiskWRKzNZlR4yVlAyRi3qOmycJr2wgo3LrfSfADfhoBJnm8h5Gm0EVCsi40Ejx63jltSfJK0AcTpIQDqQTLxWRgenJUUxJ5fIa3q9vTXsPsRfWUDBg7BO6XOK7K6wMxCo5VHGJLhcpB+fWHldN1X68NU+PyaFXuLC+inOHCNwx6RETJ96KFG7Cf2ScOzHvGtbeg0uYdBPb/Cx+KOhLDiWvW0TTMrAEnAndEb+d4dI/cHRVT5iFr9Juyuc5pTNB/xh6ZwIzr80trBaF6P3fvLGcUAlO2ajieJ/x8Q5aqNhwki1QDgUwJ+lZUZ8nOroTEuhOvs38dyeN7+e9FbfZcwSNKfK+UAsp+AinRZ9gpsRirYybrNrT0/K6/jphrzsmM2uN3TAMn431ZA==
X-Forefront-Antispam-Report:
	CIP:222.71.101.198;CTRY:CN;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:smtprelay.cixcomputing.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(82310400026)(36860700016)(10067099003)(3023799007)(6133799003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	89WvTYO1d3PQpSB5/2jozoJo5yLdj0lkSStvQv023PKsvflsdlB641Vnju1Qa4gJBdPzXPqIYilb0Zp+Z9exnQ5OvX1hK7SnvH9BEFyfYtsLYu2wbfOwd30l84GbjXzrhz7J/WPWcnWp3hmKgHLlj6ZFVoxr6lCx+PV3lR8QekQ1RMhIvzb5NSGzbLVsYucY4atPH9E+Hh5YFYGGmZRV838vU0JUwDF8WdozBdN8KmqaRVPlRTDq0KcYvHZbQ2+uMBVDvWv48LFEEp0ydCsfScHZYJF7zM1t1Pdm1LT4RfuNjCyIm4RHnCABCKEKoP1sYs3fkpQ5M6koWhsf+CxZDGuNnS+lhFTATkhidjBmTMbdWNs9ESN3zuSpdfQZEJGBVKKuxBtXFWwluHX0t+/sGtRHL7HMeXAVxyUkTDAowvg7W3orwEUwN1oROp8/hXGg
X-OriginatorOrg: cixtech.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2026 11:39:00.1381
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1754aa58-0cc6-492d-58e9-08df07547367
X-MS-Exchange-CrossTenant-Id: 0409f77a-e53d-4d23-943e-ccade7cb4811
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=0409f77a-e53d-4d23-943e-ccade7cb4811;Ip=[222.71.101.198];Helo=[smtprelay.cixcomputing.com]
X-MS-Exchange-CrossTenant-AuthSource:
	OSA0EPF000000CD.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB4981

From: "Johnny.Fan" <Johnny.Fan@cixtech.com>

Restore the EFI RTC alarm functionality (read_alarm/set_alarm and
procfs output) that was removed by commit 18a3510bc87d ("rtc: efi:
Remove wakeup functionality").

The removal was motivated by the observation that many EFI platforms
lack RTC wakeup support while also omitting the RT_PROP table, causing
the wakeup capability to be incorrectly advertised.  While that is
true, removing the feature entirely also breaks platforms where the
wakeup runtime service actually works.

On CIX SoCs, the RTC is an I2C device owned by firmware, and in the
ACPI boot configuration the I2C bus it sits on is not exposed to the
OS, so the EFI runtime services are the only way Linux can access
the RTC at all.  Both Linux and Windows use this same interface by
design, so the RTC state is consistent across the operating systems
installed on the machine, and Windows relies on the EFI wakeup
services for its own RTC alarm support.

With the alarm support removed from rtc-efi, Linux loses the
equivalent capability entirely on these platforms: rtcwake fails
for both suspend-to-RAM and power-off wakeup, as there is no other
path to program the RTC alarm.  This is a real product requirement
that CIX customers have explicitly requested, not a hypothetical
use case.

To avoid exposing a broken alarm on firmware that does not implement
the wakeup runtime services, probe the capability at ->probe() time by
actually calling GetWakeupTime() -- if it fails, clear RTC_FEATURE_ALARM
and the device behaves as before the removal.

Also set RTC_FEATURE_ALARM_WAKEUP_ONLY since EFI wakeup time is a
wakeup-only alarm, not a periodic/update interrupt source.

Reviewed-by: Feng Tang <feng.tang@linux.alibaba.com>
Reviewed-by: Fugang Duan <fugang.duan@cixtech.com>
Tested-by: Johnny.Fan <Johnny.Fan@cixtech.com>
Signed-off-by: Johnny.Fan <Johnny.Fan@cixtech.com>
---
v2:
  - Expand the commit message with the actual product motivation,
    as requested by Ard.
  - Zero-initialize efi_time_t in convert_to_efi_time() to avoid
    leaking stack garbage in pad1/pad2 fields to firmware.
  - Zero-initialize the local eft in efi_read_alarm() so that
    convert_from_efi_time() does not fail with -EIO on disabled
    alarms, where the returned time is undefined per the UEFI spec.
  - Normalize wkalrm->enabled to a strict boolean (!!) before
    passing it to SetWakeupTime, as UEFI BOOLEAN must be 0 or 1.
  - Use %d for the signed alm.timezone value in procfs output.

 drivers/rtc/rtc-efi.c | 80 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 78 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-efi.c b/drivers/rtc/rtc-efi.c
index b4f44999ef0f..5276870b410e 100644
--- a/drivers/rtc/rtc-efi.c
+++ b/drivers/rtc/rtc-efi.c
@@ -52,6 +52,7 @@ compute_wday(efi_time_t *eft, int yday)
 static void
 convert_to_efi_time(struct rtc_time *wtime, efi_time_t *eft)
 {
+	memset(eft, 0, sizeof(*eft));
 	eft->year	= wtime->tm_year + 1900;
 	eft->month	= wtime->tm_mon + 1;
 	eft->day	= wtime->tm_mday;
@@ -112,6 +113,35 @@ convert_from_efi_time(efi_time_t *eft, struct rtc_time *wtime)
 	return true;
 }
 
+static int efi_read_alarm(struct device *dev, struct rtc_wkalrm *wkalrm)
+{
+	efi_time_t eft;
+	efi_status_t status;
+
+	memset(&eft, 0, sizeof(eft));
+	status = efi.get_wakeup_time((efi_bool_t *)&wkalrm->enabled,
+				     (efi_bool_t *)&wkalrm->pending, &eft);
+	if (status != EFI_SUCCESS)
+		return -EINVAL;
+
+	if (!convert_from_efi_time(&eft, &wkalrm->time))
+		return -EIO;
+
+	return rtc_valid_tm(&wkalrm->time);
+}
+
+static int efi_set_alarm(struct device *dev, struct rtc_wkalrm *wkalrm)
+{
+	efi_time_t eft;
+	efi_status_t status;
+
+	convert_to_efi_time(&wkalrm->time, &eft);
+
+	status = efi.set_wakeup_time((efi_bool_t)!!wkalrm->enabled, &eft);
+
+	return status == EFI_SUCCESS ? 0 : -EINVAL;
+}
+
 static int efi_read_time(struct device *dev, struct rtc_time *tm)
 {
 	efi_status_t status;
@@ -146,13 +176,21 @@ static int efi_set_time(struct device *dev, struct rtc_time *tm)
 
 static int efi_procfs(struct device *dev, struct seq_file *seq)
 {
-	efi_time_t        eft;
+	efi_time_t        eft, alm;
 	efi_time_cap_t    cap;
+	efi_bool_t        enabled, pending;
+	struct rtc_device *rtc = dev_get_drvdata(dev);
 
 	memset(&eft, 0, sizeof(eft));
+	memset(&alm, 0, sizeof(alm));
 	memset(&cap, 0, sizeof(cap));
 
 	efi.get_time(&eft, &cap);
+	if (test_bit(RTC_FEATURE_ALARM, rtc->features) &&
+	    efi.get_wakeup_time(&enabled, &pending, &alm) != EFI_SUCCESS) {
+		enabled = false;
+		pending = false;
+	}
 
 	seq_printf(seq,
 		   "Time\t\t: %u:%u:%u.%09u\n"
@@ -168,6 +206,25 @@ static int efi_procfs(struct device *dev, struct seq_file *seq)
 		/* XXX fixme: convert to string? */
 		seq_printf(seq, "Timezone\t: %u\n", eft.timezone);
 
+	if (test_bit(RTC_FEATURE_ALARM, rtc->features)) {
+		seq_printf(seq,
+			   "Alarm Time\t: %u:%u:%u.%09u\n"
+			   "Alarm Date\t: %u-%u-%u\n"
+			   "Alarm Daylight\t: %u\n"
+			   "Enabled\t\t: %s\n"
+			   "Pending\t\t: %s\n",
+			   alm.hour, alm.minute, alm.second, alm.nanosecond,
+			   alm.year, alm.month, alm.day,
+			   alm.daylight,
+			   enabled == 1 ? "yes" : "no",
+			   pending == 1 ? "yes" : "no");
+
+		if (alm.timezone == EFI_UNSPECIFIED_TIMEZONE)
+			seq_puts(seq, "Alarm Timezone\t: unspecified\n");
+		else
+			seq_printf(seq, "Alarm Timezone\t: %d\n", alm.timezone);
+	}
+
 	/*
 	 * now prints the capabilities
 	 */
@@ -183,6 +240,8 @@ static int efi_procfs(struct device *dev, struct seq_file *seq)
 static const struct rtc_class_ops efi_rtc_ops = {
 	.read_time	= efi_read_time,
 	.set_time	= efi_set_time,
+	.read_alarm	= efi_read_alarm,
+	.set_alarm	= efi_set_alarm,
 	.proc		= efi_procfs,
 };
 
@@ -191,6 +250,7 @@ static int __init efi_rtc_probe(struct platform_device *dev)
 	struct rtc_device *rtc;
 	efi_time_t eft;
 	efi_time_cap_t cap;
+	efi_bool_t enabled, pending;
 
 	/* First check if the RTC is usable */
 	if (efi.get_time(&eft, &cap) != EFI_SUCCESS)
@@ -203,7 +263,23 @@ static int __init efi_rtc_probe(struct platform_device *dev)
 	platform_set_drvdata(dev, rtc);
 
 	rtc->ops = &efi_rtc_ops;
-	clear_bit(RTC_FEATURE_ALARM, rtc->features);
+	clear_bit(RTC_FEATURE_UPDATE_INTERRUPT, rtc->features);
+
+	/*
+	 * The EFI_RT_SUPPORTED_WAKEUP_SERVICES bit defaults to enabled
+	 * and only gets cleared when the RT_PROP table explicitly says
+	 * wakeup is unsupported. Many platforms lack an RT_PROP table
+	 * even though they don't implement the wakeup runtime service,
+	 * so probe by actually calling GetWakeupTime() to avoid exposing
+	 * a broken alarm to userspace.
+	 */
+	if (efi_rt_services_supported(EFI_RT_SUPPORTED_WAKEUP_SERVICES) &&
+	    efi.get_wakeup_time(&enabled, &pending, &eft) == EFI_SUCCESS) {
+		set_bit(RTC_FEATURE_ALARM, rtc->features);
+		set_bit(RTC_FEATURE_ALARM_WAKEUP_ONLY, rtc->features);
+	} else {
+		clear_bit(RTC_FEATURE_ALARM, rtc->features);
+	}
 
 	device_init_wakeup(&dev->dev, true);
 
-- 
2.55.0

