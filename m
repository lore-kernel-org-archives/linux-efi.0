Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239F43B8924;
	Tue, 10 Mar 2026 19:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773169685; cv=none; b=QR8EDzaBQSn/NIGhLwD3J7Zor0Yhg4QnWsDgJICAfyfOa8Qn0l1bt08ZHA9xEueJMRlninR2uHGBqKSJewXH5RRTtxcOBAvjFQJ3z2EyAqJp3Eg7yb0vArNqYcaUn6RmMmLAvLvKqdAZ7XdeCj+8HZwQH9thZUTTIQ/GknpGBw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773169685; c=relaxed/simple;
	bh=n7ZNpRWjQ5lW34DrHLddZlbCOJU9ccyTSwvq408p/pA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=psk9K38I/QqhakdKdmR+3WCed8e2F8HUFZ8acU6WVqdpQwg5EaQaMVv4EU1C9kRjIun+ZXDik8ohm2kRM4BXI1DwYyVczs4paL2Gw9SgeQNM+ekT/LGlehryggeXrBtcQMgAh0X4NzldNpPxMKzYFKJVysmEJItTS+bsiypdR/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=invisiblethingslab.com; spf=pass smtp.mailfrom=invisiblethingslab.com; dkim=pass (2048-bit key) header.d=invisiblethingslab.com header.i=@invisiblethingslab.com header.b=UrrXpcEn; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=G88T593o; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=invisiblethingslab.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=invisiblethingslab.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=invisiblethingslab.com header.i=@invisiblethingslab.com header.b="UrrXpcEn";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="G88T593o"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 4BA78EC003B;
	Tue, 10 Mar 2026 15:08:03 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Tue, 10 Mar 2026 15:08:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	invisiblethingslab.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to; s=fm1;
	 t=1773169683; x=1773256083; bh=2HxRlXBR3ubYLF/EDBByoY1G70xa+FKr
	TSIZ7/z47fI=; b=UrrXpcEn5J1jnFEnQPRv18WAvdjoZVTsvT9YDD7kI+1qTCw2
	hAmAEJSI+s1QReA9Bdcn1JpPQb0x/mWYgR3QBTeYSdS52k+N4GvaBVXy0/eVonWU
	/4ghIhNUSnwOkA0X+oz8wbyRajOtWlRr+1zsz7SV+F6dAhKjPe1h6APfCvmorE7Y
	NrWyiQ0DNppejvlFecaGiVTZ7Ucq+PNbpNd4TfHjDruCtPcHqJVLmW90vhcdc5rl
	Q4HJ6sbc/IamlT1vHKwqffjpkhNPz98JugS58wIKbsHVGrXbbpgN2XBz/F+2Za8N
	0Q7xMOOzzZJ3dnnSikfrsXx/n7DCqS3HmxIH9w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1773169683; x=1773256083; bh=2HxRlXBR3ubYLF/EDBByoY1G70xa
	+FKrTSIZ7/z47fI=; b=G88T593oQR1+MH8I1mwv2cnyE8fYfYcZIRySBquXMdS7
	q8jyUip0yAjJikQiAsf+ZjgwEDV/RDkEPiwhvpv70ZX5SPGz3WVbqrz7qgVReUsN
	7uWMyQhDRsMSBweUeqt1gRoJq5SQxdBmCU2w/uCU/vDYb7oNHX7qVmj6Xzbhsqfj
	O1e8ZxzgMF96S3HMVWQtaxciOGLxYDQ2XyiC5qHoGhllcwa3kTMcnyjl9c6+03I7
	zLcQDymDpwfsVLNhBgxPCJJSsHt5dmYZlZCwPZmGaSCQvkdgXlZJS8i0CMxp3I9i
	QMdgt6sFTD7z2jeMXeTdisQofSewWBmTTbD5PGR+Aw==
