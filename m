Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012009.outbound.protection.outlook.com [40.107.200.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8A34AEBEF;
	Thu,  8 Oct 2026 13:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791466015; cv=fail; b=lDYf1mGQ/o0C5GYKmv5VaQ/i1U5JMjpdyzENxiwaZJ+5SJW7RYRgHPSv4HI6rfpVqqH/RGir/r5x2Vwkq1f7zAgMSqjXcZCIkjb1B+O1fFis4+dCohGW/VozQObdonGzponNfgOdD3viCsDoKgTvY9rWmEP3N13yjscb4pgb+XI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791466015; c=relaxed/simple;
	bh=BO4CXphyyTT1GqWBLlwzD7uzTU8mhxi+OoEpIKpj418=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FBTTeBAmpngNA9cdltrrtmZpUr+r74OUHqVxm5I8Sp8570lWkbcvCIq+bUaHb7Rx7jhHDpmXOLWRHQWyqbsd48HNbcAZ4nUiFX15b62BhLxmgcCbTFm1lztqU17PGY49hLAUTpcuBkkN1ZpeQe/v/SjBCWIqWNzrAVxue1ikwuU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lks7NT6e; arc=fail smtp.client-ip=40.107.200.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lks7NT6e"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DGdj1JtuffmbODMfGJtEiqRLmsL3942aXEThcElqfizDx9TwCngBCrRX4xhzTwOaENw8xK+8AyuNf9aTDxLv0143IBxrjBRnSbC9ScvbvxUxcLBMog0YrTGbZrq6G4cGSBDytb3KjmWY+F/F01uAF+0p6euT55x11XOJYNmpkCS10vzU+Hm82YLHqYiYw1n7vj8Ato8fxfenjhTVveQqpW9kiLOHBca7N7YVa3ykCK9iR+rHG1iljwg/BDCzHBwVw1NIZRI7Jy46sTDMWy0FyO47c3kcawGZUg+8PNjOpsJE5eRv4rdownrfVL92/nJI++QPyGrTAE6nn8zq0TzFVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bZLaUhtkd89DKkWS1ZOPjATQTgQ1qLFeXidpvTlUnwQ=;
 b=y2TXWdHVvxOvIfQHOqsF0U2WZ3ZtZocz5xsNu0yErWmt7aEyJ43Fji5g2kXLrMBjhrnEriBjXRda/mjkObZ3pg90dLMD7034HnaCKoXAluxfAySUTRpTV7CweUNJ6C9dR9FeNXEitlEuRpRcyftFE1MYVAiChwfrwcDgtOlofLPsCfIICYDKEWw3FlX7QuWh8DmkdnrEU+hkDDEkjc5D1k2GOZZrQBcTDb6eDVY3Vla93ZTWWAcQpdY3fMJd0X3rpcCMsH0HaK103fRr8CLOgQCUhLJXPzCmWb8acNJ6N1cGTiFf1YR8gK2MCkquHYlPTYpBk6qRDy46wK3hsFLJrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bZLaUhtkd89DKkWS1ZOPjATQTgQ1qLFeXidpvTlUnwQ=;
 b=lks7NT6eACFQaxEAioHj6dGiSSfIKTFkrhLpnxBwVPd1IfylyTLnBVmT5WZqhVB+Qx/9sEDBeaCphpG++6WEHpdlJ5xPgTZ9ah3EVCLLBkUIkXEWm08nMJjQoPVpWuyS4lMnrfHUuG7lzmes7SlOCknB27/xO8McxfGRGqsiJAerfor6PriRv0E8AxqKPjyBfwrp7nglEYgm14EVvwUKMDye4jZaX293grKDCQuWKTyHkkFHRxVrOlZrjqhOTnjliAx92KnfHm2EDON0xlFPa7KzT5KmQ8vMcAYYtXNS4n4iiD0IDjwqDBUpV/obVUE/EkSxH/hxmFOEcdZEfA1bmQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH8PR12MB9741.namprd12.prod.outlook.com (2603:10b6:610:27a::21)
 by CY8PR12MB7587.namprd12.prod.outlook.com (2603:10b6:930:9a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.26; Thu, 8 Oct
 2026 13:26:37 +0000
Received: from CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7]) by CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7%5]) with mapi id 15.21.0472.016; Thu, 8 Oct 2026
 13:26:37 +0000
