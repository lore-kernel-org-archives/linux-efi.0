Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11022097.outbound.protection.outlook.com [52.101.126.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008B2481A8F;
	Mon, 31 Aug 2026 14:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.97
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184826; cv=fail; b=nWNq0fb4tl27dihOIC9xcezdI4eOh8wZQNyQKxTdmk/b+bB4TxEl5sdHjJ2BOPrfdPxKBSqxmdhhocnIXtqAHhyqBNF75ZhbV5X8ZBqEau1lsw8cM3DCjGOoDuMxCmagyWseDy50bXjPpKF8E6zom0nscXtQsmd0tMkUBWUm7yg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184826; c=relaxed/simple;
	bh=LWarsO/Tz/JTxn9OEVegmK/k4La4GIZrupM7/+WU4fE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bSPiQVZEq832aj9vhHrLH7qHyJq9OblL/qFZrPNpsVXQazaG+jH8OwM142lYRM5Yqucx0LruRSjoS7mD5IdUfIDgg6n96UBUGofXKu67qVsdyAF8sXSTUTRclpHlAgm5EzaXO3r8v50oVcmQjdCmdUSnPRVTyb4SUusR7BhSRLc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cixtech.com; spf=pass smtp.mailfrom=cixtech.com; arc=fail smtp.client-ip=52.101.126.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cixtech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cixtech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wnwzcj4TfmpuWCUJjrV0+vX1kewpbxmfAkLUA7NBv+npk5i4uY33mR/CwBr2yaxfX3iEkFVC0dTnOFPO4tMvqUByKekqz2ithHxLEXyLYOmoJAeIAFF29CJrjH76h/5Af5bJupevdmLfM4ef1CQbX8GEcryU+l91gYkfd3WaPtsxwWG9Dr0YSWvtp/PlTq1BbG3qzFWw8QLx0cVZJoT6iZv7v498jzi95Zf1xZTqmE7fsCLrKGAPZ9RmXeZpL2gNt6pk9LRQen/1K4G6F72sJG9egBpK9J4cT8jeVTzHt73EvkR0XdZSfYvPxP+TmaD9A6WFnXANnlP9USFgsImoFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=45OYYdCn25rUF+Z9IUzhsBRLQlbziYBEsXzDHArVwmY=;
 b=vIRqRXLjvOBczhygRBQnQRs8GENDv9DfE4HEYUi3gLVOeK46WDLqAgHB1WmFnh/5fAymFWKEOVT9qXX/ROUgpt6yv6cI2I7FglkeYNWUT2avKVwaPHad+VA52ItjY8gG5uCAVNh0fvpdb93wF9io+F/g2ATwQIOuEcL5bGq+vvM025rEYwfaJ/MEPX8u5c3TRk7a99o321hQUJOYghwnR1ob2hDGHomJcVKcGf0UzdhElQqIDBiaRr64cL0ofcCJSQ6CoHXd8I/6Co0bqz6pAV7pU+jjEHoYwcTOwTNwIcnBSwtZWimRSFEB+hr/ksDyld6s+Zgb0JtM75pCKRE6hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 222.71.101.198) smtp.rcpttodomain=bootlin.com smtp.mailfrom=cixtech.com;
 dmarc=bestguesspass action=none header.from=cixtech.com; dkim=none (message
 not signed); arc=none (0)
