Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C702B456DE6
	for <linux-efi@vger.kernel.org>; Sun, 11 Oct 2026 14:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791730141; cv=pass; b=aEd2ijnSzaaPARsjS+0TOWNMahluxvIsudyiWpu/UzoX1XWbpKOiyFQlrWMtZH7QV/i5l2uEZysUvPjBJ6+b1fpfKTPsM+laEGNeu9Lz+rdWWLJihCqN0qK5J1jdSs49EAbFq8KgYBU4UqLRgzjOCZW/RQHIrZEgd9uh2+vw1Qo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791730141; c=relaxed/simple;
	bh=KTTmDBDLvEzXTcUeFdNHCL+XWsl5T0ZipzxiDJtTFzw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Gr+TLm0Dt3Eb67tmsJFxzpIMOYaSSgdUVV20+7oNvXGGnREQcR+dGDoT1c4oVimeLkhBPjo+yGj7c0M9V7piy5l//a8D2aTkrf1N7g5HawLeCwdRIgTv+OSsp7/FSYTiaVpuJZW5a6lTcPLlG0QbmpICsWS5/tfxShAy2t0M0zM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ol0HXaXa; arc=pass smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ol0HXaXa"
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-6d7e06dbcccso755930eaf.3
        for <linux-efi@vger.kernel.org>; Sun, 11 Oct 2026 07:48:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791730138; cv=none;
        d=google.com; s=arc-20260327;
        b=Q66ptwf0tNnREg6zthPmO//mWFdqvASGD8oIHoQ/izq8izb+HIrzc+WFP7tDrt3zYZ
         v5ZLAAEd2mCc13an1Sy8anlWgAFhRq65yAREmO+a5Qz14pLJuOOG73uQsD/O0AAIFQOD
         rcBazwjdFTlQH2PHArHzXeCvAvcTxzVcRnFW23racmLrlg7X0HfVGdPhNO6FFXX9tBIR
         kbCYBUECAOXdS50Hp5+TkuCz50zMGgGfjUteZgxAehjQWYnXykzU/Hwu5l7m59NOG6q3
         H+3ACYO2Ot8ijmceOMi7kURrEvnShSWi10R5brDduAoO8zAUAOePK4YeK2BOT/6pzm/B
         n7Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=eSAItQD3XdnMYrgEBGA328w0uBEEk18b+E5vbP3GsUE=;
        fh=PPgHdXFPqijzsqKDAkMi4MbYAF0Pyz2fasKXD3E3sQE=;
        b=jb2CjP76oCE1hLwbShLqKxY93DX8Jlg1vzEVvLy7e+m6F2Uc5rebe58Uvf8LAs3QEj
         JOQMYIIxA7+0EFAxtOZPA8BqAE3A5CqlWh2rZ1zrUA2ssZl4A6msyEM4MLJZ0pqgCoxk
         DuIFMtSImuI6FMkOdh6xP6hvA8xQxVwgMQ1NpwLjoidWIYD7DUFP9Ss7nRHEfw/MlILI
         H/kNW4Z3utjJceuv22BXApYt0szjUaUk/+L5CLVfnrHbER9KpyIt2aBORc9PreYvaG+n
         ojx+KafqdjUw6PGk/647nC7MBy2QnqPyf99jsxa3SltDaGtiS6vuIHxwMnHg1yr+bWHS
         GeCA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791730138; x=1792334938; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eSAItQD3XdnMYrgEBGA328w0uBEEk18b+E5vbP3GsUE=;
        b=ol0HXaXarRSSmXNWm2M24R2JXyslD1tZpsEbjfKZq38kESqn/P41+dltQU8dcwTwmS
         h4eJ/WZ3yG/HAu2bxBTJ1Cru1DCr40nujOJE6W2QO/wWvEg6olRCGBFyDvO/F+1LS9If
         4F7zNllWJXofBPlrg8CZ6SNZoa2SwMMFJ2TAA9/Jtow3YrandohNNsO9yeatWHmRM1pq
         Km9xJZZfZOw42aeR344jAHunxF9BcpsTrg2HlTmrGQPXq7kD6ePes/E85oxqYDQ6RJrt
         4QfFb9hUD42lATmSfIH6IsLdobW63AHb1NkTFEykSu8fVBqPY1rB9fn21p7ungRhwLU/
         RG4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791730138; x=1792334938;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=eSAItQD3XdnMYrgEBGA328w0uBEEk18b+E5vbP3GsUE=;
        b=CRPXI4w2Pg2k22KguWXvzYV6ciQ/Nl2Lq6jkEiFQ1sx4MNEykxu72yLr+r2nnffS/L
         JzhWEg6ND4e4dgVWKowaN5UJFceAcrLq0ap165/LFqCeNeMKd7nuMAJkQG7Y8ogo1mOz
         gTx2s9Vv/H4CxltIwvj3jJ39JQFQ1YAclN7st6xqZLMnCLY6rtysG6hu0ElQT0hkyFxt
         EN2zbaxfRHmZkc0v/Z0jy93OGXRXqv+x02SIwpsY87CrdbB3aHKSGj3EIMLThPWeZ5IX
         bMF3PE6omcTgDumMfl1ObCil7RwIAP99pmmNimSVpliNxpj5CxWaHruJLQtJFk2TjzTe
         Oqhw==
