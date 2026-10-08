Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8773AE707
	for <linux-efi@vger.kernel.org>; Thu,  8 Oct 2026 17:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791479238; cv=pass; b=GBxkNZd3begP0OwgMa0VCM0cSYexF0t/7YyBK31lzisdmuQYpaC8NaKbqkPNtW2ryFpTXAHE8VLpLkPQbgmXH326eC0NP/Bwo0laKfZqoiVIEwAGOzOdMOdSxpa/IYIVAw/PZJAWzPhco3GRdXODWJUtvAauvhKz4p0/grYrZZU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791479238; c=relaxed/simple;
	bh=QqDI6Bbid4Z5TSJM6uhAIwDVDE3XcRkTjQOjWmVeRn4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ayPJP0fupBGmfNbFdxzxG/o3ChI0cIWb7+yQH1mjWheUNaE0v1b/9JE0z86y/ttndUE7VqeAN6o31s8leDcQHumPALpJ4qe7MsFerq1O/A8Hr7+U31f2dFVQzCVknjt2zlEjEPGZx1Dr1O46ETUZjdXdFB7M6tXTo0wX4J8Huo0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CjskiTdX; arc=pass smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CjskiTdX"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-8ae8541a2f0so34978047b3.3
        for <linux-efi@vger.kernel.org>; Thu, 08 Oct 2026 10:07:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791479236; cv=none;
        d=google.com; s=arc-20260327;
        b=lVXI5Z6EkfnAER01yObc5WceiNKuoodBiuS3Z3H2lAiYEv9gi9F68Po2cxy1yoMqkk
         berxaN4ivSp8xXLnWyBB0TrH14lKd/1eTRZtF2yXy5D6n3cI86g1KAoXaIy/jQYvdtQM
         PwVnwUy3R2QPDLizmCnEqAW6LOTBTDN5xaIPKO8ai6dBnYLnTLm271hEcIbFyJx6vg18
         qaU7iqhbdaFRtZ5GnXT+KBNILNccs4GatugTiEF+ELZw7cfZaAcW81RWmZPT77aQ/xXM
         00sfw6honLdJS7AW+ONK6Tw87OJqWRQyeyfvt2g0lOWa3o+Mad1Tck6Njjk+1yBMwzD0
         KNww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=2vxAQYqUPu2IyOv6/hcaTpeROBNAxx/kWZ9+SB1EYqQ=;
        fh=Ey793Ppl87YNyVBoP1+m1s4nlq7K/Xge5AQJbEJU5Ew=;
        b=N9yO1hcAQDJBKRozI9BA53T+rDh6I5/ySoonz/ndwfySJJ1TCkXF5a+lS7OWxvL8oF
         QoE9nIi5OJ6Id02TOM6+zkRIFZq3VdNguzJ4msU/oLQG4P7spdoW9yELksHmGakskOvf
         UKXiVrH8naqEW3iChYal6oruCTHurzkKgzh1Nz5cYBbfTbiUdWHSjELvJ9ikQU+3rLCU
         t477SVQFyet/gddaDdyxa6TTC2uMOtGZVdwWB5PpuHgX9p/ePP5ZI/iX923i9AE4e94Z
         j37LT6ptIYC/fX4XynafX0+8EaUFu7dVh/RmOsWR/SGQSAhNnDb6FSFBFwq716mSX1FP
         +SHw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1791479236; x=1792084036; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2vxAQYqUPu2IyOv6/hcaTpeROBNAxx/kWZ9+SB1EYqQ=;
        b=CjskiTdXhMBCOIOnG/ji8z7M7K/m2VM8bxynqze80Ch/Mad0y202dkdou7i8ZDrmGh
         pLXt6tEMMlu6isPmJjYONw0zlbyXN57WCSfJK2IqcD5y9CXWdpou684S3S3UefBh8m08
         d2fyETfcYmd/aBr6Fff9lHWFaF9d3TIbPFf5hE2ZYufrgNTosPdvW3Vws0Zn2h/+2r80
         wssMtraSEYY4zJmFsPiAzFjNq+j3E1lRC5s4fLoNSHhoYsIgrzDHSyjl5h+YzswXRf5c
         hEHXMo0+NUFC5JKAFGzM2Ff/yA4yX77jDoyM66BbKKiZWRqsL4WIOtSXFu5Y8BZjmozm
         cU6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791479236; x=1792084036;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=2vxAQYqUPu2IyOv6/hcaTpeROBNAxx/kWZ9+SB1EYqQ=;
        b=n7ojxlOvqU5unp/Doh6arqT5qOdUz5XIjp8KPT4kgjodqW/46rh3kenCQrwk1iQNZP
         tIOtQJnfsCSxVpoTCE4hyy146ZMxsJlqZ2hP2Q347lhD2UibWc6Q6IUjDz/D+jhj6oDB
         K11CsKKDpPIGOII/bXEjxnq+cFgUypdppxIS/l7pqpugYhH5C1GBuXahdaD9JflM9tQX
         4hC9VtLe9/PDy4iAuf94hPF+XC/Wukam7gU1WoOmeXhwwj4xy0xsSv5hHsy39ZVZpxv5
         z7fR41Na7p5vN1cALT/f8U163sUoUXJGKliS+Cycjo6a34mmwQOQvqUV6Sxf7DUxhds0
         OgkA==
