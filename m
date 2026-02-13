Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EE933D4F3
	for <linux-efi@vger.kernel.org>; Fri, 13 Feb 2026 15:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770997724; cv=none; b=dQx4TuJV2fPZEu16RC3AaSZOrJ3n5Yy9UR+r/n63/Tg0ZsgUoaDPf/fwG+DEp+yXcIkfOtjIHfklnZSk4nsI03Z18XbropkduInv6WerYA9PXjQvZgx1aPzOXbYJuuQlYnrRCMx97sS0zSCwEVdwHcYZ59DKbRFftOjLuZ4B8oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770997724; c=relaxed/simple;
	bh=PTJFDGkeSN26ugvAI4aRe+dHGTbs5yOXGvLemsc0sMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TwThBGNHKp9huHwX27jKs4JvcTIeYqj3orvjUz5MVhLcP89pXhm/0tN7cgBgjuJMCr/ouv4Y/M25YqnmevhQN/IIMXO+qL2098fdMOb0lLVV4/iVx3KEWEHfUpluC9MT7aIS7ENBHGvc3Z9liMO9ecVyjq3epvI89kd5Cp0k+OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A5i2uuQp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A5i2uuQp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58051C19424;
	Fri, 13 Feb 2026 15:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770997723;
	bh=PTJFDGkeSN26ugvAI4aRe+dHGTbs5yOXGvLemsc0sMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A5i2uuQpF4s1RFOexFyOdlWT+dXE1qKCpXkjUA0xr/6UY1MoU+yVgL9QvHoHDM8IH
	 rC431ghZqIHGKIL6pVXQ+0+4eQmd2glx1lLIlywGoD2re53AX+ch0/uyhKc2EIq8cf
	 6SNYfTseYYlyvuflEn8V/8GJSV21MAskpD0706/8XWrDujqh6ISUuxFNC4HB+vPxmL
	 eIxtXbi10RQLYhZBOS7c7uR4tW+2NPD5wU36IkEkyVpVUNJ51GTeqUeMrwnJePnZId
	 d2zLfhxtUd6qY4o9kcgFL3UQEbttabvpBsumzZxNnE0vESnBZEuZdKh0g+gs21p00f
	 HPFAulJJy8OvA==
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfauth.phl.internal (Postfix) with ESMTP id 84B87F40069;
	Fri, 13 Feb 2026 10:48:42 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Fri, 13 Feb 2026 10:48:42 -0500
X-ME-Sender: <xms:2kePaWqFpbN29LIl7FP6YKDHBORsC6aKz4tHMK99Lt8a6F7Ifp29mg>
    <xme:2kePaczbDUhypKCGMrRP9feRVW6Kuz6m_ZhplOXm2iRaIayUwPE0q2zr5c_ykeJV2
    mA1mckTp1Q9UcMVG7xCn1iOh6m91Ssk46PoJsHfJDrT_mpze86dmjI>
X-ME-Received: <xmr:2kePaavrCHPag5L-dfR_0UMCJj-KN-zv2neFD3aT1shwPafSHSj1YVbdjfMH3g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvtdekieehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfmihhrhihl
    ucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqe
    enucggtffrrghtthgvrhhnpefhudejfedvgeekffefvdekheekkeeuveeftdelheegteel
    gfefveevueekhfdtteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidq
    udeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgse
    hshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeduvddpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtoheprghruggssehkvghrnhgvlhdrohhrghdprhgtphhtthhope
    htghhlgieskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepmhhinhhgohesrhgvughhrght
    rdgtohhmpdhrtghpthhtohepsghpsegrlhhivghnkedruggvpdhrtghpthhtohepuggrvh
    gvrdhhrghnshgvnheslhhinhhugidrihhnthgvlhdrtghomhdprhgtphhtthhopehthhho
    mhgrshdrlhgvnhgurggtkhihsegrmhgurdgtohhmpdhrtghpthhtohepgiekieeskhgvrh
    hnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqvghfihesvhhgvghrrdhkvghrnhgv
    lhdrohhrghdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrgh
X-ME-Proxy: <xmx:2kePaV14ltygcAKdm1e1YpJBJV3SBvdjryEHx_Ly7h2T4puje4izog>
    <xmx:2kePaSDv4DSW6qXpLIs366VIKTgAw5Uauj3brHhUPo2iQRODkr84ag>
    <xmx:2kePaTAwijGEDJJ7mRym84UrlopQ_3-TneWyZ9ls_JALYhLEIGPDDA>
    <xmx:2kePaTmvS-THGJTVbPJSrT4dWmOQyLUDJ2vsgwmJMRSpY4fcyC4tiQ>
    <xmx:2kePaTgd3TdN6tDELwo6EHKoRo7Q64H4mWOh5RUIWu7fX9FJW8Qg_5nW>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Feb 2026 10:48:42 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>
Cc: x86@kernel.org,
	linux-efi@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Moritz Sanft <ms@edgeless.systems>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 1/2] efi: Fix reservation of unaccepted memory table
Date: Fri, 13 Feb 2026 15:48:37 +0000
Message-ID: <20260213154838.46567-2-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260213154838.46567-1-kas@kernel.org>
References: <20260213154838.46567-1-kas@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The reserve_unaccepted() function incorrectly calculates the size of the
memblock reservation for the unaccepted memory table. It aligns the
size of the table, but fails to account for cases where the table's
starting physical address (efi.unaccepted) is not page-aligned.

If the table starts at an offset within a page and its end crosses into
a subsequent page that the aligned size does not cover, the end of the
table will not be reserved. This can lead to the table being overwritten
or inaccessible, causing a kernel panic in accept_memory().

This issue was observed when starting Intel TDX VMs with specific memory
sizes (e.g., > 64GB).

Fix this by calculating the end address first (including the unaligned
start) and then aligning it up, ensuring the entire range is covered
by the reservation.

Fixes: 8dbe33956d96 ("efi/unaccepted: Make sure unaccepted table is mapped")
Reported-by: Moritz Sanft <ms@edgeless.systems>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 drivers/firmware/efi/efi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 111e87a618e5..56e9d73412fa 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -692,13 +692,13 @@ static __init int match_config_table(const efi_guid_t *guid,
 
 static __init void reserve_unaccepted(struct efi_unaccepted_memory *unaccepted)
 {
-	phys_addr_t start, size;
+	phys_addr_t start, end;
 
 	start = PAGE_ALIGN_DOWN(efi.unaccepted);
-	size = PAGE_ALIGN(sizeof(*unaccepted) + unaccepted->size);
+	end = PAGE_ALIGN(efi.unaccepted + sizeof(*unaccepted) + unaccepted->size);
 
-	memblock_add(start, size);
-	memblock_reserve(start, size);
+	memblock_add(start, end - start);
+	memblock_reserve(start, end - start);
 }
 
 int __init efi_config_parse_tables(const efi_config_table_t *config_tables,
-- 
2.51.2

