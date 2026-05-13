Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1843E4C69
	for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 08:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778661865; cv=none; b=FYD/4T8TImPG4LdFQb/Z7Z1V0cO/jmorr4UuGpp3p0EiFL/AYmITrh9kv6f2tnnjGJHnzWBGoNkaSLLZUJ07dzAKr9RoghTmzmdgmT3WSyfMqNagi2I5UFSv5RXhburR8e5f+8VCsFdwBHF43cjjVtFEmornIhyIaRAzBxqyOXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778661865; c=relaxed/simple;
	bh=lI3vWvKnic19vdOGJ+3N9CWmKDFS54Hz3RuRyiIM/kY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NjqNUP4Y1RxFNsqQu0hCGuDxxkh3VRwoXFtvHdoU/Gcp5VP+uqVgNFjn8DufT1f00hauabWeNUuoyQjZoqOHltY1c5JhPnOWUcCjLHrgf9Se1o0Ny9GpgQEUoAcFlqsUuEztGT/lb0zt7XN03hyoza3r3Cgd//0kmbOnUSbhwfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=WKj7BvvD; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=U/QxzbxA; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="WKj7BvvD";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="U/QxzbxA"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64D4pPO52321468
	for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 08:44:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=7thsI61iVOv
	UNh22HCK2qAPj5NTxS3xwSRoZruWKBf8=; b=WKj7BvvD7bYlQK1S8oz5Rw32MCc
	tGn8FxrH0FQ33DTyjhKa3chdX22dq3+PodPsALaWiNCoTnTdgoSsjAjrxSjvwTQL
	EEQ7NuR3WGdVGCGzzvPlqmMPWzAWBL1hgX0smLkmc9sTgp8gRdiDTAMTd+BMuhm6
	vCUjW0iTV5i01MO2ez6Nt48+02Pnpf32Bx9KT6HMZQaexbGUF0IyvEUiJr8K0mJP
	m87B75Uf/qBz1i1VIL48ZIz9ROkGsknfYJE/4KVIS+4rv7FilFb3Lchs6uHQX03e
	vlLTmId5vmKxsdBhXucKYXUVHQTs077y4keop69bsCeQKvGP6Opa4nXR0pQ==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e4hgu93be-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 08:44:17 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2b9b8137828so69502765ad.0
        for <linux-efi@vger.kernel.org>; Wed, 13 May 2026 01:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778661857; x=1779266657; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7thsI61iVOvUNh22HCK2qAPj5NTxS3xwSRoZruWKBf8=;
        b=U/QxzbxAuOjR1KMk6YTxY9QIlH7IwA31mwcIahCp6tPpUpIvj57QAh99VMY4jN4PY/
         bShfbhhj76wvEb8wcY4njMTxEpKOf+HW/h1gcg7WFdp9GzG9mV8WvKXq2Omz+a63z5u2
         7gQRplhYJc67GxOsqGDJ1wRd+hrBwHvO7ts3RnXpi8EQlq6Yb3gaEW3JVzkts7pOd7Nm
         A4meL+DuS8Y1QeQGz/7eU6Nxz63pt9pQOLYd7HmTLyMwVOggSwPubHl9eAYPUMBoQLP4
         2FRC7lUi28SC3lrif48/UsKGeBglKBz0VKrP0iiDHfBZLjqefpiF57ITALwC681ZQSde
         mYmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778661857; x=1779266657;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7thsI61iVOvUNh22HCK2qAPj5NTxS3xwSRoZruWKBf8=;
        b=FV5IcDYd/vTJAia1qKsGkxx6XQR7yZwbXKrPfcq30uzfnzQyUt/LclEB5Gsmr3MZzJ
         qhwoqZT7fCokjX+UbHpczF5Y5D5Kv/1pyHSGWz0AtgbtePiYY8sZqEVawLtUjg66yXL+
         vvxDouB/yYyAdnbuG8tSDCBoEhvv8JQ1xM9soBSLqmBsW1Jn+Z+2bB+LszdEQhUYmsz7
         xJi8bLFdbcU4OifxWsyjjh3KhWx5J6E/NbKfC0JYpcf0o1Iqk+L/PubB/5DbK8GYORPT
         W9sBPdax2WzQ9tKJ8wQc3WicK6qkuH4/uhK+OssAs9b/O2fRWOGCOh3R264wWgiESZ3g
         xpqA==
