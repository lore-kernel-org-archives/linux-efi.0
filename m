Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B992DF717
	for <linux-efi@vger.kernel.org>; Tue, 28 Apr 2026 16:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777393967; cv=none; b=GWGlmMyyEGCHRmxh4fpfBYeTwLfna8DLxrySd1FKaIzkl5azwjmUspBOkJ/7s9P09Dp1WghXdWa7J7vDaOCGI8BGOsCqWsNphM1Gn88d1nWyKOedKfekYcA/nxfU2xnG3qkAzd5a6JAK1Tc5iLmf6VnCyWXKfUoxAQEPqEfrANs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777393967; c=relaxed/simple;
	bh=UXi3to+PEeM0vXAZmtoShs0caavlFjs/qq6Gqzz+kdA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RWIGcMbDySYKpH21QhSBVPh96DkCfdHTc6FwQ6H1/xrP4Q54Qyg9NVaQMBZ6PG66lXXAFgOPlkCxcHQ3dDU5K0yv2D2mQ8Y4MpZjiH1SP5/9LAVNva1K5VHIyKmJisqu+EgAjSQPpmGqVrwo/9RMeFheIfdERSP5oErS8MXdvxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tdue3C8p; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tdue3C8p"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b9c3e2cf3c0so1970916666b.1
        for <linux-efi@vger.kernel.org>; Tue, 28 Apr 2026 09:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1777393965; x=1777998765; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zdQshYQj3noQptsym9r2OjNoPP3O2vv/eFEz4ctitBQ=;
        b=Tdue3C8pAMawzA0oCTAUCr5LmXQRZivT/5MQfbe0FFx5GSM8eLH8otmPenWpWJXB3/
         pfdbtbJscxFXHD73pmS1z72DD0hx6/l7GKjfW0ZzJ7IlMEJdqT8zHrGEJQTIaMyuJ9Et
         Kbo/1sB51Se7r68lcLgaD80p2V2hsoEiv/AwM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777393965; x=1777998765;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zdQshYQj3noQptsym9r2OjNoPP3O2vv/eFEz4ctitBQ=;
        b=La12LkX5gNVFfIDn4PKy6bm/TiotyFJI7SPEokZpIPkW8fO2z/tochpuPPIgogPcuu
         jJQkY1Q2N0hH/nGR2tBuv8zsJFTkMkqGs7P95OCqk5rnl0qt4LKqTjqp+o7IXLL/9NT1
         vyfQncSQqbegz8XDpq59EhjYIjlwqcYml3xX6WXJZtxtzQEL+XJX2mJAhVwb8DJOaesv
         ix+ybM/DbHUboXy6SsnaTo342rg8BWHDBJua4VOV/OWszKuJyoCpHdthYPfo4TVyIbgx
         H8DcuYuVb3ETXj6NMm/Z71nxGJ8eypTgFhEhaTAvenM54NRhewL28mtmdz9TXDiUziW3
         OhOw==
X-Forwarded-Encrypted: i=1; AFNElJ9vCZ5hRuTE/ylmLikueGcJ8oyf61NHbmp3r4WfXhdzUSsw9EPusLQf37r7CYZNUBUhPbQ8x2WwNqU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAEb+19M/llvS3Cz+v+mwzZGfnyuiT1FVIndHSu069Svz3a0Ps
	FC6f1jrSoWCEo189JmInrKKkWvv6pnBfpnxnjK2Uc0hgkHvMHeZ6jwIaxjCT0eB8OexZi9Is3Zq
	Z64b8QDpt5Q==
X-Gm-Gg: AeBDievvl5Sg20buGshn6opln97Hkt8CbFxI2jLlAR40VSa0GN8hFpnFgdQPiIFJzrd
	GEGHzTJUGIrAlPMnk09vk3+2XhOQs7iMUGWqDb5craKo+tssB7MEo75VxZhsgE6+UnSuPlVQgi+
	Y000L9KYnuyBYh2YQW7BPiPaa5tl2ipM6njMP4G40hpjFPHvDvDmHnI2eQPJDKrl6SZ1isgrjlE
	hiy4soX5z525GOiHuTXqBMdeQe9dbLMMGNUqwrr1MHibS70uYjmnUFd9o8pDh0BQ10jQkyzrMHc
	8BIVYP1DT7uTfKNLRpMIsNr9vzA46U69Zv30ZXzBeZkMleQMeC39eKgDcdvoXNANqeqst7AHyVk
	KbKcKNmbmbWJHzyPpaCCVLm+AJGjAB0O0kYnZpDFXblyRivKCkbor2HzKFF+C5sWPWqNMrOuowC
	bUGlEAdR+WX5I5XggThX5W+QsGvDhrcvMfylsgnZuB6g/GulTRdK1Q1dO5E1vB0QOouqpmFaup1
	O7ojy/zfCE=
X-Received: by 2002:a17:907:a089:b0:bab:d909:b89d with SMTP id a640c23a62f3a-bb803974a17mr245545666b.26.1777393964795;
        Tue, 28 Apr 2026 09:32:44 -0700 (PDT)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bb80c57f559sm125431466b.61.2026.04.28.09.32.41
        for <linux-efi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2026 09:32:42 -0700 (PDT)
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-67893fba9c3so11046699a12.2
        for <linux-efi@vger.kernel.org>; Tue, 28 Apr 2026 09:32:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ++EIzQoabI9kIh7dY9VTm5vEJnwkCzAZ57cmGtwREmbLqPdTXuGZOei7mTIszBWJHIcDx3kFsczgA=@vger.kernel.org
X-Received: by 2002:a05:6402:4498:b0:670:e9ce:203c with SMTP id
 4fb4d7f45d1cf-679bb05d621mr1866002a12.10.1777393961533; Tue, 28 Apr 2026
 09:32:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260427040517.828226-1-neilb@ownmail.net> <20260427040517.828226-5-neilb@ownmail.net>
 <20260428033738.GV3518998@ZenIV>
In-Reply-To: <20260428033738.GV3518998@ZenIV>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 28 Apr 2026 09:32:25 -0700
X-Gmail-Original-Message-ID: <CAHk-=whXZz=-XnJdMGzM8BCwDkoqU0yDNKWyrpZSwXzchxsPUQ@mail.gmail.com>
X-Gm-Features: AVHnY4IIvtSv2v5AokZFbGGGL2ooIu4U0QBZlzJ1iurrKn3dZQo8WV0HU53s1sE
Message-ID: <CAHk-=whXZz=-XnJdMGzM8BCwDkoqU0yDNKWyrpZSwXzchxsPUQ@mail.gmail.com>
Subject: Re: [PATCH v3 04/19] VFS: use wait_var_event for waiting in d_alloc_parallel()
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: NeilBrown <neil@brown.name>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jeff Layton <jlayton@kernel.org>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
	Jeremy Kerr <jk@ozlabs.org>, Ard Biesheuvel <ardb@kernel.org>, linux-efi@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 27 Apr 2026 at 20:37, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> I definitely like the calling conventions change, so much that I'd be glad
> to pick that one right now.

Honestly, while a 19-patch series isn't big as these things normally
go, when it comes to something as core and subtle as the dcache and
filesystem integration, I'd personally be very happy to see this
merged in small clear pieces, so I'll happily take any parts that are
good on their own early and separately.

So yes, please take any cleanups in this series asap, rather than
necessarily keeping this as a longer pending series.

               Linus
