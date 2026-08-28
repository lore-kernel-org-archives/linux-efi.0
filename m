Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11023093.outbound.protection.outlook.com [40.107.44.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233C63947A4;
	Fri, 28 Aug 2026 03:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787886947; cv=fail; b=Xz6aenrbyvVy03316DaiOJU/FHXvuhOF3fpHxDdMwCmGFq2fjHuz9o9oMRrwpeksT7blI5vkx57hBlXPo7oV9dQ3s25dhRE0nd8PRbUrZZ6ZQL733Ofl3o7egNzh2SC/TMM9mgxoagrba86u6LPVvm+MZ4we29tsWAlYqQ6MitA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787886947; c=relaxed/simple;
	bh=+LCitfdTKA6t2OgsFVbUWLYZonZ7SDvqmjOTN/4qBg0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=g1Eh5ZEh2Op0OdkVXR00eByRop6QcWdrOzEmAefcIww7FCpsbaAPFzyyx/uBFjUQTM+ES86V6K57VpSlpInDgHgN2+Qkx5+PmTx8n130sraul3sqGLhwaIMU5WrcZA5zIblR4re69fKuLhJIiGbFeC3X3aeGWYAed/mmb41SVYA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cixtech.com; spf=pass smtp.mailfrom=cixtech.com; arc=fail smtp.client-ip=40.107.44.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cixtech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cixtech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SGt0rXhEj92/RVP3qPxapGqt1Eu6l8wuMsLDOevS7In4jTAKRRzJE2a8xhISexsSLSrHpW1V4S1qr8xyiB7bJ1rawuWv6JWZLusjUNbSsW88j684x9BePnoGYOxkahFbflz8Cbtz5W6wJeF28B/x8La6L0D0M77P6SfwL2BGy86BdCvxDl5tn9O5LD5yeJ2Z3s1+8Io+zdI4VsF62vrekGXujAOF+encLL3o1INHr82UPLUTz514tVXTdEpiMa0EYjuZ/Xwj8a7YmDQyrhf97m9mujcDEdgwBuk4H7XhHXxZ9jO1ah3ugcrKYSxkdlF1ivlFGcYiBvIF2NVx9nAyAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mg2VjxJX1NJfHcsytSxHYpuHtLS7fShDc83oMsK6aJU=;
 b=HCzvA6jDLHAx9xWYfG9dvTQeVydMuOUgTk5+IJnwBEkqMSKHjN2mNT5wVkLVgsXcYmrWyrPOW5XlLigPFWoO/dDCs3crGzM5WFNaiGrnZJUoz6Ny8Vtb3qqi7I6XX/QSRZmrXqSsht62soAO4+ezh7rwWnvg46MWDLpqoNQF9fes6cWkZ/79FzfeqUkkSMZfJMZuR4dd0JjDE4vovC7ezLlgo4Z40U83B5yfbpYoN8iNo/zPJeVbmEI0aGIlkErtYXHBTzrFkOHZkcCaE7iAOJUpSeimI75ei24aoNQ+RcUH+ZbHZYL4bRF02DAX41Yd62y6o37JcstdVtn20dNW2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 222.71.101.198) smtp.rcpttodomain=bootlin.com smtp.mailfrom=cixtech.com;
 dmarc=bestguesspass action=none header.from=cixtech.com; dkim=none (message
 not signed); arc=none (0)