X-Forwarded-Encrypted: i=1; AFNElJ+cfe3upPA7U4udGeHDyHfkWy1SqniUClK/EIf7TKBqNpXH172sLa08OXYNmA4pqQIciKAFco1ZtlU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvcYksT67qnvcek71WLOy1xJ1dHRHUjVc9AXBUKCUGAoDDb9Lx
	TsV7/6sRA6Y3W7zgeKXTtH8FEJcN7NTONugbYGpib7lNeMAxyGN6rmncYMIsgm9c9qz5ikrlug3
	X0SouEsMaJESqf5HUWMAtGvp83G95uTHJMwVUFx/lVzx5S/hlgFvJqx/1KOTm8DY=
X-Gm-Gg: Acq92OF69ng8EmcnaA/jvBMVOb4TU3tdJEtKIVb5EKxcTqpNL+QCcVmRMskelabTgVF
	VNEvCLSCaSTuLx0iXpzCWijjF5GTpWcD+CMKCeHvEjVtRyFjrHGn6rimD9ScKvHMe5+awUYpxqe
	yVzPSkkhdt4oMPG9j7CMG0m8yT7gEb53RTHML9oqLiz5RNSTIAnjmQgEM/ly6M3jkKGDtgMZXFz
	AOe318Wd+ms8jM/dje0ilz1JunwV5Qtr/D31218hMk+Vx0yBgWGIK7+aNtiwQ/JAUWMqpPwf1iF
	uzoIz9f5ctUqdx/N2fie6zuRiRJDpLD0i8Ut9MaFUs18KfV+8tbDdWTeNHxYwS1rFihCHWAw1YR
	vuIYX5QEscet4AqTt6fzliXNY2WBjgodHMMr9bcCgdIH6VP1C3HVD53+9qgfG4XPSHuP6pdgXYS
	AXeCZGS3IAE8XcmLrf9r1zQO/nmrcmovg1GKIaw12dUC7Zww==
X-Received: by 2002:a17:902:7c11:b0:2b4:5f96:184d with SMTP id d9443c01a7336-2bd2f4dc314mr13678555ad.5.1778661856995;
        Wed, 13 May 2026 01:44:16 -0700 (PDT)
X-Received: by 2002:a17:902:7c11:b0:2b4:5f96:184d with SMTP id d9443c01a7336-2bd2f4dc314mr13678465ad.5.1778661856465;
        Wed, 13 May 2026 01:44:16 -0700 (PDT)
Received: from hu-himchau-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d2709bsm169158725ad.5.2026.05.13.01.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 01:44:16 -0700 (PDT)
From: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
To: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org,
        acpica-devel@lists.linux.dev, paul.walmsley@sifive.com,
        palmer@dabbelt.com, lenb@kernel.org, james.morse@arm.com,
        tony.luck@intel.com, ardb@kernel.org, conor@kernel.org,
        cleger@rivosinc.com, robert.moore@intel.com, sunilvl@oss.qualcomm.com,
        anup.patel@oss.qualcomm.com
Cc: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
Subject: [PATCH v4 06/10] riscv: Add functions to register ghes having SSE notification
Date: Wed, 13 May 2026 14:13:21 +0530
Message-ID: <20260513084325.2176952-7-himanshu.chauhan@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513084325.2176952-1-himanshu.chauhan@oss.qualcomm.com>
References: <20260513084325.2176952-1-himanshu.chauhan@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=X4di7mTe c=1 sm=1 tr=0 ts=6a0439e1 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=EUspDBNiAAAA:8
 a=2d44Z0_5zRK2QUa08RUA:9 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: QBT-bisQhzyB_zUjLVN7ldZ0Ge5f0rFJ