X-Forwarded-Encrypted: i=1; AKwUvBw83hMS7vY9/koMRMxHIXYcnpRD7Pw5muCsNxfIRKworlBxYF8EgUXkIoQwnEJzQm4wZYCTJcItLIM=@vger.kernel.org
X-Gm-Message-State: AFq9FYI1IWoWixEWo/S+EWbDFFMAF5funBD2sh7kOd3FJXFk1qaCh7Hq
	VcoBQ6XKPshVJiZ0aA7sDCusNSwwnbkQLwRRh4LpUXj0r2oTMbmtXzsKxAixEvWGjoomP7kmJ+r
	x3VkFWJX2sBqWXxXcRHDd+LJdpfPMiUvUgSScWTCU6g==
X-Gm-Gg: AYBFou3n2SWYmqdxCf5YGmL7TI9DM9HijHxB9x62jqKKY3tHb3BdvQohbLgTedl0J1S
	5s/WmN6ZmXtGJEQQpjSq630lDzOxcAS6H8KKfLKxLgnNTzojv1m70OHJZQeokzJJ4/vKuFdZ4Jk
	xl10iW7KtLtRZ6Sob+2gLxaEqMN5wVgKEP6m7VsXVjLbCnkm86QY9GjSKAXfc+31AkujtWxYwn0
	UFYE6IHyHkzmipnuWWFCOVpeyQvw0H/xKlwMxbH6P82LFLJBH6blbxWOPIBhbcFSWjiOhirN8up
	idOwszxIIOATG1FKFgWhqtTdaUv8MCkM1G77nIFXXppKgtl6fUlc8yn8eyNlx131c07kHykxgen
	jfjGHqMclKKy5EmlZ13+p96+qd3eO2VoeQu2I8u2rKy9VjWch1GIEJaxjTHJGSU8vxLqZ2fvscl
	flRFuWwQGNg/cN9wsliINaS86zIMfnqSzFaxtKwqdtKkS9RVruGRJFa1MuG4uLDN9CA/8+FLG4A
	ghqE0qKqC/ovXdS9EJ2FoagELAThlF4JW6pysd1CO92joaTYClqmUrSv5D1iRTXGtSS1acdEZ7q
	y9azwz26rDNyJ++Nek6+M7s67BE3yjcM9JE2VNPys9glmx8s9YSV5xBPKzV4Cd6ThrgyouvzCK6
	SVqVGbRwrnJrVvjVfHxbNXxW9N1tBfzn6WF1ZxZBNmdfN3aYhSwP83d92AwGBsL9s
