Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.20
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795527173;
	b=tahQ2kfF4xgHS2j+pJFa8bkBqafsT78mmw9ollQJgxs6QNpwhXQ7r9Wa97YDltQcFpwE
	 r/dw9jIdAhuVqTWmSylH8vv0ZWWsJSP0W0GW6EKp9JFBq6GWIULOeKiTly7A1P0LkTOq/
	 eCwkLzOo0R6ZfHgTZR7Hnmni21PiZQOJV4WyOafxsU70oiPt22aApytAOWR2Rte+MRGTt
	 ccmw2ItpT1tjXUyrlf589UAfrrdqcGX+2aoMyN/FOInq3HikL56+/ED3ShnhZY8g1T6oh
	 STlQH6G3KuE2EQxWtRd4O6I502fg6Mrp+GPPrYeO1gCytFcwYCyLyM4xen7qObEzS1A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795527173;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=jx6/iZupPImBn9d5Q6xuznU76VtEEfanhryYdrgn884=;
	b=DKmtsgel3PLGnMjy/kXbHIXgXv9vFxw+LuoauLz4iHeNJMOXcIgVf1eRTZe2OinHEjvp
	 tBRNkvrsCWV4Fvk/LWJcYOv/pWjNLytlrOwV/c69BGydV8oLJrdLb/fgO+Y2jv+yegxXc
	 hxwrFaMcoLl3unlhZS+5Fwbdxvrle50JRNMffu9hrNo4ZOflswNfd8KZetjpBqU/xT3gE
	 iXHX6dRw+fR2TrTdXLCIk/nt5NmZIwuCxpfAfMIEDe309BAdCfVl0BJPB/2hHJXaAQwNt
	 uGVWZJgVggCzwy3vxoZRVV3pqNihkmRysLsRKwzfWV2pqm36NEMX650brsKimswRMbg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=heQXmhNv;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.20
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011020.outbound.protection.outlook.com [40.107.208.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8147B606A683;
	Tue, 24 Nov 2026 13:32:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8147B606A683
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=heQXmhNv
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ypWJLPsWBXzKnu3MMSd/n7tf82KEaja+ePa359IwcUxPkbWnxvRQcR1VR92QoZbzdBkqWzT4t1fQk9OVHOROFXnIcIBMOS0RWIj1PDPu2d2JWzdRgCxD1R4bYFl25qVfLbILzL9EmYjnL2EdYC5P/5IIW7ty86oq3iuK+4e/NtB2ZC7ZF9p1t7bMtEMJHRdw/04yjtubZHh40oyzMB1RraJLUgQ0LU25rdBjhtAI4RkVrao/tlqedunwQf4wC2VhNFKruk1XupxjPHIKe2sgFkm7Wt1x1KDUnbnpOhz80n7VKgXd252q2Mv8U0YWOvx5MYknG4fXRIJd4/NWY6eJ0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jx6/iZupPImBn9d5Q6xuznU76VtEEfanhryYdrgn884=;
 b=sajOBr/FxTqAV4O/V29uZ/5/TJIwhjXjOGVvEtrlJ/He+u4vySmP48M6WbFry/kXQsDNhho+h9raAfSsb4QS+FIl5F3X7pmvWfLPDnLP4hMKyglDpyaHyuikVRBaIJd+nsIojDwjewVLIidO/Bar8HlJZYhduBQQSscsu0lsskk0+qgx0Sk1qern+nN5WUv8HrHkbv+XI89jxIsLY0XOTO7sHI95jJ5SWDfhPebMPp1QlJU22JUDf3WucGJGIH6+hin2R6TfnyHxlbNlXZYMsqzcmIB+HHIy1sKLXxUnb8/X/wqwW0ERGnK5dWEdGzKCbewnu2jjp41+CMTn340mDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jx6/iZupPImBn9d5Q6xuznU76VtEEfanhryYdrgn884=;
 b=heQXmhNviaEb3b46Y2boY29By3ndZSzGM0nAlJ0Dt5UUfoDGTbSEuSOsO5JZ+JLOPAQtQ6PbSIlKJlvxzrlY/5McDfGReWxBdu37lXtHw6ycaLnljaZx3XCswkELhxb907DQlcvm6JFAFQseidJ6vdtlWyrFSvUF3em52cV00oA=
Received: from CH3P221CA0025.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:1e7::20)
 by SJ2PR12MB8110.namprd12.prod.outlook.com (2603:10b6:a03:4fc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Tue, 24 Nov
 2026 13:32:45 +0000
Received: from BN1PEPF00018547.namprd05.prod.outlook.com
 (2603:10b6:610:1e7:cafe::3d) by CH3P221CA0025.outlook.office365.com
 (2603:10b6:610:1e7::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.14 via Frontend Transport; Tue,
 24 Nov 2026 13:32:44 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF00018547.mail.protection.outlook.com (10.167.248.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Tue, 24 Nov 2026 13:32:44 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 24 Nov
 2026 07:32:44 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 24 Nov
 2026 07:32:44 -0600
Received: from pankaj-M75q.amd.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Tue, 24 Nov 2026 07:32:43 -0600
From: Pankaj Gupta <pankaj.gupta@amd.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>
CC: "H . Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	Ard Biesheuvel <ardb@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, <linux-kernel@vger.kernel.org>,
	Mike Rapoport <rppt@kernel.org>, <linux-mm@kvack.org>,
	<linux-efi@vger.kernel.org>, <Pankaj.gupta.linux@gmail.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>
Subject: [PATCH RFC 2/3] x86/e820: Allow memmap= in a kdump kernel in confidential guests
Date: Tue, 24 Nov 2026 07:32:40 -0600
Message-ID: <20261124133241.221719-3-pankaj.gupta@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261124133241.221719-1-pankaj.gupta@amd.com>
References: <20261124133241.221719-1-pankaj.gupta@amd.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00018547:EE_|SJ2PR12MB8110:EE_
X-MS-Office365-Filtering-Correlation-Id: 6198d17d-073d-4ec3-7f80-08df4a2f6c13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|23010399003|36860700016|6133799003|22082099003|18002099003|261009223027099003|261022105027099003|261022075727099003|261026140227099003|261026121527099003|261028144727099003|261021121427099003|261102123227099003|56012099006|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	YlUy3nrSYbkt78aWn00CWlEKtqERf7tX4W7TJfpCzzUJae4tVVIEGtXW5rA5hJMV2XCLEGeJOVJmJNgVDUWD2DIilJ0L5smBzpjzkn2JGQY/hzrXcsYwS5cYR3ec4YOn5syHZfFQv0q0eQilxmSaXuixd7IrMGrhMSGdiLBO+R7yTScnaGJxr3Ew3VuW07LIxyXRywv+iBK17UGFFykFSYr43rJ7E7d6dnAdzeD9qM1IKlUwmxGJG42iAfJ16JLifpaqVRUJsZJSxgZMwBp+V16J1VgH4oJMu9hmdB4+rQphT5c6SHWynEfQ6bJc0SUQc9/WHsq52+ISyKK5627FqFnEEI3gzbKxJKJyA6cQugr3bXQlYIcc0O8iVkj7gvNUrnOhis+Zr3Ll9urTXvYLP6lt77slrS6yvwPTBpEbpnq8cNgmcVpj40kMY4+HubPFq2BAfCeE1RCyCiFN+XF/0q7HWWKCBWInCpSurXt7GzNJ6iwwDdmefpbZbGe7yM0+VsZImjJEE6LDqQ+8fTND/VsCUvDRcE1JrPe7BC4cM7DjM/dvfjPzZc93J3vPrKMLND5gzdIxf74t3qJcCum2wIQgw3qeM7U3llDjiA9AsafsSRRkCnmEkATgdNfWqJxfgm4FsjenyRqkdqNFkEW7oI9h2AdVzOIwdj3ZgDdmjdUyvrH7DQjOy/xvBKzEPwNR6GURpy3BuBwAJHyVvE8VBg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(23010399003)(36860700016)(6133799003)(22082099003)(18002099003)(261009223027099003)(261022105027099003)(261022075727099003)(261026140227099003)(261026121527099003)(261028144727099003)(261021121427099003)(261102123227099003)(56012099006)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DrHkxlrEMLHwNamdYc52DTntJPW/tAdfdhyultOZ+Y2KEEGbcSuemVfsdfmtd/xWXRCk7PmFppZyVBfL+/uqqibLn+TRhUskE6i4DuiM8BFthbQVbpaNWx7mhfNV9ZsTdgt1b/OwL8GlwKHmTAQdOOxQJosPINKACePUpgVIqWEe2+qQjlWmXB4whxifU5+NjHYS4OJCt2skOVfhQpnDWZMN0PPXsAukZ3C3EsKf3Eyxbh3CYFo3mDo4RFtDlh6stBn1hLelBGghBZBGwT0Ece+GkBOSJZWoRNK0qJMWj8xIWCCkRvtwX4vNC57m8bSUsX7ke8zOLSe+t/O/NfQDzy3JiNlKgzeZWYhIL81vp+CItPrVxE5NaXQwyrKsrQi53YcQsJjL6WkmnoHWXeb8mvPQVsu1oFYsnExIixWhWF/kz4alRXJ8K3TBCTDsxo/q
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 13:32:44.6321
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6198d17d-073d-4ec3-7f80-08df4a2f6c13
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00018547.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8110

A kdump kernel can get memmap= on its command line, e.g. from kexec_load,
to restrict the memory it may use to its reserved region.  Ignoring it
would let the kdump kernel use the memory of the crashed kernel.

Do not ignore memmap= when elfcorehdr= is on the command line, which marks
a kdump kernel.

Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
 arch/x86/kernel/e820.c | 7 +++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 142657be690d..9c206ad4369c 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -17,6 +17,7 @@
 #include <linux/kvm_types.h>
 #include <linux/cc_platform.h>
 
+#include <asm/cmdline.h>
 #include <asm/e820/api.h>
 #include <asm/setup.h>
 
@@ -908,9 +909,14 @@ __initdata static int userdef;
 
 __init static bool cc_ignore_cmdline_mem(const char *opt)
 {
+	char buf[32];
+
 	if (!cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
 		return false;

+	if (cmdline_find_option(boot_command_line, "elfcorehdr", buf, sizeof(buf)) >= 0)
+		return false;
+
 	pr_warn("%s= is not supported in confidential guests, ignoring\n", opt);
 	return true;
 }
-- 
2.34.1