X-Proofpoint-ORIG-GUID: QBT-bisQhzyB_zUjLVN7ldZ0Ge5f0rFJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEzMDA4OSBTYWx0ZWRfX4QRsZEZ2P1UQ
 /skcyMXz8P8OTu5SyDzDnVUZgWabN8zF2Wemu0LIRc67WKogaWDSCgFj1CGoILdHi3ll0FR3gkf
 EeMgRsDjMnx9/PxNcAK+GlAB8YheU1cDgUl0frUyrs22SlnJMXGurBFeS0PYiSV5+HFkBjmqq6w
 CqNMvOJH8f2+McYFNaaYZVIkbHZF4p8OUzAULin4r5bdArhVVv7o2/DQS/a98DOhjb2kGoTSZlP
 P6EGzTGzZYSTlun8lZtdxkAzsNrtDHxEGyl2KXSS96YKDmIPhyGS/Rmwhb0ja4p27Ioxezyy4OF
 CKpze1O4o8IbucPktdLpHYIXDxhM3kOxaDyAxcCWBqmj9hiqsWTkTKaa7cyBpLFtMfxL/aUgxh6
 /wbomWQgIPzWcZ3QDa7sKMiO93Di9htKuj7cHKi8VU5LJWTEGjWKGrLl8p2jyJ1Y6j42Bf8BN/M
 1oH/uuGa38VXzdflVvQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-11_05,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0 clxscore=1015
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2605050000
 definitions=main-2605130089

Add functions to register the ghes entries which have SSE as
notification type. The vector inside the ghes is the SSE event
ID that should be registered.

Signed-off-by: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
---
 drivers/firmware/riscv/riscv_sbi_sse.c | 146 +++++++++++++++++++++++++
 include/linux/riscv_sbi_sse.h          |  16 +++
 2 files changed, 162 insertions(+)

diff --git a/drivers/firmware/riscv/riscv_sbi_sse.c b/drivers/firmware/riscv/riscv_sbi_sse.c
index c7f29b10cdfb..ee288a0c1680 100644
--- a/drivers/firmware/riscv/riscv_sbi_sse.c
+++ b/drivers/firmware/riscv/riscv_sbi_sse.c
@@ -5,6 +5,8 @@
 
 #define pr_fmt(fmt) "sse: " fmt
 
+#include <acpi/ghes.h>
+#include <linux/acpi.h>
 #include <linux/cpu.h>
 #include <linux/cpuhotplug.h>
 #include <linux/cpu_pm.h>
@@ -692,3 +694,147 @@ static int __init sse_init(void)
 	return ret;
 }
 arch_initcall(sse_init);