X-Received: by 2002:a05:690c:6d84:b0:8ae:b617:7113 with SMTP id
 00721157ae682-8b05ae92339mr32919307b3.6.1791479235462; Thu, 08 Oct 2026
 10:07:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261008132532.1155166-1-matthewg@nvidia.com> <20261008132532.1155166-2-matthewg@nvidia.com>
In-Reply-To: <20261008132532.1155166-2-matthewg@nvidia.com>
From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date: Thu, 8 Oct 2026 20:06:39 +0300
X-Gm-Features: AclHuK_axRHHNMJXbXP5qGzIg8glDqrcsSviR3SuESczjar1LzYO3sHRH5FmG7w
Message-ID: <CAC_iWjJJMgTCPwmVA+vhDq+qfh5U36TbBiqyzPaKeDxTaYjqsQ@mail.gmail.com>
Subject: Re: [PATCH 01/17] tpm: Define a kernel-owned TPM NV index that can't
 be modified by userland
To: Matthew Garrett <matthewg@nvidia.com>
Cc: mjg59@srcf.ucam.org, keyrings@vger.kernel.org, 
	James.Bottomley@hansenpartnership.com, linux-integrity@vger.kernel.org, 
	rafael@kernel.org, linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Matthew,

On Thu, 8 Oct 2026 at 16:25, Matthew Garrett <matthewg@nvidia.com> wrote:
>
> TPM NV indexes can be used for various purposes, including using them as
> PCRs without depleting the limited number of hardware PCRs. It would be
> beneficial to have one that's under control of the kernel in order to be
> able to prove whether certain TPM operations occurred within the kernel
> or not.
>
> Reserve NV index 0x014c4853 for use by the kernel, and filter commands
> submitted through /dev/tpm* and /dev/tpmrm* so that userspace cannot
> undefine or modify it. Blocking definition is more awkward so let's
> allow that for now, not being able to modify it means there's nothing
> interesting they can do there. The filter simply validates which handle
> the relevant set of commands is referring to and returns -EPERM if it's
> the kernel one.
>
> NV indexes are from allocated ranges and this is a range allocated to
> Linux, so there should be no userland depending on the ability to access
> this - but let's gate it behind a default N config option anyway.

I think the idea is useful overall.

>
> Signed-off-by: Matthew Garrett <matthewg@nvidia.com>
> ---

[...]

> +static bool tpm2_dev_cmd_is_blocked(const u8 *buf, size_t bufsiz)
> +{
> +       const struct tpm_header *header = (const void *)buf;
> +       size_t len = min_t(size_t, be32_to_cpu(header->length), bufsiz);

I haven't read the entire code base but don't you have to check bufsiz
and make sure it's a valid header before dereferencing header->length?

> +       u32 cc;
> +       int i, index;
> +
> +       if (len < TPM_HEADER_SIZE)
> +               return false;
> +
> +       cc = be32_to_cpu(header->ordinal);
> +
> +       for (i = 0; i < ARRAY_SIZE(tpm2_nv_modify_cmds); i++) {
> +               size_t offset;
> +
> +               if (tpm2_nv_modify_cmds[i].cc != cc)
> +                       continue;
> +
> +               offset = TPM_HEADER_SIZE +
> +                        tpm2_nv_modify_cmds[i].handle * sizeof(u32);
> +               if (len < offset + sizeof(u32))
> +                       return false;
> +
> +               index = get_unaligned_be32(&buf[offset]);

nit, but get_unaligned_be32() returns a u32, might as well define the
index as such

> +
> +               if (index == TPM2_KERNEL_NV_INDEX)
> +                       return true;
> +       }
> +
> +       return false;
> +}
> +#else
> +static inline bool tpm2_dev_cmd_is_blocked(const u8 *buf, size_t bufsiz)
> +{
> +       return false;
> +}

[...]

Regards
/Ilias
