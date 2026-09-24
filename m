Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F366E479861
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 11:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790249790; cv=none; b=ri7wai76kNdRDcJ00IvDQlhj0CltaMJf/0CRIG6h71MpF3D9n+RSP9b7LCcQBIJYcpDIzxkaFfM4ySUVNHWprj7fMUEdrMwAiTi9VONTk2KL7weqLlgQtHG5qlz/+3VVMKQlkKyL+hpgmnzVO/uiNGK93p2GG4VMqXFjmw1bwA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790249790; c=relaxed/simple;
	bh=uVrulD/F0j3S8RA4z8aCS0H4Nuujjp5LUwI0loMt11w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cHowjRU67/9ExuRCkrn2AUyi1NSVdG3FfE9TlOvWCkjrafeIpHmT30Hh1200PdVC3Xw/r1O1dL6dxh6b7CsmzBABiRQIQ96a+T91E8kYaU2VN09xB0hvc7vrkl8XWaJFecZhbzsqiLpJ4ChtdH4dJBHds5GneRQ2qKkTrUHBR5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NXn3oqzr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NXn3oqzr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790249784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1mf9xwiSyUF66+L2SDy4YOfYehECWpWxm+Cowj/qDtc=;
	b=NXn3oqzry8T7lcpL5Tvzq5CG080Ygu1fysij9fwjcN6d3XqBQcLPiczRkJV0eOt0+LhyW7
	VTvCsVHqBn/8XP0uBy32VR133rpIAzNNphg1rGDWAvypgM6hHv9ixy3zMOwB8CSoD4U+Sd
	oTer71m/yciAXi8lCUXNwordUqG1OKA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-461-YqsBf8vJO7Cgm7jHq14hEw-1; Thu,
 24 Sep 2026 07:36:19 -0400
X-MC-Unique: YqsBf8vJO7Cgm7jHq14hEw-1
X-Mimecast-MFC-AGG-ID: YqsBf8vJO7Cgm7jHq14hEw_1790249777
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9BDD719560A2;
	Thu, 24 Sep 2026 11:36:16 +0000 (UTC)
Received: from localhost (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A71621800299;
	Thu, 24 Sep 2026 11:36:15 +0000 (UTC)
Date: Thu, 24 Sep 2026 08:36:14 -0300
From: "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
To: Steve McIntyre <93sam@debian.org>
Cc: Prashant Singh <singhpra@juniper.net>, Ard Biesheuvel <ardb@kernel.org>,
	Jeremy Kerr <jk@ozlabs.org>, linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v2] efivarfs: add nostatfs mount option to skip
 QueryVariableInfo()
Message-ID: <arULLk3ERQmADDBU@redhat.com>
References: <20260919044124.8268-1-singhpra@juniper.net>
 <arUD_p0Vn4qyBH_e@redhat.com>
 <20260924111913.GN3447081@tack.einval.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260924111913.GN3447081@tack.einval.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Thu, Sep 24, 2026 at 12:19:23PM +0100, Steve McIntyre wrote:
> Hey all,
> 
> On Thu, Sep 24, 2026 at 08:05:34AM -0300, Luis Claudio R. Goncalves wrote:
> >On Fri, Sep 18, 2026 at 09:41:24PM -0700, Prashant Singh wrote:
> >
> >I tested the patch and was quite satisfied with the results, but upon a
> >comment from colleagues I ran a few more tests and noticed (confirmed their
> >hunch) that fwupd complains about not being able to get the free space in
> >efivars:
> >
> >  # fwupdmgr get-devices | grep efivars
> >  │     Update Error:       getting efivars free space is not supported
> >  │ │   Update Error:       getting efivars free space is not supported
> >  ...
> >
> >I was not able to establish whether that would prevent specific operations
> >due to the HW I had available for such test.
> 
> fwupd will refuse to do some of its updates if it can't read the
> efivars free space, in particular updates of the secure boot keyrings
> like KEK/DB/DBX.

In this case, corroborating with Sashiko findings, it is necessary to have
a way to override that default in kernels with PREEMPT_RT enabled. To be used
where this is required for firmware updates.

Luis

> -- 
> Steve McIntyre, Cambridge, UK.                                93sam@debian.org
> 
> 
---end quoted text---

