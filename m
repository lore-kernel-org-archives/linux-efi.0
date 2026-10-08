Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013021.outbound.protection.outlook.com [40.93.196.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94434A43EA;
	Thu,  8 Oct 2026 13:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791465951; cv=fail; b=Fow8o8qTPdULmLDCRGYSB+Nl+MA5LAjVVojokxetlwQTBCYnvxq0vStQZ1Cx556pJ4/NIYS0vPM/IzuaoMQLR+JTvuCqNSQs3wyQOmaKDEumK4ZVvv7yNGAAsfr1vow0Ufx4BvLekin8Wc83EXrVxIEarM64JdekRg05IE5Oq4I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791465951; c=relaxed/simple;
	bh=6DdFO2Bc87UqZHGtJepqM5fOmUbWxexRjRBtsUYIwAY=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=eMWRNmzKxh+ZXGpetaxwyOhAJmesIwAHxQdsq95T+VuwpMCn2Trzh6r4lB71+uxvmviMksso8jxCDWduLRJjE4L1O17sH3ZO/oHdmf7fQ/dfZZCQ8vKg8bak1nxULzKaxYeFADqs6IjDzMSukKLydufe8WJfB8x8IV3NURV+sD0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ke9+nAXV; arc=fail smtp.client-ip=40.93.196.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ke9+nAXV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aTjCWzNOTXnPBcRZIJvYaQZk8Ij+X/XjRPZcyhXGn9v2zd+G/BLgp0TFdO62ImCqb0xNwSlVHn9kb7W8JknsUpyYPaXpO2IFOJZruKQZDlYbzugLIEZP1FZQJmwIob+L6iPYg5Y5hb/k3txxM3hBhy+qtjzKviIUq84MiKBrks8IY0MjNL4CUSqaVoNNhtwOASFPWJQL6voYR8GvkgdIDgue6wqVz75g00fMG3BTs893rHabQib4GgneUjOTl+hRlnQV+JkMFmeM9zyU6JaJ63H4v74LGkzV+u3PqZr6X9tAsxfbgjdhBomWB3Oq7/A/U3/tibdg0kZrb+99BffZEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zIATemvBmA+Q0oylSvdsTZAC83k07ipQncbAwWwBTIk=;
 b=HqgNxKNTV+LTsh5gVW1Od56fJ5xEhiXlhxYWnz98nauSbv7uR5/zTQVbDSDZUV/62f0FPDn5EQa/Wx1nlemclxvi15TV1pX+av3om8qih4EoihCOebnNdKy2zxLvuOVhBS/GCMCXzXDYqsic+FHeI81EDxx4E8tPposGR4dCa3j3FhKirUGySGQiIR5E59bAonq4E1jBZX/qiBK8D6x0bp87q3QpuiLUlN6gdX+8hTya57yROTn+fe84yzttytvH9SEf9q5Zie1gcbU28mVWVeM/zKr67/dj7E10zHBdoHyih402YIloXyHAxQtBiXSNWCtZq+92ywh/l0ejkpPuFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zIATemvBmA+Q0oylSvdsTZAC83k07ipQncbAwWwBTIk=;
 b=Ke9+nAXVD/KCPY+VezokJrXRh7HLaJjmoR2dKTN6lSe/TJRTN01Rl5A6gJOFvZXcocnW5tLiZxeZEUaTNavGd3UtY381Ijpt0hzdKtXV/ramF9ukTaUgCeyxqUtBLupvL8P4cUv8hKS9519Y5AqXBf2JhQU3heUu9zELIY2WeUNJDMZcPqrwreOpPkOkfDradpoAPkhk7Kp5Hmnfhx3FEhqdnCSkVuBaDjuo/eqHCZBX4Y4m3w667w1ebdXx2Vi7Y8wPYNLgIdqCh9cS3ZfPimAAs3nfic8BD6tFCBZFKWrexCEjtZnSmtXyFn9ldXEVWkP5Ixlon+GHT8pDQ2MmQg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH8PR12MB9741.namprd12.prod.outlook.com (2603:10b6:610:27a::21)
 by DS4PR12MB9796.namprd12.prod.outlook.com (2603:10b6:8:2a2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Thu, 8 Oct
 2026 13:25:43 +0000
Received: from CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7]) by CH8PR12MB9741.namprd12.prod.outlook.com
 ([fe80::43a6:8d0:7081:65d7%5]) with mapi id 15.21.0472.016; Thu, 8 Oct 2026
 13:25:43 +0000
From: Matthew Garrett <matthewg@nvidia.com>
To: mjg59@srcf.ucam.org
Cc: keyrings@vger.kernel.org,
	James.Bottomley@HansenPartnership.com,
	linux-integrity@vger.kernel.org,
	rafael@kernel.org,
	linux-pm@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: [RFC] Make hibernation work with lockdown
Date: Thu,  8 Oct 2026 06:20:16 -0700
Message-ID: <20261008132532.1155166-1-matthewg@nvidia.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0163.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:99::6) To CH8PR12MB9741.namprd12.prod.outlook.com
 (2603:10b6:610:27a::21)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR12MB9741:EE_|DS4PR12MB9796:EE_
