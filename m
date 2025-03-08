Received: from mail-4018.protonmail.ch (mail-4018.protonmail.ch [185.70.40.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786151662EF
	for <linux-efi@vger.kernel.org>; Sat,  8 Mar 2025 18:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.40.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741457094; cv=none; b=Q9DFnl/bECR1z0bPb5XKFp+LrLm+vyd7kc671W65pK3aJtxeL4VU9ii6w/D/FdA3D8rX7RrfdCZsF9c8qS8KeTcwYuqzM/6gn1IKQEc2iEuq6+nJSw/qI2o3QA+PVd2E87G8cC+6vl5ASiuaofvd6gp79mCri+Ubx69LkPIJk5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741457094; c=relaxed/simple;
	bh=4xkp8rjSCNfXv0Kc3CEyhl7viQ3PFIk5UIxeVoEpTjY=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=svduQ2lDY7wRZuHu95O/xdaPef4MXbBjUNz4YzoJhTruqahafI5AH1cYPF99cd5Vgeu6HfB1c+wTt9wC+ZMFYZLQcgBqk2f6uzHhdw7L2wZh9yxHwZ1jxkzz4u9LJRgoTDnNFScjDALJ8HMThlPo7Ucbh4pQHtCkAEFlxWWivx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bens.haus; spf=pass smtp.mailfrom=bens.haus; dkim=pass (2048-bit key) header.d=bens.haus header.i=@bens.haus header.b=YL1w8NMX; arc=none smtp.client-ip=185.70.40.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bens.haus
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bens.haus
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bens.haus header.i=@bens.haus header.b="YL1w8NMX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bens.haus;
	s=protonmail; t=1741457083; x=1741716283;
	bh=4xkp8rjSCNfXv0Kc3CEyhl7viQ3PFIk5UIxeVoEpTjY=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector:
	 List-Unsubscribe:List-Unsubscribe-Post;
	b=YL1w8NMXHn8NtQv3w1N7TSNlQh0yhRT/76bB8eDQLNvZ4wzLziHkEQrs4Ol898UH9
	 Q1ly3FSuseK7FI2xjleSHKPVFqX13sNvU7kkZIg40Hk9qAIPv82GahRj7MJqwZkDSc
	 vP+ALlSSM/9HzThm+b0PeWdCkgJVAq+hT0YvSuWhvDqzlJzFvKmbu2mLm+Wopsthco
	 UvrsKSXAXRJoAH4xeuG/S2vty2akMDHhJBGpN32o+ttF5GzxxGUj8L6YeoTy03jf3P
	 8u7LTT+QH1DvoCRV9diOJk0WAL2+YXdx5cUM/53p164Kc1TY0hnnHDxqH/6vYidcYi
	 41uCCUdFmEbEw==
Date: Sat, 08 Mar 2025 18:04:39 +0000
To: Ard Biesheuvel <ardb@kernel.org>
From: Ben Schneider <ben@bens.haus>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
Subject: efi_random_alloc() returning EFI_NOT_FOUND
Message-ID: <5BK24Nc0mA4pe8BFp-FUgN4Q9lCFpR1TUFMKB8mRUJIhOG1hP3yYcVIulRsDSQA_7MvOOH9dg1nUiDvQSkQ2tS1vZeiZbMEFEnsMbPzB0cg=@bens.haus>
Feedback-ID: 124562356:user:proton
X-Pm-Message-ID: c2b9f984fb18a8e02ebb4907654f582a00059aea
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Ard, I am finding when trying to decompress a zboot compressed
kernel, efi_random_alloc() is returning EFI_NOT_FOUND to
efi_zboot_entry() which causes it to stop.

I think this is happening because the second for loop in
efi_random_alloc() seems to always break after only one
iteration[1], and the first address it tries to ask for is
reserved on my device. I suspect this behavior is not
intentional--otherwise why have a loop at all. Also, when I block
the break statement with the preceding if (status =3D=3D EFI_SUCCESS),
decompression proceeds as expected.

Ben

[1] https://web.git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git/tree/dr=
ivers/firmware/efi/libstub/randomalloc.c#n133