X-Gm-Message-State: AFq9FYJmy6ZECBD+Vpv5F2Q8Mi0eRdS3w2eP5c0OOEdM5dVYQZlGqSzI
	HEcu2rh6UvHOz1iy1qbjXeopac+xEugwEKwjhEMKmr4ch4imXbSI3NBHzAOB+A251dEerDDxJ4F
	8qSHXMr+Lt6o7lgN/YTO82OsaqWe2uVc4+xtg
X-Gm-Gg: AYBFou0PBs4iXD6ReB7b7CyLovAH/rlrqg7PQoyE0T9+7ls1ow0iCf9l3W3i+nEj/8q
	xHfdJrV10f96jAcMNrAqSTN6n+O0uo7RsLDmnkbhntt9fnG9jgwFyoY+xg51glnQ67AwzvSifAe
	c5s6qpTVmuo9FsAhmkWb5A/Obw3NZL10YQzRRZAXRX0IlSuP7dcgITFDV11SOfSS6mx3LVzEVZU
	gz2Knqgfh4Y0CeIxtOs8KdMJvI8YGJsyq3omAv/mKvKIpHbOG/dCvbHK1Jo4UHEeKZaqISTBU3G
	yZOhnpcbuXN5FMUpHVQ9oM8aSf2qhd9OQh+ZQmGpe7ehDzCmueI0kc/Q
X-Received: by 2002:a05:6820:350c:20b0:6f4:80f6:6ae9 with SMTP id
 006d021491bc7-6f480f6a5ccmr760752eaf.27.1791730138569; Sun, 11 Oct 2026
 07:48:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: MaeeFilho FL <joaoanandalima@gmail.com>
Date: Sun, 11 Oct 2026 11:48:47 -0300
X-Gm-Features: AclHuK8IJOYpso1HhSgXW104tnmReEvrVU3sXstVSoTDmAtKD_QfWoBZxJyM9Ww
Message-ID: <CAFA5sMdbmqyqPhQ7Bqayd4-PBbA6RGHxgy7kFa_uF7mJWtFDLQ@mail.gmail.com>
Subject: Re: [PATCH] lkdtm: Add more EFI runtime tests
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ard,

The Code is excellent. A few points worth highlighting:

> Two bugs were found in the arm64 EFI runtime support that weren't caught
> by LKDTM. The existing EFI_RUNTIME_CRASH test instructs the firmware to
> write to kernel memory that is mapped read-only, which usually fails as
> expected. However, this does not exercise the runtime mapping logic in
> the kernel, nor the fault recovery logic when the faulting address is
> inside the EFI runtime memory regions itself.
>
> So add two more test cases:
> - a write to R/O memory test that uses the firmware's own executable
>   memory as an output buffer
> - a branch to memory that is occupied by the firmware's runtime services
>   function table, which is usually mapped non-execute.

This is an excellent addition to the LKDTM suite. Forcing GetTime() to
target efi.runtime->set_time is a very clever way to ensure that the
firmware page tables are strictly enforcing permissions over its own
executable boundaries, rather than just testing general kernel mappings.

The execution tracking via the anonymous function pointer struct conversion
to trap NX faults on efi.runtime data object is also rock solid and properl=
y
exercises the arm64 translation tables validation logic.

Reviewed-by: Jo=C3=A3o Guilherme da Silva Freitas Lima <joaoanandalima@gmai=
l.com>