X-MS-Office365-Filtering-Correlation-Id: 107f4602-b932-4c9e-e056-08df253fa754
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|6133799003|18002099003|10067099003|3023799007|5023799004|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	UhMDQJEGA27n/LrkuDlHLzfaRQ75IFS9htSeUmrWc1AZWvnSslrPJqiBeNukPQhc638W6HXcILl7+vTfk0XH3o22nKi8VmnTNsMErW2fhgjqi8snqXBDCspKRaKCl5xXnHJoXwD9iIi7P8dC7+1p7SQas5wwhzlay531bsQhMxKKBh+E/uI4JqCNfLgy0tOqX07Y/pg9bxWtbFmFPKYqPX/J9SCW4TQ0W7Z0ZwqscxAZb6ekJSp71JnkLeYNDAPDzZsxoCuvpkGg3MfHWoDo1fjN8EW0aqkWCaWM0VzpgwhJYKXo/eIOaxmHwfiDzkqq7Cv6ghFylMNqFGYa2mKCkhOTH23MXsMXD88QUxA7MOoxEdpKrL8qyZy3X5fiiruCCirsBGWyMdPKjYuh+ia0J5hN23FC5dWbHXyGovmjfJuxWd93VtKYXYjJVCG4WG1O8Df5JhUy5sNUY1EbN54nb1G1hQWSxmReLDJSWtn2s4awk8FbxuvhBDEMb3VLSutGCCvEQgbLGO1Khpj4Ho+v2VNdvZVVVycnYO1evQuS0voylda8hRY9j9iqWR4hJlbF+Ssb2irw8aymDQoUWqjhmbtTHzORBXjMI+vVn1dF7a8dL/ncLewC+x+fCvp3X5RFCdAcSKYl5Q+w912Kp8c3hRlv5KHd498QSHNnrXILCMg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR12MB9741.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(6133799003)(18002099003)(10067099003)(3023799007)(5023799004)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oB68rEPBRNPNH0+yxLDL6Yis3voOzPS/rZtRk/XtCMzKjqm+Iii/gMOcWdzS?=
 =?us-ascii?Q?KnUg/UYuewsTltv87ZgJyx8zaAz+KU9AR3bO45xzcyg07kfc4QPpMze0BGeN?=
 =?us-ascii?Q?0EqyvnRnZlw2Ae2nh1v0ux+GY0IiTLJDUvAp0lMs1uFRtaGY5gb2SFYWLQCT?=
 =?us-ascii?Q?a38FPAWDXpfcsHKW8G0b41nXELET2YbajHSrpRJWTlbovyaWok0EbQsMp97a?=
 =?us-ascii?Q?Zp7h44WsCouF7SPeR0dwDIfuKRQq0kq1Z0jgj8NNMCryqv4ou10DPca/rc3Z?=
 =?us-ascii?Q?b2Nxq6SLpOQhQ1Zl6DCJR9+DjGN1kV4OkWVsTEMj8DIkGO4GlMIh2xULg7gP?=
 =?us-ascii?Q?4FWlrB97oZs1ScKysRIdjs6c51EjArmn5QG73WOXasvKfQ/QL2FjTehg+OlW?=
 =?us-ascii?Q?Yx+1WCVSV7lTbrOOls4GiBVraAWup6Tkc0x9IL8LtbqLQKoClVFM1zVmapC7?=
 =?us-ascii?Q?ktPFn2fS7lHnSENO2p6UM5aTapevHpUu7nqQzpuYO4t0AOFNzwN7O0jtnrTL?=
 =?us-ascii?Q?Yvv7EdtoHKcuyDKGV5LZurYJxbbkAnXIUlt/jxzw4rpY5lP7oRLXHTtZXMnq?=
 =?us-ascii?Q?f1dwPwg3Ulr4ACyRwjIIHZgwtuDr/wJ9UCIe/wBi/6/ZV8gekOfuxBryIs1E?=
 =?us-ascii?Q?OGCnRfEOE4/apZpAt9wqpUsmmgHg3g+MB0cMrdP4KWI+LTkOoYHBJR1ZVgji?=
 =?us-ascii?Q?dAvuGkob2zdG0w7ECHWUsaoZGw9JAucFJ9FW5LDz+LLfSyTZqTFRhvTNARxq?=
 =?us-ascii?Q?3XGOlbgKVt3hBRCMwFSXFojjQOWibBOgHfD1Ws2oLNo1WgjdAG+Q2baVg5Sg?=
 =?us-ascii?Q?fMf+xLQLv3tfQdFtMF1tJcH0oHqQD2KucCQ/HZNSDtC1AqB2VeUaF3zwCLB8?=
 =?us-ascii?Q?vYDn29cD3HP8qCsnw4GGhTR6J3C61+XUYyMP4vNaf/XSWS8qGg8aZxeHzDjK?=
 =?us-ascii?Q?DJlp3AIL8jd2ZY57OW4+b4ka8VTtUpya/P+uWo7zwD+Cw21EmTmrv959vTGi?=
 =?us-ascii?Q?niz3rZBf7SJXJKQ5Hx7q/IPxFbMDVhzbEulnYIBly3+y+Ueymf9Fpu3bVeQX?=
 =?us-ascii?Q?bIpx5E/qRGPJDvVLsz2Rjs3Afqk2F2MAzVhjCKYK2ZxnvpItd0/QNlaRk/vU?=
 =?us-ascii?Q?7GjYfYg3Cg+212yXFOMsgAqhy3jxfTWDNmQApSTvJKglkJZpUKYif3IaRD61?=
 =?us-ascii?Q?YzkgPhJTmY6kicRJi7Jnnv/jxttASIczN0pz+NnueZbZPtq0isJxGQbaXxJ2?=
 =?us-ascii?Q?PKNRnlwUWc1jXdby+7xBxUARt/Od3d6nvarpx6RJ3RZsB6RLylJxHZY8PubW?=
 =?us-ascii?Q?lbgunApKrfeF0Qj6AIvJ7NB/EZNuxZP+y+qqFwOiEPc7jPwPq+/qdG2/QS9W?=
 =?us-ascii?Q?oZSGNRciQfsMLcrBO/h+xJJn8y+p/OAYVQ9KhigWKyi/R6Wk6i2dEllrFqw6?=
 =?us-ascii?Q?t2bpwFDnp8k1Z5bBu3LDoyqXLbAE/GqzSW8+8Kl6AUoEtD/h/KUWeGYngeK9?=
 =?us-ascii?Q?d9SvcmIqOTT6QwhL9XJVI2EB3GitzqFTbctsz6DQnW6ZjjNJSBsTyGBrCIFm?=
 =?us-ascii?Q?j8Mru3KNY5g6YLE0xXPneLrGrg/ccH42EgSAMSlTIvZ3zYtkpfI97refB36W?=
 =?us-ascii?Q?/x3mmk5piIJOKbRClo8jYX1tcJHzYJ8aUwe5U0MekSRBAVrcUWnZ1qIbl4Bd?=
 =?us-ascii?Q?AfglAqOQlLYZ2rG9liddjcb6X6cnTm6AV0eNZ2wHOwOYvxTf2+34E1h0Epe4?=
 =?us-ascii?Q?8dxXCifwew=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 107f4602-b932-4c9e-e056-08df253fa754
