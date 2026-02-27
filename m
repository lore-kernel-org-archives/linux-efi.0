Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F183542CF;
	Fri, 27 Feb 2026 17:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772212367; cv=none; b=qtWTXaKsmL1L0KuTmGjJBMH4eZ6XxA97oDIQE4ChpsBOA7k7mLIONL/S1bcuEHajmLCbWxOwOPXvsoXZ6Ydq67KtOS49EHriRz10sNe1TYM7euxtVOdoJOStguAtLKR95mqrrKyHNxVZD14zWo6tlXE7mnWWEoU4dfnyTn4tdP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772212367; c=relaxed/simple;
	bh=ZbvJgWVD+qFpuybrYYpMcarmcj1QcMZlioEjh2Nuf8g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mUOfTeTmeQdXGK5bim7ZZj8v+VKen+QOPnb3fzgattrBewqi7g1CXPUTOEkwR7mCkF3/wCiNwTeStRKWNMZUyldDPDOZu9uC3/D02Q8JHsso/c4tdAC3Zki7fJYgiiQ6Mhyz7/Bz4Ur4KrbX2yN3+LR6lM/RcUHUSvSL75/PB0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WfxHXcqw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WfxHXcqw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236AAC19421;
	Fri, 27 Feb 2026 17:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772212367;
	bh=ZbvJgWVD+qFpuybrYYpMcarmcj1QcMZlioEjh2Nuf8g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WfxHXcqw6SE7e0vBq0NRyN6jWBLgU8cD/KgBnJbqjqS8RWsLOuAs13TNIwTviJPfi
	 RileBChTh9um+qj6838aXp+wWGyIEaP2s6/DENawcwQ5NpZ3UuJjvxbLsSofFluw6A
	 0CNZi8HO5NzCklAsEI4tgD0TWK7pzQhugwr8vt1/J1Y8n1lzHut7GlLfK1OtzN8x/W
	 EGvcsXeP1x8716A+PFXfaFuRMj/mssPZyCY0gCmJkqHhF8CScZ9t4NaMjWqSPVpr/T
	 7WLqzM+c1kLK7nyKh6LD1lar/EPYaLLgrS0qwQ1qmPxzp6JP9V8tykHS5v8TPjujjO
	 XJlfFXjKMn5kw==
Date: Fri, 27 Feb 2026 07:12:46 -1000
From: Tejun Heo <tj@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	"Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	John Ogness <john.ogness@linutronix.de>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: [PATCH v2 1/2] workqueue: Allow to expose ordered workqueues via
 sysfs
Message-ID: <aaHQjt8bZsFLBwfh@slm.duckdns.org>
References: <20260227170103.4042157-1-bigeasy@linutronix.de>
 <20260227170103.4042157-2-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227170103.4042157-2-bigeasy@linutronix.de>

On Fri, Feb 27, 2026 at 06:01:02PM +0100, Sebastian Andrzej Siewior wrote:
> Ordered workqueues are not exposed via sysfs because the 'max_active'
> attribute changes the number actives worker. More than one active worker
> can break ordering guarantees.
> 
> This can be avoided by forbidding writes the file for ordered
> workqueues. Exposing it via sysfs allows to alter other attributes such
> as the cpumask on which CPU the worker can run.
> 
> The 'max_active' value shouldn't be changed for BH worker because the
> core never spawns additional worker and the worker itself can not be
> preempted. So this make no sense.
> 
> Allow to expose ordered workqueues via sysfs if requested and forbid
> changing 'max_active' value for ordered and BH worker.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Acked-by: Tejun Heo <tj@kernel.org>

I can apply this to wq/for-7.1. Would that work?

Thanks.

-- 
tejun
