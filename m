Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012009.outbound.protection.outlook.com [40.107.200.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62ED94AFE27;
	Thu,  8 Oct 2026 13:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791466021; cv=fail; b=CbunHBx3fH+XOQ+fFWuQYjLwUCziUx/7VQp3BPFy+yzl9r74JeOXxinF/4MGcKMGLV6hNcqVoY8s8rFBTR0MPJyZODXOEF9bxJ/jA+hnUmINCOm4MiUYZ7POAFBQWuJslLTYJuCmmfIx5seJXT1chFYI1NxsvJ98bHatf2KDZks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791466021; c=relaxed/simple;
	bh=2BNNpDvy4yFForZqa5cdwlBy5hg47iUFlLSfkJvc+hU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PC5LW9XxWdPWRidu+rHrlOi9iQzog2hcIG+CHC7ltXCE5Gd5m4ml8r/vpKz/b1Jy1SQlW0xuFzWOYImNy77CSrYt7sfGFZ+U0xbz/ygTaULNcO6/BNtCIbnE0r1/ZPHLs62aW94alVusYwL+0nRp0/2THjkvQNsoCmTA64znAyM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VZNb/RJX; arc=fail smtp.client-ip=40.107.200.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VZNb/RJX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iXR6zwqmaEwaZ4MWXaXxJMsmfRFX3WFUnws+9LdbkinmVtJx1QA6L55VixCriNHRyw7RQ00Mu0wyc5TA0ObQ4daJPFNvTl8EM5yCAkLIMlMXu+j/1zARgtrAd1BxtSxXgPJLFFOyb0q+BwFyu3wnlAAxyvAgCMjrewFxgJt3Guplk+/Zt+rVzR4hGL8488J+/QjzcSC/i2xyw+MOw54lxxdGgzR9hYKGc+xD9EEKO5GuJdR+3F0LNYSaHf5q0d6gp31ijvIq5PTSXA2Nxd9zLRrNUysr10rhQTPOoU4CcK1mzPgh+dC6wVSzUyozAEBRHetHOvth79rITTr1p/NBlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ScFUds3eMxwaJgMvUB/+Bg7QNl42/uGyueA6K8heTLQ=;
 b=bvdcGPgqBzklWEcME95xJrTZoVEuaG8Fzz4N3rQQXyL1iY3+NLtdDPcnUJ1waA9vrAB7BNlAzSiR+5X6qHOzTxNV/6U0huGV5l7t4D9wxE/FpCrpliw2h2FhUiOQhOIdhy9B2+33dDxSHghPyKI0jwZuN+9HtLXJ2r50tfKqcoC2F28RkjILCfh/RxZ9p+iNyUOwM3a5hPZAhe+SziM3fm5Akvt73Xb/NH/TAZwasPfNCIAAizscJlpOMhpGmmuCRhmohkLXMWuO3Vq8Df2UnFb/BQa0lZAkmf+eTxLxmroUJoBj1hRvdPiP5RKi7RUQu2fX9MP+yy7A+v/XUYtiZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ScFUds3eMxwaJgMvUB/+Bg7QNl42/uGyueA6K8heTLQ=;
 b=VZNb/RJXyxxJCmYBH4pzW3sf970NbnNKFF4Ym9lx0QTexBjOcPby/HqND53kXI2+wW0InZTTZq5crDAuZdNrJMR8SZIdAIBmiee7gh7hhR+3cdoCQbTIeZv3GOx4qsBw2eGuB9Gdrpq6pzl9Yrtm2PIaKV9p/UBDAhcXY7otGS7sRVm2WKP38Qu/PxM1+rf5l2wp/QTCTc02pWYbNJv9Dfjpf//62RvJUQUcy4TYHEenUdawxdgEODTwMUaoQ3I8MO8WA5b2rQckn3tAm7k9tP3Z0hwuC4YP2NsGNBptXSj1tD+2q+ypxKa7zgZBWqmXPA7a17a0+TNLDT+SJmFLBQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH8PR12MB9741.namprd12.prod.outlook.com (2603:10b6:610:27a::21)
 by CY8PR12MB7587.namprd12.prod.outlook.com (2603:10b6:930:9a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.26; Thu, 8 Oct
 2026 13:26:41 +0000
Received: from CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7]) by CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7%5]) with mapi id 15.21.0472.016; Thu, 8 Oct 2026
 13:26:41 +0000