X-MS-Exchange-CrossTenant-AuthSource: CH8PR12MB9741.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 13:25:43.1261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1IzIjXFnnoMxqGDfy/pSaee5g49jmy6vkwead+7Gl2RBrLf5JqD4/eIEoqC+VvhkEPvs5iXSbEJVaSdU0feSRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9796

Hibernation writes out the full system state to disk in an unencrypted 
and unauthenticated manner. Resuming from hibernate reads that data and 
throws it directly into RAM, then jumps into it. This is effectively an 
entirely unauthenticated mechanism for putting whatever you want into 
kernel space. This violates the assumptions around lockdown (root can 
write whatever they want to the swap partition and then trigger a 
resume), and as such lockdown blocks hibernate.

This has made many people unhappy.

This patchset seeks to solve this problem. In order for hibernation to 
be trustworthy we need to be able to prove that the image was generated 
by the kernel and not modified after that. This is not an easy task, and 
requires some infrastructural framework. To that end, this patchset does 
the following:

1) Co-opts a TPM NV index for the kernel's sole use. This is currently a 
placeholder and we should register one explicitly from an appropriate 
range in order to ensure that we don't conflict with userland.

2) Does something horrifying with PCR 5 in order to prove that a given 
kernel supports (1). We need to extend and cap a PCR before userland is 
running in order to prove that the kernel has support for this feature, 
but since we don't currently cap any PCRs there's nothing stopping 
userland from doing the same and so achieving the same state. The way 
around this is to rely on a feature of PCR 5 - it is extended as a 
result of ExitBootServices being called, and since the boot stub can 
execute code before that happens we can perform the proof extension 
there and then have it implicitly capped by the firmware's extension.

3) Adds support for audited TPM sessions in the kernel, allowing us to 
generate signed digests of the commands that were executed in that 
session and their results

4) Adds support for generating a predictable AK that can be used to sign 
digests from those audit sessions

5) Adds support for generating a TPM signing key in such a session, and 
using the signed digest to prove that the session took place in the 
kernel

6) Signs the hibernation image with such a key

An old kernel that doesn't implement (1) won't be able to mimic the same 
PCR 5 value. Userland won't be able to mimic the NV index value because 
the kernel will block it. This means that the only way that key could 
have been created is by the kernel, and so we can trust that the image 
was generated by the kernel.

QUESTIONS:

1) I haven't tried to make the key management generic, since this isn't 
intended to ever be exposed to userland in any way. Should it be 
integrated into the trusted keys layer anyway?

2) Filtering TPM commands from userland isn't ideal - anyone able to 
poke commands into the TPM directly is in a position to violate the 
assumptions here. Is there any way we can get a secret into the kernel 
that can be used as an auth value? It would need to be impossible to 
obtain from userland and it would need to be consistent over platform 
reboots.

