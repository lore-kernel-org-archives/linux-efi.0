Received: from mail-oo2-f38.google.com (mail-oo2-f38.google.com [74.125.231.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C6D3A5E97
	for <linux-efi@vger.kernel.org>; Sat, 26 Sep 2026 09:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.231.166
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790415246; cv=pass; b=DDlXK+/qRgcYhhVGBrPk+gi80Qwq45RDuzLUZbVCQRCywgAif7Q5GGtxZzn91xazkauFnTHLRYwKqukupQU53oA5rA5z/Xw70O/djr2kMEp7srKaw2wG5dbThDP3UTXbrHjE4FbhhDVoaNNmwWr0LrMELfZXls3shsdnB/WMM88=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790415246; c=relaxed/simple;
	bh=FmJP+O1qjXP7rKQbKyYqv9KR/pgAgmKAjVnwgDHXyoA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=WmINGB2U8fDMWDOf1FT/UxzFqqCjVvTPwbPxacml8IRRW1S0qXfQVvGfZypta7kmBInhx2au5cVNLGbVaqR3NR67/Y/skhnY9EXaAV+6jrUh3vLWZeYkgoF5Rf6Scgn4FhIFo0qqJnvcu5JPhnCSS18Z1g8ZvwD1PRGNeJsCxXg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A9b/9nXh; arc=pass smtp.client-ip=74.125.231.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A9b/9nXh"
Received: by mail-oo2-f38.google.com with SMTP id 46e09a7af769-80a71781323so983710a34.1
        for <linux-efi@vger.kernel.org>; Sat, 26 Sep 2026 02:34:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790415243; cv=none;
        d=google.com; s=arc-20260327;
        b=GSlCW7EklEHZqbYNf5yFyGTAQ9lVXahBgyYSAjKHFsdamUo8y/ChotRwJo6QvtY4el
         wfJfjYNCkJrzwqhfXdra7loZ4rGEr6N+azsPGyMvHL9C+B/xYfFNsv8+DbHmIOeNGFHg
         nND6XYerTthCky3tAb5x0hzOAJypGrWJaanBZIyHAMRmstV3rjgPmkVYnDd1tfKhXGU4
         xJdP8n4zOqkG5TgQd/rYnUpmZH0GLSMzI72wtblDh+w+gRg7BXb+3ZW2JRYr4miyr+Ad
         i0ZWNFAo/A0nMhG504jUf9+soU2q0RZsKd7xPwB8ZVjid5lqjCTWe5eQscawUN1Zt7qW
         Slmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=FmJP+O1qjXP7rKQbKyYqv9KR/pgAgmKAjVnwgDHXyoA=;
        fh=94EFkkp172E/1i+Wpm9h/Ox8pQQX4ycSSRDgd/4xIuo=;
        b=okA77R0vN+UdjSIKgy6k3nGwpdeaMaqDJjxhmQuqQ6PrXJhyfBoExaxnSq4iZE5fgJ
         uib62SgWNz9ypOI/OU4NteRIARaR1ZqV5hTlKIFORt3SKN85AqeYhN9djE1h+BqAlfMq
         5L95my1TCDIIlpz85+P6K2t+8vpKQDOdY36Ap9gNyZpKcCBsz1BRRx+cUz9cJho0YsSC
         P2lpdawJCOqteYQoa3upVbYixj+z86EeWBN2AzT217ju53DH4Ai2nQqR7yUbvGqeRFTL
         lxqBB0LPSJVxoAPCrdM2Dg9U3qzKtuNqF04cOeTixlWrra5Mwehlit2zpNV/t1kOqJiJ
         J/Ag==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790415243; x=1791020043; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=FmJP+O1qjXP7rKQbKyYqv9KR/pgAgmKAjVnwgDHXyoA=;
        b=A9b/9nXhCUaXGuh2KSPDz5mfutfM3eLs6Z0d6aC3bcqIjTDrcWBblXA6ck4ED3aBYM
         0xfboMczcmGA6Pbib0+gxZcDNoEQeikYoxb6rdTWJCkgztj0HxN5G1Dd/dznMBA8pxD4
         IO8lQaGT6AEDNJCIRMsMfkc8OJgfp+8m+HOReum02axkcrbdhCsTjdKU6gbAaV7rJeiA
         2zqoAIfPDS+JTn8Vj0IBeJoo7LFjMWioRvnsSC0ebb04Jakux+6/iNamhYkOWUkaYUhq
         wCY+XwzHHZeNgu1QpSnN+M6FrqRCu2m1bvbqjFZzHFXNW79u1Ao9HJBZsYRwWfjWJ6cY
         XQwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790415243; x=1791020043;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FmJP+O1qjXP7rKQbKyYqv9KR/pgAgmKAjVnwgDHXyoA=;
        b=TrKzaOjMwcNQGN9G0ZL/qlwYvNRZ+aT8+fdj61LQgRT/5z177nHLBWWaxjRxCVOtP8
         1LmamH5eifRRqOoY5giVcUCVSNLbIsQs7MEOj7bmu+0seOh6aeGYWwmhpG826iTPwdPo
         5xre2TsCzlLPVHiwa3kMVyhy2JBaG5jx+NaFx+wtkmsyiGHvA+mKFRej8mUj9z1unUTY
         gXBS/sVeFFSq0i3c6WtHHOzzvVLw2I9N2Wd6LGziI4Io9Bvyu556PMkq55K90McBmwSf
         QoNOtocPYKaP77T/zzIXrmZb/g93pFn+5d5vpu5FgB3OQ1qTYM2AP95gzBDEMI+NV+u9
         +6AA==
X-Gm-Message-State: AFuF++n4zCLg8sAJ0HnM0SVWaKQ/r3+iBjxCyft0kBkplLZdYWw5lcRP
	8pug5/xT3KttwPSCVqdRgvVbbWiu6K62p9Bgpoh5LhX0g30ayBXQyTN5TZZ1yPbMeEmDWppyvKX
	Q9yJw5Np+12WT0kFMq07ZdqOV0nTE0G75vG+s
X-Gm-Gg: AYBFou209BHsOeVfceqdxSbw3158W9KMfaSv5QpZAByghlMbFYGB9cRXyylJGGxuzLf
	0V2xLfILxYXd4pOMrUixnqUvs0gHloPMAoG6ggt5hz0UBPVQKfetRleaMp5ZoIE1IwlX3cUAyHG
	5lb88T7n/UUwGacAzn2phEvjWDQhQdZ++WRpN6+5Kz7Mc2g2eYApldHz8eVJ9UwGCoXdcHw/6oF
	5XMakJkabbI7b3nloVSrOJhWvT5bAvSyOqG1UzfsTOyc/fQI8WrJFVfcSce+IrBlo02k9ki1L7N
	218bWKGLoNGGjqZ7ldqVVHKSNnH5Zc9IibwpT2F56WRD5wejBe/NmHzMcg2TOK/N0UE=
X-Received: by 2002:a4a:ee1a:0:b0:6d3:54b4:897a with SMTP id
 006d021491bc7-6d44215ea70mr7387332eaf.85.1790415243578; Sat, 26 Sep 2026
 02:34:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: MaeeFilho FL <joaoanandalima@gmail.com>
Date: Sat, 26 Sep 2026 06:33:37 -0300
X-Gm-Features: AclHuK-B8oTIkMEpu8oJ5xeh7qVr3ImS2Z1hWyZXp7nnzwSPkTjBNdGslYIq6qw
Message-ID: <CAFA5sMczdTP45t_gphT_-5XExfupDz-M+e5Esws3e5QWJNXCYQ@mail.gmail.com>
Subject: Re: [PATCH v2 6/9] arm64: cfi: Use CONFIG_ARM64_FUNCTION_PREFIX_NOPS
 for the type hash offset
To: linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The patch looks solid and cleans up the hardcoded byte sizes nicely.
However, I agree with Bill here.

Leaving the equation "4 + 4 * CONFIG_ARM64_FUNCTION_PREFIX_NOPS"
without an explicit comment explaining the ARM64 architectural
constraints (4 bytes per instruction/NOP) makes it ambiguous. Adding a
quick clear comment right above it would prevent future confusion for
new contributors and maintainers tracking kCFI offsets down the line.
