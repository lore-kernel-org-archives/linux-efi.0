Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013021.outbound.protection.outlook.com [40.93.196.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAC74A1DED;
	Thu,  8 Oct 2026 13:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791465975; cv=fail; b=mRB6yNRhKdKTsIsgTSIfVgPQdLS2veRsFt2ngVdYsNsvQVl2IAbx2/rmItWND+indBB1PQsP8defP/niMrIE/H2IlZ63cKPFjPjrBO5X1AZ0IiwNztYDfXHo40JxsN41OjCSivwDO3VFUprOY0RwI3uSCwnQakFxFRIiSuklhyo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791465975; c=relaxed/simple;
	bh=OaVmmX+jHC9jNR/x0gGjs8Ba3D4+ropUsmUC22Fx154=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BpI6iMnHwfr3+wMBjsivnBAEZ9NaASjh/QJFY2pIoHY5ZAE3jQZQ0INgmmB7IrM+H8kzVUvWuJKgvEoJCSuVkCd9/DiR1U339EKNvRLTVTYiHUbnfTuJE8HcW0un6LI+CiKtLvyen+2Quski2EuqItagsJtNyVtIavr/2RPQtVQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CE1FQJWP; arc=fail smtp.client-ip=40.93.196.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CE1FQJWP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EJvFMVy/H1buR9qwxCdex0Zj0MJPqCkGCcsLK8CsVJxgbNDJwzGFgn73qHT/Ngrca334PEXiZ0nXaGH5xGuj3G0EZdGqzT/z0vj5PlWncE3eoKmtKn11OoTvSX1GtLh/WZrD/A2zWtliZq958P77ZOxxVRyHqF9NwHtb3cO2Yd2DUrgBoOlPFL7+Ptg4QGb9n05Gdapg2htzX4opgfDe6CdHm8q9eIbXxihpE8dB1QmR1S6yuJ/XHMKgFsjyYeeCuaY/ReIH6LWd8a5y9Q7H5dIhR6LS64/gH2dDGl5dgObcDaoVaqZUbTvHhKOnDcWPF0X0+ladmSA4f/lZRUuzkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qw1ERBSoqW6FIKRb7LYj8YjXA2JqjavWas4ellUlXqI=;
 b=iKZsSmdz5gbxAvHxj2H7jJURezz5kPwDozq/0hgfYp7JwXD/AkT/Y8O/0BGeuT58kaAlX7pd+j7ewCtPIJ97veP6ckvaIre2efzBNSTOIS/c06CxhqHM32r0SYkjihRA3ewcbwmwnvYQKobk1JXGWGQUTrav3uQvDKkq2M6spWFpl/qn5C+878PqfWjLF8CVhgR/loX4r/ltGmE1078B9eGOVDQYMs3tjPwE1M3KBfUq/N1ObT5bD3kaMwBYLxAq1Bk9IvvMi7Ohlq7xeaikwprhJHi9k4voEiVRh5kx0T1fMSgnMaOIHAv12D8Uou/wPAkVRettLDY0Tx1KvzdO/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qw1ERBSoqW6FIKRb7LYj8YjXA2JqjavWas4ellUlXqI=;
 b=CE1FQJWPr8Yc7kv9tigWi8PXs0/Hw4RQxcLGN6XaDhbzmPxORtPlgrI5gS/YrI4nQnrFZRf7lEVnHnI8ExMihlKuW6dkdnWH6i/ci8oTCz+BTnFTwOpza+gC4LP4kJTJcnfu66/N5vL4NTQ+eClEEmF2urbDbJ6zpJwA6pI0AZ6S1q52ySi7nWuHm8nirq3BcVruqfdzt1R1KUdR/oomb7H69IYI9sQofZJBC83FUs6GJ2n6QpqZO7VtJ8gdSPhlY302mAOfbAy/3VTrVPhtpYOmm/kNVkmSXkbu41xMWKBP4aow76fuwIEKJrYIiPbYNVeZ5ijJQ5EMZsh4pTc3Vg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH8PR12MB9741.namprd12.prod.outlook.com (2603:10b6:610:27a::21)
 by DS4PR12MB9796.namprd12.prod.outlook.com (2603:10b6:8:2a2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Thu, 8 Oct
 2026 13:26:03 +0000
Received: from CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7]) by CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7%5]) with mapi id 15.21.0472.016; Thu, 8 Oct 2026
 13:26:03 +0000