From: Matthew Garrett <matthewg@nvidia.com>
To: mjg59@srcf.ucam.org
Cc: keyrings@vger.kernel.org,
	James.Bottomley@HansenPartnership.com,
	linux-integrity@vger.kernel.org,
	rafael@kernel.org,
	linux-pm@vger.kernel.org,
	linux-efi@vger.kernel.org,
	Matthew Garrett <matthewg@nvidia.com>
Subject: [PATCH 17/17] PM: hibernate: Allow hibernation under lockdown with signed images
Date: Thu,  8 Oct 2026 06:20:33 -0700
Message-ID: <20261008132532.1155166-18-matthewg@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261008132532.1155166-1-matthewg@nvidia.com>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0265.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b5::14) To CH8PR12MB9741.namprd12.prod.outlook.com
 (2603:10b6:610:27a::21)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR12MB9741:EE_|CY8PR12MB7587:EE_
X-MS-Office365-Filtering-Correlation-Id: 5315b58b-1341-4b5a-60af-08df253fc9b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|10067099003|11063799006|56012099006|3023799007|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	giYkCp2z4rpacQAye33o1wiini3Wf4X3C7Xvo3SYfcLPMrdWibuLCuQ+KFbCSs8S20A+gPbWBc3mYmLS0xKzoWwDPPiyqQdgOqefJmsB2b1f1HVEbI3m6w6l32dbz0bgd1fJ5LP57j36mJKjekdARr5/zApp6G6HdPXZHBIsmrps60GpwQBU2gcBsXDnEBQfMMunH6k7vcCX8ZjpP+pUjYS0x3RlQIFaVXEGDv/8dQooQB+cimBJuJfNCIkKY5jy/eK5ZPiM22dVo7IYaqYjj6kAmccx8ffA5kCiZH42KL5sDaImZ6ABgqgQ2oXO0vK9J+Ge+8vz7HOMK+qxH0WxoC+dztE/v0YUKPjtqWlmazes++AMKc+cYEfGIXYS3ci6J6YhnpUOvEHOQI2h9yulm+C9pPYIFTi+qyi56PAZMqMN1KYtjraXl1eMMujqURwIqJmFy+Ow+qgR1K7/p9EwiDSUg8dVlD6buE3WPYxZHBylsBr76unigYbcHQHzl71uVkHrJEy2rpVJu8QjAkhvQZg8+3LXpder2E58vMY5AIfBBfajKbVHjXJosMFg61iHDe4Ld0yM8ttiqExSBmNam2gtXKGcBPAADP61dvivH5er3SGtgf+9NgbwCQ0uGjsV0L+sKVE0vruVtBjYaU+x9ulOVoTdpaKRIO3nK8BLY9A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR12MB9741.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(10067099003)(11063799006)(56012099006)(3023799007)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FmduTQs1/je18bessquBcCQaY/NP1LnpoDXtH1X266ODCq0i/HmVlZhSAtlZ?=
 =?us-ascii?Q?rnQyXVMZKLRPiyxmtigSPawde9QrIHsaxnRQ69Sva7SiPJo7fJEEEuztXQKA?=
 =?us-ascii?Q?fHn89LSTjzIpnMessqatDhzM790VKtXVDFBpGKRLFN3QXS22NuS5QW9RIkFr?=
 =?us-ascii?Q?sKiogjZgALgvS4GNk9YlPgKNQfUQNHk316awXmGLe53I41uPmnykDI8atlkB?=
 =?us-ascii?Q?cSgmi/jUi2Kd8jTFSM8xPAwRHDGJQ2EFPDTeioihRVye1mEzhi31xKR5uluz?=
 =?us-ascii?Q?nhO8ib3EYHI7o2NwBoVbYkRpRuyQTlAu3ETt9eoXoSqe9zJDsA+4MDHGonvz?=
 =?us-ascii?Q?dzqKycfhce/E1q5ZDObZCmemwkxNQSA/z6pJVq0mxcxzgU20uj9CmHKT2cE5?=
 =?us-ascii?Q?9XbgsfYU6tyFgA1IHOZJqd11VOm/bxSaodeurW1jfiRJjeAy+vutehLEau/r?=
 =?us-ascii?Q?Cixn2k+QTYaAUH/iibOkEBzTodW2GHbiSw+lv9XJ3ko+P+nr/YSOhVPeknAm?=
 =?us-ascii?Q?i4fWGMOhTo0zSgH0lKV5nE+DGBn7tIMrK/vjM49CjQ8WPlZ1J8lCstBiyRxz?=
 =?us-ascii?Q?MaKkoupZYhEecdq8FHtelcPh0hyLHcW3+rN1RLI1VpAMtN1okF2XCwfdU278?=
 =?us-ascii?Q?udkNd7VlWmHpOpDoqz+wP4ByIdeTgX88HDvEL8A0Q1oLMbOpxInRVgnXrOj5?=
 =?us-ascii?Q?z7YSkyy/S/+oF7d/yu1TtNxDIWWKZXvnQZbcang175epma760dOUZJmaaA3V?=
 =?us-ascii?Q?0L7FXkWORO4i9zII1vYZLi3Cm2pRHG9khmEIg/nxDTga/QcKWfrNu0XH2UrT?=
 =?us-ascii?Q?Mj1Z1tgNlv3ZhFkruQ9t4JKEp8DOl0o1sM0cR9MoXpCfYfcNHLmPwLXqmXIc?=
 =?us-ascii?Q?AWB33J6O9lNaHSd4oPf7E7soLUSeKa/ITIoK53MiDGKAr3ekmwcIoom5dwPC?=
 =?us-ascii?Q?6D9iJrGJOmRK4MGjadNpHRoWhsLw4c5uLaaRzYYjuvdEFiFkp8VrXZDTh1JS?=
 =?us-ascii?Q?9dKQY++/W1hCwrl1L2GUCkk5yLrZ8l5DOanxbL8rBMTqujpq4mV1S+bREdZr?=
 =?us-ascii?Q?zEbaPSfj8k4eiM6VG+K6XUlGC2p+1ki/W7kQgo1ftusaT6/tPeaIdYWmQOQf?=
 =?us-ascii?Q?R9F1ZQJuyYlaBMgfmwkYoZkP7ODCPWG5llr5xcUILQkfbS/m6QREn6tFGu3E?=
 =?us-ascii?Q?NZS9EuBi+qEmpUogFpKjEP25nxD9nmQrhIEU8xkRF90TTVNF4DzBaRv7VE2m?=
 =?us-ascii?Q?VGYbnqSLPWGZ0bW3JFUos0LDxXPUsC4gal53f2lDFXtkgrO73/XlwTDTekXS?=
 =?us-ascii?Q?sWjZSehNjybjrTiR2vWTcm5mP94jIvQ9J9zYiwgfpCfSG4ky3s6VMj1NTF71?=
 =?us-ascii?Q?Jt3pJUzPXMEoVcgJlZRkNSWbcSZ2YXBPDKGTIFLFcYBBGe7YVjtTJb8FH2Y0?=
 =?us-ascii?Q?mK5Zrua+KS96TSgM4C7Rm75KOVu4BgHzxldjT0dthuy7pRFSos+7WaO/Cs5V?=
 =?us-ascii?Q?b0FJ2WIX9hTqrlBoHuCVJR/WjZlaotIn8gFMzO5aq4C1JDbRxooVf+vxmpBr?=
 =?us-ascii?Q?+zcl9hw/8Gw6axb+JMYA4tY6gKVq+oyzCvmjLSH1TeU79GFwOX1cJ2eVyUc5?=
 =?us-ascii?Q?Ei5LfoHzcpWY9F1Cj2boWUWRBMlhEmMTjq+JZLaMibDx4n/7Dz8MhI+cODw+?=
 =?us-ascii?Q?NeY/XXW51GhAsMG5GDorCqFaFuHFt0PN2xEsz/snwFksnSVZ8QbbTpPCYdf/?=
 =?us-ascii?Q?Z+oapNMoKA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5315b58b-1341-4b5a-60af-08df253fc9b8