Received: from KU0P306CA0078.MYSP306.PROD.OUTLOOK.COM (2603:1096:d10:2b::10)
 by KL1PR0601MB5840.apcprd06.prod.outlook.com (2603:1096:820:9a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.10; Fri, 28 Aug
 2026 03:15:22 +0000
Received: from SG2PEPF000B66CD.apcprd03.prod.outlook.com
 (2603:1096:d10:2b:cafe::44) by KU0P306CA0078.outlook.office365.com
 (2603:1096:d10:2b::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.10 via Frontend Transport; Fri,
 28 Aug 2026 03:15:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 222.71.101.198)
 smtp.mailfrom=cixtech.com; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=cixtech.com;
Received-SPF: Pass (protection.outlook.com: domain of cixtech.com designates
 222.71.101.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=222.71.101.198; helo=smtprelay.cixcomputing.com; pr=C
Received: from smtprelay.cixcomputing.com (222.71.101.198) by
 SG2PEPF000B66CD.mail.protection.outlook.com (10.167.240.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.3 via Frontend Transport; Fri, 28 Aug 2026 03:15:20 +0000
Received: from JohnnyFan (unknown [172.21.64.24])
	by smtprelay.cixcomputing.com (Postfix) with ESMTPSA id 883B3427CEE0;
	Fri, 28 Aug 2026 11:15:19 +0800 (CST)
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
Subject: [PATCH] rtc: efi: restore alarm support with runtime capability probe
Date: Fri, 28 Aug 2026 11:15:19 +0800
Message-ID: <20260828031519.2749354-1-johnny.fan@cixtech.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SG2PEPF000B66CD:EE_|KL1PR0601MB5840:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: b529b02a-e9ce-41d7-ca80-08df04b297a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|23010399003|36860700016|10067099003|3023799007|6133799003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	XGmXNn8rjr2S9JSS5z4/s6uA4NMzqcK/T3PaMTzYZNzPkDkMr44DHBHMofHugcFFWD4qPyyBdkYS/X7pyde+cbUY2xFMH+6YlJwISW9/MDX9m/GbK6QPW/9Dfx/eY1hVWGe6Sjv+6Gv+Ike3aMCcTuYjfJ5ngG45T1Aqpia5HikQrUXAC6wzlZyNKpB4w7sDE55qZcuB0IxwVDHQi2hCUr3aGyMg6W5RpRbRYB6yf/IcJcX1zXLvYAur+5OlotVYPB9X0hJ1oXVjfaObsCCorWhTFOYpPo6WQvl4ZIQnO09+lyl9SlcgQCC28HCBkx534Ehqj6/ASBQv31892BjA+ozu9JnXK1y4F/f5BWfto0Afoc3rSE1LaNMmhGcGD8v9wWDTHAl3/bybKR5f9216QL1SvAWvrmMR5Xo8szOk0IzwhA+enG00AZTph5ddigkY4k2vPSz5OS5yZVAUUDmXbxLBVziz3nwEHhsakKr0tGGGY3HTjHwnu0Cme+pu2yn6lJ4DfY6LYGUkTW7y7jKcsalU1rstuE+hUcNJQZdm2zUpZ7ZtRltYWw+B0rzZSBJTO7CcNWFTRXWUv6/1ldXrdLqzFH8BfYkstKFt2/4ibfAdQdBbAyfYotDIWWZpKlo5ZGJv0SY2Rz+hNsqPSacbJvT8FTXProJsDnNoyaPj+v6LdEU5gylkZhzISLJE1VAwwHEN44h3jPyG7+fQhINvAQ==
X-Forefront-Antispam-Report:
	CIP:222.71.101.198;CTRY:CN;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:smtprelay.cixcomputing.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(23010399003)(36860700016)(10067099003)(3023799007)(6133799003)(18002099003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cWnMELRHE+tX5co1KpzCEgvhmfslgpgk9JaJv7XzMA9hz4Pn3m9KkYpnOyMB1MbnzcXDBN7K/b/wWarj1cdz3iwEGJ5+uaetgp9ZSWtt5AzZaFYZzIhgt4H/IHdf4ouOtEipW8Rt71pQFD8wx8AYdhrWD37sa/bF6T3b1G8nEnNK41QCKlGpqf20iGymJRG59gbTPU3S3PdHd++RhoEmqQmBIh3mGw0Cxi01P5HiY4MJxmTqMVkMoaUUQ56mAbjDVbo/adQseWUp8SiUx1eDo55rwkKgiLzWymQfkKhjU/PVvhhZeHmFLIFK1vQBNxWYYYghiBTbMdsbzs77sySgbRME0BbuLaoR/F8yb32+OI3hyEFu7ucTPn+7PND9ip/3LUybB4ZvEoE+lbVVzCWI8tgErlXMMxvKtQmGceH8Vi0Y9v7nLkfIQ26b28t9cqDP
X-OriginatorOrg: cixtech.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2026 03:15:20.2929
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b529b02a-e9ce-41d7-ca80-08df04b297a5
X-MS-Exchange-CrossTenant-Id: 0409f77a-e53d-4d23-943e-ccade7cb4811
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=0409f77a-e53d-4d23-943e-ccade7cb4811;Ip=[222.71.101.198];Helo=[smtprelay.cixcomputing.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SG2PEPF000B66CD.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0601MB5840

From: "Johnny.Fan" <Johnny.Fan@cixtech.com>

Restore the EFI RTC alarm functionality (read_alarm/set_alarm and
procfs output) that was removed by commit 18a3510bc87d ("rtc: efi:
Remove wakeup functionality").

The removal was motivated by the observation that many EFI platforms
lack RTC wakeup support while also omitting the RT_PROP table, causing
the wakeup capability to be incorrectly advertised.  While that is
true, removing the feature entirely also breaks platforms where the
wakeup runtime service actually works.

On CIX SoCs with an I2C-connected RTC, the firmware owns the RTC and
exposes it via EFI runtime services.  Using the native I2C RTC driver
under Linux breaks Windows, which relies on EFI runtime services to
access the RTC.  rtc-efi is therefore the only viable option for
shared RTC access across operating systems, and it needs working
alarm/wakeup support.

To avoid exposing a broken alarm on firmware that does not implement
the wakeup runtime services, probe the capability at ->probe() time by
actually calling GetWakeupTime() -- if it fails, clear RTC_FEATURE_ALARM
and the device behaves as before the removal.

Also set RTC_FEATURE_ALARM_WAKEUP_ONLY since EFI wakeup time is a
wakeup-only alarm, not a periodic/update interrupt source.

Reviewed-by: Fugang Duan <fugang.duan@cixtech.com>
Tested-by: Johnny.Fan <Johnny.Fan@cixtech.com>
Signed-off-by: Johnny.Fan <Johnny.Fan@cixtech.com>
---
 drivers/rtc/rtc-efi.c | 78 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 76 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-efi.c b/drivers/rtc/rtc-efi.c
index b4f44999ef0f..708cba43435e 100644
--- a/drivers/rtc/rtc-efi.c
+++ b/drivers/rtc/rtc-efi.c
@@ -112,6 +112,34 @@ convert_from_efi_time(efi_time_t *eft, struct rtc_time *wtime)
 	return true;
 }
 
+static int efi_read_alarm(struct device *dev, struct rtc_wkalrm *wkalrm)
+{
+	efi_time_t eft;
+	efi_status_t status;
+
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
+	status = efi.set_wakeup_time((efi_bool_t)wkalrm->enabled, &eft);
+
+	return status == EFI_SUCCESS ? 0 : -EINVAL;
+}
+
 static int efi_read_time(struct device *dev, struct rtc_time *tm)
 {
 	efi_status_t status;
@@ -146,13 +174,21 @@ static int efi_set_time(struct device *dev, struct rtc_time *tm)
 
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
@@ -168,6 +204,25 @@ static int efi_procfs(struct device *dev, struct seq_file *seq)
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
+			seq_printf(seq, "Alarm Timezone\t: %u\n", alm.timezone);
+	}
+
 	/*
 	 * now prints the capabilities
 	 */
@@ -183,6 +238,8 @@ static int efi_procfs(struct device *dev, struct seq_file *seq)
 static const struct rtc_class_ops efi_rtc_ops = {
 	.read_time	= efi_read_time,
 	.set_time	= efi_set_time,
+	.read_alarm	= efi_read_alarm,
+	.set_alarm	= efi_set_alarm,
 	.proc		= efi_procfs,
 };
 
@@ -191,6 +248,7 @@ static int __init efi_rtc_probe(struct platform_device *dev)
 	struct rtc_device *rtc;
 	efi_time_t eft;
 	efi_time_cap_t cap;
+	efi_bool_t enabled, pending;
 
 	/* First check if the RTC is usable */
 	if (efi.get_time(&eft, &cap) != EFI_SUCCESS)
@@ -203,7 +261,23 @@ static int __init efi_rtc_probe(struct platform_device *dev)
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

