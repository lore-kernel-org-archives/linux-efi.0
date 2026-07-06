Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8733E8C6F;
	Mon,  6 Jul 2026 09:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783329502; cv=none; b=YQm0F23a2y8zx3HZeJftZZNOuw5p53U7wb8YNr92sgZ9vLP/Ab2Onp7GcA3zqWu/Cn0mJGKOKRmMRHUOMBG+TFB4LrgKEN5UEX4q/Pcrq3xLjo6wjfRmmO5Ie7zQ9J4t2OHg55g9Dg2MBnTPqgp73g8g2eQKhoSdD5dYUFN0laM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783329502; c=relaxed/simple;
	bh=us+BTOSuleW+zhLIE7FG5OiAMD1nc9S/DyjcVVxeSvY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R++ZeOXUA2ZRfGIu6byD6tILJRWBwh2Llg0D3NSHfeGO2G21jyPMyECTHZPWYR4Wrry+U4ZL99kvbXt3N8hVQoVe1PKXkRbT/7xQ9AsyS5EtFoACRj7bdeNw8IUqtjoki7ki9dVwVvrTRQq+JD0j2ojesMitOAMkjZHZvSRmeDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.245.140])
	by APP-01 (Coremail) with SMTP id qwCowAAXudHWcktqLx3xBA--.35503S2;
	Mon, 06 Jul 2026 17:18:15 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] efi: apple-properties: validate setup data header length
Date: Mon,  6 Jul 2026 17:18:13 +0800
Message-ID: <20260706091813.77792-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAAXudHWcktqLx3xBA--.35503S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Xr47Ar15JrW5Zw1kWFWfXwb_yoWDtFX_ur
	y5ur18XF1kKrWjqrnxArW2vrWvyayUu3W8ZrnFgw1akr43Ar1fXFWvvFn5Zr18Jw4qqF93
	tw48urW3AF4xCjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb4xFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1q6rW5McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r12
	6r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JU2Q6JUUU
	UU=
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

map_properties() remaps the Apple properties setup_data payload
and then reads the properties header fields.

Reject a truncated payload before checking the header version and length
fields.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/firmware/efi/apple-properties.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/apple-properties.c b/drivers/firmware/efi/apple-properties.c
index 2e525e17fba7..f401a04edf4c 100644
--- a/drivers/firmware/efi/apple-properties.c
+++ b/drivers/firmware/efi/apple-properties.c
@@ -207,7 +207,10 @@ static int __init map_properties(void)
 		}
 
 		properties = (struct properties_header *)data->data;
-		if (properties->version != 1) {
+		if (data_len < sizeof(*properties)) {
+			pr_err("truncated properties header\n");
+			ret = -EINVAL;
+		} else if (properties->version != 1) {
 			pr_err("unsupported version:\n");
 			print_hex_dump(KERN_ERR, pr_fmt(), DUMP_PREFIX_OFFSET,
 			       16, 1, properties, data_len, true);
-- 
2.43.0

