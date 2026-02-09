Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4243793D2
	for <linux-efi@vger.kernel.org>; Mon,  9 Feb 2026 15:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770650279; cv=none; b=f81nG80wltmNEmPe1fIiHTPhqm/HcPUFaoc+YUl99Of1efhHVprCejekv71hJV8uk8WqedNxLZoLXeJQ6FKHX0odTXh9g1FoVvrWUb07zTb7sS9ABr7zO1yJCi2Z9sfk5hi8nQKcjrh1sTahqKJO4PlBq/1+6j7aiEM9iJ0dtF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770650279; c=relaxed/simple;
	bh=KUrB2ixHhbk8tXReGVRYZjGMeVc1cY5bqQ/6Yef0SdE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NIxtAwJTkYsS/75EFEocxggqEkPFTsCAhojnHoXw2yI/KwNWtk3NCVRJzPw/uoV2BtX7/f5d6zJuk9MaJ2GkWLk+2dFjdkucaJDnPcaovMBxHqEt1TR73Q528j9CwgvdgL83m0rndPMxggkaghXqiG3CCX/udntgFLolXa3RHNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ThN62Pon; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ThN62Pon"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770650278;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Fngc8mPVj+G9GNxVuTpiu+ARVdY7pvX/WkbOn6P4HDw=;
	b=ThN62PonQPPHGKyioKdWRd1mzJ8ioC7q65w5rr7pNpBuqO28RX6DUS5vcBxgEXdmbYnmQc
	czM4CXVjHljw7oPdloQ0minbWrSyhlMXG77eqWaPkfkZSbiQypP+DzFVN1CGgmAxWru/zc
	nzG/gDQdTJROrp0kMzhOkRAwYOJjI0o=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-618-I9cyAgBGPM6bVqWai9FRAw-1; Mon,
 09 Feb 2026 10:17:51 -0500
X-MC-Unique: I9cyAgBGPM6bVqWai9FRAw-1
X-Mimecast-MFC-AGG-ID: I9cyAgBGPM6bVqWai9FRAw_1770650269
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 37C351954105;
	Mon,  9 Feb 2026 15:17:37 +0000 (UTC)
Received: from localhost (unknown [10.22.64.105])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5328D18004BB;
	Mon,  9 Feb 2026 15:17:36 +0000 (UTC)
Date: Mon, 9 Feb 2026 12:17:35 -0300
From: "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev, Ard Biesheuvel <ardb@kernel.org>,
	John Ogness <john.ogness@linutronix.de>,
	Lai Jiangshan <jiangshanlai@gmail.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/2] efi: Expose the runtime-services workqueue via sysfs
Message-ID: <aYn6j_JLBENcY96V@redhat.com>
References: <20260205115559.1625236-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205115559.1625236-1-bigeasy@linutronix.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Thu, Feb 05, 2026 at 12:55:57PM +0100, Sebastian Andrzej Siewior wrote:
> EFI runtime services are disabled on PREEMPT_RT by default which can be
> overwritten on the boot command line. For native EFI, an invocation
> requires to disable preemption while a call is made into EFI. The time
> spent in EFI is not deterministic and depends on SW and HW of the
> system.
> While accessing the efi-rtc device can be avoided by using a native
> driver, accessing the "variables" is important and there is no second
> path.
> 
> The "runtime-wrappers" is wrapping access to the EFI callback via a
> workqueue. On a SMP system one CPU could be declared as housekeeping/
> not-realtime-capable and force all EFI invocation to be performed on
> this CPU. This could be achieved by setting workqueue.unbound_cpus or
> 	/sys/devices/virtual/workqueue/cpumask
> 
> at runtime. This however will affect all workqueues and might not be
> desired. With an explicit setting such as
> 	/sys/devices/virtual/workqueue/efi_runtime/cpumask
> 
> it looks like an official way to limit the CPUs involved here.
> 
> With this in place I was wondering if EFI_DISABLE_RUNTIME could be
> lifted at runtime on SMP systems. But given the unbound_cpus option
> and the auto-config based on NOHZ-full it might not be wise to add yet
> another smart option here. Also it needs to be a subset of root cpumask
> or it won't be effective.

I ran tests on two aarch64 boxes and two x86_64 boxes. I ran timerlat on a
set of isolated CPUs (10-30) and serviced the EFI Runtime requests on CPU4.
During the tests I ran operations such as df, efibootmgr, read individual
EFIvars and performed read/write ops to the boxes using efi-rtc. All that,
at regular intervals during the test duration.

I had previously checked the interference/latency generated by these
operations on each box, so I knew what to look for in terms of expected
latency spikes.

On the aarch64 boxes the impact of the EFI-related requests was confined to
CPU4, as expected, and no apparent noise was recorded on the isolated CPUs.

In one of the x86_64 boxes the noise also seemed to be contained to CPU4.
The other box gave me the impression that SMIs were being triggered by the
EFI runtime requests and that was affecting all the CPUs. I will explore
a bit more both x86_64 cases, but I am more than satisfied with the results
of the proposed patches.

Sebastian, as for the TEE feature you mentioned, is there specific test I
should run? Or is there any test you would like me to run in the context of
this change?

In any case,

Tested-by: Luis Claudio R. Goncalves <lgoncalv@redhat.com>

 
> There are two EFI invocations which are not covered by this
> - mixed EFI
>   Used on x86 with 64bit kernel but 32bit EFI. Would it work to use here
>   the same workqueue mechanism?
> 
> - TEE / ARM secure monitor
>   If I understand this right then TEE invokes the secure monitor which
>   is preemptible. So an interrupt will interrupt and enter "normal"
>   world immediately and could wake a user task. The following context
>   switch will not happen because the return from interrupt path goes
>   back to the secure monitor/ TEE.
>   If so, or if TEE may disable interrupts from normal world, would it
>   make sense to use a wrapper here, too?
> 
> Any comments or things I have missed?
> 
> Sebastian
> 
> Sebastian Andrzej Siewior (2):
>   workqueue: Allow to expose ordered workqueues via sysfs
>   efi: Allow to expose the workqueue via sysfs
> 
>  drivers/firmware/efi/efi.c |  2 +-
>  kernel/workqueue.c         | 14 +++++++-------
>  2 files changed, 8 insertions(+), 8 deletions(-)
> 
> -- 
> 2.51.0
> 
---end quoted text---

