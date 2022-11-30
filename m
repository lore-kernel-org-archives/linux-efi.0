Return-Path: <linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 661B0C636F8
	for <linux-efi@archiver.kernel.org>; Wed, 30 Nov 2022 22:56:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiK3W4z (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 30 Nov 2022 17:56:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiK3W4s (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Wed, 30 Nov 2022 17:56:48 -0500
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A3B9454F
        for <linux-efi@vger.kernel.org>; Wed, 30 Nov 2022 14:56:44 -0800 (PST)
Received: from ip5b412258.dynamic.kabel-deutschland.de ([91.65.34.88] helo=phil.lan)
        by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <heiko@sntech.de>)
        id 1p0W0M-0005PW-0F; Wed, 30 Nov 2022 23:56:38 +0100
From:   Heiko Stuebner <heiko@sntech.de>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com
Cc:     christoph.muellner@vrull.eu, prabhakar.csengg@gmail.com,
        conor@kernel.org, philipp.tomsich@vrull.eu,
        ajones@ventanamicro.com, heiko@sntech.de,
        emil.renner.berthing@canonical.com, ardb@kernel.org,
        linux-efi@vger.kernel.org,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH v3 08/14] RISC-V: kprobes: use central defined funct3 constants
Date:   Wed, 30 Nov 2022 23:56:08 +0100
Message-Id: <20221130225614.1594256-9-heiko@sntech.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221130225614.1594256-1-heiko@sntech.de>
References: <20221130225614.1594256-1-heiko@sntech.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

From: Heiko Stuebner <heiko.stuebner@vrull.eu>

Don't redefine values that are already available in the central header
asm/insn.h . Use the values from there instead.

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
---
 arch/riscv/kernel/probes/simulate-insn.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/arch/riscv/kernel/probes/simulate-insn.c b/arch/riscv/kernel/probes/simulate-insn.c
index d73e96f6ed7c..330afe9331a8 100644
--- a/arch/riscv/kernel/probes/simulate-insn.c
+++ b/arch/riscv/kernel/probes/simulate-insn.c
@@ -136,13 +136,6 @@ bool __kprobes simulate_auipc(u32 opcode, unsigned long addr, struct pt_regs *re
 #define branch_offset(opcode) \
 	sign_extend32((branch_imm(opcode)), 12)
 
-#define BRANCH_BEQ	0x0
-#define BRANCH_BNE	0x1
-#define BRANCH_BLT	0x4
-#define BRANCH_BGE	0x5
-#define BRANCH_BLTU	0x6
-#define BRANCH_BGEU	0x7
-
 bool __kprobes simulate_branch(u32 opcode, unsigned long addr, struct pt_regs *regs)
 {
 	/*
@@ -169,22 +162,22 @@ bool __kprobes simulate_branch(u32 opcode, unsigned long addr, struct pt_regs *r
 
 	offset_tmp = branch_offset(opcode);
 	switch (branch_funct3(opcode)) {
-	case BRANCH_BEQ:
+	case RVG_FUNCT3_BEQ:
 		offset = (rs1_val == rs2_val) ? offset_tmp : 4;
 		break;
-	case BRANCH_BNE:
+	case RVG_FUNCT3_BNE:
 		offset = (rs1_val != rs2_val) ? offset_tmp : 4;
 		break;
-	case BRANCH_BLT:
+	case RVG_FUNCT3_BLT:
 		offset = ((long)rs1_val < (long)rs2_val) ? offset_tmp : 4;
 		break;
-	case BRANCH_BGE:
+	case RVG_FUNCT3_BGE:
 		offset = ((long)rs1_val >= (long)rs2_val) ? offset_tmp : 4;
 		break;
-	case BRANCH_BLTU:
+	case RVG_FUNCT3_BLTU:
 		offset = (rs1_val < rs2_val) ? offset_tmp : 4;
 		break;
-	case BRANCH_BGEU:
+	case RVG_FUNCT3_BGEU:
 		offset = (rs1_val >= rs2_val) ? offset_tmp : 4;
 		break;
 	default:
-- 
2.35.1