X-MS-Exchange-CrossTenant-AuthSource: CH8PR12MB9741.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 13:26:40.8116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uhGrJ1ImL8fHmvNF+ixgA5D58/4QNn+iVRMSXgpsd1nPtbu7pFJFzvlkrrDvf2F4X90Yzg87BPLb5qfC/pq9Cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7587

Hibernation is unavailable when the kernel is locked down, as an image
could be modified to alter the running kernel when it is restored. With
CONFIG_HIBERNATION_TPM_SIGNATURE, only images signed with a key that the
kernel created are restored, so this no longer applies.

Allow hibernation under lockdown when images are signed. Images are not
encrypted, though, and contain all of kernel memory, which would then be
readable from the swap device or through /dev/snapshot. Add a
LOCKDOWN_HIBERNATION_IMAGE reason at the confidentiality level, so that
hibernation remains unavailable when the kernel is locked down for
confidentiality.

Signed-off-by: Matthew Garrett <matthewg@nvidia.com>
---
 include/linux/security.h |  1 +
 kernel/power/Kconfig     |  5 +++++
 kernel/power/hibernate.c | 18 +++++++++++++-----
 security/security.c      |  1 +
 4 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 153e9043058f..6b4dfe80501b 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -155,6 +155,7 @@ enum lockdown_reason {
 	LOCKDOWN_TRACEFS,
 	LOCKDOWN_XMON_RW,
 	LOCKDOWN_XFRM_SECRET,
+	LOCKDOWN_HIBERNATION_IMAGE,
 	LOCKDOWN_CONFIDENTIALITY_MAX,
 };
 
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 2eb6af9226f7..639dc124c17d 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -132,6 +132,11 @@ config HIBERNATION_TPM_SIGNATURE
 	  ExitBootServices() is called. If these requirements are not met,
 	  hibernation is unavailable.
 
