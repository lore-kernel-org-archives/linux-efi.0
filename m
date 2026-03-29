Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE04830EF75
	for <linux-efi@vger.kernel.org>; Sun, 29 Mar 2026 22:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774825078; cv=none; b=aK7o8FIBeR1N1wvkH+yUuTZ1jcztDbYE3ltPVjCrkC/h11AQMNLsLX/MkmnxL7NW77bAgfKC7NqSO4krRhGRLXROluxO0Mn8H3Hf6gHVn+O9SQBTO9fuCdkx13wobw+tR6cUuhP6vohYnBh1kiIcypO6xuu9sVRQIVqYW6N8zEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774825078; c=relaxed/simple;
	bh=DkXLUmcpu+vp7QMomsKqeu+nj8dpLA67HJln8CiZhFw=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jTUPSYXjDxTE+iYT7E7TuivyqGKL1KCBE4x5DP460wRima+a9UiLwfV/fVmWnflBZCGss35KJ9TUh0V5Es6dHbEbaU6ZVGhTqAzeFjAo9SoMmYRqjXml68MdTlyIq1HEiavMMui8CotNDahJ9aeL/71c5hWYxzRqBDxl/wvtORo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=code406.com; spf=pass smtp.mailfrom=code406.com; dkim=pass (1024-bit key) header.d=code406.com header.i=@code406.com header.b=Fbh9/3k5; arc=none smtp.client-ip=74.125.82.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=code406.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=code406.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=code406.com header.i=@code406.com header.b="Fbh9/3k5"
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-128b9b7e3edso1936114c88.0
        for <linux-efi@vger.kernel.org>; Sun, 29 Mar 2026 15:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=code406.com; s=google; t=1774825076; x=1775429876; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EmjkZkbbVjjgaCUxuu5+nE0xjPd5gN1qT4GlMrecGi4=;
        b=Fbh9/3k5YE4y04oqhexqsWQeQ2Y6SKUKF3WuZwp0/6sj4phYuWiRBU/C08fCMQ2EHr
         BTyUJU8glTj+XLWy4pSTzGR2CL+smGXsOx1wY2z0jpGncGQmq+hfW8XyZbnfVMVXViUl
         GswqzKhrEh+7vquNe+fGCoklacbwOR0ccnIpI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774825076; x=1775429876;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EmjkZkbbVjjgaCUxuu5+nE0xjPd5gN1qT4GlMrecGi4=;
        b=fD4qg6BHThDoviLe4nl4U0hjiJiQJtcDrlU+NZXQ2RrCp/UuK3z0xcZFtC0V+Mwr6d
         cq/f/Ig/+rrul5T6Q53VwHcQDUGjDokCa19s36NI4uhb45IvmNXsBAHaE2O9xUVnWCRQ
         MWMv9VHEYRSX2AhkSFdMUc1nVsJBS06H0XciIl26JX4YbGQecEo5sp+Cp0cTW+EGwCae
         I5yT2jfOYAtH8X9aEz+sACFmRgMK4qwanS6pr+5J0Wdd6sX2LmIMtWn2LHbjL09PSD/B
         DoNOR0sUcxoqpGd460R2MeMsBHwp16HGvqlFRMY1I7drLxdzwssZUwSluQRM+s6tZkLO
         P+Cw==
X-Forwarded-Encrypted: i=1; AJvYcCVkbeMueByDRtmTh7SgjpwFeKIIcZ5G7SQB0FJQV+m1crXC0RuUyMYZsDohF6zfKHY1tIRiY0DIcEk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyuvkaBpd6F3Ixt8zVBF5UvxZ9QYrozjj8mL8cWAKW/tYIrP+Id
	rGmUEg0OmNUDNlp5ix/YzOcS7Ob7/P99DY3Jk4+8tRWIX2y5rspb8BwfvSLvBT97Hg==
