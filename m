Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.177
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795086861;
	b=iyGx3gG4+BUeLkFDYZCEYIN26yhfDk74MA0DUNY4HrKCc3JkSn42//LX7VYZfrgUZeET
	 X0E05FGCZimp5cyVgtt5hBGkngCciqUyDYTFCAn7kRzo0wICq446Cqr4kZD7pxUslztTu
	 uNYyaA1ffi6ZLCYoK6GkyVkww2JAoJO2O5hgUMz5DcL5WZdOFPZDFcvwjr7ZbGVUt8ltF
	 50DTS16P2HQlSguMmNT+gkWrzF9JGfbF0w49DB2cf1NdES7qX6HWvCtzKqnGOY37XM0mo
	 NM6q0hC/1WcoHovLjQHdU2neHqeHsxFbI3pUxgWLrUr6Y24eiJEsPh0AoTIVEaDuXow==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795086861;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type;
	bh=gdl4ZwMsFppyGc+IZDtPmhYKKcOVSIQ1Mm6hg1JYybg=;
	b=T0/EhUjXn2OlL2aO0EhGb4gJapJ3ecAeeG5JF+dcJgFySaB0dfEzf3YmjiByoN2h4NNI
	 5JcENUX8BL3C6R8Ozi2ngqkFRki+A5JVTaBj9diRko1CX/sbJOaCK6BcexELmPC1dExmA
	 e7UobdsAEY0AcJZ5iYmM3bfgmJouJXGx0vjp3ZYc/NqO2V5hT56QpsDVGuR7hKkk9byi9
	 9+B7IE+VHm+0JqzZOpMNxM59E4aYXIu+gECM1iNmz9d4SsoSGfRhMA6m9tXlIi7wflvzi
	 tpV4JOwS5xiZi5CfpOlTJNeNV7i4aoZ7tVykpwqv54j0dmBdmN0Sku9hLRyOHy/Mv1w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=fail header.from=fc.jpn.org;
	spf=pass smtp.mailfrom=gmail.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.177
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4417606A326
	for <linux-efi@vger.kernel.org>; Thu, 19 Nov 2026 11:14:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4417606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fc.jpn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-8b0dba37a7fso18818627b3.0
        for <linux-efi@vger.kernel.org>; Thu, 19 Nov 2026 03:14:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795086860; cv=none;
        d=google.com; s=arc-20260327;
        b=BRRNpsLyg/etadr7Vj/oZha38o8Qnh/ZYAPg9PlKSCBTOk8pbq+tbPdEFlnzc1/qf8
         G0gxUlUcYqwu3aKOyQmQZlW61b5J2pjeAb+2hUpYH3ail24AAZ8J0IcMJG8XzCwgacOI
         vxwnkavvL6PJsuYY6HUxaxh+HH+XC1VpdNWSvI3e+lxp2kAouE8iC/uGCGygAw83Wpj0
         3ml8L/4lfGs5zMyCETIg3LB8i3ie3UQE9tPohOVMhSF90wjsrqyZMHoa01NhDZ4iAFx3
         hxS7gMwQZp2EnQHQocU4liWJR6nM3eoHZ8TPVe5Em4yI5xOcmfJXx/JsBWx6fVTGjPF9
         ETAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version;
        bh=gdl4ZwMsFppyGc+IZDtPmhYKKcOVSIQ1Mm6hg1JYybg=;
        fh=sDNlbjnfbVOA91JCQgvZ8f3PnrFNkpYu9hb7Jpre2AM=;
        b=dSsU9G7R3Pzki/jiwaCKuL0uM/fuQ0dSiviSkGzdSpys+bd7xOKOuzi464JM+8lXG6
         UTvckPxPN8xdyfUxKjGyP2ChX91yE1iMg3lgwH2U/2ZTKwssQKfz5qaup36Jng8pMaJI
         ehJ140Ga4bVGlBIIDZb83If0PGWnUp9eWDQYW+FzTnzlbPW8QqWpq/Cz7UaPHkzU9gDJ
         oUmBXXLQ4JI66ZuASvvlvoinpokLH0TOhEJ5MaDwrY6T21ve82NTfhxwzGgAQ6c0UPSZ
         o7uwb4/f0tMODT1sjqidNQqheQN1xexwb3nD+KggJY/PvNz5r69M5/blrNUFcUccHByV
         tcbQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795086860; x=1795691660;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=gdl4ZwMsFppyGc+IZDtPmhYKKcOVSIQ1Mm6hg1JYybg=;
        b=ueLoLPFIerH/ugM3xcR82wFAOWY2d8OZ5bhEktvzR0DvNVVMNO7VUyPr2Kq9kxeghI
         /L3CZOEzXkRXEg6H+M3zpQcXVUmWiNuNqeOKvoP4rRYX90pLGeqnGhDW7+3qV3lcwawc
         OAu8T0kbRA7Z1tJMo6JGIUbiwWtXc9EIMHHHABHNUpG0wGF/emqfYrfwZ+aaxgR5+laa
         5SfqdGjWExdLeGvGj3RG7b3P40gFfqihlN9rwQRA10r6unr6v66k5hQzr2mRNv8vw6qY
         w5CTqTSY3qu1p2d7fBBvcNHpQNJOZa6TUoCz46Oi6pffR6TV4tOdabnKmnrO9Lo9oY8L
         jxJw==
