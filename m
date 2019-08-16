Return-Path: <SRS0=PY3k=WM=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FF3FC3A59C
	for <linux-efi@archiver.kernel.org>; Fri, 16 Aug 2019 15:57:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EC032133F
	for <linux-efi@archiver.kernel.org>; Fri, 16 Aug 2019 15:57:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbfHPP5g (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 16 Aug 2019 11:57:36 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:42646 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727377AbfHPP5g (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Fri, 16 Aug 2019 11:57:36 -0400
Received: from localhost ([127.0.0.1] helo=flow.W.breakpoint.cc)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1hyebe-00047L-VY; Fri, 16 Aug 2019 17:57:35 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     linux-efi@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>, tglx@linutronix.de
Subject: [PATCH 0/2] efi: Allow to auto-disable it on RT
Date:   Fri, 16 Aug 2019 17:57:27 +0200
Message-Id: <20190816155729.12518-1-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.23.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

Hi,

since we have CONFIG_PREEMPT_RT these two patches allow to auto-disable
EFI runtime services on RT while it is still possible to override it and
use it if needed.

Sebastian