+
+struct sse_ghes_callback {
+	struct list_head head;
+	struct ghes *ghes;
+	sse_event_handler_fn *callback;
+};
+
+struct sse_ghes_event_data {
+	struct list_head head;
+	u32 event_num;
+	struct list_head callback_list;
+	struct sse_event *event;
+};
+
+static DEFINE_SPINLOCK(sse_ghes_event_list_lock);
+static LIST_HEAD(sse_ghes_event_list);
+
+static int sse_ghes_handler(u32 event_num, void *arg, struct pt_regs *regs)
+{
+	struct sse_ghes_event_data *ev_data = arg;
+	struct sse_ghes_callback *cb = NULL;
+
+	list_for_each_entry(cb, &ev_data->callback_list, head) {
+		if (cb && cb->ghes && cb->callback)
+			cb->callback(ev_data->event_num, cb->ghes, regs);
+	}
+
+	return 0;
+}
+
+int sse_register_ghes(struct ghes *ghes, sse_event_handler_fn *lo_cb,
+		      sse_event_handler_fn *hi_cb)
+{
+	struct sse_ghes_event_data *ev_data, *evd;
+	struct sse_ghes_callback *cb;
+	u32 ev_num;
+	int err;
+
+	if (!sse_available)
+		return -EOPNOTSUPP;
+	if (!ghes || !lo_cb || !hi_cb)
+		return -EINVAL;
+
+	ev_num = ghes->generic->notify.vector;
+
+	ev_data = NULL;
+	spin_lock(&sse_ghes_event_list_lock);
+	list_for_each_entry(evd, &sse_ghes_event_list, head) {
+		if (evd->event_num == ev_num) {
+			ev_data = evd;
+			break;
+		}
+	}
+	spin_unlock(&sse_ghes_event_list_lock);
+
+	if (!ev_data) {
+		ev_data = kzalloc(sizeof(*ev_data), GFP_KERNEL);
+		if (!ev_data)
+			return -ENOMEM;
+
+		INIT_LIST_HEAD(&ev_data->head);
+		ev_data->event_num = ev_num;
+
+		INIT_LIST_HEAD(&ev_data->callback_list);
+
+		ev_data->event = sse_event_register(ev_num, ev_num,
+						    sse_ghes_handler, ev_data);
+		if (IS_ERR(ev_data->event)) {
+			pr_err("%s: Couldn't register event 0x%x\n", __func__, ev_num);
+			kfree(ev_data);
+			return -ENOMEM;
+		}
+
+		err = sse_event_enable(ev_data->event);
+		if (err) {
+			pr_err("%s: Couldn't enable event 0x%x\n", __func__, ev_num);
+			sse_event_unregister(ev_data->event);
+			kfree(ev_data);
+			return err;
+		}
+
+		spin_lock(&sse_ghes_event_list_lock);
+		list_add_tail(&ev_data->head, &sse_ghes_event_list);
+		spin_unlock(&sse_ghes_event_list_lock);
+	}
+
+	list_for_each_entry(cb, &ev_data->callback_list, head) {
+		if (cb->ghes == ghes)
+			return -EALREADY;
+	}
+
+	cb = kzalloc(sizeof(*cb), GFP_KERNEL);
+	if (!cb)
+		return -ENOMEM;
+	INIT_LIST_HEAD(&cb->head);
+	cb->ghes = ghes;
+	cb->callback = lo_cb;
+	list_add_tail(&cb->head, &ev_data->callback_list);
+
+	return 0;
+}
+
+int sse_unregister_ghes(struct ghes *ghes)
+{
+	struct sse_ghes_event_data *ev_data, *tmp;
+	struct sse_ghes_callback *cb;
+	int free_ev_data = 0;
+
+	if (!ghes)
+		return -EINVAL;
+
+	spin_lock(&sse_ghes_event_list_lock);
+
+	list_for_each_entry_safe(ev_data, tmp, &sse_ghes_event_list, head) {
+		list_for_each_entry(cb, &ev_data->callback_list, head) {
+			if (cb->ghes != ghes)
+				continue;
+
+			list_del(&cb->head);
+			kfree(cb);
+			break;
+		}
+
+		if (list_empty(&ev_data->callback_list))
+			free_ev_data = 1;
+
+		if (free_ev_data) {
+			spin_unlock(&sse_ghes_event_list_lock);
+
+			sse_event_disable(ev_data->event);
+			sse_event_unregister(ev_data->event);
+			ev_data->event = NULL;
+
+			spin_lock(&sse_ghes_event_list_lock);
+
+			list_del(&ev_data->head);
+			kfree(ev_data);
+		}
+	}
+
+	spin_unlock(&sse_ghes_event_list_lock);
+
+	return 0;
+}
diff --git a/include/linux/riscv_sbi_sse.h b/include/linux/riscv_sbi_sse.h
index 84165cb5f2d0..be0c9ad0a00c 100644
--- a/include/linux/riscv_sbi_sse.h
+++ b/include/linux/riscv_sbi_sse.h
@@ -11,6 +11,7 @@
 
 struct sse_event;
 struct pt_regs;
+struct ghes;
 
 typedef int (sse_event_handler_fn)(u32 event_num, void *arg,
 				   struct pt_regs *regs);
@@ -24,6 +25,10 @@ void sse_event_unregister(struct sse_event *evt);
 
 int sse_event_set_target_cpu(struct sse_event *sse_evt, unsigned int cpu);
 
+int sse_register_ghes(struct ghes *ghes, sse_event_handler_fn *lo_cb,
+		      sse_event_handler_fn *hi_cb);
+int sse_unregister_ghes(struct ghes *ghes);
+
 int sse_event_enable(struct sse_event *sse_evt);
 
 void sse_event_disable(struct sse_event *sse_evt);
@@ -47,6 +52,17 @@ static inline int sse_event_set_target_cpu(struct sse_event *sse_evt,
 	return -EOPNOTSUPP;
 }
 
+static inline int sse_register_ghes(struct ghes *ghes, sse_event_handler_fn *lo_cb,
+				    sse_event_handler_fn *hi_cb)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int sse_unregister_ghes(struct ghes *ghes)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int sse_event_enable(struct sse_event *sse_evt)
 {
 	return -EOPNOTSUPP;
-- 
2.43.0