X-Forwarded-Encrypted: i=1; AL+hErHlt8QCzTg7lNhuE+DYh76Fdb5SrBtARav/RKM0+zHYOMiE8/27ywruPk15MWyk0AkXp6NTUfqFqz8=@vger.kernel.org
X-Gm-Message-State: APuU4Z8LFMsI9mvD8Ha6+RlRx5nCbP7MhNM0bA82MXlkqGPwEIYw0YLh
	VFrAnyRsFnoEv2gqUEWLmejpWjCcV+MgeLcjCsZgW3Rh9VgJbuNZAIT/cpDeAf/yoc3ee2U2b7F
	R25ktXBwgA/VNkGopa25RPiiKR1yY7XzpLl6U
X-Gm-Gg: AZFdTZeax+UzFUgjDinzqfAuRI05xS6cg/7nhQfnEgZp7eWn5Y9ztifrvJ/8xFvgeoq
	LaG+fFT382MLb7XZHk+dXDWwKoIFHFKgADgeHv0oIv0tTKWttjC+NdxkJfAfoKGfxkqVigiZ1T3
	J/9Ooe1C3JsiIg7W14ki54YEZO1gBfMZ4RML+DxZBtrRQEhij5JuVC95M66bssmugaKMGGSEUDS
	Iy2ybf+xdCk8qRYPDblXsqsDdJtL4+d9h3Ul9Wb2xfwNcqXJR9xv0nM2BLZemSVFCDU23RdrcpX
	LBO+i/cktkT/+l5kQxdRgusBqN9zPlj74lKD2dyAn/G48gb81IGwBrKrwx8rCriLUYmBiWLlS0h
	Kc+M42jJojHqC/kpG3WPa/OEhcQApgigoKy3rUy9FCTS58tOJOEpJ8smMuLg9cay/FtEE81osa5
	3OtOg8w0/0mcUfJbyzJyiYc3GCAcnIgFi5VmoFISQ=
X-Received: by 2002:a05:690c:44a:b0:8b3:2e4f:6c06 with SMTP id
 00721157ae682-8b4fed6f8c2mr19300117b3.47.1795086859463; Thu, 19 Nov 2026
 03:14:19 -0800 (PST)
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Kazunori Ando <ando@fc.jpn.org>
Date: Thu, 19 Nov 2026 20:14:07 +0900
X-Gm-Features: Aa3M54qH87R4r-pJ1ObKkvFZ7ORk-7hIS0GY3zxihV_ERs9C13QvuiQcSH1M0Jc
Message-ID: <CAKPbQspktkzF-GH9728aG0mAiQGG9NQxbO15ruvcyaQGTm2y=w@mail.gmail.com>
Subject: [BUG] x86/hibernate: Intermittent resume failure due to a 4 KiB
 EFI/E820 memory map change on MacBookAir5,1
To: rafael@kernel.org
Cc: pavel@kernel.org, linux-pm@vger.kernel.org, x86@kernel.org, 
	linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

I have been investigating intermittent hibernation resume failures on an
Apple MacBook Air (11-inch, Mid 2012, model identifier MacBookAir5,1)
running Void Linux.

The system occasionally performs a normal boot instead of resuming from
hibernation because the EFI/E820 memory map changes the classification
of a single 4 KiB physical memory page between usable RAM and ACPI
Reclaim Memory.

I have reproduced the issue without GRUB and without the proprietary
Broadcom wl driver, with a kernel taint value of 0.

1. System information

- Hardware: Apple MacBook Air (11-inch, Mid 2012)
- DMI product name: MacBookAir5,1
- Firmware: Apple EFI 429.0.0.0.0 (2022-03-18)
- Architecture: x86_64, 64-bit UEFI
- RAM: 8 GiB
- Distribution: Void Linux (musl)
- Affected kernel versions: 6.18.62 and 6.18.63
- Tested kernel: 6.18.63_2 (Void Linux package revision)
- Swap: 16 GiB swap file
- Hibernation mode: shutdown
- Boot methods: GRUB and direct Linux EFI stub boot

The tested 6.18.63 kernel includes a small diagnostic patch that prints
the saved and current E820 CRC32 values. The patch does not modify the
integrity check or the resume behavior.

