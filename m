Return-Path: <SRS0=LSKn=CC=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,RCVD_ILLEGAL_IP,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FF74C433E4
	for <linux-efi@archiver.kernel.org>; Mon, 24 Aug 2020 16:50:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 349002067C
	for <linux-efi@archiver.kernel.org>; Mon, 24 Aug 2020 16:50:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="MD0V6uU0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbgHXQtr (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 24 Aug 2020 12:49:47 -0400
Received: from mail-dm6nam12on2104.outbound.protection.outlook.com ([40.107.243.104]:1074
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728777AbgHXQtY (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Mon, 24 Aug 2020 12:49:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DFc9DhOWZAge5eWytkQnRaxK10Y3535vXV+2FdJDNi5GCl/Ad193ysEifR22z8n3Eqg4kafNvHNcilOHKdLZ1ZO95tdCDXzizMDMSw2kKYUzUoUpkKFrvRWUAzjtHDQBwCxG6tFDvmGkeRWUO0yUAozGPsf+yR7noM0ToKOJ2AhODxv8KH7V5YgAHTfqUSfeDFix4SX47RVoO/yLl4Z9ZnqYkXK0d6hQNE9HaNimvudGnMEr67SdzJwxCrrCVYThhY8oHB6i+LBgQQJElzpzs8ouHsNwBoPlwvi5hgSCMUzWUAKgXq6ZDR4uNCKUuJqStehA47XmHPb4b5ClGDVbGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ewbfHZXjxiR3o31sgRc557/LsbDk01g0KASzcHU7ci4=;
 b=fgxBsot44HESe15u5iVRnwUMLLFkSdDcWfQ0hTMJ+vmr2Dew3VfiRvj0xpnKQm8uXhk4TdjTsriqzLR877jAOkYJ7B4iL/b74UROCeWZdPqSjpSD0vRGAThnx8iXgX3rRmxUFBohjvO7Y5uNuzKYkpvXI+OJ6oeXPQvE8CTlXJAm2WuYaAe599O8QDElA2Pr5Kyuqkjn68pgK8C/3IDk5rbhK7eo3QblBAKmFSJ+NaBkaUR1QOhifks4Pljat9fpG780TrG5EHh/594SByNOkH9h2OueQKfULWDe1ao9AJ+KX2+kDapzdKDGlzpAbpQ+xbe1lmNpeziosv5Mb1zH2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ewbfHZXjxiR3o31sgRc557/LsbDk01g0KASzcHU7ci4=;
 b=MD0V6uU0prJJowd7ORCQUZNU0dCvly96h119e/8vwoT6aW7PHF88VZCR53cMl38BrzoQ/xCeenZmq/X8yf0Q8wX+DK0iOw9PoAuaNdXKdxxWzq/jCgglzbl2c5xip9JTBfrKnyxLl/hRnG7N1jh4H1Bi7xDyhmrUNasbhS5deAg=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=microsoft.com;
Received: from BN8PR21MB1281.namprd21.prod.outlook.com (2603:10b6:408:a2::19)
 by BN6PR21MB0753.namprd21.prod.outlook.com (2603:10b6:404:9c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.4; Mon, 24 Aug
 2020 16:48:03 +0000
Received: from BN8PR21MB1281.namprd21.prod.outlook.com
 ([fe80::e0c9:2634:6fb1:5615]) by BN8PR21MB1281.namprd21.prod.outlook.com
 ([fe80::e0c9:2634:6fb1:5615%3]) with mapi id 15.20.3326.012; Mon, 24 Aug 2020
 16:48:03 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     will@kernel.org, ardb@kernel.org, arnd@arndb.de,
        catalin.marinas@arm.com, mark.rutland@arm.com, maz@kernel.org,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-arch@vger.kernel.org,
        wei.liu@kernel.org, vkuznets@redhat.com, kys@microsoft.com
Cc:     mikelley@microsoft.com, sunilmut@microsoft.com,
        boqun.feng@gmail.com
Subject: [PATCH v7 10/10] Drivers: hv: Enable Hyper-V code to be built on ARM64
Date:   Mon, 24 Aug 2020 09:46:23 -0700
Message-Id: <1598287583-71762-11-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1598287583-71762-1-git-send-email-mikelley@microsoft.com>
References: <1598287583-71762-1-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: CO2PR04CA0145.namprd04.prod.outlook.com (2603:10b6:104::23)
 To BN8PR21MB1281.namprd21.prod.outlook.com (2603:10b6:408:a2::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by CO2PR04CA0145.namprd04.prod.outlook.com (2603:10b6:104::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Mon, 24 Aug 2020 16:47:59 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [131.107.159.16]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 54525498-901b-4bfa-6104-08d8484d764e
X-MS-TrafficTypeDiagnostic: BN6PR21MB0753:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <BN6PR21MB075338D2F89220951BA45C34D7560@BN6PR21MB0753.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1332;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WLT/fk8AOVtOqqVcpLb3oOkPUt41pvsgkfOX8UAoJKsnYxDyjP7o023SFTwVtoifuCfe6x7mYzXewZf79f2ITJaRTYOT3OaIbXuDDSUzfGOj9zxWtVDYMwRtmxv2nG8RNPaz9l2UnVPriXuTv5MfbVfe6Hbe83nyGbCUtWZE/of/Ni2I7NxfLZieOaM73ZEHujNoEbwfgQntrdMc+xY4s/kuc63MZJMUHIehOwQ1PMQFY43LmqvGLWTGbAH10HkeIHupXz6LVeXhzrs1gFW+epFuTMV/8EIHuII9dZbbV6Oq6ReTiMvQ2VI5O4DulHl73Cs1R3qcTP3yyeWXo1hADjBjfLJ0JUfw6UEKlCnu1AZ4JcRWzo698Tg0YyeRLAM0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR21MB1281.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(376002)(396003)(346002)(8676002)(86362001)(2616005)(956004)(2906002)(6486002)(8936002)(52116002)(10290500003)(5660300002)(66946007)(16576012)(66556008)(4326008)(6636002)(316002)(4744005)(36756003)(186003)(82950400001)(478600001)(26005)(6666004)(66476007)(82960400001)(83380400001)(7416002)(921003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: yD8/VXkbZ4+eOYxTYBfK4nspVKu/06/JoYLC1fGDi9K3Xw09sYxVGy+PojvFuoMcaBobgxwbQM+8atGA7bSth1QpMe/jFxrNQTArmHb2xA5LyKrgObCnC5XTZgtkBHXexYzyiXERkS52dq0Vkt3681PI1O+atjp+skvbX1o6DIHVpiN6dfLx2GQ2HJEgT/JS/v2uigXyqpJTWDT19AGBPwcxcm1heBMy6JT617OsPSrlN2pKDSz2Q9iEUCi5W7Rw1T15SeCMu1Ze6ac1fJMvYngbdFi+UwThx+0xDRU8acyZ/lxTCAcgz9kCOOOG0KsFpxUYxs1CLMtnpApayjNzsJJXBQcgOL4ESMfti7gf89UDfISgBLHWFeV/lMzkxSH9NMpiyM0K3axCVPAHgSRXcTwtbLjIlOfhpsKNu38Rp5YOj23sUSU+vAFQaDkN8v1lLo8FYPm6ydBh1JFV45f9rLDySpBqvim5bJ0eyxpTFCG1XLnEHRWvpx4tiXZjiakiswvSuwPAh/QXnMZ9/wSxkQK4ox0ROOoJklGp4O37Z7ig2CPIvbdGSdCYO5LjnsrkKg9dSjYO8p14u9v9vcBYarqPc6ejh/m6Xo1jlTnWIqKRKuazDlP3xa2K0mEwbUWFDl3nPDxmh8WUiu56CunvWg==
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54525498-901b-4bfa-6104-08d8484d764e
X-MS-Exchange-CrossTenant-AuthSource: BN8PR21MB1281.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2020 16:48:00.9283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0lerLPaNRh5aKadjfXOsYptPClQf2ljXeXf+yo0qCPQWUxPdxd4QLqktOADvCxTQM0lIqZa3jvyNXiz+YV80xQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR21MB0753
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Update drivers/hv/Kconfig so CONFIG_HYPERV can be selected on
ARM64, causing the Hyper-V specific code to be built.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
---
 drivers/hv/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hv/Kconfig b/drivers/hv/Kconfig
index 79e5356..1113e49 100644
--- a/drivers/hv/Kconfig
+++ b/drivers/hv/Kconfig
@@ -4,7 +4,8 @@ menu "Microsoft Hyper-V guest support"
 
 config HYPERV
 	tristate "Microsoft Hyper-V client drivers"
-	depends on X86 && ACPI && X86_LOCAL_APIC && HYPERVISOR_GUEST
+	depends on ACPI && \
+			((X86 && X86_LOCAL_APIC && HYPERVISOR_GUEST) || ARM64)
 	select PARAVIRT
 	select X86_HV_CALLBACK_VECTOR
 	help
-- 
1.8.3.1