X-ME-Sender: <xms:EmywabMMaysP6SHZ_j8m9rvKKQyBt8wlO1t3XTyeNTePJFvwb_ixIA>
    <xme:EmywafSp7nxV1SBrnbYvrjvoPUAT-aJstzPzkPo0x8ibEi-htVybjLFXPQKysfxxt
    2TWpDLJ-XobXcdYoVyUXCuQI6XlmWkBAlEv_kdsef_EOYaMZg>
X-ME-Received: <xmr:EmywaRhktUn29UFAu52RSq_x7eCbunOd5NEgMvaiWn1K8UeTdBYacm-HpYjJogiXYmlQRntLxOZT3mzKhdTcZKCBZ8umEubC0eVfL8hVP80>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkedukedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofggtgfgsehtkeertdertdejnecuhfhrohhmpeforghrvghkucfo
    rghrtgiihihkohifshhkihdqifpkrhgvtghkihcuoehmrghrmhgrrhgvkhesihhnvhhish
    hisghlvghthhhinhhgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeekkeeiveek
    ueehfeegveejveevuedtjeeiveeguefhvdffueetfedtuddvueetveenucffohhmrghinh
    epkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepmhgrrhhmrghrvghksehinhhvihhsihgslhgvthhhihhnghhslhgrsg
    drtghomhdpnhgspghrtghpthhtohepiedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    oheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpth
    htohepmhgrrhhmrghrvghksehinhhvihhsihgslhgvthhhihhnghhslhgrsgdrtghomhdp
    rhgtphhtthhopehlkhhpsehinhhtvghlrdgtohhmpdhrtghpthhtoheprghruggssehkvg
    hrnhgvlhdrohhrghdprhgtphhtthhopehilhhirghsrdgrphgrlhhoughimhgrsheslhhi
    nhgrrhhordhorhhgpdhrtghpthhtoheplhhinhhugidqvghfihesvhhgvghrrdhkvghrnh
    gvlhdrohhrgh
X-ME-Proxy: <xmx:EmywaQ9Nef9A55XZVqt6WoyIoKjewaMhjvWzlfpzPp4dCZSJFiavtg>
    <xmx:EmywaQHAvdvazssPNkiCm1H83loDHSSuXWwJ4JVdqVQdYo6wCewSNQ>
    <xmx:EmywabmqBegV9GaLi7B3OACoywVO_kz2yBAYFl_Q7i_Lcb_Hl0_Jiw>
    <xmx:EmywacbCm51NDUyS12-NykivHTRl16pt_-7Q87UvkFpuCGzcJzWp_A>
    <xmx:E2ywaTuwaRpF2MUY5jWEwJXWputhP_-I_E7aMCK8ukZdFibEEUbSn6fR>
Feedback-ID: i1568416f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 Mar 2026 15:08:01 -0400 (EDT)
From: =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	kernel test robot <lkp@intel.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-efi@vger.kernel.org (open list:EXTENSIBLE FIRMWARE INTERFACE (EFI))
Subject: [PATCH] efi: fix type in efi_mem_type()
Date: Tue, 10 Mar 2026 19:56:18 +0100
Message-ID: <20260310190753.273425-1-marmarek@invisiblethingslab.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Drop const, as use of efi_mem_desc_lookup() will modify the variable.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202603101851.bAhG7uGN-lkp@intel.com/
Fixes: 5992265762e6 "efi: make efi_mem_type() and efi_mem_attributes() work on Xen PV"
Signed-off-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
---
 drivers/firmware/efi/efi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 36efc92bdf02..288834a193d1 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -1001,7 +1001,7 @@ u64 efi_mem_attributes(unsigned long phys_addr)
  */
 int efi_mem_type(unsigned long phys_addr)
 {
-	const efi_memory_desc_t md;
+	efi_memory_desc_t md;
 
 	if (!efi_enabled(EFI_MEMMAP) && !efi_enabled(EFI_PARAVIRT))
 		return -ENOTSUPP;
-- 
2.52.0