Received: from PS2PR01CA0049.apcprd01.prod.exchangelabs.com
 (2603:1096:300:57::13) by OSNPR06MB8468.apcprd06.prod.outlook.com
 (2603:1096:604:487::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.12; Mon, 31 Aug
 2026 14:00:18 +0000
Received: from TY2PEPF0000AB88.apcprd03.prod.outlook.com
 (2603:1096:300:57:cafe::15) by PS2PR01CA0049.outlook.office365.com
 (2603:1096:300:57::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.13 via Frontend Transport; Mon,
 31 Aug 2026 14:00:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 222.71.101.198)
 smtp.mailfrom=cixtech.com; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=cixtech.com;
Received-SPF: Pass (protection.outlook.com: domain of cixtech.com designates
 222.71.101.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=222.71.101.198; helo=smtprelay.cixcomputing.com; pr=C
Received: from smtprelay.cixcomputing.com (222.71.101.198) by
 TY2PEPF0000AB88.mail.protection.outlook.com (10.167.253.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Mon, 31 Aug 2026 14:00:16 +0000
Received: from JohnnyFan (unknown [172.21.64.24])
	by smtprelay.cixcomputing.com (Postfix) with ESMTPSA id 264BA409210F;
	Mon, 31 Aug 2026 22:00:15 +0800 (CST)
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
Subject: [PATCH v3] rtc: efi: restore alarm support with runtime capability probe
Date: Mon, 31 Aug 2026 22:00:14 +0800
Message-ID: <20260831140014.839222-1-johnny.fan@cixtech.com>
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
X-MS-TrafficTypeDiagnostic: TY2PEPF0000AB88:EE_|OSNPR06MB8468:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 4a689d3d-befb-415d-f6ff-08df07682f9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|1800799024|82310400026|376014|6133799003|22082099003|18002099003|56012099006|3023799007|10067099003;
X-Microsoft-Antispam-Message-Info:
	FtNZKYn4cmt1+5xEEOR4GfkUhUwXNjyDH2hdXeUNTaXEy9ycsk87EGbbaZ0h7fo3ldw4OXxWwloFLvPZvQ0nNbKUJv8b6hZcYO3LZNGS8U1nMwksV+U2EPQ7YJDFrcutW4EryH7kyxwAP52jig/r28xOEE/RURBYqVuEsqQjl9m6uEKJgN2P1rvX/jjjlgad1sDBu4+a0YerLbKH5X8WkBYp36h4sFjHMSrudxZNQOwwytKu8nubFIOiABLKpl9kIrD+wDAdSUSf7v0IwyAvlq3O0gPXCA6gRDrnyVAdU7rMQQfn932rpcTvRalFiip2JLtzlDP91prnOpQrO5gGGQYam6ygzJsCci2XlN2T3GtdJWaiLCJ9vQsjzmO+OlZbNsxZdQwkpdW5Fku3McgnaZ9x3S1OG/iZGRkpBVPgXfcyfDR1sUkoNQcFde3F7jWjHW5VayWEcDZ/PKZcrHASOIKWMk18bP2rm9c8Vh8A0dpLIRRMjY9RtXyDRBfpaTWsmok2dV+MQLmzFuLgNfk0QXZq3o67wUtGOxJgtkszNq8KjDc1eSmmMtav08iIX1z2d16ho+1blP/ndl3ujytpeJhQbr0wyAQ6vcfY1RfvqbOyyUfhry/hFA+9y9R/9n6VAzUjEdxXoSrFZKzL8i5f206y7phqttwO/lkvZyE73/wctFfZeiJNxk61ifl6CEVQHVlpYE1ewr1008SgFituTQ==
X-Forefront-Antispam-Report:
	CIP:222.71.101.198;CTRY:CN;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:smtprelay.cixcomputing.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(1800799024)(82310400026)(376014)(6133799003)(22082099003)(18002099003)(56012099006)(3023799007)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	aP6OFZvwxNdThgmctjkBHJTkLBSXCe9wFUQwMQIRxxPAh5Y+K2c4C2EbOsm6dPdMWrDXCPQLQg3/Q5B1Ph9ajrtcmteV5iW84t2OilqEICLMYXWq7sx9rI3cRUu8kk57TgMD81NBETCqIZDLtQWb4LgCeoSnHUXlYJdWkIFv9wF9ka9db68rxhcmVPjVjNFBcPvT/Ge/zkAKiOwVjddcpnzkG6ZS2LRt70Vvsry7EM1d4Fm2pvPHmdP5k9N6petMNlmdm1XfSWGkBIgXGetCWRFZ/2yn+B0PDoNbQ6HEBlC1t3LHQ17UO2oRgCw4TO55rgEmEGjrKUoAgicSAaCSEr+tGWxkrZIqKA2151OSZXpkL+DWrHh5iu71+zNf13DzoIaOaGjLzL1NPZ4cdf/Z0kzOFiwAUc2HyUbMGP510ZkZR6VCd6NZfuRN6EZ/68v8
X-OriginatorOrg: cixtech.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2026 14:00:16.3976
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a689d3d-befb-415d-f6ff-08df07682f9f
X-MS-Exchange-CrossTenant-Id: 0409f77a-e53d-4d23-943e-ccade7cb4811
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=0409f77a-e53d-4d23-943e-ccade7cb4811;Ip=[222.71.101.198];Helo=[smtprelay.cixcomputing.com]
X-MS-Exchange-CrossTenant-AuthSource:
	TY2PEPF0000AB88.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSNPR06MB8468

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

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Feng Tang <feng.tang@linux.alibaba.com>
Reviewed-by: Fugang Duan <fugang.duan@cixtech.com>
Signed-off-by: Johnny.Fan <Johnny.Fan@cixtech.com>
---
v3:
  - Assign 0 instead of false to the efi_bool_t variables, as
    suggested by Ard.
  - Drop the Tested-by tag.
  - Collect Ard's Acked-by.

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
index b4f44999ef0f..a8c18ebc5599 100644
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
+		enabled = 0;
+		pending = 0;
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

