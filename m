Return-Path: <SRS0=QuFd=SK=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2160C10F13
	for <linux-efi@archiver.kernel.org>; Mon,  8 Apr 2019 22:52:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C95520880
	for <linux-efi@archiver.kernel.org>; Mon,  8 Apr 2019 22:52:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbfDHWwx (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 8 Apr 2019 18:52:53 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48896 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726515AbfDHWwu (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Mon, 8 Apr 2019 18:52:50 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x38MnB58063646
        for <linux-efi@vger.kernel.org>; Mon, 8 Apr 2019 18:52:49 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2rrd9vvf05-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-efi@vger.kernel.org>; Mon, 08 Apr 2019 18:52:48 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-efi@vger.kernel.org> from <nayna@linux.ibm.com>;
        Mon, 8 Apr 2019 23:52:46 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 8 Apr 2019 23:52:43 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x38MqfAQ55509016
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Apr 2019 22:52:41 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1D7D4C04A;
        Mon,  8 Apr 2019 22:52:41 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 059964C040;
        Mon,  8 Apr 2019 22:52:40 +0000 (GMT)
Received: from swastik.ibm.com (unknown [9.85.157.39])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Apr 2019 22:52:39 +0000 (GMT)
From:   Nayna Jain <nayna@linux.ibm.com>
To:     linuxppc-dev@ozlabs.org, linux-efi@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Jeremy Kerr <jk@ozlabs.org>,
        Matthew Garret <matthew.garret@nebula.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Claudio Carvalho <cclaudio@linux.ibm.com>,
        Nayna Jain <nayna@linux.ibm.com>
Subject: [PATCH v2 0/3] powerpc: Enabling secure boot on powernv systems - Part 1
Date:   Mon,  8 Apr 2019 18:52:31 -0400
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
x-cbid: 19040822-4275-0000-0000-00000325B110
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19040822-4276-0000-0000-00003834C80A
Message-Id: <1554763954-11795-1-git-send-email-nayna@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-08_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904080164
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20190408225231.Vd7qeJKEFD30tq4PabXBWtIR4l8_5lRDRwSlWxQF_GY@z>

This patch set is part of a series that implements secure boot on PowerNV
systems.

In order to verify the OS kernel on PowerNV, secure boot requires X.509
certificates trusted by the platform, the secure boot modes, and several
other pieces of information. These are stored in secure variables
controlled by OPAL, also known as OPAL secure variables.

The IMA architecture specific policy support on Power is dependent on OPAL
runtime services to access secure variables. Instead of directly accessing
the OPAL runtime services, version 1[1] of this patch set relied upon the
EFI hooks. This version drops that dependency and calls the OPAL runtime
services directly.

Exposing the OPAL secure variables to userspace will be posted as a
separate patch set, allowing the IMA architecture specific policy on Power
to be upstreamed independently.

This patch set adds the following features:

1. Add support for OPAL Runtime API to access secure variables controlled
by OPAL.
2. Define IMA arch-specific policies based on the secure boot state and
mode of the system. On secure boot enabled powernv systems, the OS kernel
signature will be verified by IMA appraisal.

[1] https://patchwork.kernel.org/cover/10882149/

Changelog:

v2:

* Removed Patch 1: powerpc/include: Override unneeded early ioremap
functions
* Updated Subject line and patch description of the Patch 1 of this series
* Removed dependency of OPAL_SECVAR on EFI, CPU_BIG_ENDIAN and UCS2_STRING
* Changed OPAL APIs from static to non-static. Added opal-secvar.h for the
same
* Removed EFI hooks from opal_secvar.c 
* Removed opal_secvar_get_next(), opal_secvar_enqueue() and
opal_query_variable_info() function
* get_powerpc_sb_mode() in secboot.c now directly calls OPAL Runtime API
rather than via EFI hooks.
* Fixed log messages in get_powerpc_sb_mode() function.
* Added dependency for PPC_SECURE_BOOT on configs PPC64 and OPAL_SECVAR
* Replaced obj-$(CONFIG_IMA) with obj-$(CONFIG_PPC_SECURE_BOOT) in
arch/powerpc/kernel/Makefile

Claudio Carvalho (1):
  powerpc/powernv: Add support for OPAL_SECVAR_GET

Nayna Jain (2):
  powerpc/powernv: detect the secure boot mode of the system
  powerpc: Add support to initialize ima policy rules

 arch/powerpc/Kconfig                         |  14 +++
 arch/powerpc/include/asm/opal-api.h          |   3 +-
 arch/powerpc/include/asm/opal-secvar.h       |  18 ++++
 arch/powerpc/include/asm/opal.h              |   2 +
 arch/powerpc/include/asm/secboot.h           |  21 ++++
 arch/powerpc/kernel/Makefile                 |   1 +
 arch/powerpc/kernel/ima_arch.c               |  54 ++++++++++
 arch/powerpc/platforms/powernv/Kconfig       |   6 ++
 arch/powerpc/platforms/powernv/Makefile      |   2 +
 arch/powerpc/platforms/powernv/opal-call.c   |   1 +
 arch/powerpc/platforms/powernv/opal-secvar.c | 107 +++++++++++++++++++
 arch/powerpc/platforms/powernv/secboot.c     |  54 ++++++++++
 include/linux/ima.h                          |   3 +-
 13 files changed, 284 insertions(+), 2 deletions(-)
 create mode 100644 arch/powerpc/include/asm/opal-secvar.h
 create mode 100644 arch/powerpc/include/asm/secboot.h
 create mode 100644 arch/powerpc/kernel/ima_arch.c
 create mode 100644 arch/powerpc/platforms/powernv/opal-secvar.c
 create mode 100644 arch/powerpc/platforms/powernv/secboot.c

-- 
2.20.1

