Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C493A4530
	for <linux-efi@vger.kernel.org>; Thu,  9 Apr 2026 15:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775748371; cv=none; b=sK7VycSQAvrmxtLLY1drQjzGhZNG10mhBwjbbAoiRcW/oCcFu8xcor89y1QvcuY4VbUN8OKaVfJp2F3JEr9rN2OMO3PUN+qj4/g+aXiR3cphBiVeYRcIWLya7I5OnOGtLZeKuvm6BzZHef/nuGMnurrwCemwybYOUUyZoNsPDLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775748371; c=relaxed/simple;
	bh=D1chEyCPlKyg0Pzm8V2HtSHGCVxn2+H57IFBWSRMhFY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ESp5kkIiUKKcFtV4olXVs3l6G/F6Xx3BQFK5/zKZRrtLBNh2jsq4keAA1v0Okh7yZiFfiChBxoCwXfCHuM9MD+8M0o06ac66o2KrCl6MlgG9huIXKuvnRXIJ+IYmoqMBjbvwRc7jM6lxoxM6P15qxY3OSFrPasZr4Ds9100i9nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DLS6+WAI; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DLS6+WAI"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43d1ceb2ddfso1127873f8f.2
        for <linux-efi@vger.kernel.org>; Thu, 09 Apr 2026 08:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775748368; x=1776353168; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1wjcw//HBR66IWAhhSr+EeBMazBdDTltxggX5pMzV9E=;
        b=DLS6+WAIn8nE0DV227OpNlKoU7NvVyRGC6rMLO69e0t6PHjIPKLlWTgGX0IUuLv/wA
         rlMs6HMYIxwjC/UMpm9GLsLcT81P1ABs0m/FvrxKDvTCS2TBNJDOkGFcY3Cf0yL7IRlO
         MoYxlmMt/u6vaf36tHReX9JNGxfspeK6crrBSgE7KCPJWyLuznFe0Lq/0ARM+eAVRvcu
         YlGYEjyCUgX7H0fafcs9IuNycHDO9zTWarwALcmeqHz6qwYOw/0TIJP/YNzK2b336es/
         zab4SwCun5VPHhCuJFIc4ogN1/gS4CuyDSe2akCNgHU9I4IBGhYQ+U58rZdin3KTwhld
         fixg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775748368; x=1776353168;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1wjcw//HBR66IWAhhSr+EeBMazBdDTltxggX5pMzV9E=;
        b=TiEqCN7t8bJWxX+uiQya9QCUo8j1M1NQK4+bQuqobMu3+K2r57sq1x1TA0501A06+Q
         84SoN2Rynop9DS5OSdt7RxVl8iorB8JlXowZo7UyPLyVn3mwEAUYa8VgxaYpHKnWEykW
         hHpFOOZgamkftfKBFK6yE946j80LNoq+F37g36sJ6rADAKFG6eY+nblIzGfWpLXeHrK1
         XI/e/aoPOCvCe/Mv8qsKLz6yepAN5ElHjjJKyw4wdRDzbdebuuXs614yC0yXB7s4X3kB
         dYJfo4fYjrjtVsy1AHEMGRWdAnKZNHI1XsDOh+T2LGN2Jo0IDms2SrCM6zATij47KoEi
         lmFw==
X-Gm-Message-State: AOJu0YzPTKhVmiWW+0QidoifkeyVigdUrNf0wa7rm0J69GlkzfvghcCu
	GN+B3O2wGL48gOv4rng/6+FqJrQFp7iRltalYQKI5KosUiqdndg1qxJn6zeAu+ZaIbzBVNHYfA=
	=
X-Received: from wrut11.prod.google.com ([2002:a5d:690b:0:b0:43c:fb8f:bb6c])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:5f86:0:b0:43d:1c75:db70
 with SMTP id ffacd0b85a97d-43d5a13da16mr5524645f8f.15.1775748368023; Thu, 09
 Apr 2026 08:26:08 -0700 (PDT)
Date: Thu,  9 Apr 2026 17:25:24 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1056; i=ardb@kernel.org;
 h=from:subject; bh=dzXspNqdZ6Rq8XLErK4e15URz4PU0/+QCSOeqsX0ZBk=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfP6kSfzWUrWaa4I1H5gZMkYIX9M5RJzSQa3nUn44+ClJ
 6Sfz3foKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABPpWcjwT0synFt+1VP+tAvr
 +YpKvExag6Qd/a47n3//p2rJdL9N9owM6wOqa95nTrWocHjy4obRUjmjTyzizQvfrXxc/buJVeI AIwA=
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
Message-ID: <20260409152523.1035577-2-ardb+git@google.com>
Subject: [GIT PULL] EFI fix for v7.0 #4
From: Ard Biesheuvel <ardb+git@google.com>
To: torvalds@linux-foundation.org
Cc: linux-efi@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Hi Linus,

Please pull this final v7.0 fix for a misplaced closing parenthesis in a
preprocessor conditional.


The following changes since commit 217c0a5c177a3d4f7c8497950cbf5c36756e8bbb:

  x86/efi: efi_unmap_boot_services: fix calculation of ranges_to_free size (2026-03-20 15:31:10 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-fixes-for-v7.0-4

for you to fetch changes up to 5241c2ca33bb181bf7abb7cb4bba1cc67d1b6278:

  firmware: efi: Never declare sysfb_primary_display on x86 (2026-04-08 16:09:11 +0200)

----------------------------------------------------------------
EFI fix for v7.0 #4

Fix an incorrect preprocessor conditional that may result in duplicate
instances of sysfb_primary_display on x86.

----------------------------------------------------------------
Thomas Zimmermann (1):
      firmware: efi: Never declare sysfb_primary_display on x86

 drivers/firmware/efi/efi-init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