+	  As only signed images are restored, hibernation remains available
+	  when the kernel is locked down for integrity. Images are not
+	  encrypted, so it is unavailable when the kernel is locked down for
+	  confidentiality.
+
 	  If unsure, say N.
 
 config TPM_HIBERNATE_INSECURE
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 256790aeca86..7bbef9c3ae1c 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -108,11 +108,19 @@ bool hibernation_in_progress(void)
 
 bool hibernation_available(void)
 {
-	return nohibernate == 0 &&
-		!security_locked_down(LOCKDOWN_HIBERNATION) &&
-		!secretmem_active() && !cxl_mem_active() &&
-		(!IS_ENABLED(CONFIG_HIBERNATION_TPM_SIGNATURE) ||
-		 hibernate_tpm_available());
+	if (nohibernate || secretmem_active() || cxl_mem_active())
+		return false;
+
+	/*
+	 * Only images signed by the kernel are restored, so hibernation does
+	 * not undermine the integrity of a locked down kernel.  Images are
+	 * not encrypted, though, so they would expose kernel memory.
+	 */
+	if (IS_ENABLED(CONFIG_HIBERNATION_TPM_SIGNATURE))
+		return hibernate_tpm_available() &&
+		       !security_locked_down(LOCKDOWN_HIBERNATION_IMAGE);
+
+	return !security_locked_down(LOCKDOWN_HIBERNATION);
 }
 
 /**
diff --git a/security/security.c b/security/security.c
index 2ee276ab15c5..5d91ca69bbf1 100644
--- a/security/security.c
+++ b/security/security.c
@@ -71,6 +71,7 @@ const char *const lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX + 1] = {
 	[LOCKDOWN_TRACEFS] = "use of tracefs",
 	[LOCKDOWN_XMON_RW] = "xmon read and write access",
 	[LOCKDOWN_XFRM_SECRET] = "xfrm SA secret",
+	[LOCKDOWN_HIBERNATION_IMAGE] = "hibernation with signed images",
 	[LOCKDOWN_CONFIDENTIALITY_MAX] = "confidentiality",
 };
 
-- 
2.43.0