From: Matthew Garrett <matthewg@nvidia.com>
To: mjg59@srcf.ucam.org
Cc: keyrings@vger.kernel.org,
	James.Bottomley@HansenPartnership.com,
	linux-integrity@vger.kernel.org,
	rafael@kernel.org,
	linux-pm@vger.kernel.org,
	linux-efi@vger.kernel.org,
	Matthew Garrett <matthewg@nvidia.com>
Subject: [PATCH 06/17] tpm: Use TPM2_NV_ReadPublic to read NV index names
Date: Thu,  8 Oct 2026 06:20:22 -0700
Message-ID: <20261008132532.1155166-7-matthewg@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261008132532.1155166-1-matthewg@nvidia.com>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0221.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e4::18) To CH8PR12MB9741.namprd12.prod.outlook.com
 (2603:10b6:610:27a::21)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR12MB9741:EE_|DS4PR12MB9796:EE_
X-MS-Office365-Filtering-Correlation-Id: 02766454-c270-4026-814b-08df253fb324
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|22082099003|18002099003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	pmJoGu/ZDEJiKPn/VTdUoDRQE+EAsG0LG8IHQ/rNPJTZXEP4qOoXvtMWbN2MjZ1bI4uuZdOVHPf9Mm3ANtew3niv63iTxcp5nilk06MuJCASzyGTFPR8os0+xEowMgiTtuSxn+UWtv63JR8YaN4qtfsrv4WYOxEGALJ1WCeFzZQMPq0+JuxDp2vmTSUn4+JtXcIAs5Ybj6Coiz3tQYSxyH73+evAw/qiQ/1ftpDe2NqSaf0nnDM3LF5kWtKhAaqWgN4zyZOvc0szSJ7hRhqT9uiL8FhsBHdo0zFCO9K//1wcYEo3bQUMdKYV+23/3oHSKI/gggtm1+YIyp7vl51BjMBk/ZJzulki927myukjNKWsna4rp4AkxdIyrmgrsbGew08BYuoctIRLhfT61Ouv6tPg8uTWuAPyXnUQGv+0nWrz1AYP7dNrnn3LaxUpS7+UtC6VEhfbioY/CLO324DU13V7m9cSwuA3wQjbYECxuQDZGglRWRmZkLTP3/2Sw5JFGH3uETa+SRk3blDUVr0J66+iPulkvOBoYSFWmqrOQ6dA9If7+Ck0EoDexVNl7IKo7i0EJ0lP040KIS+B/vQzgjzwabtMG1AI2kql0K3PRD8sNxjjl/tTyitTA6EMX812ZSZ96mtPcK/K5shPF7eTis5Jy5DkiPp5GA3Mv7SZxEk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR12MB9741.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(22082099003)(18002099003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?glwRredWqVkPgUkFw/7CSJf4qJVS5VWBGGaowAtDgWbHQlAIOxQuRn1TwROy?=
 =?us-ascii?Q?UPXsQ5AGcHoW86AJQyCVtFAQ9pn8fuPnmgozhYCPXd70EskpvBKESMfcn36U?=
 =?us-ascii?Q?rn+URGB1KmWC7THLFwT4rF47XmqYX8+bqWv0X2QpybpOP7iKVfwWFoCavJkB?=
 =?us-ascii?Q?GFQVjK8N9cn6Pzst6hjDSs4ej94AORXZt6AR3DbcEtoWMqgmF0yqGR+j9v38?=
 =?us-ascii?Q?KH9W7GvgSrE8Z3kF+8vHUdNjAvwE27iL35/IHwYsg+UqqSJsTAUFvIgbIqf1?=
 =?us-ascii?Q?PXeq81ndBlmzi/bVcQcxwPAAzPWLB/RGv/umXm7qmnvIdmMXZz+XXc4BwHbA?=
 =?us-ascii?Q?GIdVE4TbDq9PPrjKwIBzmOENpjhY5qv4brlW9ZEnwDubssD12e5+h0Ok3lHt?=
 =?us-ascii?Q?9/6dezD/neFmiRTWUi02WgArj2Qo7baxoQsHjvdT0xAtVxn/8ylBwz0T4MRL?=
 =?us-ascii?Q?EzO9Qlvjc3HPucyCErblrWE+IjWSyifhODJ/JV3erzDCBhdANeseoO665XZs?=
 =?us-ascii?Q?7+rVS4JLo63vQnpyXqaGbI6Sd/gtRy11gUYFHnAYoCsQ1jaCYBBO7UwDJ9LE?=
 =?us-ascii?Q?31S59kmKVafCLZJ9uBzIhfN+9BeoAp0jL9fu1AnRPhYZublSzAv6goasN+G8?=
 =?us-ascii?Q?5Fnl81aZknt8ZSvCzrerslXucmH4wjWhWW2D2WXPzxpcgJBiMvDSIYNGJoBX?=
 =?us-ascii?Q?p52oryQVzDg6DQS3CmCncAvds0Et1nLY/MzaAGrcnjyL/98MnSlqUxNaYH3Q?=
 =?us-ascii?Q?rI5egjUlM/nP0OnL9oaMNFhjoA+Rs6d6byn93EM/D59AhVHXocukl1ot2TH0?=
 =?us-ascii?Q?mBjKCqrEuPdvD7p106sHEvrGgBSISs8gn/4JiEu4dK0T52pdk1fh0D1J51tm?=
 =?us-ascii?Q?Kl5qURtZZYChyUvfoakhSIR/sJJDEvCU3xAvANpvU7mY7wE38Xk0/4x+7+ve?=
 =?us-ascii?Q?q3HwbVDHDcUAdvETF6uiUZefu+otrtZ3s/mqMgyJVvUULq4k8Rd/mnvgPWRP?=
 =?us-ascii?Q?twC0nPof3U16WuF0DX7dE+6c1zgDuG8hELnsGkpxRpLaLzQ2rbkrygYNlkpW?=
 =?us-ascii?Q?Ud7XXlkHDqdk8cq2tHUUIViajjPr0prJXvyXxZ3raxnjKzSWrKqKOsoD4bOt?=
 =?us-ascii?Q?IYA2SkCcYg//7Tq+tNV9K2FTB4vLCbVwupPSrxkKErDx9aBetMnm7xZeB7UZ?=
 =?us-ascii?Q?pdgMJR542zqksGTHB4/J1i5R+xkrd7nuiuly0ch+LwncDfijs//Y7q0x/eGr?=
 =?us-ascii?Q?9qIA/QQYJ+OpN6HUkUsYfhcbNz19CGCEmXWKKiNhWWIb2iDlsG/cFrZRQQCU?=
 =?us-ascii?Q?/ZSC1eruDCOxqnoXTjesGvAPEK7+Gl63oMa1hs1ocjZLDRwlceEPGUlgbTHS?=
 =?us-ascii?Q?qkIHvz7oP00nIwxToBJllxbXcFYaD86JAJFQR98me6xkFDugII8GHXIthjLa?=
 =?us-ascii?Q?EmQUYr8prJ1krr/B8j0F135E3pv6LDKQ4CGS9PYN2WbCXdkqm7RMd01NxFWI?=
 =?us-ascii?Q?ZTiwcLNqO3E1s2dQfJuQ8wBHKbScQ1d9X0HQ/t+nkXSI3IU/Ye8Om9Uu7rs1?=
 =?us-ascii?Q?iXI7x1d5lpVajTxORA+kHXBEbxIxB6QPyqn4Ft2L9848A1FT4R53L7fodwdx?=
 =?us-ascii?Q?bHQv2nsIiUxLJ1u95QisQhmFW2QSTRhvBi17rmOf0j4Wui1wyKsFwKPxy1Q6?=
 =?us-ascii?Q?l5RGUu24tI4SnkOm/2/CGViPUecYv3ybYbpEy1Lv9LlGS3fL0hO8TjNQ21he?=
 =?us-ascii?Q?bDBoB5q1ww=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02766454-c270-4026-814b-08df253fb324