From: Matthew Garrett <matthewg@nvidia.com>
To: mjg59@srcf.ucam.org
Cc: keyrings@vger.kernel.org,
	James.Bottomley@HansenPartnership.com,
	linux-integrity@vger.kernel.org,
	rafael@kernel.org,
	linux-pm@vger.kernel.org,
	linux-efi@vger.kernel.org,
	Matthew Garrett <matthewg@nvidia.com>
Subject: [PATCH 16/17] PM: hibernate: Refuse to verify images with a virtual TPM
Date: Thu,  8 Oct 2026 06:20:32 -0700
Message-ID: <20261008132532.1155166-17-matthewg@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261008132532.1155166-1-matthewg@nvidia.com>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0250.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:af::20) To CH8PR12MB9741.namprd12.prod.outlook.com
 (2603:10b6:610:27a::21)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR12MB9741:EE_|CY8PR12MB7587:EE_
X-MS-Office365-Filtering-Correlation-Id: d50df652-1375-4263-b1e0-08df253fc779
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	4OWH7YYOb3RtiNUl+g4ai0PpjrZL+zbDus3T/VUUIcZvqFA7fwasSRKIcNRNiP5OtnqGtmw7EjsLfGgW/+bRWIRQnAZZnHt8EBQSQHXq/9j17/dH9uhmTetmrM8Q9jVl7NOFY/n6tHUfPA+Yu5iV8DZKFJ9Gqi3XEzL0yEF2jts9bo1LJiUFEQMB+VpJAzw3t7pMbDBbMqAIsAWZK/+YgPhbhjXOTL5HZrazqS4v2XWONHks5421oeVIOgJ/IS/eZARQfDzn7a7CrRr1ytcUPML1dJHUZhW8kR36W057AzasVV2cb6t+GsN9V0mYsOg/wl8FMY4V1OOtz4SFiOq0JzAlOWTiEmVg2MTPfWontdSM4vObp25QQVopdTItjt9VbuvlPuQ4P5WkJsHgzG0b5wdACJKfr4uE+ePooSUdyg9J6JNQzbHncktQLo9h5awiaARZNpJXyDxA5cp/8zBjnI2qKL0+ylveFAZR4xW5afUJAeRdrw94k/UTgfp636mne0tPkHOch0bVejJhG4JMSWEbOy8hUy0TMNpWpPf84IYQiigmkowQvU4iHutmo9cOHcBBQJ+mwpHKX1x+7AyKU87JrRyuVOx89xQgzYFdnJV7OAvAyW7ljeSFaVH42XGo22HWcATC2+sUXVU8+Dl9VR8RLCXa+/YFjnXVLUNdqHc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR12MB9741.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pvhTg7sojkIqqCn5WpuKAAxlYfb5kUe6a82pZ5Fyb5RKjHISPWhGnTv0t5YT?=
 =?us-ascii?Q?dMzC+O+36/Ph3PuKG7m841g4omxYWrGC/ezuZYOx3PXahOwxr8KF76FAtAi2?=
 =?us-ascii?Q?WHmqSVy9q4C8XS+ebJoUPOzr90EyP8vQuhsWQAJLfje2A0DDamYlW3fI8/Lp?=
 =?us-ascii?Q?f5I9SceB/VoJQ/jyHdUr3+Hg3SyF0uYX4fgPadc2gO76939Fp2SOV1CpYcoW?=
 =?us-ascii?Q?Xzm5pN//amSUMF+nZVvgSNrDptVZGlWygxJ0QKR8I+1bkFN6kzbDYg/SWrkj?=
 =?us-ascii?Q?C+JrkFie3P88w6K8C26Bli5/MhiC9HA3SquMYsxeTQQVeD1cSWMemN4LbjjS?=
 =?us-ascii?Q?dwYhwgkertMSYHLRzYkPSLvZ2KzXInKtGPHM2dLaBAKA8AyuSRl6oxfpSuV8?=
 =?us-ascii?Q?T5yWfeLTh4HujAujVbgi/kNM078dXeBEGaCQccNH3GSdGiQKB4Qkszm12yEr?=
 =?us-ascii?Q?1dgm3vArmx+oR5iqayp4yCaG1UgxsSEaIP8t5JAZYdPG9d4G5VoLYm7lSB3P?=
 =?us-ascii?Q?tO7h/jbRSMFdr/lhJhdtVst5KM+QpdNYaFz7bt28rCRStilJ2W8dJAhWr9ke?=
 =?us-ascii?Q?IHT6fA+IdZvcO6+62W/m6XM40hpikN3O925HbdcNqpGCXk1XMgHPyEsU/ln+?=
 =?us-ascii?Q?VHOlWFn1gw7zHr9yLH4cAI+ZL/XchLIiqN1X2GRXg00yxR6sItCA5NXebixm?=
 =?us-ascii?Q?uKEYmfasp9fTLfHWK8VOc9QwkOZSaQNUMxwQs4rFxdGk5mhww3Nxem9VsVQV?=
 =?us-ascii?Q?+NTnG8RvXmfryDkqAbWZXFVcPimDDLm8uMZtm/Xzm8Ca5L1fuabudbu3ijpn?=
 =?us-ascii?Q?KdDKWLolt75xFz2vPuFwhqrXHDQ9lnRDA5bFDxJVXBjcjQAVX6c9Oav1zhk5?=
 =?us-ascii?Q?6wzcTKzw4FAX2K4kg2iKaa8BI499c9qLDnelJtOU8u6jjHBo++gBvUcqpOFm?=
 =?us-ascii?Q?99NVJsW0lw78NhYps3aOsgJOty24X7Hx+WJhT6ARGxjq3tlER4yPnxqMKEJk?=
 =?us-ascii?Q?vWuy1Yg3h9iguG+UXENzbd3AY+kpMjovzbp6CEiGO9thQdVrSo4vTaiIXPUa?=
 =?us-ascii?Q?gX84eNyDJWhlVjfdy140hNr5ZenL8TbA6tJWzPH5tJGhE7xBlc0KSJ21O4ug?=
 =?us-ascii?Q?YlXKoziS7uvrgNW8nTWw8p/9F63HKREjcC2NcsXO+S6PfYvZAvv2xufQC0DX?=
 =?us-ascii?Q?49TuNcjIDkYtYZkOhIYHJwMn4FJfTcnFIM1gE3pqJPH3NK5IlCyqKqUGN/nU?=
 =?us-ascii?Q?D4EdaG2NcnNlHxHr3tHzENA+6215wTZa19Rh6FfySVjcAfAR2f4pnfDvyIZh?=
 =?us-ascii?Q?vh8slduYQiwlNfGIOLnRBk4lTiJogU07wCtyjeX1YH1Vk7q15Cu0Cayq/qdo?=
 =?us-ascii?Q?pOht6eiJuPBP+VD8/dSyl5hlIBL2hvnqc1thDwyVieYD9ju4XZeUIkHSppXU?=
 =?us-ascii?Q?7xZxw55kGokO4vDtvj1IigSniDln8VBeXLsPU8GzRgSfPxr/ejUFWNpHYx5P?=
 =?us-ascii?Q?VcutanEkVaYE3mlQcENR45+csI9JCaxJlTDuOLSYFDSSt2eRdAb5A7uP5nMP?=
 =?us-ascii?Q?1Bxp3wfAjcp7rrx7v4kYUykBLuSkdsGgjS8HNKkX/2zQzXN2hVZSTsXoMEcd?=
 =?us-ascii?Q?afz3TEPrP74XiHWaZO6LaMLhVimC/Wxrjxd2O50zRm3M/rP4FkiHJbryJh8S?=
 =?us-ascii?Q?wTetkWYy/CU7T0SoyCWpbziWb15rv6XzzHn6uTatnCAVboVrhgEsX+1GUnnQ?=
 =?us-ascii?Q?L/IjFCKZAg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d50df652-1375-4263-b1e0-08df253fc779
