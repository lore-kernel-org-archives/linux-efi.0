Received: from PAUP264CU001.outbound.protection.outlook.com (mail-francecentralazon11021133.outbound.protection.outlook.com [40.107.160.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781672931EE;
	Mon, 12 Oct 2026 13:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.160.133
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791812236; cv=fail; b=OHaxOZIUZ2Yyo+Nm5qvAT6zDt8/3Cm04CWzQtQoZf2OjgZAvZNSdws2YWivTnruplxRg3GRhbVIYeOZ8hkVvLtBzg0jC2aUcpTT/ZO+Vfz1JlnHjcft98X6uHPacu79H/SMFV9uCAfJUWh+kArmdG8o0N0I32Dd4VwXDrSjPOR8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791812236; c=relaxed/simple;
	bh=Qyd5E59+XjkGLHd5ZVavfY6A1BDuZzxojIH8BwHT38w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Yl0cMQ57kLKxV0pJ/gVXapZg/g298qwGDEDl8/RZBQBg110Dshr7biPnI8awPWy/WwVOii1ksY3DD9pSwEopJzjoEoUevMsQgTuViHO3uDQHrIvdmZR/v3HqDcnirHVw2tswCDPwE5rV8O4Gim4gcNI7Pj0/QBoQUVYXswqSuXY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wenske.fr; spf=pass smtp.mailfrom=wenske.fr; dkim=pass (2048-bit key) header.d=wenske.fr header.i=@wenske.fr header.b=i5SA1nD0; arc=fail smtp.client-ip=40.107.160.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wenske.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wenske.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wenske.fr header.i=@wenske.fr header.b="i5SA1nD0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YHOsS+8Q2hu42JkxQuHqHdGiqqnf8JkCNvGbnmAJxdm2Rjf3fNkQqciKpxVuRg86xa99yvoS2QrfN1cmfaLsJlznj/SnOtn5uQk7G2o4A/86DujQ08cF+Ul0LnAFFdGOYTGmzsZ6RkSsYNjeUbjel1jlIELrzSR8igBiV+G69X5uAzV/b68jBClIWk+LQEe4CXcva5rlVYiR0HioKatEwfo3xkBdoVMbigmN0GpD7NZkuAqj/ygxpeImNd7cizBL82Bmfkbu0kyATx+mBM+pEMogcIY54N7x2x/soy2gtuoh+dCoIRp06XyH/NrX2kjJGxIXb/szUPzRbI+nosd0kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cb1KzrYb/NxclxupdogkcL42hOzn0oXY2ub1PZfz+xw=;
 b=IX+KCyYAcxZhhLNzxQ7JTf8pf1kUMGVRjJW095IvlyVSA22pO5cVebnKgNxHH5uamK/8WouyXNtwYSD14/+PkD7SKKnlfWm7v/owPNYbElet+tHaScl8QI3/J8mwHchJn6bFnA8Rrruc14u5N2lbvDOTBZqjDy6XwV8KRRLgs/XSFFDvnjh+AEdndBVGts2kFrraR1lHZsK41ETh3Iv4XUCauYvXJXgWJpZa/5bmSQxhzAEGZNBLTGTQ7Usb1Dlv0HPpNaPaC297vEEkzWOFwljrKaOFqwcD4P6Wo2ddTbzMrgw2ZI0T4G+TcjfA5ZNEtGzBtHhjjFPHQQF8pgjFwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 82.65.107.217) smtp.rcpttodomain=gentoo.org smtp.mailfrom=wenske.fr;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=wenske.fr;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wenske.fr;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cb1KzrYb/NxclxupdogkcL42hOzn0oXY2ub1PZfz+xw=;
 b=i5SA1nD0zNX0ACjK6u5JEgOo9YNqc8fCXzq0s1/23PUimowg0fT+epSCQ6uITMxUDGK9ouh1jaVC8R2SyRD6JmFaffWE2VVGkkBjD8EJ2zvCvdDaFjtxr/d2cD8VLkUfbYDOTCvk8wkVEkBUGU6l4FpHSizZiahrsYqlbsPErOPfBeXitKXkhkb4rvNMcEbfySfCL12P8h8viDGobR9ca29TrZLD6KRx9dQTfo4Vkzzl/OGnKLSyL5Ncu1Ty8HUYb14dK2b+iEVJZ1aIboUUELFIPtGI0RtDF/cWoH7S8u11E9WwIF/X8H/6ISTnYNL87qyIPho6Xe6Q4kAu5TXwAA==
Received: from PAZP264CA0141.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1f8::16)
 by MR1P264MB2356.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:35::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Mon, 12 Oct
 2026 13:37:09 +0000
Received: from PA2PEPF00019231.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1f8:cafe::4d) by PAZP264CA0141.outlook.office365.com
 (2603:10a6:102:1f8::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Mon, 12
 Oct 2026 13:37:09 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 82.65.107.217) smtp.mailfrom=wenske.fr; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=wenske.fr;
Received-SPF: Pass (protection.outlook.com: domain of wenske.fr designates
 82.65.107.217 as permitted sender) receiver=protection.outlook.com;
 client-ip=82.65.107.217; helo=lgs.sw-servers.net; pr=C