X-MS-Exchange-CrossTenant-AuthSource: CH8PR12MB9741.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 13:26:02.9321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eaKO1NdBn7SGV935RA7orKM/4IeStAcAPWaP7/s8g6GpdBv1WxHynjcmTT0knA+rRz2bdaCb470V/4ZyjlH/JQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9796

tpm2_read_public() is used by tpm_buf_append_name() to find the name of
a handle for HMAC session calculations. It treats NV indices as needing
a lookup, but sends TPM2_ReadPublic, which only accepts objects, so the
lookup fails for any NV index.

Send TPM2_NV_ReadPublic for NV indices instead. Its response has the
same layout of a public area followed by the name, so the existing
parsing works unchanged.

Signed-off-by: Matthew Garrett <matthewg@nvidia.com>
---
 drivers/char/tpm/tpm2-sessions.c | 11 +++++++++--
 include/linux/tpm_command.h      |  1 +
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm2-sessions.c b/drivers/char/tpm/tpm2-sessions.c
index badc9bec9caa..e5ef30238fbe 100644
--- a/drivers/char/tpm/tpm2-sessions.c
+++ b/drivers/char/tpm/tpm2-sessions.c
@@ -225,15 +225,22 @@ static int tpm2_read_public(struct tpm_chip *chip, u32 handle, void *name)
 	if (!buf)
 		return -ENOMEM;
 
