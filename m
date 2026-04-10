Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67E93A9D82
	for <linux-efi@vger.kernel.org>; Fri, 10 Apr 2026 08:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775808030; cv=none; b=Kz5FJRd3JhgiePygKqYZmsNwF5OZcuwBbsF0UVKJK+BfeNTQZif+NWmxpMsqRS9mZCkTSu2wRiyBL2mNB5EI+iZgyioTs8Jf473Dpeqh/jqrcMQITEhYtEZDEWgSHv3G8xLVQ03ssZjf1EtA76uSSoNTN3050z8Le0ZhWvaPguY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775808030; c=relaxed/simple;
	bh=KZOdKedRJTaQZyah+9eCfz+YfoGmm7w2ZyA7JVGQMg4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=VlyMAb9L/l9vCe9VVpFfdlGEFzebd+dA9b3otow1ieZDAKH6/Dh2dmbeUzovt73FRF0My2PKt02Rc4dPWExih59l/KHt5eDMkSpD+GsWSy60sfVWs+ZqvdMTrWXg8alrplny3jQi16nEV1Kzb0NBNDMsqikDF0goGap+kstCf78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nbihcUM2; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nbihcUM2"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43b8f9374dfso935336f8f.0
        for <linux-efi@vger.kernel.org>; Fri, 10 Apr 2026 01:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775808028; x=1776412828; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dLbVvzFy8D701YVA2BRF24HdYZCjubrUN80gi2rZdHE=;
        b=nbihcUM2nhhmB8xsEQO/A+MK8LNdCY8a8owrkjPuf0+43+C2CxlT+ranxkywjEkZi6
         K+fjG3iuza9fVY2pE1CxkBQUOLgiAYFctJO1tQ0TUWGmAD4h5bbjIVjBaBcgOyJa5Dqz
         Lf1oIYlg3eniRH5KMrw1uH62ZwjpjRGypjEfgIyUCoUFdvXnQt44XishubtZhvwS9VTo
         cF+w4LCgf/vLzpczXbO0clJ1QzjZ0cxcf0qeMr3kRqMCVmlWZXv8AIvIjPLm6BLdGfgj
         uM3wdidFgZeNAxQVCcrr1583kwDvZ5bSeun9eMGuxooIXkb/3cUvuAnYR0TjA/MnlLh+
         taCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775808028; x=1776412828;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dLbVvzFy8D701YVA2BRF24HdYZCjubrUN80gi2rZdHE=;
        b=LFCElZZFT6nvanVnCX+xxghrnPx0CcKQdC1lVCP83hAa2KaK64qR4bZFVY6T2zUl3W
         +uQprfr0Q7WhOel/MDJybka521t0TfbOIu6O9mqpkWQQfNO9NEHVAwwfwvYVag7oegLi
         tcNbXZoRB8tiRRIusuXYlq8kmciCeZjQoqz/BZgboYtFZVV85WoZsVeP0BZzess3Ifbp
         AHzKRowS06xgRqPk+sXattfuGxWPHczSOZtxvZHI/svZVNofVqDVa03mvJz1yNvIUDC7
         PJADbRa0YtH9hnOWLQXbrVld2FQjwhXmdsmBDAB586sSaKUmSFBnL2GSzr8fXWNeaoRn
         NVXw==
X-Gm-Message-State: AOJu0YyP72w3YF7yF/NzZsLppCjC6J9vHUxDCXDXbPdkwqmq9DsBccXz
	05nKi4Gb8GFfEMULIJ7P+V1+6R3bkx6+NqBSRj/SaQyes+eobjIFtkS/6faxuNecD12xLK8WqR4
	ylWCflVqSly2+DnZtSXHEKqOGKV52FsaH/oF+oX0r7GOK/00NYhsz9JPKzKgVvctS2IRLywfcFd
	BBqgLIlprkWW5UiT0wLGWrEBQisVUYmw==
X-Received: from wrrs6.prod.google.com ([2002:a5d:4246:0:b0:43b:63b2:1e5d])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:3104:b0:43c:f67a:5b50
 with SMTP id ffacd0b85a97d-43d6493219fmr2978983f8f.10.1775808027362; Fri, 10
 Apr 2026 01:00:27 -0700 (PDT)
Date: Fri, 10 Apr 2026 09:59:50 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1397; i=ardb@kernel.org;
 h=from:subject; bh=B48VgGQqLR2SWHpOUkloN+MlJxE8/ErgP8y5RmAT8vg=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfPG2u8HT68+vfPgBK5LucZOyoor2Sc3nd3652vykoMBP
 Bt83Qvvd5SyMIhxMciKKbIIzP77bufpiVK1zrNkYeawMoEMYeDiFICJ/JrPyLD0Sr98720DS+F3
 YQZ327d+CTrlWjf/Wdr6XE+WnXcFyn4z/NN5vffmbYF5M+QPc7xUC34fqHuo+MiqiLcRVbKxwlr +0kwA
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
Message-ID: <20260410075950.1687350-9-ardb+git@google.com>
Subject: [PATCH 0/7] x86/efi: Prepwork for memory map cleanup
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

This is a follow-up to [0], which had some fundamental issues, as
spotted by Sashiko [1]. Disentangling the EFI memory map mess on x86
needs a rethink, but some of the prepwork is still worthwhile, and so it
is presented here separately.

The end goal is still the same, i.e., to remove the need for the x86
boot code to modify the EFI memory map, or reallocate/copy/remap it
numerous times.


[0] https://lore.kernel.org/all/20260319090529.1091660-21-ardb+git@google.com/
[1] https://sashiko.dev/#/patchset/20260319090529.1091660-21-ardb%2Bgit%40google.com

Ard Biesheuvel (7):
  x86/efi: Omit redundant kernel image overlap check
  x86/efi: Drop redundant EFI_PARAVIRT check
  x86/efi: Only merge EFI memory map entries on 32-bit systems
  x86/efi: Defer sub-1M check from unmap to free stage
  x86/efi: Simplify real mode trampoline allocation quirk
  x86/efi: Unmap kernel-reserved boot regions from EFI page tables
  x86/efi: Drop EFI_MEMORY_RUNTIME check from __ioremap_check_other()

 arch/x86/include/asm/efi.h     |  6 ++
 arch/x86/mm/ioremap.c          |  7 +-
 arch/x86/platform/efi/efi.c    | 39 +---------
 arch/x86/platform/efi/efi_32.c | 31 ++++++++
 arch/x86/platform/efi/quirks.c | 78 +++++++-------------
 5 files changed, 69 insertions(+), 92 deletions(-)


base-commit: 259e3e6f9382b6a9fe570313d97c59a233f7d72f
-- 
2.53.0.1213.gd9a14994de-goog