X-MS-Exchange-CrossTenant-AuthSource: CH8PR12MB9741.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 13:26:37.0474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kD54XIKtN08QfIdvHM4dw3e4XQzBJiWbdPWXJ6MAfh9mwrR+xsZV5s2TB2IsEUgkeHamH5vfOY6dKAe5JvFdDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7587

Images are verified with whichever TPM tpm_default_chip() returns. We
don't ensure integrity of initramfs, so an attacker can unbind the
hardware TPM's driver and create a virtual TPM through /dev/vtpmx in its
place. A virtual TPM can answer verification however it likes, including
recreating an AK of its own choosing and reporting any PCR 5 value, so
it can be made to accept a forged image.

Refuse to verify images when the TPM is virtual. Add
CONFIG_TPM_HIBERNATE_INSECURE to allow it anyway, for testing, but never
while the kernel is locked down.

Signed-off-by: Matthew Garrett <matthewg@nvidia.com>
---
 kernel/power/Kconfig         | 12 ++++++++++++
 kernel/power/hibernate_tpm.c | 14 ++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 2ff9f807ab5a..2eb6af9226f7 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -134,6 +134,18 @@ config HIBERNATION_TPM_SIGNATURE
 
 	  If unsure, say N.
 
+config TPM_HIBERNATE_INSECURE
+	bool "Allow resume using a virtual TPM (INSECURE)"
+	depends on HIBERNATION_TPM_SIGNATURE
+	help
+	  By default, hibernation images are not restored if the TPM used
+	  to verify them is a virtual TPM, such as one provided by
+	  userspace through /dev/vtpmx, since such a TPM can be made to
+	  accept a forged image. Say Y to allow it anyway, for example for
+	  testing. This has no effect while the kernel is locked down.
+
+	  If unsure, say N.
+
 config PM_STD_PARTITION
 	string "Default resume partition"
 	depends on HIBERNATION