2. Steps to reproduce

1. Boot the system with hibernation configured.
2. Collect the EFI and E820 memory maps with efi=debug enabled.
3. Hibernate the system using shutdown mode.
4. Power on the machine.
5. Repeat until the system performs a normal boot instead of resuming.

The issue is intermittent. Multiple consecutive successful resumes are
possible.

3. Observed error

A failed resume produces the following kernel messages:

    Hibernate E820: saved CRC32=1eebf10d, current CRC32=f70aedce
    Hibernate inconsistent memory map detected!
    PM: hibernation: Image mismatch: architecture specific data
    PM: hibernation: resume failed (-1)

The failure occurs during the E820 checksum comparison in
arch_hibernation_header_restore() in arch/x86/power/hibernate.c.

4. E820 memory map comparison

I identified two recurring E820 memory map layouts.

Layout A:

    0x8ad53000-0x8ad64fff usable
    0x8ad65000-0x8ad8efff ACPI data

Layout B:

    0x8ad53000-0x8ad63fff usable
    0x8ad64000-0x8ad8efff ACPI data

The only difference between these two E820 layouts is the classification
of the following 4 KiB page:

    0x8ad64000-0x8ad64fff

I independently reconstructed the E820 tables from the boot logs and
calculated the following CRC32 values:

    Layout A: f70aedce
    Layout B: 1eebf10d

These values match the checksums printed by the diagnostic patch.

5. EFI memory map comparison

With efi=debug enabled, I confirmed that the corresponding change is
already present in the EFI memory map.

Layout A:

    0x8ad53000-0x8ad64fff Conventional
    0x8ad65000-0x8ad8efff ACPI Reclaim

Layout B:

    0x8ad53000-0x8ad63fff Conventional
    0x8ad64000-0x8ad8efff ACPI Reclaim

Thus, the difference is present in the EFI memory map available to the
kernel and is not merely an artifact of the E820 conversion.

The physical addresses of the ACPI tables reported in the boot logs,
including RSDP, XSDT, FACP, DSDT, FACS, DMAR and SSDTs, remained
unchanged.

No ACPI table reported in the boot logs occupies the affected 4 KiB
page. However, I cannot establish whether that page contains other
firmware data.

6. Reproduction without GRUB

To investigate whether GRUB contributes to the memory map variation, I
configured the same kernel and initramfs to boot directly through the
Linux EFI stub.

All initial warm and cold boot tests through the EFI stub produced
layout A.

However, the first hibernation resume attempt through the EFI stub
failed with the following checksum transition:

    Hibernate E820: saved CRC32=f70aedce, current CRC32=1eebf10d
    Hibernate inconsistent memory map detected!

The EFI memory map changed the affected page from Conventional Memory to
ACPI Reclaim Memory.

The kernel command lines before and after the failed resume were
identical and contained the EFI stub-specific initrd path.

This establishes that GRUB is not necessary to reproduce the issue.

7. Reproduction without the proprietary Broadcom wl driver

I repeated the hibernation tests using direct EFI stub boot with the
following additional kernel parameter:

    module_blacklist=wl

I verified that the wl module was not loaded and that
/proc/sys/kernel/tainted was 0.

The same hibernation resume failure was reproduced, and both directions
of the E820 checksum transition were observed:

    f70aedce -> 1eebf10d
    1eebf10d -> f70aedce

Therefore, the problem is reproducible without GRUB, without the
proprietary Broadcom wl driver, and with an untainted kernel.

8. Related discussion

I found the following related patch proposal:

[PATCH v2 0/4] PM: hibernate: Add relaxed_memmap option for x86 E820
integrity check

https://lists.openwall.net/linux-kernel/2026/06/23/1726

However, the proposed RAM-only checksum comparison would not appear to
address this particular case, because the usable RAM boundary itself
changes by 4 KiB.

I understand that ignoring the E820 checksum mismatch could be unsafe,
particularly when a page classified as usable RAM during image creation
is classified as ACPI Reclaim Memory during resume.

9. Questions

- Is there a recommended way to investigate why the firmware memory map
  changes the classification of this particular page?
- Would additional EFI or ACPI diagnostics be useful?
- Could a platform-specific workaround safely handle this type of
  memory map variation, for example by consistently reserving the
  affected page before it can be used as normal RAM?

I have not yet tested the latest unmodified mainline kernel, and I have
not established whether this is a regression.

Representative before/after logs, EFI and E820 memory maps, kernel
configuration, hardware information, module and taint information,
and the diagnostic patch are available at:

https://github.com/andokazunori/macbook-air-hibernate-debug

I would appreciate any suggestions for further investigation.

Thank you for your time.

Best regards,
Kazunori Ando