+	/*
+	 * NV indices have their own command, whose response has the same
+	 * layout: a public area followed by the name.
+	 */
 	tpm_buf_init(buf, TPM_BUFSIZE);
-	tpm_buf_reset(buf, TPM2_ST_NO_SESSIONS, TPM2_CC_READ_PUBLIC);
+	if (mso == TPM2_MSO_NVRAM)
+		tpm_buf_reset(buf, TPM2_ST_NO_SESSIONS, TPM2_CC_NV_READ_PUBLIC);
+	else
+		tpm_buf_reset(buf, TPM2_ST_NO_SESSIONS, TPM2_CC_READ_PUBLIC);
 	tpm_buf_append_u32(buf, handle);
 
 	rc = tpm_transmit_cmd(chip, buf, 0, "TPM2_ReadPublic");
 	if (rc)
 		return tpm_ret_to_err(rc);
 
-	/* Skip TPMT_PUBLIC: */
+	/* Skip TPMT_PUBLIC or TPMS_NV_PUBLIC: */
 	offset += tpm_buf_read_u16(buf, &offset);
 
 	/*
diff --git a/include/linux/tpm_command.h b/include/linux/tpm_command.h
index 486493efa759..9c393f98bac2 100644
--- a/include/linux/tpm_command.h
+++ b/include/linux/tpm_command.h
@@ -241,6 +241,7 @@ enum tpm2_command_codes {
 	TPM2_CC_CONTEXT_LOAD		= 0x0161,
 	TPM2_CC_CONTEXT_SAVE		= 0x0162,
 	TPM2_CC_FLUSH_CONTEXT		= 0x0165,
+	TPM2_CC_NV_READ_PUBLIC		= 0x0169,
 	TPM2_CC_READ_PUBLIC		= 0x0173,
 	TPM2_CC_START_AUTH_SESS		= 0x0176,
 	TPM2_CC_VERIFY_SIGNATURE	= 0x0177,
-- 
2.43.0