diff --git a/kernel/power/hibernate_tpm.c b/kernel/power/hibernate_tpm.c
index 96f01c80f3cb..43f8d7324360 100644
--- a/kernel/power/hibernate_tpm.c
+++ b/kernel/power/hibernate_tpm.c
@@ -19,6 +19,7 @@
 
 #include <linux/efi.h>
 #include <linux/init.h>
+#include <linux/security.h>
 #include <linux/tpm.h>
 
 #include "power.h"
@@ -164,6 +165,19 @@ static int hib_tpm_check_header(const void *data, size_t size)
 		return -ENODEV;
 	}
 
+	/*
+	 * A virtual TPM, such as one provided by userspace through
+	 * /dev/vtpmx, can answer verification with anything it likes.  Only
+	 * allow one if explicitly configured to, and never under lockdown.
+	 */
+	if ((chip->flags & TPM_CHIP_FLAG_VIRTUAL) &&
+	    (!IS_ENABLED(CONFIG_TPM_HIBERNATE_INSECURE) ||
+	     security_locked_down(LOCKDOWN_HIBERNATION))) {
+		hib_tpm_put_chip(chip);
+		pr_err("Cannot verify image: TPM is virtual\n");
+		return -EKEYREJECTED;
+	}
+
 	rc = tpm2_kernel_key_verify(chip, prov, hib_tpm_x, hib_tpm_y);
 	hib_tpm_put_chip(chip);
 	if (rc) {
-- 
2.43.0