X-Gm-Gg: ATEYQzydlhBcu4nNww7x6oXXRLd5tXsrKGf4vP5EeYzTEbnDZ+Dgfdsp1w0MW2HJG+d
	tKQOskGVgLymCuLrma+q5lRNMsR8g+bbm/5C15mKRvfVyVKOPr0uVSs1H1unadlSQPsKy/LklkK
	rEnzYU+GxtWQTwqPBxLi1C/H2PgKlFjfdfGyO6aIAyf/20dr6eSYYTLIRieMvEM6K1iwnn2my1G
	/64sqDP8OuLCqqnct9Y7DwDJLgrwJnHk/XFkjW3UdGgehb3MS3nB+o0j69XH2+x5tfpoExtkVSN
	TudAMg+lBaTgOIsVtQowPXs8bRGJE3fcBilX/mRQ7Fo5uLSq6KCSc196GCMuQjZIHxw0aEee4zW
	f8oUudSdiGZHn6QEyfOxUdRSHWSibYsTgVWJZTEHND5dA971CtkpXscxtNy5ASQ1GdpuMwu021k
	oEUKtBN50of+OGTx74XSu1/oC8nLEgjcbn7u9m0JIidezaHp55dTE3N7vEK7FQv3ozUpPWhyV7r
	oyzDBtZ6+YCgTbVETgVRisYI2h1
X-Received: by 2002:a05:7022:2209:b0:11d:f89d:85a0 with SMTP id a92af1059eb24-12ab2912740mr5861569c88.27.1774825075962;
        Sun, 29 Mar 2026 15:57:55 -0700 (PDT)
Received: from ubuntu ([2601:645:8a00:6e44:958e:90e9:e30b:7ecc])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12ab970da7fsm6096026c88.0.2026.03.29.15.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2026 15:57:55 -0700 (PDT)
From: Josh Snyder <josh@code406.com>
X-Google-Original-From: Josh Snyder <josh@cod406.com>
Date: Sun, 29 Mar 2026 15:57:51 -0700
To: Ross Philipson <ross.philipson@oracle.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	linux-integrity@vger.kernel.org, linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org, 
	kexec@lists.infradead.org, linux-efi@vger.kernel.org, iommu@lists.linux.dev, 
	dpsmith@apertussolutions.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	hpa@zytor.com, dave.hansen@linux.intel.com, ardb@kernel.org, 
	mjg59@srcf.ucam.org, James.Bottomley@hansenpartnership.com, peterhuewe@gmx.de, 
	jarkko@kernel.org, jgg@ziepe.ca, luto@amacapital.net, nivedita@alum.mit.edu, 
	herbert@gondor.apana.org.au, davem@davemloft.net, corbet@lwn.net, ebiederm@xmission.com, 
	dwmw2@infradead.org, baolu.lu@linux.intel.com, kanth.ghatraju@oracle.com, 
	andrew.cooper3@citrix.com, trenchboot-devel@googlegroups.com
Subject: Re: [PATCH v15 08/28] tpm/tpm_tis: Close all localities
Message-ID: <v2l4v5imh2lmsayevxz3palyjeglpxo3qu475gjpchitgfzil2@l24ax4vevjp7>
References: <20251215233316.1076248-1-ross.philipson@oracle.com>
 <20251215233316.1076248-9-ross.philipson@oracle.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251215233316.1076248-9-ross.philipson@oracle.com>

On Mon, Dec 15, 2025 at 03:32:56PM -0800, Ross Philipson wrote:
> From: "Daniel P. Smith" <dpsmith@apertussolutions.com>
> +		if (check_locality(chip, i))
> +			tpm_tis_relinquish_locality(chip, i);

When I applied this patch locally, tpm_chip's locality_count underflowed to -1
and no IO was performed. That is because tpm_tis_relinquish_locality is
implemented like so:

  struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);

  mutex_lock(&priv->locality_count_mutex);
  priv->locality_count--;
  if (priv->locality_count == 0)
	  __tpm_tis_relinquish_locality(priv, l);

I was able to work around the issue by calling __tpm_tis_relinquish_locality
instead.

Thanks,
Josh