Received: from lgs.sw-servers.net (82.65.107.217) by
 PA2PEPF00019231.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.6
 via Frontend Transport; Mon, 12 Oct 2026 13:37:09 +0000
Received: from zephy.int.sw-servers.net (zephy.int.sw-servers.net [10.1.2.3])
	by lgs.sw-servers.net (Postfix) with ESMTPS id 0CDE3830;
	Mon, 12 Oct 2026 15:37:09 +0200 (CEST)
Received: by zephy.int.sw-servers.net (Postfix, from userid 1000)
	id 4C5306531E; Mon, 12 Oct 2026 15:37:12 +0200 (CEST)
From: Sebastien WENSKE <sebastien@wenske.fr>
To: Ard Biesheuvel <ardb@kernel.org>,
	linux-efi@vger.kernel.org
Cc: swenske@veepee.com,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	James Le Cuirot <chewi@gentoo.org>,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] efi/libstub: Allocate the INITRD table in ACPI reclaim memory
Date: Mon, 12 Oct 2026 15:37:09 +0200
Message-ID: <20261012133712.618913-1-sebastien@wenske.fr>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA2PEPF00019231:EE_|MR1P264MB2356:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 7027699e-4e05-4390-f91b-08df2865ea03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|36860700016|376014|1800799024|6133799003|10067099003|18002099003|5023799004|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	4nQeTQdBwidr5d1y2JzP9RbwmAZzgk5K6FtFT+FrsnBWDvb0OiIlEmmnSDYH9xdB+DZF6V+zC2u2B+u/87f/WWRK/mJGLjrhCVzbpa5LmvOI2EuKr3qcGs0qzABjPzKP0xu0rKylxdn2OvzBtKORO6wnzThAXnhtaxHAX+OWx9ji/gSNrLpJMDf9oFphnBoBpDg7CE5RL41mhcuX1sT0UWqRV8OzLDTvFdZjkB5GQ3KMQFDGeA/NC3ghIPgaix9FU5NjRxgd685DVVd0s+mroPuYkujk4LgQJce6cGNyS28Xn7V5U+Tx7v6bPEMLDHWfbkjdfhmjJOyS7b+38EW0NRwz+AjXoEVDBFXtZMnbwlTt0dj+inknmHg+dJGzBkAMZXSQnItnOYGbQPD4KJhvQaAigeg3Gnus+RM7zH1bIXSWZD58cmR6vJhWHA2nY5UKoi84MqIozplA2EQJMdia45221i4ChliYl/7KdPL2SZ0Q0DhYEoEG7itqfmi6dRLWpsar6gF5oot/dPPRbkL3EqKKoG2npeM85EZUeUcVDPEM07VCXQaptpoSVHVDQTBMbO2AJDz7DI4UqswROFJh96Z0D07CY1jhmfZkpWH3r02cAZOG7dBiGeM4TBzNVRXsFnc/ZLUs5x2GJQIbprOQSPxzjK8EzivKlzdhmDrXWaCpF0RlqUKKMgk8HYwP7ogN
X-Forefront-Antispam-Report:
	CIP:82.65.107.217;CTRY:FR;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lgs.sw-servers.net;PTR:82-65-107-217.subs.proxad.net;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(36860700016)(376014)(1800799024)(6133799003)(10067099003)(18002099003)(5023799004)(261009223027099003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Q4A+77ZEOZtgrZnBRdlqYmwy39s8qkuNGytVLi9Hcugo3rNbA2YFNcyNGdZ6jQQWbpDBpeAVcjJ40u1CWE6qy9j5uBOObHmMm5CbkQok/S+baK/09qvIcNpXmbLfuk5Nr4hj+WAeyRXYi4AD0gf4QKNPYwIZly1g3s2qCTcw9L9JE/KtVmJ2TNjCSIIhHcrdem5nd3G/0W+u00L2G5dG51iFrwr+kmwGaTwnbDqukWgJHQan7fJbTyS3LMBe9xOk2Bh2sqXXSAEkt5u/5WcldfvZ433lvFhrhywCmVmcXz2FWFGCJOfotPf9n2eVUW0SPMzqqkQRcwiuVP5Og/oc5BRaO93bk0OQy17cAt1I15jZQDqzIDYdaN6LO/WQhHv7AJ+z5kigcarkhsWXzaf/71lH9Ib3czHAAepC5KUIDGqkJZC7hPntZnxSzcsHMOT1
X-OriginatorOrg: wenske.fr
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2026 13:37:09.2309
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7027699e-4e05-4390-f91b-08df2865ea03
X-MS-Exchange-CrossTenant-Id: ff4ca3b8-6c54-4519-8b0b-9389fb15cdbb
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=ff4ca3b8-6c54-4519-8b0b-9389fb15cdbb;Ip=[82.65.107.217];Helo=[lgs.sw-servers.net]
X-MS-Exchange-CrossTenant-AuthSource: PA2PEPF00019231.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR1P264MB2356

Commit 6e62d1c6f2c7 ("efi: Wipe INITRD config table from memory after
consumption") makes the kernel clear the base and size of the
LINUX_EFI_INITRD_MEDIA_GUID configuration table once it has read them,
so that a kexec'd kernel no longer picks up a stale initrd.

However, the stub allocates that table from EFI_LOADER_DATA, which the
kernel that consumes it treats as ordinary RAM, while the configuration
table entry pointing at it survives kexec. A kexec'd kernel therefore
finds the same address in the configuration table, and clears 16 bytes
there again, in memory that may by then hold anything - including the
kexec'd kernel's own image, which kexec_file_load() is free to place
there.

Seen on x86_64 v7.2.10 under QEMU with Debian's OVMF 2025.02 Secure
Boot capable build (OVMF_CODE_4M.secboot.fd, no keys enrolled), the
initrd handed to the stub through the LINUX_EFI_INITRD_MEDIA_GUID
device path (systemd-stub UKI). A kexec reboot (kexec_file_load(),
bzImage64, with an initrd) loads the new kernel at 0x1ca00000; the
stale table is at 0x1d4bcf98, in the middle of tcp_parse_options() in
that image. The kexec'd kernel boots, then oopses on the first incoming
SYN, 16 bytes of its text zeroed:

  BUG: kernel NULL pointer dereference, address: 0000000000000002
  RIP: 0010:tcp_parse_options+0xe7/0x2f0
  Code: a5 4c 29 e1 89 c8 0f b6 4d 12 83 e0 3f 83 e1 c0 09 c1 88 4d 12 eb de 41 83 fe 04 75 d8 41 f6 44 24 0d 02 74 d0 45 85 d2 75 cb <0f> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 66 39 d0 89 d1
  Call Trace:
   <IRQ>
   tcp_conn_request+0x270/0x9d0
   tcp_rcv_state_process+0x147/0x1560
   tcp_v4_do_rcv+0xc1/0x260
   tcp_v4_rcv+0x110e/0x1190

A debug print added before the wipe shows what the kexec'd kernel reads
at the table's address - its own text:

  efi: INITRD table at 0x1d4bcf98:
       base 0xc274c085660241b7 size 0x8c0c1661455b70f

Whether a given kernel crashes depends on what happens to land at that
address: v7.2.9 clears 16 bytes elsewhere in its image without any
visible failure, and bisecting v7.2.9..v7.2.10 ends on an unrelated
commit that only shifts the image's layout.

Allocate the table from EFI_ACPI_RECLAIM_MEMORY instead, as the stub
already does for the RNG seed table so that it survives a kexec reboot.
The table then stays where it is across kexec, and the wipe always
lands on the table itself.

Fixes: 6e62d1c6f2c7 ("efi: Wipe INITRD config table from memory after consumption")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Sebastien WENSKE <sebastien@wenske.fr>
---
Tested on x86_64 under QEMU (q35, KVM) with Debian's OVMF 2025.02
(OVMF_CODE_4M.secboot.fd and OVMF_CODE_4M.fd), booting a systemd-stub
UKI, then rebooting with kexec_file_load() and an initrd:

- v7.2.10: the oops above in 6 out of 6 kexec reboots under the
  secboot build (none under the plain one). With this patch: 2 out of
  2 come up, and two chained kexec'd kernels read the cleared table
  back (base 0x0 size 0x0), now in ACPI data memory.
- v7.3-rc7 without this patch: no visible failure, but the same debug
  print shows the kexec'd kernel reading its own image at the table's
  address - and so clearing 16 bytes of it:

    efi: INITRD table at 0x1d4bcf98:
         base 0xf413863894c40c4 size 0x415c74063c1246b6 - inside this
         kernel's image

  With this patch: kexec reboots (chained too) come up under both OVMF
  builds. It builds without warnings, W=1 included for libstub.

Not tested: other architectures, real hardware.

Reserving the table with efi_mem_reserve() in efi_config_parse_tables()
instead doesn't help on x86: efi_arch_mem_reserve() only handles
EFI_BOOT_SERVICES_DATA ("Failed to lookup EFI memory descriptor"), so
kexec still places the next kernel over the table. Note that a kernel
kexec'd from one without this patch still finds the table in loader
data memory.

 drivers/firmware/efi/libstub/efi-stub-helper.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index f27f2e1f0..9293b8b31 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -641,8 +641,14 @@ efi_status_t efi_load_initrd(efi_loaded_image_t *image,
 				     EFISTUB_EVT_INITRD) == EFI_SUCCESS)
 		efi_info("Measured initrd data into PCR 9\n");
 
-	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA, sizeof(initrd),
-			     (void **)&tbl);
+	/*
+	 * Use EFI_ACPI_RECLAIM_MEMORY so the table survives a kexec reboot:
+	 * configuration tables do, and the kernel wipes this one once it has
+	 * consumed it - a kexec'd kernel wipes it again, at the same address,
+	 * which in EFI_LOADER_DATA memory may hold anything by then.
+	 */
+	status = efi_bs_call(allocate_pool, EFI_ACPI_RECLAIM_MEMORY,
+			     sizeof(initrd), (void **)&tbl);
 	if (status != EFI_SUCCESS)
 		goto free_initrd;
 

base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
2.47.3

