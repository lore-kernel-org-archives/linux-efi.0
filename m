Received: from mail-qt1-f227.google.com (mail-qt1-f227.google.com [209.85.160.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E9D3DB64D
	for <linux-efi@vger.kernel.org>; Fri,  9 Oct 2026 08:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791534664; cv=none; b=ifHQyFo+kiEkL9Fqk38srjtncXu1Y3gUDtx9mppYihKPVIHa7SIqLBuacmZ+FkOzfEMDQYLsLvHe31o7YsE/yYSKECSxOZMSO3dvHioQn4qmiM19i9ewxSKphI0D+SG21aFCfiYQeIaX5sCR24ukFxnrgVe+QjH74bABQpjVbyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791534664; c=relaxed/simple;
	bh=DIFxmRnwufPE43JRiH6E4AfHlHo9hVO52fExH+S+rK0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bo3q9uVXfZRWxVWQyw8Xvw+5F79wmoh3WXpnCz65nVU0a/RzxD6PAjKOfuyxlLciLo0AUIg9jwWppJH1ieQczVvpSUDzMuRUFk8cDC518V1rDpTYHU7CzL3cFYtRprL75gbi1AiXTE4LGys3XbdeNmdzLbcswCcuKOuJZ9zdnRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=srcf.ucam.org; spf=pass smtp.mailfrom=cavan.codon.org.uk; arc=none smtp.client-ip=209.85.160.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=srcf.ucam.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cavan.codon.org.uk
Received: by mail-qt1-f227.google.com with SMTP id d75a77b69052e-5339173489eso45559251cf.3
        for <linux-efi@vger.kernel.org>; Fri, 09 Oct 2026 01:31:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791534662; x=1792139462;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bIf3Kb4v9Q13a/WyDvBX8cPlNPGYJMWyM06g7YQDej8=;
        b=s3OLbvEqKEhm5XodRWnPUrOSLSFRknb9bGBLG293mRc8IbkCFH+dFFikT4T+XbUYB0
         L3MGkvTy8YewZLWay3JR5J1hkykq9b6W0LhgT28tf31RlpX9MqkY5zlHGslhJk+Fi2Yt
         yYP3m0qEpOfHA4YabKUMKdhbCLQA5KEU+uwrRnD+MwGN/KctSlq6zp1wXVvKFKdydleE
         nOVBbMopTIe3XP9X4woQtiznXz2LZ0LPSI/LOWvUuSadiE8C4iobiUM4dkl8fP0vWZKY
         cf/sopDkzJtMvI+zQgryHLhNjC8PDAQRa7LGJG9fkr/S0YqJV3qDlysx+X0VqpMq3Zcz
         Cy3g==
X-Forwarded-Encrypted: i=1; AKwUvBz60wk5JuOZ0gl2NQOV5oenRhOS1yVrg2xMFqfenV3pMnjzNE3lKqn9/ibqFNbfGmlcKkNJ2xAYtOA=@vger.kernel.org
X-Gm-Message-State: AFuF++kPgelkW7WXLQQoHh89iaYq0V3mHbH15vqfKHM0vK4QL9hNT9t5
	rAjCNW5i56+djFUUUC/dBn5gEcCwtOEQvFNQy6weteH4YQEjf1TUelKW2K6IWpq+OxdrktLQ/iU
	nlzkUDvXsuG9ssiyzttkA45+wKzZu/zzZGVwTIp30LAz2Zy6Jj56X
X-Gm-Gg: AYBFou3gkcUNNjgPJQ/U/Q8KxGjQUkDaTPAaOPLa9yR6ZR1YB9vEmjDMnZ1SSJnhUCb
	8pjGd1TPkM2VelfsRTnjOEiHwKTTdlVJbt82d90NjFtvLI6jKerfBIWCpFJluH3VC1+0OwCU3wM
	AP82C3WIg76QsSPbav7eM+VupgCN73OiJZXh5ZHdKOlUb8eYy9Dnvx2luNsFO6LHTmOVxvDikWY
	Q8TumdwKVOTbcNamr1xf1etMMMkp9ZS7sjz47Un/VZb0SjwJoxMUqwOPTHbViIYcFvMQpW0nhE4
	ZqLH+6a0E/oRIC6+Orvd5cK7/tdUG+IpQltYHUx/c4nil2ow3YHKu0DvOBJNifb6ivODXSBbYg4
	VCTc=
X-Received: by 2002:ac8:5a92:0:b0:533:340e:7483 with SMTP id d75a77b69052e-5359f488e55mr18513871cf.5.1791534662295;
        Fri, 09 Oct 2026 01:31:02 -0700 (PDT)
Received: from cavan.codon.org.uk ([2607:f598:b99a:160:8a88:88ff:fe88:8788])
        by smtp-relay.gmail.com with ESMTPS id d75a77b69052e-5359b7dcf1dsm79991cf.37.2026.10.09.01.31.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 01:31:02 -0700 (PDT)
X-Relaying-Domain: codon.org.uk
Received: by cavan.codon.org.uk (Postfix, from userid 1000)
	id 1E60A12862D5; Fri, 09 Oct 2026 01:31:01 -0700 (PDT)
Date: Fri, 9 Oct 2026 01:31:01 -0700
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Matthew Garrett <matthewg@nvidia.com>, keyrings@vger.kernel.org,
	James.Bottomley@hansenpartnership.com,
	linux-integrity@vger.kernel.org, rafael@kernel.org,
	linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH 17/17] PM: hibernate: Allow hibernation under lockdown
 with signed images
Message-ID: <asimRSqckPDUl0A8@srcf.ucam.org>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
 <20261008132532.1155166-18-matthewg@nvidia.com>
 <asfKpInP6j8DYA4-@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asfKpInP6j8DYA4-@kernel.org>

On Thu, Oct 08, 2026 at 07:53:56PM +0300, Jarkko Sakkinen wrote:

> I skimmed the rest of the patches but gave up for now given time and
> bandwidth, and also having quite loose grip to the changes until I
> run them (it's just complex patch set enough).
> 
> What kind of test environment you have in high-level, or could you
> give some rough guidelines for a test environment?
> 
> I'm thinking of setting up something with Buildroot, QEMU and swtpm
> perhaps.

Testing has been qemu + swtpm, with some scripts to build a toy 
initramfs to automatically do the testing. What would be the best way to 
share those with you?
